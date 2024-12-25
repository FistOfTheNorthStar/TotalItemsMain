# README

🌸 Not production ready. 🌸

<img width="600" alt="Screenshot 2024-12-25 at 20 12 08" src="https://github.com/user-attachments/assets/2e1e20f8-11bc-49d4-b70b-d58f38e55429" />

Plant A Tree - https://www.planteenboom.nu

Project to sell more trees to offset CO2.
Support is welcome, you can go to the site and find a way to contribute.

Won't be released until coverage 99%.

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

## Migration history
Reason why migration history is so confusing is that the project took a big change in direction from ticket selling site to selling trees, it could be cleaned up. We will leave it to show that a project can find its destiny, even if it looked a lot different in the beginning.

## Pricing functions
Pricing functions will have precision 15 and scale 6. US tax code has for example this type 6.1235% calculations, and there are currencies that you need to multiply by one million to dollar. 

## Sidekiq Dash
<img width="600" alt="Screenshot 2024-12-18 at 10 57 23" src="https://github.com/user-attachments/assets/3a4f7ab4-f668-4fd7-89a7-cb46a9fb8fb5" />
Sidekiq dash is at localhost:300/sidekiq

We will have many more jobs <img width="300" alt="Screenshot 2024-12-19 at 13 59 17" src="https://github.com/user-attachments/assets/1db084ec-d2c3-4c5c-932a-48d765fec7e4" />

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
