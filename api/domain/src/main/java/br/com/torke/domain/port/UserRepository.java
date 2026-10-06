package br.com.torke.domain.port;
import br.com.torke.domain.model.User;
import java.util.Optional;
import java.util.UUID;
public interface UserRepository { User save(User user); Optional<User> findByTenantIdAndEmail(UUID tenantId, String email); }
