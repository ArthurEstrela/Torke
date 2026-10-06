package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.Tenant;
import br.com.torke.domain.port.TenantRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;
@Repository public class TenantPersistenceAdapter implements TenantRepository {
    private final TenantJpaRepository repository; public TenantPersistenceAdapter(TenantJpaRepository repository){this.repository=repository;}
    public Tenant save(Tenant tenant){return PersistenceMapper.domain(repository.save(PersistenceMapper.entity(tenant)));}
    public Optional<Tenant> findBySlug(String slug){return repository.findBySlug(slug).map(PersistenceMapper::domain);}
    public Optional<Tenant> findById(UUID id){return repository.findById(id).map(PersistenceMapper::domain);}
}
