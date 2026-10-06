package br.com.torke.adapter.out.persistence;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

interface TenantJpaRepository extends JpaRepository<TenantEntity, UUID> { Optional<TenantEntity> findBySlug(String slug); }
interface UserJpaRepository extends JpaRepository<UserEntity, UUID> { Optional<UserEntity> findByTenantIdAndEmail(UUID tenantId, String email); }
interface CustomerJpaRepository extends JpaRepository<CustomerEntity, UUID> {
    @Query("select c from CustomerEntity c where c.tenantId = :tenantId and (:search = '' or lower(c.name) like lower(concat('%', :search, '%')) or c.phone like concat('%', :search, '%')) order by c.name")
    List<CustomerEntity> search(@Param("tenantId") UUID tenantId, @Param("search") String search);
    Optional<CustomerEntity> findByTenantIdAndId(UUID tenantId, UUID id);
}
interface VehicleJpaRepository extends JpaRepository<VehicleEntity, UUID> {
    List<VehicleEntity> findByTenantIdAndCustomerIdOrderByCreatedAtDesc(UUID tenantId, UUID customerId);
    Optional<VehicleEntity> findByTenantIdAndId(UUID tenantId, UUID id);
    boolean existsByTenantIdAndPlate(UUID tenantId, String plate);
}
interface ServiceOrderJpaRepository extends JpaRepository<ServiceOrderEntity, UUID> {
    List<ServiceOrderEntity> findByTenantIdOrderByScheduledAtDesc(UUID tenantId);
    List<ServiceOrderEntity> findByTenantIdAndStatusOrderByScheduledAtDesc(UUID tenantId, br.com.torke.domain.model.ServiceOrder.Status status);
    Optional<ServiceOrderEntity> findByTenantIdAndId(UUID tenantId, UUID id);
}
