package br.com.torke.application.usecase;

import br.com.torke.domain.model.Tenant;
import br.com.torke.domain.model.User;

import java.util.UUID;

public interface AuthUseCase {
    AuthResult register(RegisterCommand command);
    AuthResult login(LoginCommand command);
    record RegisterCommand(String workshopName, String slug, String ownerName, String email, String password) { }
    record LoginCommand(String tenantSlug, String email, String password) { }
    record AuthResult(String accessToken, UUID tenantId, String tenantName, UUID userId, String userName, String email, User.Role role) {
        public static AuthResult of(String token, Tenant tenant, User user) { return new AuthResult(token, tenant.id(), tenant.name(), user.id(), user.name(), user.email(), user.role()); }
    }
}
