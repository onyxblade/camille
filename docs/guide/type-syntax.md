# Type Syntax

Camille supports most of the type syntax in TypeScript. Below is a list of types that you can use in type and schema definitions, with the TypeScript each one generates.

## Primitives

::: side-by-side
```ruby
params(
  number: Number,
  string: String,
  boolean: Boolean,
  null: Null,
  undefined: Undefined,
  any: Any
)
```
```typescript
params: {
  number: number,
  string: string,
  boolean: boolean,
  null: null,
  undefined: undefined,
  any: any
}
```
:::

## Arrays and objects

An array type is a type name followed by `[]`. An object type looks like a hash.

::: side-by-side
```ruby
params(
  array: Number[],
  object: {
    field: Number
  },
  object_array: {
    field: Number
  }[]
)
```
```typescript
params: {
  array: number[],
  object: {
    field: number
  },
  objectArray: {
    field: number
  }[]
}
```
:::

## Union, intersection and tuple

A union type is two types connected by `|`, an intersection by `&`, and a tuple is several types inside `[]`.

::: side-by-side
```ruby
params(
  union: Number | String,
  intersection: { id: Number } & { name: String },
  tuple: [Number, String, Boolean]
)
```
```typescript
params: {
  union: number | string,
  intersection: {id: number} & {name: string},
  tuple: [number, string, boolean]
}
```
:::

## Optional fields

A field followed by `?` is optional, the same as in TypeScript.

::: side-by-side
```ruby
params(
  optional?: Number
)
```
```typescript
params: {
  optional?: number
}
```
:::

## Literal types

::: side-by-side
```ruby
params(
  number_literal: 1,
  string_literal: 'hello',
  boolean_literal: false
)
```
```typescript
params: {
  numberLiteral: 1,
  stringLiteral: "hello",
  booleanLiteral: false
}
```
:::

## Custom types

A [custom type](./custom-types) is referenced by its class name.

::: side-by-side
```ruby
params(
  product: Product
)
```
```typescript
params: {
  product: Product
}
```
:::

## Utility types

`Pick` and `Omit` accept a type and an array of symbols. `Record` accepts a key type and a value type.

::: side-by-side
```ruby
params(
  pick: Pick[{a: 1, b: 2}, [:a, :b]],
  omit: Omit[Product, [:id]],
  record: Record[Number, String]
)
```
```typescript
params: {
  pick: Pick<{a: 1, b: 2}, "a" | "b">,
  omit: Omit<Product, "id">,
  record: Record<number, string>
}
```
:::
