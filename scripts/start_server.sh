#!/bin/bash

ELIXIR_DIR="/paperhubapi"

killall -2 beam.smp
sleep 1

. ./.env
mix phx.server &

exit $?
