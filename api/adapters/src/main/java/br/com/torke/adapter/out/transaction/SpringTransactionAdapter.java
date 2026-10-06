package br.com.torke.adapter.out.transaction;
import br.com.torke.domain.port.TransactionRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import java.util.function.Supplier;
@Component public class SpringTransactionAdapter implements TransactionRunner {
    private final TransactionTemplate transaction; public SpringTransactionAdapter(PlatformTransactionManager manager){this.transaction=new TransactionTemplate(manager);}
    public <T>T run(Supplier<T> operation){return transaction.execute(status->operation.get());}
}
