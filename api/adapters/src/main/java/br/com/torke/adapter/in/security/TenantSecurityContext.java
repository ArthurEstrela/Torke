package br.com.torke.adapter.in.security;
import br.com.torke.domain.model.TenantSession;
import br.com.torke.domain.port.SessionProvider;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
@Component public class TenantSecurityContext implements SessionProvider {
    public TenantSession current(){Object principal=SecurityContextHolder.getContext().getAuthentication().getPrincipal();if(principal instanceof TenantSession session)return session;throw new IllegalStateException("Tenant não autenticado");}
}
