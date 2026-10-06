package br.com.torke.application.usecase;
import br.com.torke.domain.model.ServiceOrder;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
public interface ServiceOrderUseCase {
    ServiceOrder create(CreateOrderCommand command);
    List<ServiceOrder> list(ServiceOrder.Status status);
    ServiceOrder changeStatus(UUID id, ServiceOrder.Status status);
    record CreateOrderCommand(UUID customerId, UUID vehicleId, String description, BigDecimal amount, OffsetDateTime scheduledAt) { }
}
