package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.*;
final class PersistenceMapper {
    private PersistenceMapper() { }
    static TenantEntity entity(Tenant d) { var e=new TenantEntity(); e.id=d.id(); e.name=d.name(); e.slug=d.slug(); e.createdAt=d.createdAt(); return e; }
    static Tenant domain(TenantEntity e) { return new Tenant(e.id,e.name,e.slug,e.createdAt); }
    static UserEntity entity(User d) { var e=new UserEntity(); e.id=d.id(); e.tenantId=d.tenantId(); e.name=d.name(); e.email=d.email(); e.passwordHash=d.passwordHash(); e.role=d.role(); e.createdAt=d.createdAt(); return e; }
    static User domain(UserEntity e) { return new User(e.id,e.tenantId,e.name,e.email,e.passwordHash,e.role,e.createdAt); }
    static CustomerEntity entity(Customer d) { var e=new CustomerEntity(); e.id=d.id(); e.tenantId=d.tenantId(); e.name=d.name(); e.phone=d.phone(); e.email=d.email(); e.createdAt=d.createdAt(); e.updatedAt=d.updatedAt(); return e; }
    static Customer domain(CustomerEntity e) { return new Customer(e.id,e.tenantId,e.name,e.phone,e.email,e.createdAt,e.updatedAt); }
    static VehicleEntity entity(Vehicle d) { var e=new VehicleEntity(); e.id=d.id(); e.tenantId=d.tenantId(); e.customerId=d.customerId(); e.brand=d.brand(); e.model=d.model(); e.plate=d.plate(); e.year=d.year(); e.color=d.color(); e.createdAt=d.createdAt(); return e; }
    static Vehicle domain(VehicleEntity e) { return new Vehicle(e.id,e.tenantId,e.customerId,e.brand,e.model,e.plate,e.year,e.color,e.createdAt); }
    static ServiceOrderEntity entity(ServiceOrder d) { var e=new ServiceOrderEntity(); e.id=d.id(); e.tenantId=d.tenantId(); e.number=d.number(); e.customerId=d.customerId(); e.vehicleId=d.vehicleId(); e.description=d.description(); e.amount=d.amount(); e.scheduledAt=d.scheduledAt(); e.status=d.status(); e.createdAt=d.createdAt(); e.updatedAt=d.updatedAt(); return e; }
    static ServiceOrder domain(ServiceOrderEntity e) { return new ServiceOrder(e.id,e.tenantId,e.number,e.customerId,e.vehicleId,e.description,e.amount,e.scheduledAt,e.status,e.createdAt,e.updatedAt); }
}
