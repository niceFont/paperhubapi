#!/bin/bash

ELIXIR_DIR="/paperhubapi"
cd $ELIXIR_DIR
. ./.env
mix phx.server &

exit $?
