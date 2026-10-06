package br.com.torke.domain.model;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.UUID;

public record ServiceOrder(UUID id, UUID tenantId, long number, UUID customerId, UUID vehicleId, String description, BigDecimal amount, OffsetDateTime scheduledAt, Status status, Instant createdAt, Instant updatedAt) {
    public ServiceOrder {
        if (id == null || tenantId == null || customerId == null || vehicleId == null || amount == null || scheduledAt == null || status == null || createdAt == null || updatedAt == null) throw new IllegalArgumentException("Ordem de serviço inválida");
        if (description == null || description.isBlank()) throw new IllegalArgumentException("Descrição é obrigatória");
        if (amount.signum() < 0) throw new IllegalArgumentException("Valor não pode ser negativo");
        description = description.trim();
    }
    public ServiceOrder changeStatus(Status newStatus, Instant now) { return new ServiceOrder(id, tenantId, number, customerId, vehicleId, description, amount, scheduledAt, newStatus, createdAt, now); }
    public enum Status { SCHEDULED, IN_PROGRESS, AWAITING_APPROVAL, READY, DELIVERED, CANCELLED }
}
