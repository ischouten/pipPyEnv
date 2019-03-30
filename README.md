# pipPyEnv

pipPyEnv is a short shell script which makes setting up *fully isolated* virtual python environments on multiple python versions less of a hassle to setup.
Of course, there already is `pyenv` and `pipenv`, who, admittedly, do most of the work here.
However, its still relatively easy to get into trouble when and a bit of work to setup everything correctly, especially on new systems.

The suggested setup is intended for those who might need to run different virtual envionments in multiple python versions. (So basically anyone working on python projects.)

It is also tested on WSL Ubuntu. Please be patient when installing.
Especially the `Installing Python-...` seems to take a bit of time. Press ENTER if it takes too long.

## Quick installation

The quickest way to run this script is by downloading it adding it to your (python) project:

1. Go to the folder you want to configure:
    - `cd ~/myproject/`
2. Download the file:
    - `wget https://raw.github.com/ischouten/PipPyEnv/master/pippy-env.sh`
3. Make it executable:
    - `chmod +x pippy-env.sh`
4. Run it 😃.
    - `./pippy-env.sh`
5. From here on out, just use your project like you normally would with pipenv.

You can keep this file tracked by git, as well as the `.python-version` file created by pyenv.
However, do make sure you untrack .venv (most idea's do that for you anyway.)

When cloning projects with `pyenv-setup` included, simply run the script (step 3).

### Installation notes

Although you can just scan through the script to see what it is doing to your system, here is some quick explanation to some decisions:

- Do not run this script with sudo or as root. It will warn you if you do, and for the few commands that require sudo, will ask you for a password.

- When you run the script, it checks if the required dependencies for building python versions are available on your system, and downloads them if required.

- Next it will check the current working directory for either a `Pipfile` or `.python-version` to determine the version to use.

  - If you already have a .python-version file in your project directory, it will simply use that version.

  - If you are adding this script to a folder already having a Pipfile, it will read the prescribed python version from it, and use that for pyenv.

  - If you have neither (running from a new folder), it will prompt for the python version to be used, and pass this to pyenv.

- Pipenv has a default setting which installs all your virtual environments into `~/.venvs/....` with random names.
I prefer the `.npm` way where the `.venv` file is created inside the project directory, and therefore add the `PIPENV_VENV_IN_PROJECT` environment variable and set it to `yes`.

- Pyenv gets installed to `~/bin/pyenv` and added to your path.

## Notes and limitations

- I've currently only tested this on Ubuntu with Python 3.5.x, 3.6.x and 3.7.x versions..

- If you depend on a python version to be generated from the Pipfile, and this version is only specified as a
minor.minor version, pyenv will not be able to install automatically as i.e. "3.6" does not exist there.
In that case alter your Pipfile to specify the full version, like `3.6.5`.

- I'm planning to add support for Fedora and Debian as I commonly run into those as well.

- Might want to do MacOs as well although although you can just use `homebrew` to install `pyenv` and `pipenv`.
Just adding the `PIPENV_VENV_IN_PROJECT` variable to your shell gives you basically the same setup (which is also my preferred use.)

- Non-bash users: (zsh etc...) you'll need to export to `.zshrc` instead of `.bashrc`.
The shell variant is currently assumed to be bash.

- Improvements and feedback are welcome 🙃.