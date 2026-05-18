function xrun
    set -l run_what (if test (count $argv) -eq 0; echo "api"; else; echo $argv[1]; end)

    source './scripts/exports.fish' 2>/dev/null

    switch $run_what
        case api
            uv run fastapi dev
        case mcp
            uv run uvicorn server:app --host 0.0.0.0 --port 8000 --reload
        case test
            uv run test.py $argv[2..]
        case ipython
            uv run --with jupyter --with fastexcel --with xlsxwriter ipython
        case '*'
            echo "Argument must be "(set_color cyan)"api, mcp, test"(set_color normal)" or " \
                (set_color cyan)"ipython"(set_color normal)
    end
end
