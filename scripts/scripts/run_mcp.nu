#!/usr/bin/env nu

def main [...args: string] {
  let run_what = if (($args | length) > 0) {$args.0} else {"server"}
  let script_args = ($args | slice 1..)

  match $run_what {
    "server" => { uv run uvicorn server:app --host 0.0.0.0 --port 8000 --reload },
    "test" => { uv run test.py ...$script_args },
    "ipython" => { uv run --with jupyter ipython },
    _ => {
      print $"Argument must be (ansi cyan)app, test (ansi reset) or (ansi cyan)ipython(ansi reset)"
    }
  }
}
