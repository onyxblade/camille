# Custom Types

In addition to primitive types, you can define custom types in Camille. The following commands will generate type definition files in `config/camille/types`.

```bash
# to generate a type named Product
rails g camille:type product
# to generate a type named Nested::Product
rails g camille:type nested/product
```

Each custom type is considered a type alias in TypeScript, and `alias_of` defines what this type is aliasing:

::: side-by-side
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
```typescript
export type Product = {
  id: number,
  name: string
}
```
:::

In this case, the `Product` type is an alias of an object type having fields `id` as `Number` and `name` as `String`.

Once defined, `Product` can be used anywhere a type is expected in a schema or another type, see [Type Syntax](./type-syntax).

## Checking a value

You can perform a type check on a value using `check`, which can be handy in testing:

```ruby
# `check` will return either a Camille::Checked or a Camille::TypeError
result = Camille::Types::Product.check(hash)
if result.checked?
  # the hash is accepted by Camille::Types::Product type
else
  p result
end
```
