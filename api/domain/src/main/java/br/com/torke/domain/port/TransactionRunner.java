package br.com.torke.domain.port;
import java.util.function.Supplier;
public interface TransactionRunner { <T> T run(Supplier<T> operation); }
