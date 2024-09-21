import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

class EndOfListPaddingSliver extends HookConsumerWidget {
  const EndOfListPaddingSliver({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: UnselectedDimmer(child: VSpace.x4l()),
    );
  }
}
