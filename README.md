# Camille

## Why?

Traditionally, the JSON response from a Rails API server isn't typed. So even if we have TypeScript at the front-end, we still have little guarantee that our back-end would return the correct type and structure of data.

In order to eliminate type mismatch between both ends, Camille provides a syntax for you to define type schema for your Rails API, and uses these schemas to generate the TypeScript functions for calling the API.

For example, an endpoint defined in Ruby, where `data` is a controller action,

```ruby
get :data do
  params(
    id: Number
  )
  response(
    name: String
  )
end
```

will become a function in TypeScript:

```typescript
data(params: {id: number}): Promise<{name: string}>
```

Therefore, if the front-end requests the API by calling `data`, we have guarantee that `id` is presented in `params`, and Camille will require the response to contain a string `name`, so the front-end can receive the correct type of data.

By using these request functions, we also don't need to know about HTTP verbs and paths. It's impossible to have unrecognized routes, since Camille will make sure that each function handled by the correct Rails action.

## Tutorial

There's a step by step tutorial for setting up and showcasing Camille: https://github.com/onyxblade/camille-tutorial.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'camille'
```

And then execute:

```bash
bundle install
bundle exec rails g camille:install
```

## Usage

### Schemas

A schema defines the type of `params` and `response` for a controller action. The following commands will generate schema definition files in `config/camille/schemas`.

```bash
# to generate a schema for ProductsController
bundle exec rails g camille:schema products
# to generate a schema for Api::ProductController
bundle exec rails g camille:schema api/products
```

An example of schema definition:

```ruby
using Camille::Syntax

class Camille::Schemas::Api::Products < Camille::Schema
  include Camille::Types

  get :data do
    params(
      id: Number
    )
    response(
      name: String
    )
  end
end
```

The `Api::Products` schema defines one endpoint `data` and its params and response type. This endpoint corresponds to the `data` action on `Api::ProductsController`. Inside the action, you can assume that `params[:id]` is a number, and you will need to `render json: {name: 'some string'}` in order to pass the typecheck.

When generating TypeScript request functions, the `data` endpoint will become a function having the following signature:

```typescript
data(params: {id: number}): Promise<{name: string}>
```

Therefore, the front-end user is required to provide an `id` when they call this function. And they can expect to get a `name` from the response of this request. There are no more type mismatch between both ends.

The `params` type for an endpoint is required to be an object type, or a hash in Ruby, while `response` type can be any supported type, for example a `Boolean`.

Camille will automatically add a Rails route for each endpoint. You don't need to do anything other than having the schema file in place.

When defining an endpoint, you can also use `post` instead of `get` for non-idempotent requests. However, no other HTTP verbs are supported, because verbs in RESTful like `patch` and `delete` indicate what we do on resources, but in RPC-style design each request is merely a function call that does not concern RESTful resources.

### Custom types

In addition to primitive types, you can define custom types in Camille. The following commands will generate type definition files in `config/camille/types`.

```bash
# to generate a type named Product
rails g camille:type product
# to generate a type named Nested::Product
rails g camille:type nested/product
```

An example of custom type definition:

```ruby
using Camille::Syntax

class Camille::Types::Product < Camille::Type
  include Camille::Types

  alias_of(
    id: Number,
    name: String
  )
end
```

Each custom type is considered a type alias in TypeScript. And `alias_of` defines what this type is aliasing. In this case, the `Product` type is an alias of an object type having fields `id` as `Number` and `name` as `String`. When generating TypeScript, it will be converted to the following:

```typescript
type Product = {id: number, name: string}
```

You can perform a type check on a value using `test`, which might be handy in testing:

```ruby
error = Camille::Types::Product.test(hash)
if error.nil?
  # the hash is accepted by Camille::Types::Product type
else
  p error
end
```

### Available syntax for types

Camille supports most of the type syntax in TypeScript. Below is a list of types that you can use in type and schema definition.

```ruby
params(
  # primitive types in TypeScript
  number: Number,
  string: String,
  boolean: Boolean,
  null: Null,
  undefined: Undefined,
  any: Any,
  # an array type is a type name followed by '[]'
  array: Number[],
  # an object type looks like hash
  object: {
    field: Number
  },
  # an array of objects also works
  object_array: {
    field: Number
  }[]
  # a union type is two types connected by '|'
  union: Number | String,
  # an intersection type is two types connected by '&'
  intersection: { id: Number } & { name: String },
  # a tuple type is several types put inside '[]'
  tuple: [Number, String, Boolean],
  # a field followed by '?' is optional, the same as in TypeScript
  optional?: Number,
  # literal types
  number_literal: 1,
  string_literal: 'hello',
  boolean_literal: false,
  # a custom type we defined above
  product: Product,
  # Pick and Omit accept a type and an array of symbols
  pick: Pick[{a: 1, b: 2}, [:a, :b]],
  omit: Omit[Product, [:id]],
  # Record accepts a key type and a value type
  record: Record[Number, String]
)
```

### TypeScript generation

After you have your types and schemas in place, you can visit `/camille/endpoints.ts` in development environment to have the TypeScript request functions generated.

An example from our previously defined type and schema will be:

```typescript
import request from './request'

export type Product = {id: number, name: string}

export default {
  api: {
    data(params: {id: number}): Promise<{name: string}> {
      return request('get', '/api/products/data', params)
    }
  }
}
```

The first line of `import` is configurable as `config.ts_header` in `config/camille/configuration.rb`. You would need to implement a `request` function that performs the HTTP request.

### Conversion between camelCase and snake_case

In TypeScript world, people usually use camelCase to name functions and variables, while in Ruby the convention is to use snake_case. Camille will automatically convert between these two when processing request.

For example,

```ruby
get :special_data do
  params(
    long_id: Number
  )
  response(
    long_name: String
  )
end
```

will have TS signature:

```typescript
specialData(params: {longId: number}): Promise<{longName: string}>
```

In the Rails action you still use `params[:long_id]` to access the parameter and return `long_name` in response.

### Typechecking

If a controller action has a corresponding schema, Camille will raise an error if the returned JSON doesn't match the response type specified in the schema.

For example for
```ruby
response(
  object: {
    array: Number[]
  }
)
```

if we return such a JSON in our action
```ruby
render json: {
  object: {
    array: [1, 2, '3']
  }
}
```

Camille will print the following error:
```
object:
  array:
    array[2]: Expected number, got "3".
```

### Reloading

Everything in `config/camille/types` and `config/camille/schemas` will automatically reload after changes in development environment, just like other files in Rails.

## Development

Run tests with `bundle exec rake`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/onyxblade/camille.
