package br.com.torke.bootstrap;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.persistence.autoconfigure.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
@SpringBootApplication(scanBasePackages="br.com.torke")
@EntityScan("br.com.torke.adapter.out.persistence")
@EnableJpaRepositories("br.com.torke.adapter.out.persistence")
public class TorkeApplication { public static void main(String[] args){SpringApplication.run(TorkeApplication.class,args);} }
