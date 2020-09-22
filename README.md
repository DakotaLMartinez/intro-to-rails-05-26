# README

## Key Differences Between Sinatra and Rails

### Routing

Routes in Sinatra are defined within Controllers.
Routes in Rails are defined within `config/routes.rb` 

Routes in Rails map request patterns to controller actions. Action is a word for a method defined in a controller.

### Rendering Views

In Sinatra we render views by calling the `erb` method
In Rails we render views by calling `render`. Also, we don't have to call render to render html, if we don't call the render method, it will implicitly render the view with a name matching the controller action.
For example, 
if we have an index action

```rb
class PostsController 
  def index
    @posts = Post.all
  end
end
```

This controller action will render a template at `app/views/posts/index.html.erb` implicitly (without us having to call render)
If we don't have a template that corresponds with an action, we're probably going to redirect from that action and/or render if something goes wrong.

For example:

```rb
class PostsController
  ...
  # post '/posts'
  def create 
    @post = current_user.posts.build(title: params[:post][:title], content: params[:post][:content])
    if @post.save 
      redirect_to "/posts"
    else
      render :new
    end
  end
end
```

Controllers have a method called `view_path` that will return `app/views/name_of_controller`
For the PostsController, this would be `app/views/posts`. So when we call `render :new` it looks for `app/views/posts/new.html.erb`

### Naming Conventions

In Sinatra, we talked about naming classes inside of files so that they matched the name of the file. If you didn't do this, nothing would break.
In Rails this actually matters. Rails autoloads your classes based on the names of your files.

One of the main consequences of this, is that you really almost always want to be using generators to create your files. This is because the generator will create the files for you.


### Layers

#### Dependencies (Gems/packages)
Sinatra -> we had the Sinatra gem
Rails -> rails gem
Rails gem includes a bunch of other gems that handle various aspects of the web application stack. 
ActiveRecord is one of these gems, it's part of Rails
Rails has turbolinks
and a web console for debugging server errors in your development server
Rails has a lot more gems available for it than Sinatra does.
#### Configuration (environment variables/other stuff in config folder)
Rails has a lot more open source software available (in the form of gems). These gems will often have some configuration in our config directory. Environment variables could be loaded using the `dotenv` gem in Sinatra, for Rails you would use `dotenv-rails`. Rails also has a built in encrypted credentials functionality that you can edit via the command line using `rails credentials:edit` this is still not as secure as using the `.env` file, but definitely preferrable to storing credentials in version control.
Rails has a lot more moving parts to configure, so there's a lot more going on in this folder. In general, Rails follows a philosophy of convention over configuration. In rails we try to use defaults if we can and configure if we have to, not to configure everything.
#### Database
these are going to be mostly the same as Sinatra with ActiveRecord (with the exception that we're using newer versions of ActiveRecord now because Sinatra-ActiveRecord has some issues with Rails 6)
#### Models
Sinatra models were inheriting from ActiveRecord::Base, with Rails models we create a base model called `ApplicationRecord` and our other models inherit from that.
#### Views
Sinatra -> We were building our HTML with sprinkles of ERB
Rails -> We'll be using helper methods to generate more of our html (more ERB in our views especially when we build forms)
We have implicit rendering in Rails (we don't have to call `render :index` from inside of our `index` action in a controller, Rails will do this for us)
#### Controllers
Both Rails and Sinatra get input from the user via the params hash
Rails => Strong parameters to whitelist acceptable keys in params hash before passing to .new or .create
```rb
def post_params
  params.require(:post).permit(:title, :content)
end
```
`params.require(:post)` this will raise an error if `post` is not a key in the `params` hash. This part: `.permit(:title, :content)` says that within the require `post` key in `params` we're going to select the key value pairs where the keys are `title` and `content`, everything else will be ignored.
When we messed with the post_params method in our controller and tried it out in the browser here's what we got:
```rb
>> params
=> <ActionController::Parameters {"authenticity_token"=>"SEdwCCzdVqoDJUHfTHV+NVrr96/gMTclbjVudmNg6A5h8L88tZn+jdjlQhOzxM1RT5kWJVZuJ/m7oJeCY/L8jg==", "post"=>{"title"=>"this shouldn't work", "content"=>"let's see if it happens or not...."}, "commit"=>"Create Post", "controller"=>"posts", "action"=>"create"} permitted: false>
>> params.require(:post).permit(:title, :content)
=> <ActionController::Parameters {"title"=>"this shouldn't work", "content"=>"let's see if it happens or not...."} permitted: true>
>> params.require(:balloon).permit(:title, :content)
ActionController::ParameterMissing: param is missing or the value is empty: balloon
	from /Users/dakotamartinez/Development/study-groups/rails-blog/app/controllers/posts_controller.rb:65:in `post_params'
>>  
```
#### Routes
Sinatra Routes are defined in controllers
Rails -> Routes are defined in `config/routes.rb`
The syntax in Rails for a route is designed to map a request pattern to a controller action:
`get '/posts', to: 'posts#index'`

### Debugging/Development Tools

#### Local Server:
Sinatra -> `shotgun`
Rails -> `rails s` (`rails server`)

#### Development Console
Sinatra -> `bundle exec tux`
Rails -> `rails c` (`rails console`)

#### Debugging
Sinatra -> `gem 'pry'` -> `binding.pry`
Rails -> `gem 'pry-rails'` -> `binding.pry`
Rails also has the web-console, which is an in browser version of pry that works if you hit a server error while running the `rails server`

#### Routing
We can go to `localhost:3000/rails/info` to see all of the routes our Rails app knows how to respond to and this will include the path helpers (methods that return a url) we can use in our views within forms and links.

#### Generators 
`rails new name_of_app` -> Creates the folder/file structure and runs bundle install and initializes a git repository
`rails generate model` -> creates a model/migration/spec
`rails generate controller` -> creates a controller/views directory/routes?
`rails generate resource` -> creates a model/migration/controller/views path/routes also creates a helper and a scss file (styles)


Example:
`rails generate resource Envelope size color`

This does this:

```
invoke  active_record
create    db/migrate/20200922232256_create_envelopes.rb
create    app/models/envelope.rb
invoke    test_unit
create      test/models/envelope_test.rb
create      test/fixtures/envelopes.yml
invoke  controller
create    app/controllers/envelopes_controller.rb
invoke    erb
create      app/views/envelopes
invoke    test_unit
create      test/controllers/envelopes_controller_test.rb
invoke    helper
create      app/helpers/envelopes_helper.rb
invoke      test_unit
invoke    assets
invoke      scss
create        app/assets/stylesheets/envelopes.scss
invoke  resource_route
  route    resources :envelopes
```

This generator creates an EnvelopesController, Envelope model, create_envelopes migration and adds resources :envelopes to our `config/routes.rb` file. We'll still have to create the controller actions and view files ourselves.

We'll also need to run `rails db:migrate` to commit the changes to our database.

