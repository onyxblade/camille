import { defineConfig } from 'vitepress'
import container from 'markdown-it-container'

export default defineConfig({
  title: 'Camille',
  description: 'Typed Rails API for TypeScript front-ends',
  base: '/camille/',
  cleanUrls: true,
  markdown: {
    config(md) {
      // ::: side-by-side ... ::: renders its children in a two-column grid.
      md.use(container, 'side-by-side', {
        render(tokens, idx) {
          return tokens[idx].nesting === 1
            ? '<div class="side-by-side">\n'
            : '</div>\n'
        },
      })
    },
  },
  themeConfig: {
    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'RubyGems', link: 'https://rubygems.org/gems/camille' },
    ],
    sidebar: [
      {
        text: 'Guide',
        items: [
          { text: 'Getting Started', link: '/guide/getting-started' },
          { text: 'Schemas', link: '/guide/schemas' },
          { text: 'Custom Types', link: '/guide/custom-types' },
          { text: 'Type Syntax', link: '/guide/type-syntax' },
          { text: 'TypeScript Generation', link: '/guide/typescript-generation' },
          { text: 'Typechecking', link: '/guide/typechecking' },
          { text: 'Caching Rendered Fragments', link: '/guide/caching' },
          { text: 'Test Helper', link: '/guide/testing' },
        ],
      },
    ],
    socialLinks: [{ icon: 'github', link: 'https://github.com/onyxblade/camille' }],
    search: { provider: 'local' },
    editLink: {
      pattern: 'https://github.com/onyxblade/camille/edit/master/docs/:path',
    },
  },
})
