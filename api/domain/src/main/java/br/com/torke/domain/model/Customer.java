package br.com.torke.domain.model;

import java.time.Instant;
import java.util.UUID;

public record Customer(UUID id, UUID tenantId, String name, String phone, String email, Instant createdAt, Instant updatedAt) {
    public Customer {
        if (id == null || tenantId == null || createdAt == null || updatedAt == null) throw new IllegalArgumentException("Cliente inválido");
        if (name == null || name.isBlank() || phone == null || phone.isBlank()) throw new IllegalArgumentException("Nome e telefone são obrigatórios");
        name = name.trim(); phone = phone.trim(); email = email == null ? "" : email.trim().toLowerCase();
    }
}
