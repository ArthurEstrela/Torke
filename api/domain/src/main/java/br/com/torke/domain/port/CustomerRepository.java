package br.com.torke.domain.port;
import br.com.torke.domain.model.Customer;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
public interface CustomerRepository { Customer save(Customer customer); List<Customer> findAll(UUID tenantId, String search); Optional<Customer> findById(UUID tenantId, UUID id); }
