# Getting Started

## Why?

Traditionally, the JSON response from a Rails API server isn't typed. So even if we have TypeScript at the front-end, we still have little guarantee that our back-end would return the correct type and structure of data.

In order to eliminate type mismatch between both ends, Camille provides a syntax for you to define type schema for your Rails API, and uses these schemas to generate the TypeScript functions for calling the API.

For example, an endpoint defined in Ruby, where `data` is a controller action, becomes a function in TypeScript:

::: side-by-side
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
```typescript
data(
  params: {id: number}
): Promise<{name: string}>
```
:::

Therefore, if the front-end requests the API by calling `data`, we have guarantee that `id` is presented in `params`, and Camille will require the response to contain a string `name`, so the front-end can receive the correct type of data.

By using these request functions, we also don't need to know about HTTP verbs and paths. It's impossible to have unrecognized routes, since Camille will make sure that each function is handled by the correct Rails action.

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

## Next steps

- [Schemas](./schemas) — define endpoints for a controller.
- [Custom Types](./custom-types) — reuse object types across endpoints.
- [TypeScript Generation](./typescript-generation) — wire the generated functions into your front-end.
