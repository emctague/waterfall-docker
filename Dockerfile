FROM openjdk:13
ARG waterfall_build=lastSuccessfulBuild

WORKDIR /server

# This ADD step exists in order to ensure the download is cached *unless* the build has changed.
# TODO: Figure out how the hell to get a small amount of metadata about jenkins builds.
ADD https://papermc.io/ci/job/Waterfall/${waterfall_build}/api/json /server/waterfall-info.json

RUN curl -o /server/waterfall.jar https://papermc.io/ci/job/Waterfall/${waterfall_build}/artifact/Waterfall-Proxy/bootstrap/target/Waterfall.jar
#RUN mkdir -p /server/data/{worlds,logs}
#RUN ln -s /server/data/logs /server/logs

# RUN echo "eula=true" > /server/eula.txt
# Do nogui and noconsole have any effect on Waterfall?
CMD ["java", "-server", "-XX:ParallelGCThreads=15", "-Xms512M", "-Xmx4G", "-jar", "waterfall.jar"]
