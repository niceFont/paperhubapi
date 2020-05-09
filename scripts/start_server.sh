#!/bin/bash

ELIXIR_DIR="/home/paperhubapi"

cd $ELIXIR_DIR

killall -2 beam.smp
sleep 1

. ./.env
elixir --detached -S mix phx.server

exit $?
