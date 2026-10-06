package br.com.torke.adapter.in.security;
import br.com.torke.adapter.out.security.HmacTokenAdapter;
import br.com.torke.domain.exception.BusinessException;
import tools.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;
import java.time.Instant;
import java.util.List;
import java.util.Map;

@Component public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final HmacTokenAdapter tokens; private final ObjectMapper json;
    public JwtAuthenticationFilter(HmacTokenAdapter tokens,ObjectMapper json){this.tokens=tokens;this.json=json;}
    @Override protected void doFilterInternal(HttpServletRequest request,HttpServletResponse response,FilterChain chain)throws ServletException,IOException{
        String authorization=request.getHeader("Authorization");
        if(authorization==null||!authorization.startsWith("Bearer ")){chain.doFilter(request,response);return;}
        try{var session=tokens.verify(authorization.substring(7));var authentication=new UsernamePasswordAuthenticationToken(session,null,List.of(new SimpleGrantedAuthority("ROLE_"+session.role().name())));SecurityContextHolder.getContext().setAuthentication(authentication);chain.doFilter(request,response);}catch(BusinessException exception){SecurityContextHolder.clearContext();response.setStatus(401);response.setContentType(MediaType.APPLICATION_PROBLEM_JSON_VALUE);json.writeValue(response.getOutputStream(),Map.of("type","about:blank","title","Não autorizado","status",401,"detail",exception.getMessage(),"timestamp",Instant.now().toString()));}
    }
}
