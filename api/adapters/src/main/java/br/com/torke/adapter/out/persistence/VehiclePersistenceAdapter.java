package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.Vehicle;
import br.com.torke.domain.port.VehicleRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;
@Repository public class VehiclePersistenceAdapter implements VehicleRepository {
    private final VehicleJpaRepository repository; public VehiclePersistenceAdapter(VehicleJpaRepository repository){this.repository=repository;}
    public Vehicle save(Vehicle vehicle){return PersistenceMapper.domain(repository.save(PersistenceMapper.entity(vehicle)));}
    public List<Vehicle> findAll(UUID tenantId,UUID customerId){return repository.findByTenantIdAndCustomerIdOrderByCreatedAtDesc(tenantId,customerId).stream().map(PersistenceMapper::domain).toList();}
    public Optional<Vehicle> findById(UUID tenantId,UUID id){return repository.findByTenantIdAndId(tenantId,id).map(PersistenceMapper::domain);}
    public boolean existsByPlate(UUID tenantId,String plate){return repository.existsByTenantIdAndPlate(tenantId,plate.replaceAll("[^A-Za-z0-9]","").toUpperCase(Locale.ROOT));}
}
