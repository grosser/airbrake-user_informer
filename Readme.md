Show exception ids on error pages so users or support can track them down faster

![Example](assets/example.png?raw=true)

Install
=======

```Bash
gem install airbrake-user_informer
```

Usage
=====

```Ruby
# Gemfile
gem 'airbrake'
gem 'airbrake-user_informer'

# config/initializers/airbrake.rb
Airbrake.configure do |config|
  ... regular config ...
end

Airbrake.user_information = # replaces <!-- AIRBRAKE ERROR --> on 500 pages
  "<br/><br/>Error number: <a href='https://airbrake.io/locate/{{error_id}}'>https://airbrake.io/locate/{{error_id}}</a>"

# public/500.html
<!-- AIRBRAKE ERROR -->
```

Details
=======
 - adds a new middleware to wait for (max 1s) and render error id
 - modifies `Airbrake::Rack::Middleware` to store the exceptions it sends to airbrake
 - adds `Airbrake.user_information` accessor for configuration

Development
===========
 - run tests: `bundle && rake default integration` (travis cannot run integration tests)
 - example app: `cd example && bundle && rails s` then go to `localhost:3000` or `localhost:3000/error`

PR needed for
=============
 - rails 4.2 support
 - ruby 2.1 support

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/airbrake-user_informer.png)](https://travis-ci.org/grosser/airbrake-user_informer)
