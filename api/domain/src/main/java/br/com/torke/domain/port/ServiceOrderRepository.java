package br.com.torke.domain.port;
import br.com.torke.domain.model.ServiceOrder;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
public interface ServiceOrderRepository { ServiceOrder save(ServiceOrder order); List<ServiceOrder> findAll(UUID tenantId, ServiceOrder.Status status); Optional<ServiceOrder> findById(UUID tenantId, UUID id); long nextNumber(UUID tenantId); }
