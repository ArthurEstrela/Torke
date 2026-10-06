package br.com.torke.domain.model;

import java.time.Instant;
import java.util.UUID;

public record Tenant(UUID id, String name, String slug, Instant createdAt) {
    public Tenant {
        if (id == null || createdAt == null) throw new IllegalArgumentException("Id e data são obrigatórios");
        name = requireText(name, "Nome");
        slug = requireText(slug, "Slug").toLowerCase();
    }

    private static String requireText(String value, String field) {
        if (value == null || value.isBlank()) throw new IllegalArgumentException(field + " é obrigatório");
        return value.trim();
    }
}
