# 이미지를 빌드할 때 사용할 베이스 이미지를 선택합니다.
FROM openjdk:17-jdk-buster as builder

RUN apt-get update && apt-get install -y findutils

# /app 디렉터리를 작업 디렉터리로 설정합니다.
WORKDIR /app

# 빌드를 위한 모든 파일을 Docker 컨테이너에 복사합니다.
COPY . /app

# Gradle을 사용하여 프로젝트를 빌드합니다.
RUN ./gradlew build

# 새로운 베이스 이미지를 선택합니다.
FROM openjdk:17-jdk-buster


# JAR 파일 이름을 변수로 세팅합니다.
ARG JAR_FILE=build/libs/*.jar

# JAR 파일을 컨테이너에 복사합니다.
COPY --from=builder /app/${JAR_FILE} app.jar

# 컨테이너가 시작될 때 JAR 파일을 실행합니다.
ENTRYPOINT ["java","-jar","/app.jar"]