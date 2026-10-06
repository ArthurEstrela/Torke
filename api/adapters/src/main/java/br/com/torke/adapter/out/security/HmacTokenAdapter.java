package br.com.torke.adapter.out.security;
import br.com.torke.domain.exception.BusinessException;
import br.com.torke.domain.model.TenantSession;
import br.com.torke.domain.model.User;
import br.com.torke.domain.port.TokenIssuer;
import tools.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.Map;
import java.util.UUID;

@Component public class HmacTokenAdapter implements TokenIssuer {
    private static final Base64.Encoder ENCODER=Base64.getUrlEncoder().withoutPadding();
    private static final Base64.Decoder DECODER=Base64.getUrlDecoder();
    private final ObjectMapper json; private final byte[] secret; private final Clock clock;
    public HmacTokenAdapter(ObjectMapper json,@Value("${torke.security.jwt-secret}") String secret,Clock clock){if(secret.length()<32)throw new IllegalStateException("JWT_SECRET deve ter pelo menos 32 caracteres");this.json=json;this.secret=secret.getBytes(StandardCharsets.UTF_8);this.clock=clock;}
    public String issue(TenantSession session){try{String header=encode(json.writeValueAsBytes(Map.of("alg","HS256","typ","JWT")));Instant now=clock.instant();String payload=encode(json.writeValueAsBytes(Map.of("sub",session.userId().toString(),"tid",session.tenantId().toString(),"email",session.email(),"role",session.role().name(),"iat",now.getEpochSecond(),"exp",now.plus(Duration.ofHours(12)).getEpochSecond())));String content=header+"."+payload;return content+"."+encode(sign(content));}catch(Exception e){throw new IllegalStateException("Não foi possível emitir token",e);}}
    public TenantSession verify(String token){try{String[] parts=token.split("\\.");if(parts.length!=3)throw new BusinessException("Token inválido");String content=parts[0]+"."+parts[1];if(!MessageDigest.isEqual(sign(content),DECODER.decode(parts[2])))throw new BusinessException("Token inválido");@SuppressWarnings("unchecked") Map<String,Object> claims=json.readValue(DECODER.decode(parts[1]),Map.class);long exp=((Number)claims.get("exp")).longValue();if(clock.instant().getEpochSecond()>=exp)throw new BusinessException("Token expirado");return new TenantSession(UUID.fromString((String)claims.get("tid")),UUID.fromString((String)claims.get("sub")),(String)claims.get("email"),User.Role.valueOf((String)claims.get("role")));}catch(BusinessException e){throw e;}catch(Exception e){throw new BusinessException("Token inválido");}}
    private byte[] sign(String value)throws Exception{Mac mac=Mac.getInstance("HmacSHA256");mac.init(new SecretKeySpec(secret,"HmacSHA256"));return mac.doFinal(value.getBytes(StandardCharsets.UTF_8));}
    private static String encode(byte[] value){return ENCODER.encodeToString(value);}
}
