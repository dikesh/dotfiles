function vi --wraps nvim
    if test -d .venv
        uv run nvim $argv
    else
        nvim $argv
    end
end
