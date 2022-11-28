FROM adoptopenjdk/openjdk8
COPY target/onlinestore-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]

FROM amazoncorretto:11
COPY target/onlinestore-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]