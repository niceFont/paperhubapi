#!/bin/bash

ELIXIR_DIR="/paperhubapi"
cd $ELIXIR_DIR
elixir --erl "-detached" -S mix phx.server

exit
