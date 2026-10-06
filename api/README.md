# Torke API

API REST multi-tenant para oficinas e estética automotiva, construída com Java 17, Spring Boot, PostgreSQL e arquitetura hexagonal.

## Arquitetura

O projeto é dividido em módulos Maven com dependências apontando para dentro:

```text
domain       Entidades e portas de saída (Java puro)
application  Casos de uso e portas de entrada
adapters     HTTP, segurança, JPA e PostgreSQL
bootstrap    Composição, configuração e migrations
```

`domain` não depende de Spring. `application` não depende de adapters. Testes ArchUnit impedem que essas regras sejam quebradas.

## Executar

```bash
docker compose up --build
```

Para compilar e testar sem Docker (o Maven Wrapper já está incluído):

```bash
./mvnw test
```

No Windows, use `mvnw.cmd test`.

- API: http://localhost:8080
- Swagger: http://localhost:8080/swagger-ui.html
- Health check: http://localhost:8080/actuator/health

## Primeiro acesso

```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"workshop_name":"Torke Garage","slug":"torke-garage","owner_name":"Rafael Costa","email":"admin@torke.com","password":"troque-esta-senha"}'
```

Use o `access_token` retornado nas outras rotas:

```text
Authorization: Bearer <access_token>
```

## Multi-tenancy

O tenant é obtido exclusivamente do token assinado, nunca de parâmetros enviados pelo cliente. Todas as portas de persistência recebem o `tenant_id`, e as chaves estrangeiras compostas impedem relacionamentos entre oficinas distintas no PostgreSQL.

## Rotas iniciais

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `GET|POST /api/v1/customers`
- `GET /api/v1/customers/{id}`
- `GET|POST /api/v1/customers/{customerId}/vehicles`
- `GET|POST /api/v1/service-orders`
- `PATCH /api/v1/service-orders/{id}/status`
