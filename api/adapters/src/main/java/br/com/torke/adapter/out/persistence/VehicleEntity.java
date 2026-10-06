package br.com.torke.adapter.out.persistence;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;
@Entity @Table(name = "vehicles")
public class VehicleEntity {
    @Id public UUID id; @Column(name="tenant_id",nullable=false) public UUID tenantId; @Column(name="customer_id",nullable=false) public UUID customerId; @Column(nullable=false) public String brand; @Column(nullable=false) public String model; @Column(nullable=false) public String plate; @Column(nullable=false) public int year; @Column(nullable=false) public String color; @Column(name="created_at",nullable=false) public Instant createdAt;
    protected VehicleEntity() { }
}
