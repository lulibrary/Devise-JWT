# Devise LULibrary JWT

Provides a simple devise authentication strategy for authenticating by JSON Web Tokens (JWTs) passed either as a GET parameter or as an Authorization header.

Designed to be used with our JWT Server package which provides a central server to authenticate users behind CoSign or similar service that provides a JWT to be used for authentication with other services.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise_lulibrary_jwt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_lulibrary_jwt

## Usage

After installing the gem add the following to the model you wish to use for authentication.

`devise :jwt_authenticatable, :authentication_keys => [:username], :jwt_create_user => true`

The options of `authentication_keys` and `jwt_create_user` allow for multiple models to be used with different configuration options, be this using different authentication keys or changed whether the strategy only looks up a user compared to creating the user if they don't exist.

Within the global devise config the following options can be configured, the only required values are `jwt_secret`, `jwt_issuer` and `jwt_audience`.

| Parameter | Description |
| --- | --- |
| jwt_secret | The secret used to verify the integrity of the JWT (required) |
| jwt_issuer | The issuer of the JWT (required) |
| jwt_audience | The audience for the JWT (required) |
| verify_aud | Boolean for whether to verify the token audience (false allows for jwt_audience to be nil) |
| verify_iss | Boolean for whether to verify the token issuer (false allows for jwt_issuer to be nil) |
| verify_iat | Boolean for whether to verify the issued at timestamp of the token |
| jwt_create_user | Boolean - Global option for whether to create a user if they don't exist (true) or to just find existing users (false). Can be overridden by setting :jwt_create_user on the devise config line of the model. |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lulibrary/devise_lulibrary_jwt.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
