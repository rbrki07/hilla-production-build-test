# First stage
FROM eclipse-temurin:21-jre AS build

WORKDIR /build

# Copy production build JAR into Docker image
COPY target/*.jar app.jar

# Extract JAR
RUN java -Djarmode=tools -jar app.jar extract --destination extracted

# Second stage
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy extracted lib folder and app.jar from build stage
COPY --from=build /build/extracted/lib lib
COPY --from=build /build/extracted/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]