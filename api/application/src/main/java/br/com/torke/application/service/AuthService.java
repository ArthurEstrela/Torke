package br.com.torke.application.service;

import br.com.torke.application.usecase.AuthUseCase;
import br.com.torke.domain.exception.BusinessException;
import br.com.torke.domain.model.Tenant;
import br.com.torke.domain.model.TenantSession;
import br.com.torke.domain.model.User;
import br.com.torke.domain.port.*;

import java.time.Clock;
import java.time.Instant;
import java.util.Locale;
import java.util.UUID;

public final class AuthService implements AuthUseCase {
    private final TenantRepository tenants; private final UserRepository users; private final PasswordHasher passwords; private final TokenIssuer tokens; private final TransactionRunner transactions; private final Clock clock;
    public AuthService(TenantRepository tenants, UserRepository users, PasswordHasher passwords, TokenIssuer tokens, TransactionRunner transactions, Clock clock) { this.tenants = tenants; this.users = users; this.passwords = passwords; this.tokens = tokens; this.transactions = transactions; this.clock = clock; }

    @Override public AuthResult register(RegisterCommand command) {
        validatePassword(command.password());
        return transactions.run(() -> {
            String slug = normalizeSlug(command.slug());
            if (tenants.findBySlug(slug).isPresent()) throw new BusinessException("Este identificador de oficina já está em uso");
            Instant now = clock.instant();
            Tenant tenant = tenants.save(new Tenant(UUID.randomUUID(), command.workshopName(), slug, now));
            User user = users.save(new User(UUID.randomUUID(), tenant.id(), command.ownerName(), command.email(), passwords.hash(command.password()), User.Role.OWNER, now));
            return AuthResult.of(tokens.issue(new TenantSession(tenant.id(), user.id(), user.email(), user.role())), tenant, user);
        });
    }

    @Override public AuthResult login(LoginCommand command) {
        Tenant tenant = tenants.findBySlug(normalizeSlug(command.tenantSlug())).orElseThrow(() -> new BusinessException("Credenciais inválidas"));
        User user = users.findByTenantIdAndEmail(tenant.id(), command.email().trim().toLowerCase(Locale.ROOT)).orElseThrow(() -> new BusinessException("Credenciais inválidas"));
        if (!passwords.matches(command.password(), user.passwordHash())) throw new BusinessException("Credenciais inválidas");
        return AuthResult.of(tokens.issue(new TenantSession(tenant.id(), user.id(), user.email(), user.role())), tenant, user);
    }

    private static String normalizeSlug(String value) { if (value == null || value.isBlank()) throw new BusinessException("Identificador da oficina é obrigatório"); String slug = value.trim().toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9-]", "-").replaceAll("-+", "-"); if (slug.length() < 3) throw new BusinessException("Identificador da oficina deve ter pelo menos 3 caracteres"); return slug; }
    private static void validatePassword(String password) { if (password == null || password.length() < 8) throw new BusinessException("A senha deve ter pelo menos 8 caracteres"); }
}
