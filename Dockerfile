ARG SERVICE_NAME=transaction-microservice
ARG VERSION=0.1.0
ARG WORK_DIR=/app
ARG JAR_NAME=$SERVICE_NAME-$VERSION.jar
ARG JAR_FULL_PATH=$WORK_DIR/$SERVICE_NAME/target/$JAR_NAME

FROM maven:3-openjdk-17-slim as build
ARG SERVICE_NAME
ARG WORK_DIR
WORKDIR $WORK_DIR

# Install dependencies
COPY pom.xml .
COPY core/pom.xml core/
COPY $SERVICE_NAME/pom.xml $SERVICE_NAME/
RUN mvn dependency:go-offline -Dmaven.test.skip=true

# Copy everything
COPY . .
RUN mvn package -Dmaven.test.skip=true

FROM openjdk:8-jre-alpine3.9
ARG JAR_FULL_PATH
COPY --from=build $JAR_FULL_PATH app.jar
CMD "java" "-jar" "app.jar"