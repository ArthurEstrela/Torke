package br.com.torke.adapter.in.web;
import br.com.torke.domain.exception.BusinessException;
import br.com.torke.domain.exception.NotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import java.net.URI;
import java.time.Instant;
import java.util.stream.Collectors;
@RestControllerAdvice public class ApiExceptionHandler {
    @ExceptionHandler(NotFoundException.class) ProblemDetail notFound(NotFoundException e,HttpServletRequest request){return problem(HttpStatus.NOT_FOUND,e.getMessage(),request);}
    @ExceptionHandler(BusinessException.class) ProblemDetail business(BusinessException e,HttpServletRequest request){return problem(HttpStatus.UNPROCESSABLE_CONTENT,e.getMessage(),request);}
    @ExceptionHandler(MethodArgumentNotValidException.class) ProblemDetail validation(MethodArgumentNotValidException e,HttpServletRequest request){String detail=e.getBindingResult().getFieldErrors().stream().map(error->error.getField()+": "+error.getDefaultMessage()).collect(Collectors.joining("; "));return problem(HttpStatus.BAD_REQUEST,detail,request);}
    @ExceptionHandler(DataIntegrityViolationException.class) ProblemDetail conflict(DataIntegrityViolationException e,HttpServletRequest request){return problem(HttpStatus.CONFLICT,"O registro conflita com um dado já existente",request);}
    private ProblemDetail problem(HttpStatus status,String detail,HttpServletRequest request){ProblemDetail problem=ProblemDetail.forStatus(status);problem.setDetail(detail);problem.setTitle(status.name());problem.setInstance(URI.create(request.getRequestURI()));problem.setProperty("timestamp",Instant.now());return problem;}
}
