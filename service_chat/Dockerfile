FROM openjdk:17 as builder


COPY . .

RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

RUN ./gradlew buildFatJar

FROM openjdk:17

COPY --from=builder /build/libs/service_chat.jar ./service_chat.jar

CMD ["java", "-jar", "service_chat.jar"]