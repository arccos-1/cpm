import 'dart:io';

import 'package:cpm/cpm.dart';
import 'package:cpm/strings.dart';
import 'package:cryptography/cryptography.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print(cmdlist);
    exit(-1);
  }

  if (args.first == 'create' && args.length == 3) {
    await createDatabase(args[1], args[2]);
  } else if (args.first == 'add' && args.length == 5) {
    await addEntryToDatabase(args[1], args[2], args[3], args[4]);
  } else if (args.first == 'list' && args.length == 3) {
    await listEntries(args[1], args[2]);
  } else if (args.first == 'show' && args.length == 4) {
    await showEntry(args[1], args[2], args[3]);
  } else {
    print(cmdlist);
    exit(-2);
  }
}