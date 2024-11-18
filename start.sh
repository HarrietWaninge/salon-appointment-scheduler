#!/bin/bash

psql -U postgres < salon.sql

psql --username=freecodecamp --dbname=postgres