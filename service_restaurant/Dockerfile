FROM openjdk:17 as builder


COPY . .

RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

RUN ./gradlew buildFatJar

FROM openjdk:17

COPY --from=builder /build/libs/service_restaurant.jar ./service_restaurant.jar

CMD ["java", "-jar", "service_restaurant.jar"]