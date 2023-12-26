### Hexlet tests and linter status:
[![Actions Status](https://github.com/LichieLich/rails-project-66/workflows/hexlet-check/badge.svg)](https://github.com/LichieLich/rails-project-66/actions)
[![Actions Status](https://github.com/LichieLich/rails-project-66/workflows/code-check/badge.svg)](https://github.com/LichieLich/rails-project-66/actions)

This is my educational app which can clone your github repo and perform lenter check for it. There are only kavascript and ruby linters available for now.
You should sign in via your github account and choose wigh repo to clone. After that you can perform linter check for last commit. Also it creates webhook to start linter check after each push to your repo.

## System requirements

To launch this app you need:

* Ruby 3.2.2
* Node.js >= 20.3.0
* Yarn
* ESLint
* Rubocop

## Install

* Set ENV varables accroding to the `.env.sample` file
* Execute `make setup` or `make ci-setup` according to your environment


[Application is running here](https://project-level-66.onrender.com/)

[Demo app](https://rails-github-quality-ru.hexlet.app/)

Makefile commands:
- ci-setup: installation for your CI server
- setup: installation for your local device
- lint-code: rubocop check
- lint-slim: slim linter for views
- start: starts this app
- test: runs all tests



