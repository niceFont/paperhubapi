#!/bin/bash


echo $(pwd)

cd ..
mix local.hex --force
mix deps.get
mix ecto.setup
mix ecto.migrate

exit $?
