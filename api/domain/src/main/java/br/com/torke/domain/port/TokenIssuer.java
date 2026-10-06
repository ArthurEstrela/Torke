package br.com.torke.domain.port;
import br.com.torke.domain.model.TenantSession;
public interface TokenIssuer { String issue(TenantSession session); }
