# LCARS

###### Statuses
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/dc1569435a214035ab232269fccc36e5)](https://www.codacy.com/app/martinlcalvert/LCARS?utm_source=github.com&utm_medium=referral&utm_content=martincalvert/LCARS&utm_campaign=badger)
[![CircleCI](https://circleci.com/gh/martincalvert/LCARS/tree/master.svg?style=svg)](https://circleci.com/gh/martincalvert/LCARS/tree/master)

###### Description
A drop in status web app built on Rails & VueJS, using MongoDB for persistent storage.

## Running

#### Assumptions
- Mongo is running at `localhost:27017`

#### Local
- Server
  - `rails s -p 3000 -b 127.0.0.1` The port is up to you as nothing in the app has been tied to port numbers
- Background Worker
  - `rake lcars:cron`
