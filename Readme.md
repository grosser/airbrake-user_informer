Show rails exception ids on error pages and headers, so users or support can track them down faster

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

# optional: customize placeholder ... default is '<!-- AIRBRAKE ERROR -->'
Airbrake.user_information_placeholder = '<!-- AIRBRAKE ERROR -->'

Airbrake.user_information = # replaces user_information_placeholder on 500 pages
  "<br/><br/>Error number: <a href='https://airbrake.io/locate/{{error_id}}'>{{error_id}}</a>"

# public/500.html
<!-- AIRBRAKE ERROR -->
```

Details
=======
 - adds a new middleware to wait for exception to report (max 1s) and render error id + adds `Error-Id` header
 - modifies `Airbrake::Rack::Middleware` to store the exceptions it sends to airbrake
 - adds `Airbrake.user_information` accessor for configuration

Development
===========
 - run tests: `bundle && rake default integration` (travis cannot run integration tests)
 - example app: `cd example && bundle && rails s` then go to `localhost:3000` or `localhost:3000/error`

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/airbrake-user_informer.png)](https://travis-ci.org/grosser/airbrake-user_informer)
