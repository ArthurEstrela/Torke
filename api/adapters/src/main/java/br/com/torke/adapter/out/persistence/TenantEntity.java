package br.com.torke.adapter.out.persistence;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;
@Entity @Table(name = "tenants")
public class TenantEntity {
    @Id public UUID id; @Column(nullable=false) public String name; @Column(nullable=false,unique=true) public String slug; @Column(name="created_at",nullable=false) public Instant createdAt;
    protected TenantEntity() { }
}
