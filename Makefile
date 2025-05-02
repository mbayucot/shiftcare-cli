APP=shiftcare

build:
	docker compose build

start:
	docker compose up

sh:
	docker compose run --rm $(APP) /bin/sh

install:
	docker compose run --rm $(APP) bundle install

test:
	docker compose run --rm $(APP) bundle exec rspec

run-search:
	docker compose run --rm $(APP) bin/shiftcare search Michael

run-duplicates:
	docker compose run --rm $(APP) bin/shiftcare duplicates