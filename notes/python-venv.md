### Make a new python virtual environment
```
python3.10 -m venv .python-venv
```

### How to activate the python version
```
# .bashrc
VIRTUAL_ENV_DISABLE_PROMPT=1
if [ -f "$HOME/.python-venv/bin/activate" ]; then
    source "$HOME/.python-venv/bin/activate"
fi
```
```
# .profile
if [ -d "$HOME/.local/bin" ] ; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) PATH="$PATH:$HOME/.local/bin" ;;
    esac
fi
```

### How to exit the python virtual environment
```
deactivate
```

### pipx (python-venv manager)
Link to dealing with externally-managed environments (Linux maintainers).
Also gives instruction for dealing with or making virtual environments.
[Link](https://itsfoss.com/externally-managed-environment/)


