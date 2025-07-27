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
Include the `RailsRestKit::RestfulControllerActions` module in your controller. This will automatically provide callback hooks for your default REST actions (`index, show, new, create, edit, update, destroy`):

```ruby
class UsersController < ApplicationController
  include RailsRestKit::RestfulControllerActions
end
```

You can hook into a specific callback by defining callback blocks for each hook:

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
You can reference all callback hooks here.

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
    # Permitted params:
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
    permitted_user_params = permit_params(:user) # Raises a ActionController::ParameterMissing error
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

Then you can call the setter helper methods to set resource instance variables:

```js
// Users table
[
  {
    id: 1,
    name: "John Doe",
    email: "john@example.com",
  },
  {
    id: 2,
    name: "Jane Doe",
    email: "jane@example.com",
  }
]
```

```ruby
class UsersController < ApplicationController
  include RailsRestKit::Helpers::ResourceHelper

  def test_index_action
    set_users
    Rails.logger.info(@users)
    # [
    #   {
    #     id: 1,
    #     name: "John Doe",
    #     email: "john@example.com",
    #   },
    #   {
    #     id: 2,
    #     name: "Jane Doe",
    #     email: "jane@example.com",
    #   }
    # ]
  end

  # Incoming params:
  # { id: 1 }
  def test_show_action
    set_user
    Rails.logger.info(@user)
    # {
    #   id: 1,
    #   name: "John Doe",
    #   email: "john@example.com",
    # }
  end

  def test_new_action
    set_new_user
    Rails.logger.info(@user)
    # {
    #   id: nil,
    #   name: nil,
    #   email: nil,
    # }
  end
end
```

You can see a detailed list of all helper methods here.

## Contributing
We welcome contributions to Rails Rest Kit!

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
