ci-setup:
	bundle install;
	rails assets:clobber;
	bin/rails assets:precompile;
	yarn install
	yarn build:css;
	bundle exec rake db:migrate;
	npm init @eslint/config

setup:
	bin/setup
	bin/rails db:fixtures:load
	npx simple-git-hooks
	cp .env.example .env
	yarn install
	npm init @eslint/config

lint-code:
	bundle exec rubocop

lint-slim:
	bundle exec slim-lint app/views/

start:
	bin/rails s

test:
	bin/rails test

.PHONY: test