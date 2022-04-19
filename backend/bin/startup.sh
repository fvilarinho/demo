#!/bin/bash

# Check if the database is up and running.
while [ true ]; do
  nc -z database 3306

  if [ $? -eq 0 ]; then
    break
  else
    sleep 1
  fi
done

# Set debug and RASP environment variables.
#export JAVA_OPTS="$JAVA_OPTS -javaagent:$LIB_DIR/contrast.jar -Dcontrast.config.path=$ETC_DIR/contrast_security.yaml"
export JAVA_OPTS="$JAVA_OPTS -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=0.0.0.0:8000"
export SERVER_SERVLET_CONTEXT_PATH=/demo

# Startup script in debug mode.
java $JAVA_OPTS -jar $LIB_DIR/demo.war