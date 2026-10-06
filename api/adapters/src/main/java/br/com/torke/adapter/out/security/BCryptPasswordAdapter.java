package br.com.torke.adapter.out.security;
import br.com.torke.domain.port.PasswordHasher;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
@Component public class BCryptPasswordAdapter implements PasswordHasher {
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
    public String hash(String rawPassword){return encoder.encode(rawPassword);}
    public boolean matches(String rawPassword,String hash){return encoder.matches(rawPassword,hash);}
}
