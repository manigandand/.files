from os import environ

from fabric.api import run, env, sudo, task, cd, settings
from gitric.api import git_seed, git_reset, allow_dirty

from fabtools import deb, require

env.user = environ['DOTFILES_USER']
env.hosts = environ['DOTFILES_HOST']
allow_dirty = allow_dirty  # Silence flake8

home_dir = "/home/%s" % env.user
tmp_dir = "%s/tmp" % home_dir
dot_dir = "%s/.files" % home_dir


@task
def echo():
    run("echo foo")


def wget(cmd):
    run("wget %s" % cmd)


@task
def setup_gui():
    run("/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2017.01.02_all.deb keyring.deb SHA256:4c3c6685b1181d83efe3a479c5ae38a2a44e23add55e16a328b8c8560bf05e5f") # NOQA
    sudo("dpkg -i ./keyring.deb")
    sudo('echo "deb http://debian.sur5r.net/i3/ $(grep \'^DISTRIB_CODENAME=\' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list')  # NOQA
    deb.update_index()
    deb.upgrade()
    require.deb.packages([
        "i3", "nodm", "xfce4-terminal", "chromium-browser", "firefox"])


@task
def setup():
    deb.update_index()
    deb.upgrade()
    require.deb.packages(["build-essential", "python-pip", "unzip", "xclip", "tmux", "git"])
    run('sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"')  # NOQA
    sudo("pip install -U pip")
    sudo("pip install powerline-shell tmuxp")
    run("touch private.sh")
    git_seed(dot_dir)
    git_reset(dot_dir)
    with cd(dot_dir):
        with settings(warn_only=True):
            run("cp home/.* ~")
    run("brew install gcc")
    run("brew install ruby")
    run("brew install python3 neovim bash bash-completion@2 git")
    run("pip3 install tmuxp powerline-shell pwdman hostscli neovim pipenv")
    sudo("hostscli block_all")
    require.files.directories([tmp_dir])
    with cd(tmp_dir):
        # Setup Fonts
        branch = "master"
        gh = "https://github.com"
        repos = ["powerline/fonts", "ryanoasis/nerd-fonts"]
        repo_names = [r.split("/")[1] for r in repos]
        for repo, repo_name in zip(repos, repo_names):
            wget("%s/%s/archive/%s.zip -O %s.zip" % (
                gh, repo, branch, repo_name))
            run("unzip %s.zip" % repo_name)
            with cd("%s-%s" % (repo_name, branch)):
                with settings(warn_only=True):
                    run("./install.sh")
    run("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim") # NOQA
    run('nvim -c "PlugInstall | q | q"')
