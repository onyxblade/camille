# TypeScript Generation

After you have your types and schemas in place, you can visit `/camille/endpoints.ts` in the development environment to have the TypeScript request functions generated.

An example from the previously defined [type](./custom-types) and [schema](./schemas) will be:

```typescript
import request from './request'

export type Product = {id: number, name: string}

export default {
  api: {
    products: {
      data(params: {id: number}): Promise<{name: string}> {
        return request('get', '/api/products/data', params)
      }
    }
  }
}
```

The first line of `import` is configurable as `config.ts_header` in `config/camille/configuration.rb`. You would need to implement a `request` function that performs the HTTP request.
