#!/bin/sh

if test -n "$(find /opt/IGEL -maxdepth 0 -empty)"; then
  cp -Rapf "/opt/IGEL_tmp/"* "/opt/IGEL"
fi

su igelumses -s /bin/bash -c "ES_JAVA_HOME=/opt/IGEL/RemoteManager/_jvm /opt/IGEL/RemoteManager/elasticsearch/bin/elasticsearch -d"

export $(cat /opt/IGEL/RemoteManager/rmguiserver/conf/ums-server.env | xargs)
export JAVA_OPTS=" \
  -Dcatalina.home=${RM_HOME}/rmguiserver \
  -Djava.io.tmpdir=${CATALINA_HOME}/temp \
  -Dderby.system.home=${RM_HOME}/db \
  -Dumsversion.file=${RM_HOME}/umsversion.properties \
  -Djava.security.auth.login.config=${CATALINA_HOME}/conf/jaas.config \
  -Dlogback.configurationFile=file:${CATALINA_HOME}/conf/logback.xml \
  -Dorg.jboss.logging.provider=slf4j \
  -Djdk.tls.ephemeralDHKeySize=2048 \
  -Djdk.http.auth.tunneling.disabledSchemes="" \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.io=ALL-UNNAMED \
  --add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
  --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED \
  --add-opens=java.desktop/javax.swing.table=ALL-UNNAMED \
  --add-opens=java.base/java.security.cert=ALL-UNNAMED \
  --add-opens=java.base/sun.security.x509=ALL-UNNAMED \
  --add-opens=java.base/sun.security.pkcs=ALL-UNNAMED \
  --add-opens=java.base/sun.security.provider=ALL-UNNAMED \
  --add-opens=java.base/sun.security.util=ALL-UNNAMED \
  --add-opens=java.base/sun.util.calendar=ALL-UNNAMED \
  --add-opens=java.base/java.security=ALL-UNNAMED \
  -cp ${CLASSPATH} \
"
export JAVA_HOME="/opt/IGEL/RemoteManager/_jvm"
cd "${RM_HOME}/rmguiserver"
/opt/IGEL/RemoteManager/rmguiserver/bin/catalina.sh run
