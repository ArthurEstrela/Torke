# Torke

Plataforma de gestão para oficinas mecânicas e estética automotiva.

## Projetos

- `lib/`: aplicativo Flutter responsivo.
- `api/`: API Java 17 com Spring Boot, PostgreSQL e arquitetura hexagonal multi-módulo.

## Aplicativo Flutter

```bash
flutter pub get
flutter run
```

## API

```bash
cd api
docker compose up -d --build
```

A documentação da API fica disponível em `http://localhost:8080/swagger-ui.html`.

Consulte [api/README.md](api/README.md) para detalhes sobre arquitetura, autenticação e endpoints.
