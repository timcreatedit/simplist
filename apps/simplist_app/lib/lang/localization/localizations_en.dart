import 'localizations.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'simplist';

  @override
  String get onboardingDisplay => 'Make it simple, make it work.';

  @override
  String get getStartedAction => 'Get Started';

  @override
  String get signInPrompt => 'Have an Account?';

  @override
  String get signInAction => 'Sign In';

  @override
  String get inbox => 'Inbox';

  @override
  String get today => 'Today';

  @override
  String get logbook => 'Logbook';
}
