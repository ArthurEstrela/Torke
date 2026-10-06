package br.com.torke.domain.port;
import br.com.torke.domain.model.Tenant;
import java.util.Optional;
import java.util.UUID;
public interface TenantRepository { Tenant save(Tenant tenant); Optional<Tenant> findBySlug(String slug); Optional<Tenant> findById(UUID id); }
