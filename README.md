# Camille

![Gem Version](https://img.shields.io/gem/v/camille)

Camille lets you define type schemas for your Rails API in Ruby, then generates typed TypeScript request functions from them and typechecks every response at runtime. The front-end and back-end can no longer disagree about the shape of data.

An endpoint defined in Ruby, where `data` is a controller action,

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

becomes a function in TypeScript:

```typescript
data(params: {id: number}): Promise<{name: string}>
```

Routes are derived from the schema, so the front-end calls a function instead of remembering HTTP verbs and paths, and Camille makes sure the correct Rails action handles it.

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

## Documentation

Full documentation is at **https://onyxblade.github.io/camille/**, covering:

- [Schemas](https://onyxblade.github.io/camille/guide/schemas) and [custom types](https://onyxblade.github.io/camille/guide/custom-types)
- [Supported type syntax](https://onyxblade.github.io/camille/guide/type-syntax)
- [TypeScript generation](https://onyxblade.github.io/camille/guide/typescript-generation)
- [Runtime typechecking](https://onyxblade.github.io/camille/guide/typechecking)
- [Caching rendered fragments](https://onyxblade.github.io/camille/guide/caching)
- [Test helper](https://onyxblade.github.io/camille/guide/testing)

The docs source lives in `docs/`; run `npm install && npm run dev` there to preview locally.

## Versioning

This project uses [Semantic Versioning](https://semver.org/). See [CHANGELOG.md](CHANGELOG.md).

## Development

Run tests with `bundle exec rake`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/onyxblade/camille.
