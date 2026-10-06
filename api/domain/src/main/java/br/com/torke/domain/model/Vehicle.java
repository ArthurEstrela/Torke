package br.com.torke.domain.model;

import java.time.Instant;
import java.util.Locale;
import java.util.UUID;

public record Vehicle(UUID id, UUID tenantId, UUID customerId, String brand, String model, String plate, int year, String color, Instant createdAt) {
    public Vehicle {
        if (id == null || tenantId == null || customerId == null || createdAt == null) throw new IllegalArgumentException("Veículo inválido");
        if (brand == null || brand.isBlank() || model == null || model.isBlank() || plate == null || plate.isBlank()) throw new IllegalArgumentException("Marca, modelo e placa são obrigatórios");
        if (year < 1900 || year > 2100) throw new IllegalArgumentException("Ano do veículo inválido");
        brand = brand.trim(); model = model.trim(); plate = plate.replaceAll("[^A-Za-z0-9]", "").toUpperCase(Locale.ROOT); color = color == null ? "" : color.trim();
    }
}
