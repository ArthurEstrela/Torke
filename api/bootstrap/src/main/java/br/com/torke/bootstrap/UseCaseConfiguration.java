package br.com.torke.bootstrap;
import br.com.torke.application.service.*;
import br.com.torke.application.usecase.*;
import br.com.torke.domain.port.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.time.Clock;
@Configuration public class UseCaseConfiguration {
    @Bean Clock clock(){return Clock.systemUTC();}
    @Bean AuthUseCase authUseCase(TenantRepository tenants,UserRepository users,PasswordHasher passwords,TokenIssuer tokens,TransactionRunner transactions,Clock clock){return new AuthService(tenants,users,passwords,tokens,transactions,clock);}
    @Bean CustomerUseCase customerUseCase(CustomerRepository customers,SessionProvider sessions,Clock clock){return new CustomerService(customers,sessions,clock);}
    @Bean VehicleUseCase vehicleUseCase(VehicleRepository vehicles,CustomerRepository customers,SessionProvider sessions,Clock clock){return new VehicleService(vehicles,customers,sessions,clock);}
    @Bean ServiceOrderUseCase serviceOrderUseCase(ServiceOrderRepository orders,CustomerRepository customers,VehicleRepository vehicles,SessionProvider sessions,Clock clock){return new ServiceOrderService(orders,customers,vehicles,sessions,clock);}
}
