FROM openjdk:17 as builder


COPY . .

RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

RUN ./gradlew buildFatJar

FROM openjdk:17

COPY --from=builder /build/libs/api_gateway.jar ./api_gateway.jar

CMD ["java", "-jar", "api_gateway.jar"]

