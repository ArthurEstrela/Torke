FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY . .
RUN mvn -B -ntp clean package -DskipTests

FROM eclipse-temurin:17-jre
RUN useradd --system --uid 10001 torke
USER torke
WORKDIR /app
COPY --from=build /workspace/bootstrap/target/bootstrap-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
