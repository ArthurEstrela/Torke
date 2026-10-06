package br.com.torke.domain.model;

import java.time.Instant;
import java.util.UUID;

public record User(UUID id, UUID tenantId, String name, String email, String passwordHash, Role role, Instant createdAt) {
    public User {
        if (id == null || tenantId == null || role == null || createdAt == null) throw new IllegalArgumentException("Usuário inválido");
        if (name == null || name.isBlank() || email == null || email.isBlank() || passwordHash == null || passwordHash.isBlank()) throw new IllegalArgumentException("Dados do usuário são obrigatórios");
        name = name.trim();
        email = email.trim().toLowerCase();
    }
    public enum Role { OWNER, MANAGER, TECHNICIAN, ATTENDANT }
}
