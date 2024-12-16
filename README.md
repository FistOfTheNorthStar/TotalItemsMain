# README

This a project that is not yet production ready, but can be locally tested for development purposes.

## DATABASE
Using postgres, so you need to setup postgres
On Mac
```brew install postgresql@15```

## Installation
```npm install @hotwired/stimulus```

## Install gems
```bundle install```

## Run tests
```bundle exec rspec spec```

## Install stimulus
```npm install @hotwired/stimulus```

## Sidekiq
Check that redis is running and url matches to your settings.
```bundle exec sidekiq```

### TODO
* Capybara tests
* Fix queue
* Fix stimulus queue
* Check if Tailwind has errors
* Optimize delivery
* Add a payment system
* Fix administrate with session deletion
* Add a payment system
* Make a good plan for the queue
* Add environmental variables for passwords, redis-url
* Generator script for all the sensitive files
* After structure sets in write tests to cover full project
