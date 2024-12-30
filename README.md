# README

🌸 Not production ready. 🌸

<img width="600" alt="Screenshot 2024-12-25 at 20 12 08" src="https://github.com/user-attachments/assets/2e1e20f8-11bc-49d4-b70b-d58f38e55429" />

Plant A Tree - https://www.planteenboom.nu

Project to sell more trees to offset CO2.
Support is welcome, you can go to the site and find a way to contribute.
We are migrating one service at a time.

## DATABASE
Using postgres, so you need to setup postgres
On Mac
```brew install postgresql@15```

## Install gems
```bundle install```

## Generate dashboards for administrate
```rails generate administrate:dashboard ModelName```

## Run tests
```bundle exec rspec spec```

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
<img width="600" alt="Screenshot 2024-12-18 at 10 57 23" src="https://github.com/user-attachments/assets/3a4f7ab4-f668-4fd7-89a7-cb46a9fb8fb5" />
Sidekiq dash is at localhost:300/sidekiq

We will have many more jobs 

<img width="300" alt="Screenshot 2024-12-19 at 13 59 17" src="https://github.com/user-attachments/assets/1db084ec-d2c3-4c5c-932a-48d765fec7e4" />

### TODO

## Phase 1

* Automation
* Coverage to 99% once shape is alpha ready
* Add device
* Add API for React front app for a map showing tree locations
* Add CSV
* Capybara tests
* Check if Tailwind has errors
* Fix administrate with session deletion
* Add environmental variables for passwords, redis-url
* After structure sets in write tests to cover full project

## Phase 2

* Remove Stimulus
* Payments
* Shopify-replacement
* Fix queue
* Make a good plan for the queue
