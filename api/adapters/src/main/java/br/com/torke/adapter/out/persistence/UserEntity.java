package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.User;
import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;
@Entity @Table(name = "users")
public class UserEntity {
    @Id public UUID id; @Column(name="tenant_id",nullable=false) public UUID tenantId; @Column(nullable=false) public String name; @Column(nullable=false) public String email; @Column(name="password_hash",nullable=false) public String passwordHash; @Enumerated(EnumType.STRING) @Column(nullable=false) public User.Role role; @Column(name="created_at",nullable=false) public Instant createdAt;
    protected UserEntity() { }
}
