const version = '1.0-alpha';

const usage = 'Usage: cpm [command] [args]';

const cmdlist = '''
create [file] [key] - Creates a database with specific encryption key.
add [file] [key] [name] [value] - Adds an entry to a database.
list [file] [key] - Shows a list of all entries in a database.
show [file] [key] [name] - Shows an entry in a database.
''';