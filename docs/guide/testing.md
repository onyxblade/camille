# Test Helper

Camille ships an optional `response.data` helper for Rails integration / request tests. It looks up the endpoint from the current request, validates `response.parsed_body` against the endpoint's response type, and returns the snake_case body as a `HashWithIndifferentAccess` so you can use either string or symbol keys in assertions.

In your `rails_helper.rb` (RSpec) or `test_helper.rb` (Minitest):

```ruby
require 'camille/testing'
```

Then in a test:

```ruby
get '/products/data'
expect(response.data[:product][:available_stock]).to eq(1)
```

Since `Camille::Controller#render` only type checks and converts keys for 200 responses, `response.data` returns non-200 bodies as-is without validation.

## Errors

| Situation | Raised |
| --- | --- |
| A 200 response body fails the type check | `Camille::Testing::ResponseTypeError` |
| The route has no Camille endpoint | `Camille::Testing::MissingEndpointError` |
