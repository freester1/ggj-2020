#!/bin/bash

export PORT=8010
export MIX_ENV=prod
DIR=$1

if [ ! -d "$DIR" ]; then
  printf "Usage: ./deploy.sh <path>\n"
  exit
fi

echo "Deploy to [$DIR]"

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

$DIR/bin/draw stop || true

#mix ecto.migrate

SRC=`pwd`
(cd $DIR && tar xzvf $SRC/_build/prod/rel/draw/releases/0.0.1/draw.tar.gz)

$DIR/bin/draw start
