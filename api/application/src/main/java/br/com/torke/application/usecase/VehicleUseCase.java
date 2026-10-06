package br.com.torke.application.usecase;
import br.com.torke.domain.model.Vehicle;
import java.util.List;
import java.util.UUID;
public interface VehicleUseCase { Vehicle create(CreateVehicleCommand command); List<Vehicle> list(UUID customerId); record CreateVehicleCommand(UUID customerId, String brand, String model, String plate, int year, String color) { } }
