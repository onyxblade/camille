---
layout: home

hero:
  name: Camille
  text: Typed Rails API for TypeScript front-ends
  tagline: Define your API schema once in Ruby. Get typed TypeScript request functions and runtime response checks for free.
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/onyxblade/camille

features:
  - title: One schema, both ends
    details: Declare params and response types next to your controllers. Camille generates the TypeScript functions that call them.
  - title: Runtime typechecking
    details: Every render is checked against the schema, so a mismatch fails loudly on the server instead of silently on the client.
  - title: No routes to remember
    details: Routes are derived from the schema. The front-end calls a function; Camille makes sure the right action handles it.
---

## At a glance

An endpoint defined in Ruby, where `data` is a controller action:

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

If the front-end calls `data`, it must supply an `id`, and Camille requires the response to contain a string `name`. The two ends can no longer disagree about types.
