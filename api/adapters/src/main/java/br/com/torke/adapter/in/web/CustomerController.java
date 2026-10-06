package br.com.torke.adapter.in.web;
import br.com.torke.application.usecase.CustomerUseCase;
import br.com.torke.application.usecase.CustomerUseCase.CreateCustomerCommand;
import br.com.torke.domain.model.Customer;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;
@RestController @RequestMapping("/api/v1/customers") public class CustomerController {
    private final CustomerUseCase useCase; public CustomerController(CustomerUseCase useCase){this.useCase=useCase;}
    @PostMapping @ResponseStatus(HttpStatus.CREATED) Customer create(@Valid @RequestBody CustomerRequest request){return useCase.create(new CreateCustomerCommand(request.name(),request.phone(),request.email()));}
    @GetMapping List<Customer> list(@RequestParam(defaultValue="") String search){return useCase.list(search);}
    @GetMapping("/{id}") Customer get(@PathVariable UUID id){return useCase.get(id);}
    record CustomerRequest(@NotBlank @Size(max=150) String name,@NotBlank @Size(max=30) String phone,@Email @Size(max=180) String email){}
}
