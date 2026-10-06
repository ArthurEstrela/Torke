package br.com.torke.adapter.out.persistence;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;
@Entity @Table(name = "customers")
public class CustomerEntity {
    @Id public UUID id; @Column(name="tenant_id",nullable=false) public UUID tenantId; @Column(nullable=false) public String name; @Column(nullable=false) public String phone; @Column(nullable=false) public String email; @Column(name="created_at",nullable=false) public Instant createdAt; @Column(name="updated_at",nullable=false) public Instant updatedAt;
    protected CustomerEntity() { }
}
