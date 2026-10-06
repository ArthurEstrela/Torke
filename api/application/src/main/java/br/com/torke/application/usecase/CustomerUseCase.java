package br.com.torke.application.usecase;
import br.com.torke.domain.model.Customer;
import java.util.List;
import java.util.UUID;
public interface CustomerUseCase { Customer create(CreateCustomerCommand command); List<Customer> list(String search); Customer get(UUID id); record CreateCustomerCommand(String name, String phone, String email) { } }
