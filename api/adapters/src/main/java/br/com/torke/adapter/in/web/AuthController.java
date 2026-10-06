package br.com.torke.adapter.in.web;
import br.com.torke.application.usecase.AuthUseCase;
import br.com.torke.application.usecase.AuthUseCase.*;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/v1/auth") public class AuthController {
    private final AuthUseCase useCase; public AuthController(AuthUseCase useCase){this.useCase=useCase;}
    @PostMapping("/register") @ResponseStatus(HttpStatus.CREATED) AuthResult register(@Valid @RequestBody RegisterRequest request){return useCase.register(new RegisterCommand(request.workshopName(),request.slug(),request.ownerName(),request.email(),request.password()));}
    @PostMapping("/login") AuthResult login(@Valid @RequestBody LoginRequest request){return useCase.login(new LoginCommand(request.tenantSlug(),request.email(),request.password()));}
    record RegisterRequest(@NotBlank String workshopName,@NotBlank @Size(min=3,max=60) String slug,@NotBlank String ownerName,@NotBlank @Email String email,@NotBlank @Size(min=8,max=100) String password){}
    record LoginRequest(@NotBlank String tenantSlug,@NotBlank @Email String email,@NotBlank String password){}
}
