package br.com.torke.application.service;
import br.com.torke.application.usecase.CustomerUseCase;
import br.com.torke.domain.exception.NotFoundException;
import br.com.torke.domain.model.Customer;
import br.com.torke.domain.port.CustomerRepository;
import br.com.torke.domain.port.SessionProvider;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
public final class CustomerService implements CustomerUseCase {
    private final CustomerRepository repository; private final SessionProvider sessions; private final Clock clock;
    public CustomerService(CustomerRepository repository, SessionProvider sessions, Clock clock) { this.repository = repository; this.sessions = sessions; this.clock = clock; }
    @Override public Customer create(CreateCustomerCommand command) { Instant now = clock.instant(); return repository.save(new Customer(UUID.randomUUID(), sessions.current().tenantId(), command.name(), command.phone(), command.email(), now, now)); }
    @Override public List<Customer> list(String search) { return repository.findAll(sessions.current().tenantId(), search == null ? "" : search.trim()); }
    @Override public Customer get(UUID id) { return repository.findById(sessions.current().tenantId(), id).orElseThrow(() -> new NotFoundException("Cliente não encontrado")); }
}
