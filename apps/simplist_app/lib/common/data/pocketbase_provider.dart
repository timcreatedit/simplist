import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbased/pocketbased.dart';

final $pocketbase = FutureProvider<PocketBase>((ref) async {
  final authStore = SembastAuthStore();
  await authStore.initialized;
  return PocketBase(
    "https://pocketbase.simplist.madethese.works",
    authStore: authStore,
  );
});
