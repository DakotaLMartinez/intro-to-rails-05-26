# Routing in Rails

Resources for routing in Rails:
- [RailsGuides Routing from the Outside In](https://guides.rubyonrails.org/routing.html)

## Routes & Path Helpers
When a path (in a route) includes a route parameter (something prefixed with :, oftentimes this will be :id), the path helper method that generates that path will accept an argument.The argument will be used to fill in the route parameter.

```
get '/posts/:id', to: 'posts#show', as: 'post' #=> post_path helper that we call like this:



@post = Post.find(2)
post_path(@post) #=> 
```

<%= link_to 'all posts', posts_path %>

<% @posts.each do |post| %>
  <p><%= link_to post.title, post_path %></p>
<% end %>

post_path generates a route that concerns a single post, 4 different kinds of request can have /posts/:id
get '/posts/:id' => 'posts#show'
patch '/posts/:id' => 'posts#update'
put '/posts/:id' => 'posts#update'
delete '/posts/:id' => 'posts#destroy'

To fill in the id in this route, we can pass an id in directly or we can pass in an object which the router will convert to a parameter (id)

If we do
post_path(@post)
The router notices that @post is not an id, so it calls a method called `to_param` on it and puts the return value into the path.

If we don't define a method called `to_param` in our ActiveRecord Model for `Post` then `to_param` will return the `id` of the record

In most cases this is fine. But if we wanted to change the name of a parameter in the routes, for example to use a :slug instead:

```rb
get '/posts'
get '/posts/:slug'
get '/posts/new'
get '/posts/:slug/edit'
post '/posts'
patch '/posts/:slug'
delete '/posts/:slug'
```

We would want to define a `to_param` method in our `Post` model and have it return the slug.

```rb
class Post
  def to_param
    slug
  end
end
```

If you see an error like this:

```
ActionController::UrlGenerationError: No route matches {:action=>"show", :controller=>"posts"}, missing required keys: [:id]
```
This means, you've probably called a path helper without a required argument. So the path helper is unable to generate the right url.

If we see an error like this:

```
undefined local variable or method `new_post_path' for #<#<Class:0x00007fa9ed692910>:0x00007fa9ed691038>
Did you mean?  new_user_path
```
The first place I would wanna check would be localhost:3000/rails/info and we'll want to look for something like new_post_path and it's most likely not going to be there.

All of the path helpers come from your routes.

If we want to get some more readable urls for our routes, we can modify the to_param method in a model to include both the id and some meaningful attribute like this title:

```rb
class Post < ApplicationRecord
  belongs_to :user

  def to_param
    "#{id}-#{ActiveSupport::Inflector.parameterize(title)}"
  end
end

```

This will make it so if we have a post like this:

```rb
@post = #<Post:0x00007ffb166be8d8
 id: 2,
 title: "This one's mine!!!!",
 content: "don't take it :D",
 user_id: 1,
 created_at: Tue, 22 Sep 2020 01:43:30 UTC +00:00,
 updated_at: Tue, 22 Sep 2020 01:43:30 UTC +00:00>
```

and we call `post_path(@post)`, we'll get:

```
"/posts/2-this-one-s-mine"
```

When we call the `post_path` helper and we pass a `post` instance as an argument, `to_param` will be called on the post and the return value will be inserted in the url parameter in the returned path.
