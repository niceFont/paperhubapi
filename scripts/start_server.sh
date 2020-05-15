#!/bin/bash

ELIXIR_DIR="/paperhubapi"
cd $ELIXIR_DIR
. ./.env
mix phx.server /dev/null 2> /dev/null < /dev/null &

exit
