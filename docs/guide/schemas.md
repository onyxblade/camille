# Schemas

A schema defines the type of `params` and `response` for a controller action. The following commands will generate schema definition files in `config/camille/schemas`.

```bash
# to generate a schema for ProductsController
bundle exec rails g camille:schema products
# to generate a schema for Api::ProductController
bundle exec rails g camille:schema api/products
```

An example of schema definition, and the TypeScript function it generates:

::: side-by-side
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
```typescript
export default {
  api: {
    products: {
      data(
        params: {id: number}
      ): Promise<{name: string}> {
        return request(
          'get',
          '/api/products/data',
          params
        )
      }
    }
  }
}
```
:::

The `Api::Products` schema defines one endpoint `data` and its params and response type. This endpoint corresponds to the `data` action on `Api::ProductsController`. Inside the action, you can assume that `params[:id]` is a number, and you will need to `render json: {name: 'some string'}` in order to pass the typecheck.

The front-end user is required to provide an `id` when they call this function, and they can expect to get a `name` from the response of this request. There are no more type mismatches between both ends.

The `params` type for an endpoint is required to be an object type, or a hash in Ruby, while `response` type can be any supported type, for example a `Boolean`.

Camille will automatically add a Rails route for each endpoint. You don't need to do anything other than having the schema file in place.

When defining an endpoint, you can use any of `get`, `post`, `put`, `patch`, or `delete`.

## camelCase and snake_case

In the TypeScript world, people usually use camelCase to name functions and variables, while in Ruby the convention is to use snake_case. Camille will automatically convert between these two when processing a request.

::: side-by-side
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
```typescript
specialData(
  params: {longId: number}
): Promise<{longName: string}>
```
:::

In the Rails action you still use `params[:long_id]` to access the parameter and return `long_name` in the response.

## Reloading

Everything in `config/camille/types` and `config/camille/schemas` will automatically reload after changes in the development environment, just like other files in Rails.
