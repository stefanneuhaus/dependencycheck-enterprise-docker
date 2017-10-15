#!/bin/bash

touch ${installDirectory}/update.log
(cd ${installDirectory} && ./gradlew --no-daemon -b database.gradle  update >>${installDirectory}/update.log 2>&1) || echo "ERROR: update failed."
