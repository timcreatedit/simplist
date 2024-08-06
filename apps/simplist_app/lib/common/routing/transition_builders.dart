import 'package:flutter/widgets.dart';

Widget fadeShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final toHero = toHeroContext.widget as Hero;
  final fromHero = fromHeroContext.widget as Hero;

  final forward = (flightDirection == HeroFlightDirection.push);

  return SizedBox.expand(
    child: Stack(
      children: [
        SizedBox.expand(
          child: FadeTransition(
            opacity: animation,
            child: forward ? toHero : fromHero,
          ),
        ),
        SizedBox.expand(
          child: FadeTransition(
            opacity: ReverseAnimation(animation),
            child: forward ? fromHero : toHero,
          ),
        ),
      ],
    ),
  );
}
