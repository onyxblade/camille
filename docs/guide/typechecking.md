# Typechecking

If a controller action has a corresponding schema, Camille will raise an error if the returned JSON doesn't match the response type specified in the schema.

For example, given this response type and this render call:

::: side-by-side
```ruby
response(
  object: {
    array: Number[]
  }
)
```
```ruby
render json: {
  object: {
    array: [1, 2, '3']
  }
}
```
:::

Camille will print the following error:

```
object:
  array:
    array[2]: Expected number, got "3".
```
