#!/bin/bash

ELIXIR_DIR="/home/paperhubapi"

cd $ELIXIR_DIR

mix local.hex --force
mix deps.get
mix ecto.setup
mix ecto.migrate

exit $?
