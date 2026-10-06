package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.ServiceOrder;
import br.com.torke.domain.port.ServiceOrderRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
@Repository public class ServiceOrderPersistenceAdapter implements ServiceOrderRepository {
    private final ServiceOrderJpaRepository repository; private final JdbcTemplate jdbc;
    public ServiceOrderPersistenceAdapter(ServiceOrderJpaRepository repository,JdbcTemplate jdbc){this.repository=repository;this.jdbc=jdbc;}
    public ServiceOrder save(ServiceOrder order){return PersistenceMapper.domain(repository.save(PersistenceMapper.entity(order)));}
    public List<ServiceOrder> findAll(UUID tenantId,ServiceOrder.Status status){var result=status==null?repository.findByTenantIdOrderByScheduledAtDesc(tenantId):repository.findByTenantIdAndStatusOrderByScheduledAtDesc(tenantId,status);return result.stream().map(PersistenceMapper::domain).toList();}
    public Optional<ServiceOrder> findById(UUID tenantId,UUID id){return repository.findByTenantIdAndId(tenantId,id).map(PersistenceMapper::domain);}
    public long nextNumber(UUID tenantId){Long value=jdbc.queryForObject("insert into tenant_counters (tenant_id, next_order_number) values (?, 1001) on conflict (tenant_id) do update set next_order_number = tenant_counters.next_order_number + 1 returning next_order_number",Long.class,tenantId);return value==null?1001:value;}
}
