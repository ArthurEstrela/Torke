package br.com.torke.adapter.out.persistence;
import br.com.torke.domain.model.User;
import br.com.torke.domain.port.UserRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;
@Repository public class UserPersistenceAdapter implements UserRepository {
    private final UserJpaRepository repository; public UserPersistenceAdapter(UserJpaRepository repository){this.repository=repository;}
    public User save(User user){return PersistenceMapper.domain(repository.save(PersistenceMapper.entity(user)));}
    public Optional<User> findByTenantIdAndEmail(UUID tenantId,String email){return repository.findByTenantIdAndEmail(tenantId,email).map(PersistenceMapper::domain);}
}
