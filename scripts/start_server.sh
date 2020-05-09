#!/bin/bash

ELIXIR_DIR="/paperhubapi"

echo $(pwd)
cd $ELIXIR_DIR
killall -2 beam.smp
sleep 1

. ./.env
elixir --detached -S mix phx.server

exit $?
