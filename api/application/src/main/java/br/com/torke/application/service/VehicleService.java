package br.com.torke.application.service;
import br.com.torke.application.usecase.VehicleUseCase;
import br.com.torke.domain.exception.BusinessException;
import br.com.torke.domain.exception.NotFoundException;
import br.com.torke.domain.model.Vehicle;
import br.com.torke.domain.port.CustomerRepository;
import br.com.torke.domain.port.SessionProvider;
import br.com.torke.domain.port.VehicleRepository;
import java.time.Clock;
import java.util.List;
import java.util.UUID;
public final class VehicleService implements VehicleUseCase {
    private final VehicleRepository vehicles; private final CustomerRepository customers; private final SessionProvider sessions; private final Clock clock;
    public VehicleService(VehicleRepository vehicles, CustomerRepository customers, SessionProvider sessions, Clock clock) { this.vehicles = vehicles; this.customers = customers; this.sessions = sessions; this.clock = clock; }
    @Override public Vehicle create(CreateVehicleCommand command) { UUID tenantId = sessions.current().tenantId(); customers.findById(tenantId, command.customerId()).orElseThrow(() -> new NotFoundException("Cliente não encontrado")); if (vehicles.existsByPlate(tenantId, command.plate())) throw new BusinessException("Já existe um veículo com esta placa"); return vehicles.save(new Vehicle(UUID.randomUUID(), tenantId, command.customerId(), command.brand(), command.model(), command.plate(), command.year(), command.color(), clock.instant())); }
    @Override public List<Vehicle> list(UUID customerId) { return vehicles.findAll(sessions.current().tenantId(), customerId); }
}
