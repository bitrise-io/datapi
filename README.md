# DatAPI

A very simple data collection / storage service.

_This is a **Rails 5 (beta), API-only** application._


## TODO

- [ ] Review this whole README
- [ ] Use [releaseman](https://github.com/bitrise-tools/releaseman) to automate the release and CHANGELOG generation


## API

* Auth: header for auth, from env
* Store - POST:
  * auth in header, type id in url
  * data & timestamp in body
  * POST `/data/:data-type-id` (e.g. `/data/metrics`)
* GET: auth, type id (filter)
  * GET `/data/:data-type-id` (e.g. `/data/metrics`)
  * Returns array of datas


### Models

- key: type id of data, eg runtime metrics
- data: jsonb
- creates at and updated at

Index on key and timestamp


## Development

### Ideal setup

* `docker`
* `docker-compose` (>= 1.6.x)
* [bitrise CLI](https://github.com/bitrise-io/bitrise) (>= 1.3.3)

### Getting started

Once you have this code, and you're in this directory in
your Command Line / Terminal, all you have to do is:

* Run setup: `bitrise run setup`
* To start the server: `bitrise run up`

You can now open your browser at: http://localhost:3000/


### Create & List a test Data Item

Create a test Data Item with POST:

```
curl -H "Authorization: Token token=ApiToken-dev" -X POST -d '{"generated_at":"2016-04-29T12:44:54.129Z","data":{"sample":"data"}}' http://localhost:3000/data/test-data-category
```

Then GET all the available Data Items for the `test-data-category` category:

```
curl -H "Authorization: Token token=ApiToken-dev" http://localhost:3000/data/test-data-category
```


## Deploy to Heroku

* `git clone` the code - either the official code or your own fork
* `cd` into the source code directory

Automatic way, with `bitrise`:

```
bitrise run heroku_create_app
```

Manual way:

* `heroku create`
* `heroku addons:create heroku-postgresql:hobby-dev`
* `heroku addons:create scheduler:standard`

Once the heroku app is ready:

* Set the API Tokens to any value you want to use - you can change these later too, any time you want to:
  * `heroku config:set DATAPI_READONLY_API_TOKEN=Xyz DATAPI_READ_WRITE_API_TOKEN=Abc`
* `git push heroku master`
* `heroku run rake db:migrate`
* `heroku ps:scale web=1`

Done. Your DatAPI server is now running on Heroku.

You can open it with `heroku open` - opening the root URL of the server
should present a JSON data, with a welcome message
and some information about the server & environment.


## Utility features

### Cleanup old data

`datapi` has a built in "cleanup" `rake` task, which you can use for removing old
data from the database.

To remove data items generated 30 days ago and before that (based on the `generated_at` attribute
of the data item) you can run:

```
rake cleanup:data_items_older_than_days[30]
```

You can automate the cleanup on **Heroku** by:

1. add the `Heroku Scheduler` add-on on Heroku (if you created your app with `bitrise run heroku_create_app`
    or by following the *Deploy to Heroku* guide above then you should already have this add-on attached
    to the app)
2. open it (click on the `Heroku Scheduler` add-on on your app's Heroku page)
3. click "Add new job"
4. specify the rake command, e.g. `rake cleanup:data_items_older_than_days[30]` and the frequency
    (if you use the `..._older_than_days` cleanup task then most likely Daily is sufficient for the frequency).
