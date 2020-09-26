We initially started following along with the Bootstrap Gem docs (https://github.com/twbs/bootstrap-rubygem#a-ruby-on-rails) but ran into issues when we realized that it was using the asset pipeline for javascript which Rails 6 doesn't do (it uses webpack).
We used these resources:
https://dev.to/amree/rails-6-with-bootstrap-webpacker-for-js-asset-pipeline-for-css-2lmn
https://github.com/insales/rails-bootstrap-forms
https://blog.makersacademy.com/how-to-install-bootstrap-and-jquery-on-rails-6-da6e810c1b87

### Dependencies (Gems/packages)
```
yarn add bootstrap jquery popper.js
```

```
gem "bootstrap_form", "~> 4.5"
```

### Configuration (environment variables/other stuff in config folder)
rename application.css to application.scss in app/assets/stylesheets and add the following
```rb
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, or any plugin's
 * vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any other CSS/SCSS
 * files in this directory. Styles in this file should be added after the last require_* statement.
 * It is generally better to create a new file per style scope.
 *
 *= require_tree .
 *= require_self
 *= require rails_bootstrap_forms
 */

@import "variables";
@import "bootstrap/scss/bootstrap";
```
For this to work, we also need a file in `app/assets/stylesheets` called `variables.scss`. In our case we just had the following inside:

```scss
$secondary: orange;
```

You can override variables based on these examples:
https://github.com/twbs/bootstrap-rubygem/blob/master/assets/stylesheets/bootstrap/_variables.scss

Add the jQuery and popper dependencies to webpack environment config to fully support bootstrap component features:
```
// config/webpack/environment.js
const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide', 
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

module.exports = environment

```

Import bootstrap in app/javascript/packs/application.js
```

import 'bootstrap'
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

```

If you wanted to enable tooltips in the application, we'd also add 

```
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})
```
to the bottom of this file.

Addding `import 'bootstrap'` will load all of bootstrap, if we want to pick and choose which components we want, we can do that by importing modules independently and requiring bootstrap like so:

```js
require("./bootstrap")
```

We would then create another file inside of app/javascript/packs/bootstrap/index.js

```js
import "bootstrap/js/src/alert"
import "bootstrap/js/src/button"
import "bootstrap/js/src/carousel"
import "bootstrap/js/src/collapse"
import "bootstrap/js/src/dropdown"
import "bootstrap/js/src/modal"
import "bootstrap/js/src/popover"
import "bootstrap/js/src/scrollspy"
import "bootstrap/js/src/tab"
import "bootstrap/js/src/toast"
import "bootstrap/js/src/tooltip"

// Tooltip/Other components initialization here
```
### Database

### Models

### Views
```
<div class="container">
  <% if @error %>
    <div class="alert alert-danger" role="alert">
      <%= @error %>
    </div>
  <% end %>
  <%= bootstrap_form_for(@user, url: '/sessions') do |f| %>
    <%= f.email_field :email %>
    <%= f.password_field :password %>
    
    <%= f.submit "Log In" %>
  <% end %>
</div>
```
### Controllers

### Routes