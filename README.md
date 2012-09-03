# OmniAuth HackID

HackID OAuth2 Strategy for OmniAuth 1.0.

Supports the OAuth 2.0 server-side and client-side flows. Read the HackID docs for more details: https://hackid.herokuapp.com/docs

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-hackid'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::HackID` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['HACKID_KEY'], ENV['HACKID_SECRET']
end
```

[See the example Sinatra app for full examples](https://github.com/mkdynamic/omniauth-facebook/blob/master/example/config.ru)

## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: A comma-separated list of permissions that has not been implemented yet.

### Custom Callback URL/Path

You can set a custom `callback_url` or `callback_path` option to override the default value. See [OmniAuth::Strategy#callback_url](https://github.com/intridea/omniauth/blob/master/lib/omniauth/strategy.rb#L411) for more details on the default.

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

```ruby
{
  :provider => 'hackid',
  :uid => '1234567',
  :info => {
    :nickname => 'jbloggs',
    :email => 'joe@bloggs.com',
    :name => 'Joe Bloggs',
    :first_name => 'Joe',
    :last_name => 'Bloggs',
    :verified => true
  },
  :credentials => {
    :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
    :expires_at => 1321747205, # when the access token expires (it always will)
    :expires => true # this will always be true
  },
  :extra => {
    :raw_info => {
      :name => 'Joe Bloggs',
      :email => 'joe@bloggs.com',
    }
  }
}
```

The precise information available may depend on the permissions which you request.

The expiration time of the access token you obtain will depend on which flow you are using. See below for more details.

### Server-Side Flow

If you use the server-side flow, HackID will give you back a longer loved access token (~ 14 days).

## Supported Rubies

Actively tested with the following Ruby versions:

- MRI 1.9.3
- MRI 1.9.2
- MRI 1.8.7
- JRuby 1.6.5

*NB.* For JRuby, you'll need to install the `jruby-openssl` gem. There's no way to automatically specify this in a Rubygem gemspec, so you need to manually add it your project's own Gemfile:

```ruby
gem 'jruby-openssl', :platform => :jruby
```

## License

Copyright (c) 2012 by Mark Dodwell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
