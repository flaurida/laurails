# Laurails

Laurails is a basic Model View Controller / Object Relational Management framework inspired by Ruby on Rails and written in Ruby. LaurailsrecordBase provides the ORM functionality, ControllerBase allows for basic controller capabilities, and Router allows for creation of various routes.

## LaurailsrecordBase

### Key Features

Classes that extend Laurails inherit a variety of ORM features:

* The ability to define getter and setter methods for instance variables by calling finalize!
* The ability to define relationships (belongs_to, has_many) between other model classes
* The ability to do basic CRUD operations on instances of the model class and have these operations persist to the database
* Basic search operations that connect the database entries with matching instances of the model class

### Example Usage

The following example is located in the app/models folder:

```
class Hedgehog < LaurailsrecordBase
  finalize!

  belongs_to :owner, class_name: "Person", foreign_key: :owner_id
  has_one_through :house, :house, :owner
end
```

## ControllerBase

### Key Features

Classes that extend ControllerBase can do the following:

* The ability to render a given template (render_template) located in the app/views/controller_name directory, as well as render custom content of a specified type  (render_content)
* The ability to use form authenticity tokens to protect against CSRF attacks (protect_from_forgery)
* The ability to get and set flash notices
* The ability to get and set session cookies
* The ability to redirect to a given URL

### Example Usage

The following example is located in the app/controllers folder:

```
class HedgehogsController < ControllerBase
  def index
    @hedgehogs = Hedgehog.all
    render :index
  end

  def new
    render :new
  end

  def create
    @hedgehog = Hedgehog.new(
      name: params['hedgehog']['name'],
      color: params['hedgehog']['color'],
      owner_id: params['hedgehog']['owner_id']
    )

    @hedgehog.save
    redirect_to "/"
  end

  ...

end
```

## Router

The router allows custom mapping of routes to controller actions. The following example is located in the config/routes.rb file:

```
Laurails::Router.draw do
  get Regexp.new("^/$"), HedgehogsController, :index
  get Regexp.new("^/hedgehogs$"), HedgehogsController, :index
  get Regexp.new("^/hedgehogs/new$"), HedgehogsController, :new
  post Regexp.new("^/hedgehogs$"), HedgehogsController, :create
  delete Regexp.new("^/hedgehogs/(?<hedgehog_id>\\d+)$"), HedgehogsController, :destroy
  get Regexp.new("^/hedgehogs/(?<hedgehog_id>\\d+)$"), HedgehogsController, :show
end
```

## Configuring the Database

Laurailsrecord uses a DBConnection class that works with SQLite. A database structure is defined in the lib/laurails/database.sql file, with some seeds included for example purposes. You may define your own structure in this file if you prefer.

## Additional Rack Middleware

* AssetServer allows for static assets with .jpg, .png, .gif, and .html extensions located in the public/ folder to be served.
* Exceptions provides a detailed error message for Ruby errors.

## Getting Started

The entry file is laurails.rb. In addition, the file lib/laurails.rb provides more detail into the initial setup. To run an example app, please do the following:

1. `git clone https://github.com/flaurida/laurails.git`
2. `cd laurails`
3.  `bundle install`
4.  `ruby laurails.rb`
5. Open `http://localhost:3000`

## Future Improvements (Coming Soon)

* Define has_many_through relationships (currently only has_one_through is supported)
* Add template HTML files to the application so layouts can be reused across pages
* Integrate PostgreSQL database functionality
* Allow for running `laurails new` as a command to set up a default application
