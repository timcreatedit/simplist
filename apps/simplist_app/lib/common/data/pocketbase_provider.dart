import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final $pocketbase = Provider<PocketBase>((ref) {
  return PocketBase(
    "https://pocketbase.simplist.madethese.works",
  );
});
