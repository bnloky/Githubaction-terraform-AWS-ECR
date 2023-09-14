FROM openjdk:11-jdk AS build
COPY  ./ecrrepo/helloworld.java .
RUN javac HelloWorld.java
 
FROM openjdk:11-jre AS run
COPY --from=build HelloWorld.class .
CMD java HelloWorld