#!/bin/bash

mysql --user=root --password=dc ${databaseName} < ${installDirectory}/initialize.sql
