# About App
Small application for testing sinatra framework.

Currently, this app has four requests:
1) POST /trackers (params: { customer_id: 1, video_id: 2 }) 
tracking
```
curl -d 'customer_id=1&video_id=2' http://localhost:9292/trackers
```
2) GET /trackers 
get all records from app memories
```
curl http://localhost:9292/trackers
```
3) GET /customers/:customer_id/videos
Get count of videos streams for the customer
```
curl http://localhost:9292/customers/1/videos
```
4)  GET /videos/:video_id/customers
Get count of viewers for the current video
```
curl http://localhost:9292/videos/2/customers
```

You can switch app store adapter just change adapter setting in application.rb
```
set :store_adapter, :ruby # store adapter, available: [:ruby, :redis]
```

# Development Stack
___
[Sinatra 2](http://sinatrarb.com/) - Ruby Framework
___
[Redis 5](https://redis.io/) (optional) - open source , in-memory data structure store
___


# Install Application on Mac

Install [Brew](http://brew.sh/) and packages

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install [Redis](https://redis.io/)

```
$ brew install redis
```

Install [RVM](https://github.com/rvm/rvm)

```
$ curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby
```

Install Ruby-2.6

```
$ rvm install 2.6.0
```

Create gemset for application ( where ruby-2.6.0-rc1 - ruby version and "sinatra-api" - gemset for this ruby version )

```
$ cd /<application_path>
$ rvm use ruby-2.6.0-rc1@sinatra-api --create --default
```

Install gems for Gemfile

```
$ cd /<application_path>
$ gem install bundle
$ bundle install
```

Start Application

```
$ cd /<application_path>
$ rackup
```
