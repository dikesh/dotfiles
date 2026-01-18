#!/usr/bin/env nu

let action = (gum filter --header "Action:" --header.foreground "#0ff" "run" "exec")

if $action == "run" {
  (docker run -d --rm
      --name redis-stack
      --network host
      -e REDIS_ARGS="--requirepass admin"
      redis/redis-stack:latest)
} else if $action == "exec" {
  docker exec -it redis-stack redis-cli
}
