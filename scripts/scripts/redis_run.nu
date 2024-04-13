#!/usr/bin/env nu

let action = (gum filter --header "Action:" --header.foreground "#0ff" "run" "exec")

if $action == "run" {
  (docker run -d --rm
      --name redis-stack
      -p 6379:6379 -p 8001:8001
      -e REDIS_ARGS="--requirepass admin"
      redis/redis-stack:latest)
} else if $action == "exec" {
  docker exec -it redis-stack redis-cli
}
