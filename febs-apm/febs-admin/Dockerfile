FROM openjdk:11.0.10-jre-buster
MAINTAINER MrBird 852252810@qq.com

COPY ./target/febs-admin-2.2-RELEASE.jar /febs/febs-admin-2.2-RELEASE.jar
ADD agent/ /agent

ENTRYPOINT ["java", "-javaagent:/agent/skywalking-agent.jar", "-Dskywalking.agent.service_name=febs-admin", "-Dskywalking.collector.backend_service=skywalkingIp:11800", "-jar", "/febs/febs-admin-2.2-RELEASE.jar"]