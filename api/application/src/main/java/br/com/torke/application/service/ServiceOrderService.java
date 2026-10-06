package br.com.torke.application.service;
import br.com.torke.application.usecase.ServiceOrderUseCase;
import br.com.torke.domain.exception.BusinessException;
import br.com.torke.domain.exception.NotFoundException;
import br.com.torke.domain.model.ServiceOrder;
import br.com.torke.domain.port.*;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
public final class ServiceOrderService implements ServiceOrderUseCase {
    private final ServiceOrderRepository orders; private final CustomerRepository customers; private final VehicleRepository vehicles; private final SessionProvider sessions; private final Clock clock;
    public ServiceOrderService(ServiceOrderRepository orders, CustomerRepository customers, VehicleRepository vehicles, SessionProvider sessions, Clock clock) { this.orders = orders; this.customers = customers; this.vehicles = vehicles; this.sessions = sessions; this.clock = clock; }
    @Override public ServiceOrder create(CreateOrderCommand command) { UUID tenantId = sessions.current().tenantId(); customers.findById(tenantId, command.customerId()).orElseThrow(() -> new NotFoundException("Cliente não encontrado")); var vehicle = vehicles.findById(tenantId, command.vehicleId()).orElseThrow(() -> new NotFoundException("Veículo não encontrado")); if (!vehicle.customerId().equals(command.customerId())) throw new BusinessException("O veículo não pertence ao cliente informado"); Instant now = clock.instant(); return orders.save(new ServiceOrder(UUID.randomUUID(), tenantId, orders.nextNumber(tenantId), command.customerId(), command.vehicleId(), command.description(), command.amount(), command.scheduledAt(), ServiceOrder.Status.SCHEDULED, now, now)); }
    @Override public List<ServiceOrder> list(ServiceOrder.Status status) { return orders.findAll(sessions.current().tenantId(), status); }
    @Override public ServiceOrder changeStatus(UUID id, ServiceOrder.Status status) { UUID tenantId = sessions.current().tenantId(); ServiceOrder order = orders.findById(tenantId, id).orElseThrow(() -> new NotFoundException("Ordem de serviço não encontrada")); return orders.save(order.changeStatus(status, clock.instant())); }
}
