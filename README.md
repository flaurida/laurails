# Laurails

Laurails is a basic Model View Controller / Object Relational Management framework inspired by Ruby on Rails and written in Ruby. LaurailsrecordBase provides the ORM functionality, ControllerBase allows for basic controller capabilities, and Router allows for creation of various routes.

## LaurailsrecordBase

### Key Features

Classes that extend Laurails inherit a variety of ORM features:

* The ability to define getter and setter methods for instance variables by calling finalize!
* The ability to define relationships (belongs_to, has_many, has_one_through, has_many_through) between other model classes
* The ability to do basic CRUD operations on instances of the model class and have these operations persist to the database
* Basic search operations that connect the database entries with matching instances of the model class

### Example Usage

To create your your own model, simply add the file to the app/models folder, inherit from LaurailsrecordBase, and call the finalize! method. An example is shown below ([see file](./app/models/hedgehog.rb)).

```ruby
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

To create a controller for a corresponding model, add the file name to the [controllers folder](./app/controllers). Be sure to require the model file at the top of your controller file (improvement on this coming soon).

You may also create a folder with the Rails convention naming in the [views folder](./app/views/). For example, if your controller is named HedgehogsController, add a folder called "hedgehogs" to the views folder.

The following example illustrates the creation of a controller that inherits from ControllerBase. See the full file [here](./app/controllers/hedgehogs_controller.rb).

```ruby
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
end
```

## Views

Views for a given controller should be saved in the corresponding folder in the [views folder](./app/assets/views). These views will have access to any instance variables defined in controller actions. You may also call the render method from within the controller with the desired template name as a symbol as you would in a Rails application to have the template rendered. A example snipped from the [show view](./app/assets/views/show.html.erb) is provided below.

```html
<h1><%= @hedgehog.name %> Show Page</h1>
<h2><%= @hedgehog.color %></h2>
```

## Router

The router allows custom mapping of routes to controller actions. To define a custom route, provide a regular expression, a controller name, and a controller action to the method corresponding to the desired HTTP verb.

The following example is located in the config/routes.rb file:

```ruby
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

Laurailsrecord uses a DBConnection class that works with SQLite. You may use the default database defined in the  [lib/laurails/hedgehogs.sql](./lib/laurails/hedgehogs.sql) file, which has some seeds included for example purposes. Alternatively, you may create your own database in the [lib/laurails/database.sql](./lib/laurails/database.sql) file, and simply change the database name in the [config file](./config/database.yml) to "database". Lastly, you can also create your own SQL file named whatever you wish, and update the config file accordingly to reflect the change.

## Additional Rack Middleware

* AssetServer allows for static assets with .jpg, .png, .gif, and .html extensions located in the [images folder](./app/assets/images) to be served. To use this, simply include an image tag in an HTML view, and make sure that the path is something like "app/assets/images/your_image.jpg".
* Exceptions provides a detailed error message for Ruby errors.

## Getting Started

The entry file is laurails.rb. In addition, the file lib/laurails.rb provides more detail into the initial setup. To run an example app, please do the following:

1. `git clone https://github.com/flaurida/laurails.git`
2. `cd laurails`
3. `bundle install`
4. `ruby laurails.rb`
5. Open `http://localhost:3000`

## Future Improvements (Coming Soon)

* Add other options for `validates` like uniqueness
* Add template HTML files to the application so layouts can be reused across pages
* Integrate PostgreSQL database functionality
* Allow for running `laurails new` as a command to set up a default application
