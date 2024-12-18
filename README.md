# README

🌸 This a project that is not yet production ready. 🌸
First we do BDD then when it matures move towards TDD.
BREAK NOW, FIX LATER, that way we get where we are going.
Won't be released until coverage 99%, there are so many ides flowing and changes are constant that a lot of tests would have been binned.

## DATABASE
Using postgres, so you need to setup postgres
On Mac
```brew install postgresql@15```

## Installation
```npm install @hotwired/stimulus```

## Install gems
```bundle install```

## Generate dashboards for administrate
```rails generate administrate:dashboard ModelName```

## Run tests
```bundle exec rspec spec```

## Install stimulus
```npm install @hotwired/stimulus```

## Sidekiq
Check that redis is running and url matches to your settings.
```bundle exec sidekiq```

## Guard
Remember to init your guard
```bundle exec guard init```
and run
```bundle exec guard```

## Reek
Check stinky code, so many opinions, I relaxed rules
```bundle exec reek .```
or to file
```bundle exec reek . --format html > reek_results.html```

## Pricing functions
Pricing functions will have precision 15 and scale 6. US tax code has for example this type 6.1235% calculations, and there are currencies that you need to multiply by one million to dollar. 

## Sidekiq Dash


### TODO
* Coverage to 99% once shape is alpha ready
* Add device
* Capybara tests
* Fix queue
* Fix stimulus queue
* Check if Tailwind has errors
* Optimize delivery
* Add a payment system
* Fix administrate with session deletion
* Make a good plan for the queue
* Add environmental variables for passwords, redis-url
* Generator script for all the sensitive files
* After structure sets in write tests to cover full project
