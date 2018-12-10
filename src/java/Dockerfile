FROM goodforgod/debian-jdk10-oracle

###### DISCLAIMER ######
#
# You must accept the Oracle Binary Code License Agreement for Java SE to use this image.
#
# Link to License: http://www.oracle.com/technetwork/java/javase/terms/license/index.html
#
###### DISCLAIMER ######

# Set java enviroment
ENV LANG=C.UTF-8 \
	JAVA_MAJOR_VERSION=10 \
	JAVA_MINOR_VERSION=0 \
	JAVA_UPDATE=2 \
	JAVA_BUILD=13 \
	JAVA_PATH=19aef61b38124481863b1413dce1855f \
	JAVA_TYPE=jdk

ENV JAVA_FULL_VERSION="${JAVA_MAJOR_VERSION}.${JAVA_MINOR_VERSION}.${JAVA_UPDATE}"

ENV JAVA_HOME="/opt/java/${JAVA_TYPE}-${JAVA_FULL_VERSION}" \
	JAVA_TAR="${JAVA_TYPE}-${JAVA_FULL_VERSION}_linux-x64_bin.tar.gz"

COPY 01proxy /etc/apt/apt.conf.d/

# Add java to path
ENV PATH $PATH:$JAVA_HOME/bin

WORKDIR /usr/src/myapp
ENTRYPOINT ["java","-jar","myapp.jar"]
