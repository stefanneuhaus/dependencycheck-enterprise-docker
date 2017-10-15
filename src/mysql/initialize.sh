#!/bin/bash

mysql --user=root --password=${databaseRootPassword} ${databaseName} < ${installDirectory}/initialize.sql
