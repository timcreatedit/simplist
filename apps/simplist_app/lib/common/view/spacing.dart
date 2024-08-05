// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/widgets.dart';

abstract class Spacers {
  Spacers._();

  static const em = 4.0;
  static const xxs = 1 * em;
  static const xs = 2 * em;
  static const s = 3 * em;
  static const m = 4 * em;
  static const l = 6 * em;
  static const xl = 8 * em;
  static const x2l = 12 * em;
  static const x3l = 16 * em;
  static const x4l = 24 * em;
  static const x5l = 32 * em;
  static const x6l = 64 * em;
  static const x7l = 96 * em;
  static const x8l = 128 * em;

  static const formWidthConstraints = BoxConstraints(maxWidth: 400);
}

/// A horizontal space of given width
class HSpace extends StatelessWidget {
  const HSpace(this.width, {super.key});

  const HSpace.xxs() : this(Spacers.xxs);

  const HSpace.xs() : this(Spacers.xs);

  const HSpace.s() : this(Spacers.s);

  const HSpace.m() : this(Spacers.m);

  const HSpace.l() : this(Spacers.l);

  const HSpace.xl() : this(Spacers.xl);

  const HSpace.x2l() : this(Spacers.x2l);

  const HSpace.x3l() : this(Spacers.x3l);

  const HSpace.x4l() : this(Spacers.x4l);

  const HSpace.x5l() : this(Spacers.x5l);

  const HSpace.x6l() : this(Spacers.x6l);

  const HSpace.expand() : this(double.infinity);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

/// A vertical space of given height
class VSpace extends StatelessWidget {
  const VSpace(this.height, {super.key});

  const VSpace.xxs() : this(Spacers.xxs);

  const VSpace.xs() : this(Spacers.xs);

  const VSpace.s() : this(Spacers.s);

  const VSpace.m() : this(Spacers.m);

  const VSpace.l() : this(Spacers.l);

  const VSpace.xl() : this(Spacers.xl);

  const VSpace.x2l() : this(Spacers.x2l);

  const VSpace.x3l() : this(Spacers.x3l);

  const VSpace.x4l() : this(Spacers.x4l);

  const VSpace.x5l() : this(Spacers.x5l);

  const VSpace.x6l() : this(Spacers.x6l);

  const VSpace.expand() : this(double.infinity);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
