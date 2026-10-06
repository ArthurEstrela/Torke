package br.com.torke.adapter.in.web;
import br.com.torke.application.usecase.VehicleUseCase;
import br.com.torke.application.usecase.VehicleUseCase.CreateVehicleCommand;
import br.com.torke.domain.model.Vehicle;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;
@RestController @RequestMapping("/api/v1/customers/{customerId}/vehicles") public class VehicleController {
    private final VehicleUseCase useCase; public VehicleController(VehicleUseCase useCase){this.useCase=useCase;}
    @PostMapping @ResponseStatus(HttpStatus.CREATED) Vehicle create(@PathVariable UUID customerId,@Valid @RequestBody VehicleRequest request){return useCase.create(new CreateVehicleCommand(customerId,request.brand(),request.model(),request.plate(),request.year(),request.color()));}
    @GetMapping List<Vehicle> list(@PathVariable UUID customerId){return useCase.list(customerId);}
    record VehicleRequest(@NotBlank @Size(max=80) String brand,@NotBlank @Size(max=100) String model,@NotBlank @Size(min=7,max=8) String plate,@Min(1900) @Max(2100) int year,@Size(max=50) String color){}
}
