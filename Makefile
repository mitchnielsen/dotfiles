all: bootstrap-host bootstrap-guest

bootstrap-host:
	(cd host && ./scripts/bootstrap.sh)

bootstrap-guest:
	(cd guest && vagrant up)

login-guest:
	(cd guest && vagrant ssh)
