Camille.configure do |config|
  # Contents to be placed at the beginning of the output TypeScript file.
  config.ts_header = <<~EOF
    // DO NOT EDIT! This file is automatically generated.
    import request from './request'
  EOF
end