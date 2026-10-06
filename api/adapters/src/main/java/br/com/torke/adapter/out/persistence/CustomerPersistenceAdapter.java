package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.Customer;
import br.com.torke.domain.port.CustomerRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
@Repository public class CustomerPersistenceAdapter implements CustomerRepository {
    private final CustomerJpaRepository repository; public CustomerPersistenceAdapter(CustomerJpaRepository repository){this.repository=repository;}
    public Customer save(Customer customer){return PersistenceMapper.domain(repository.save(PersistenceMapper.entity(customer)));}
    public List<Customer> findAll(UUID tenantId,String search){return repository.search(tenantId,search).stream().map(PersistenceMapper::domain).toList();}
    public Optional<Customer> findById(UUID tenantId,UUID id){return repository.findByTenantIdAndId(tenantId,id).map(PersistenceMapper::domain);}
}
