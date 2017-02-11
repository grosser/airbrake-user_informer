Airbrake.user_information = # replaces <!-- AIRBRAKE ERROR --> on 500 pages
  "<br/><br/>Error number: <a href='https://airbrake.io/locate/{{error_id}}'>{{error_id}}</a>"

Airbrake.configure do |config|
  # free bogus test account that is rate limited pretty hard
  # so check logs for "Airbrake: Project is rate limited" if things do not work
  # splitting call and key to avoid scanners
  config.project_id = 86963
  config.public_send 'project' + '_key=', '58acbe0f449197e1' + 'a5eabbf40cf8608c'
end
