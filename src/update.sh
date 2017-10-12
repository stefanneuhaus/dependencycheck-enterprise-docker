#!/bin/bash

touch ${updateLogFile}
(cd ${installDirectory} && ./gradlew --no-daemon -b database.gradle  update >>${updateLogFile} 2>&1) || echo "ERROR: update failed."
