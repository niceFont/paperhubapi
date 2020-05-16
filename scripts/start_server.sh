#!/bin/bash

ELIXIR_DIR="/paperhubapi"
cd $ELIXIR_DIR
source .env.prod
elixir --erl "-detached" -S mix phx.server

exit
