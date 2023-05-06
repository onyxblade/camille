# Changelog

## 0.5.2

### Added

* Symbols are now accepted in string types
* When omitted, the response type of an endpoint will now have the default `{}`

## 0.5.1

### Fixed

* Fixed the wrong error returned for `union.left`

## 0.5.0

### Changed

* Pick and Omit now use a new syntax, so it can handle snake to camel case conversion correctly

## 0.4.3

### Fixed

* Fixed the error that values not getting transformed in array/tuple/union types
* Fixed optional fields getting `nil` due to transformation

## 0.4.2

### Added

* Supported `transform` for custom types
* Added default DateTime and Decimal type to install generator

## 0.4.1

### Added

* Added utility types Pick and Omit

### Fixed

* Prevent loader errors from being silently rescued by Rails in development environment

## 0.4.0

The first stable release