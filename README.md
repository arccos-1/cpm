a simple CLI password manager written in Dart
uses AES-256-GCM for encryption and Argon2 for key derivation 

how to use:

use `create [file] [key]` to create a database
for example, `create example abc123` will create database in file `example` with key `abc123`

use `add [file] [key] [name] [value]` to add an entry to the database
for example, `add example abc123 password 1234567890` will add an entry `password` with a value `1234567890` in database `example` using key `abc123`

use `list [file] [key]` to show all entries from the database without their values
for example, `list example abc123` will show all entries from the database `example` using key `abc123`

use `show [file] [key] [name]` to show a value of an entry
for example `show example abc123 password` will show a value of `password` in database `example` using key `abc123`

