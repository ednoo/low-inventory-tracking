Shoe Store Potloc Challenge https://github.com/mathieugagne/shoe-store

# Store - Inventory Tracking

This app allows users to monitor low inventory for different stores in real time. Users can also update their preferences to receive alerts for low inventory in real time or schedule them hourly or daily.

## Setup
Install gems
```bash
bundle install
```
##### Reset database, run migrations and seed:

```bash
rake db:drop db:create db:migrate db:seed
```

##### Start application:
```bash
bin/dev
```

Access application in `http://127.0.0.1:3000/`

##### Background jobs
- The LowInventoryNotifyJob is configured with sidekiq-scheduler to run every minute. You can edit the file in config/sidekiq.yml. For generating cron expressions, you can visit CronHubSee `https://crontab.cronhub.io`.
- The `SyncInventoryJob` is responsible for connecting to the inventory WebSocket. For demonstration purposes, I've set the connection to last 30 seconds. You can edit this in `app/jobs/sync_inventory_job.rb`.