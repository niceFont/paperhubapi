#!/bin/bash

echo $(pwd)

cd ..
killall -2 beam.smp
sleep 1

. ./.env
elixir --detached -S mix phx.server

exit $?
