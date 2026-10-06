package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.ServiceOrder;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.UUID;
@Entity @Table(name = "service_orders")
public class ServiceOrderEntity {
    @Id public UUID id; @Column(name="tenant_id",nullable=false) public UUID tenantId; @Column(nullable=false) public long number; @Column(name="customer_id",nullable=false) public UUID customerId; @Column(name="vehicle_id",nullable=false) public UUID vehicleId; @Column(nullable=false) public String description; @Column(nullable=false,precision=12,scale=2) public BigDecimal amount; @Column(name="scheduled_at",nullable=false) public OffsetDateTime scheduledAt; @Enumerated(EnumType.STRING) @Column(nullable=false) public ServiceOrder.Status status; @Column(name="created_at",nullable=false) public Instant createdAt; @Column(name="updated_at",nullable=false) public Instant updatedAt;
    protected ServiceOrderEntity() { }
}
