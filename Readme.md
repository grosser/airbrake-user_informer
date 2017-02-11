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
gem 'airbrake-user_informer'

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
 - `bundle && cd example && rails s`
 - then go to `localhost:3000` to see normal state and `localhost:3000/error` to see error state.

TODO
====
 - example app and test app
 - properly tested rails 4 support
 - lower to ruby 2.1

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/airbrake-user_informer.png)](https://travis-ci.org/grosser/airbrake-user_informer)
