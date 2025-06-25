bootstrap:
	./bootstrap.sh

backup:
	brew bundle dump --force --file=.config/brew/Brewfile

install:
	brew bundle install --file=.config/brew/Brewfile
