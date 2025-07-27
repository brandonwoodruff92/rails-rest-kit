# Rails Rest Kit
Rails Rest Kit is a comprehensive Rails gem that automates RESTful controller actions with built-in lifecycle callbacks and intelligent parameter permitting. It eliminates boilerplate code while providing a flexible, convention-over-configuration approach to building REST APIs.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "rails-rest-kit"
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install rails-rest-kit
```

## Usage
Include the `RailsRestKit::RestfulControllerActions` module in your controller. Your controller will now be defined with all REST actions (`index, show, new, create, edit, update, destroy`), and perform typical CRUD behavior:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::RestfulControllerActions
end
```

If you need to add specific functionality outside your typical REST flow, you can hook into a specific REST action's callback by defining a callback block for each hook:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::RestfulControllerActions

  before_index do 
    Rails.logger.info("Before index")
  end

  around_show do
    Rails.logger.info("Around show")
  end

  after_create_valid do 
    Rails.logger.info("Succesfully created resource")
  end
end
```

### Available Callback Hooks

| Action | Callback | Description |
|--------|----------|-------------|
| **index** | `before_index` | Before setting index resources |
| | `after_index` | After setting index resources |
| | `around_index` | Around setting index resources |
| **show** | `before_show` | Before setting a show resource |
| | `after_show` | After setting a show resource  |
| | `around_show` | Around setting a show resource  |
| **new** | `before_new` | Before setting a new resource |
| | `after_new` | After setting a new resource |
| | `around_new` | Around setting a new resource |
| **create** | `before_create` | Before creating new resource |
| | `after_create` | After creating new resource (Regardless of whether it's valid or not) |
| | `around_create` | Around creating new resource (Regardless of whether it's valid or not) |
| | `before_create_valid` | After `resource.save` succeeds, but before post-create processing |
| | `after_create_valid` | After `resource.save` succeeds, and after post-create processing |
| | `before_create_invalid` | After `resource.save` fails, but before post-create processing |
| | `after_create_invalid` | After `resource.save` fails, and after post-create processing |
| **edit** | `before_edit` | Before setting an edit resource |
| | `after_edit` | After setting an edit resource |
| | `around_edit` | Around setting an edit resource |
| **update** | `before_update` | Before updating a resource |
| | `after_update` | After updating a resource (Regardless of whether it's valid or not) |
| | `around_update` | Around updating a resource (Regardless of whether it's valid or not) |
| | `before_update_valid` | After `resource.save` succeeds, but before post-update processing |
| | `after_update_valid` | After `resource.save` succeeds, and after post-update processing |
| | `before_update_invalid` | After `resource.save` fails, but before post-update processing |
| | `after_update_invalid` | After `resource.save` fails, and after post-update processing|
| **destroy** | `before_destroy` | Before destroying a resource |
| | `after_destroy` | After destroying a resource |
| | `around_destroy` | Around destroying a resource |

### Permitters

You can use `RailsRestKit::Permitter` in your controller by including the `RailsRestKit::Helpers::PermitterHelper` or `RailsRestKit::RestfulControllerActions` in your controller:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::PermitterHelper
end
```

You can define permitted params for a controller using the `RailsRestKit::Permitter` DSL:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::PermitterHelper

  permit_resource :user do
    attributes :name, :email
    nested :address do
      attributes :street, :city, :state
    end
    collection :posts do
      attributes :content
    end
  end
end
```

Then you can access permissions with the `permit_params` method:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::PermitterHelper

  permit_resource :user do
    attributes :name, :email
    nested :address do
      attributes :street, :city, :state
    end
    collection :posts do
      attributes :content
    end
  end

  # Incoming params:
  # user: {
  #   name: "John Doe",
  #   email: "john@example.com",
  #   age: 27
  #   address: { street: "123 Main St", city: "Anytown", zip: 12345 },
  #   posts: [{ title: "First Post", content: "Hello" }]
  # }
  def test_action
    permitted_user_params = permit_params(:user)
    # Result:
    # {
    #   name: "John Doe",
    #   email: "john@example.com"
    #   address: { street: "123 Main St", city: "Anytown" },
    #   posts: [{ content: "Hello" }]
    # }
  end
end
```

You can use the `required: true` flag to require resource params:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::PermitterHelper

  permit_resource :user, required: true do
    attributes :name, :email
    nested :address do
      attributes :street, :city, :state
    end
    collection :posts do
      attributes :content
    end
  end

  # Incoming params:
  # user: {}
  def test_action
    # Raises an ActionController::ParameterMissing error
    permitted_user_params = permit_params(:user)
  end
end
```

### Helpers

Rails Rest Kit provides a number of controller helper methods to use by including the `RailsRestKit::Helpers::ResourceHelper` or `RailsRestKit::RestfulControllerActions` in your controller:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::ResourceHelper
end
```

This will give your controller access to a variety of helper methods scoped to the resource of your controller:

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::ResourceHelper

  def test_index_action
    set_users # Sets @users ||= Users.all
    # @users is now available
  end

  def test_show_action
    set_user # Sets @user ||= User.find(params[:id])
    # @user is now available
  end

  def test_new_action
    set_new_user # Sets @user ||= User.new
    # @user is now available
  end
end

UsersController.model_name # => "User"
UsersController.model_slug # => "user"
UsersController.model_class # => User

# Aliases for convenience
UsersController.resource_name   # => "User"
UsersController.resource_slug   # => "user"
UsersController.resource_class  # => User
```

#### How They Work
The gem automatically infers these values from your controller name:
- `UsersController` → `User` model
- `PostsController` → `Post` model
- `BlogPostsController` → `BlogPost` model

## Contributing
We welcome contributions to Rails Rest Kit!

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
