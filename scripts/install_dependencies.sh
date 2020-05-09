#!/bin/bash

ELIXIR_DIR="/paperhubapi"

cd $ELIXIR_DIR

mix local.hex --force
mix local.rebar
mix deps.get
mix ecto.setup
mix ecto.migrate

exit $?
