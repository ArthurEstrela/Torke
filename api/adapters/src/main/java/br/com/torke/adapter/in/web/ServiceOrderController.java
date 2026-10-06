package br.com.torke.adapter.in.web;
import br.com.torke.application.usecase.ServiceOrderUseCase;
import br.com.torke.application.usecase.ServiceOrderUseCase.CreateOrderCommand;
import br.com.torke.domain.model.ServiceOrder;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
@RestController @RequestMapping("/api/v1/service-orders") public class ServiceOrderController {
    private final ServiceOrderUseCase useCase; public ServiceOrderController(ServiceOrderUseCase useCase){this.useCase=useCase;}
    @PostMapping @ResponseStatus(HttpStatus.CREATED) ServiceOrder create(@Valid @RequestBody OrderRequest request){return useCase.create(new CreateOrderCommand(request.customerId(),request.vehicleId(),request.description(),request.amount(),request.scheduledAt()));}
    @GetMapping List<ServiceOrder> list(@RequestParam(required=false) ServiceOrder.Status status){return useCase.list(status);}
    @PatchMapping("/{id}/status") ServiceOrder changeStatus(@PathVariable UUID id,@Valid @RequestBody StatusRequest request){return useCase.changeStatus(id,request.status());}
    record OrderRequest(@NotNull UUID customerId,@NotNull UUID vehicleId,@NotBlank @Size(max=500) String description,@NotNull @DecimalMin("0.00") BigDecimal amount,@NotNull OffsetDateTime scheduledAt){}
    record StatusRequest(@NotNull ServiceOrder.Status status){}
}
