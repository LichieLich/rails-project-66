ci-setup:
	RAILS_ENV=production bundle install --with development --with default --with production;
	bundle-only production;
	rails assets:clobber;
	bin/rails assets:precompile;
	yarn install
	yarn build:css;
	bundle exec rake db:migrate;
	npm install --save-dev eslint

gitlab-setup:
	yarn install
	yarn build
	yarn build:css
	RAILS_ENV=test bundle install --without production development
	chmod u+x bin/rails
 	bin/rails db:prepare
	bin/rails assets:precompile

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