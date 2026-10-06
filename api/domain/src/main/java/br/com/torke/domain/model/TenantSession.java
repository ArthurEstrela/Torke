package br.com.torke.domain.model;

import java.util.UUID;

public record TenantSession(UUID tenantId, UUID userId, String email, User.Role role) { }
