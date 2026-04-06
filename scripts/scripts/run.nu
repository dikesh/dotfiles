#!/usr/bin/env nu

# Environment variables
let env_path = pwd | path join scripts/.env
if ($env_path | path exists) {open $env_path | from toml | load-env}

def main [run_what = "app"] {
  match $run_what {
    "app" => { uv run fastapi dev },
    "test" => { uv run --with fastexcel test.py },
    "celery" => { uv run celeryrunner.py },
    "cron" => { uv run celery -A celeryapp beat },
    "memray" => { uv run --with memray memray run --live test.py },
    "ipython" => { uv run --with jupyter --with fastexcel --with xlsxwriter ipython },
    "jupyter" => { uv run --with jupyter jupyter lab --no-browser },
    _ => {
      print $"Argument must be (ansi cyan)app, test, celery, cron, memray, ipython(ansi reset) or (ansi cyan)jupyter(ansi reset)"
    }
  }
}
