package br.com.torke.domain.port;
import br.com.torke.domain.model.Vehicle;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
public interface VehicleRepository { Vehicle save(Vehicle vehicle); List<Vehicle> findAll(UUID tenantId, UUID customerId); Optional<Vehicle> findById(UUID tenantId, UUID id); boolean existsByPlate(UUID tenantId, String plate); }
