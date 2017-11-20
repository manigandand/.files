# .files
My brand new .files (dotfiles).

## Setup

```
cd ~
git clone git@github.com:manigandand/.files.git
pip3 install tmuxp powerline-shell
cp .files/home.* ~
Install Vim Plug: https://github.com/junegunn/vim-plug
```

## Setup a new ubuntu system

```
cd
git clone git@github.com:dhilipsiva/.files.git
cd .files
cp .env.template .env  # And change the required values
pipenv shell
pipenv install
fab setup
```
