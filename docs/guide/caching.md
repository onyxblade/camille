# Caching Rendered Fragments

Type checking and key conversion run on every `render`. For data that is expensive to build and shared across requests, you can check it once and cache the result as a `Camille::Rendered`:

```ruby
rendered = Camille::Types::Product.render!(serialize(product))
# => Camille::Rendered with the type's fingerprint and the final JSON string
Rails.cache.write("product/#{product.id}/#{Camille::Types::Product.new.fingerprint}", rendered)
```

`render!` raises `Camille::BasicType::RenderError` if the value doesn't match the type. A `Rendered` can be placed anywhere a value of that type is expected:

```ruby
render json: {
  products: Rails.cache.read_multi(*keys).values  # Product[]
}
```

The type accepts it by comparing fingerprints instead of re-checking, and `to_json` splices the stored string verbatim, so no parsing or re-serialization happens on the cached fragments.

::: tip
A `Rendered` is immutable and opaque. If a fragment needs to be modified before rendering, cache the plain hash instead and let Camille check it as usual; the two forms are a per-fragment choice.
:::

Keep volatile or per-user fields outside cached fragments, and include the type's `fingerprint` in the cache key so entries are invalidated when the type changes.

## Serialization

`Rendered` defines `marshal_dump`/`marshal_load` as `[fingerprint, json]`, so the default `Rails.cache` coder stores just the two strings. If you use the `:message_pack` cache serializer, register the class with `ActiveSupport::MessagePack::CacheSerializer` using the same pair.
