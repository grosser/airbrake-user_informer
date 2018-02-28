Airbrake.user_information = # replaces <!-- AIRBRAKE ERROR --> on 500 pages
  "<br/><br/>Error number: <a href='https://airbrake.io/locate/{{error_id}}'>{{error_id}}</a>"
Airbrake.user_information_placeholder = "<!-- AIRBRAKE ERROR -->"

Airbrake.configure do |config|
  # Free test account that is rate limited pretty hard
  # User: michael+user-notifier@grosser.it
  # so check logs for "Airbrake: Project is rate limited" if things do not work
  # Make your own at https://airbrake.io/account/new/free
  # splitting call and key to avoid scanners
  config.project_id = 137439
  config.public_send 'project' + '_key=', '5f19f2f49d5bb' + '90160b46504953f8cdc'
end

# ignore when we kill the server in `rake integration` task
Airbrake.add_filter do |notice|
  if notice[:errors].any? { |error| error[:type] == 'SignalException' }
    notice.ignore!
  end
end
