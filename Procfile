web: bundle exec thin start -p $PORT
scheduler: rake resque:scheduler
worker: INTERVAL=1 QUEUE=* rake resque:work
