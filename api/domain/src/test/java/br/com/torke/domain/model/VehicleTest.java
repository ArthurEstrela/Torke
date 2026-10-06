package br.com.torke.domain.model;
import org.junit.jupiter.api.Test;
import java.time.Instant;
import java.util.UUID;
import static org.junit.jupiter.api.Assertions.*;
class VehicleTest {
    @Test void normalizesPlate(){var vehicle=new Vehicle(UUID.randomUUID(),UUID.randomUUID(),UUID.randomUUID(),"Honda","Civic","abc-1d23",2024,"Preto",Instant.now());assertEquals("ABC1D23",vehicle.plate());}
    @Test void rejectsInvalidYear(){assertThrows(IllegalArgumentException.class,()->new Vehicle(UUID.randomUUID(),UUID.randomUUID(),UUID.randomUUID(),"Honda","Civic","ABC1D23",1800,"Preto",Instant.now()));}
}
