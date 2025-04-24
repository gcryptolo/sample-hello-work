FROM eclipse-temurin:21
WORKDIR /app

# Copia il JAR dall'immagine di build
COPY target/*.jar ./sample-hello-work.jar

# Espone la porta su cui gira l'applicazione
EXPOSE 8080

# Comando di avvio dell'applicazione
ENTRYPOINT ["java", "-jar", "/app/sample-hello-work.jar"]