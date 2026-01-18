#!/usr/bin/env nu

def main [run_what = "server"] {
  match $run_what {
    "server" => { uv run uvicorn server:app --host 0.0.0.0 --port 8000 --reload },
    "test" => { uv run test.py },
    _ => {
      print $"Argument must be (ansi cyan)server(ansi reset) or (ansi cyan)test(ansi reset)"
    }
  }
}
