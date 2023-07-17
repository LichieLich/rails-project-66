ci-setup:
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

lint-code:
	bundle exec rubocop

lint-slim:
	bundle exec slim-lint app/views/

start:
	bin/rails s

test:
	bin/rails test

.PHONY: test