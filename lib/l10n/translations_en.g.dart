///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           );

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

  // Translations
  String get locale => 'en';
  late final TranslationsCoreEn core = TranslationsCoreEn.internal(_root);
  late final TranslationsPhotoUseDisclaimerEn photoUseDisclaimer = TranslationsPhotoUseDisclaimerEn.internal(_root);
  late final TranslationsHomeScreenEn homeScreen = TranslationsHomeScreenEn.internal(_root);
  String get noActionsToday => 'No actions today — your glow-up pause starts here or you can add a task!';
  String get loginSubtitle => 'Login to your account';
  String get userNameFieldHint => 'Username';
  String get passwordFieldHint => 'Password';
  String get userNameValidation => 'Username is required';
  String get passwordValidation => 'Password is required';
  String get imageUploadValidation => 'We need at least one image to give you accurate results';
  String get scheduleCreationLoading => 'Crafting your ultimate glow-up plan\nget ready to shine!✨';
  late final TranslationsPersonalInfoStepEn personalInfoStep = TranslationsPersonalInfoStepEn.internal(_root);
  late final TranslationsPersonalGoalStepEn personalGoalStep = TranslationsPersonalGoalStepEn.internal(_root);
  late final TranslationsImagePickerStepEn imagePickerStep = TranslationsImagePickerStepEn.internal(_root);
  late final TranslationsUpdateActionBottomSheetEn updateActionBottomSheet = TranslationsUpdateActionBottomSheetEn.internal(_root);
  late final TranslationsProfileScreenEn profileScreen = TranslationsProfileScreenEn.internal(_root);
  late final TranslationsEditProfileScreenEn editProfileScreen = TranslationsEditProfileScreenEn.internal(_root);
  late final TranslationsCalendarScreenEn calendarScreen = TranslationsCalendarScreenEn.internal(_root);
  late final TranslationsUserProfileSummaryEn userProfileSummary = TranslationsUserProfileSummaryEn.internal(_root);
}

// Path: core
class TranslationsCoreEn {
  TranslationsCoreEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get somethingWentWrong => 'Something went wrong';
  String get confirm => 'Confirm';
  String get kContinue => 'Continue';
  String get cancel => 'Cancel';
  String get done => 'Done';
  String get back => 'Back';
  String get requestCancelled => 'Request was cancelled';
  String get connectionTimeout => 'Connection timeout';
  String get connectionError => 'Connection error';
  String get noInternetConnection => 'No internet connection';
  String get serverMaintenance => 'Server under maintenance';
  String get networkUnreachable => 'Network is unreachable';
  String get unexpectedError => 'An unexpected error occurred';
  String get unauthorizedRequest => 'Unauthorized request';
  String get badRequest => 'Bad request';
  String get notFound => 'Resource not found';
  String get requestTimeout => 'Request timed out';
  String get internalServerError => 'Internal server error';
  String get serviceUnavailable => 'Service unavailable';
  String get sslHandshakeFailed => 'SSL handshake failed';
  String get formatException => 'Response was not properly formatted';
  String get invalidJsonStructure => 'Invalid JSON structure';
  String get typeMismatch => 'Type mismatch during processing';
  String get unknownError => 'Unknown error occurred';
  String get badCertificate => 'Bad SSL certificate';
}

// Path: photoUseDisclaimer
class TranslationsPhotoUseDisclaimerEn {
  TranslationsPhotoUseDisclaimerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get disclaimerTitlePart1 => 'By continuing, you agree to this';
  String get disclaimerTitlePart2 => 'for personalization purposes.';
  String get disclaimerTitle => 'Photo Use Disclaimer';
  String get disclaimerDescription =>
      'Glowr uses an AI model (Google\'s Gemini API) to help personalize your schedule based on your photo.\n\n🔒 We do not store your image. Your photo is sent one time to Gemini AI for analysis, and then discarded.\n\n📤 Third-party processing: The image is sent to Google’s servers and processed under their AI Terms and Privacy Policy. Glowr does not control how Google uses or stores that data.\n\nBy continuing, you agree to this use for personalization purposes. disclaimerTitlePart2: for personalization purposes.\n';
}

// Path: homeScreen
class TranslationsHomeScreenEn {
  TranslationsHomeScreenEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Next in your Schedule.. ⏭️';
  String get emptyScheduleMessage => 'Nothing planned yet — your golden hour is yours to create ✨';
  String get emptyScheduleTitle => 'You’re in control of your time';
  String get emptyScheduleSubTitle => 'Plan something to glow up your life ✨';
  String get createScheduleCta => 'Start Your Glow Up';
  List<String> get morningGreetings => [
    'Good morning, glow-getter! 🌞',
    'Rise and shine! Time to sparkle ✨',
    'Hello, sunshine! ☀️ Ready to glow?',
    'New day, new glow 💫',
    'Wakey wakey, beautiful! 🌼',
    'Mornings are better with you 😊',
    'Let’s slay this day! 💪',
    'Top of the morning to you! ☕',
    'Rise and bloom 🌸',
    'Today’s your canvas – paint it bright 🎨',
    'Hello, gorgeous! Time to thrive 💄',
    'Wake up and smell the possibilities! 🌈',
    'You + Morning = Magic ✨',
    'Let’s make today legendary 🌟',
    'Good morning, future self-improvement! 💯',
    'Rise like the champion you are 🏆',
    'Fresh start loading... 100% complete 🚀',
    'Today called – it said you’re gonna rock it 🤘',
    'Mornings are for winners – and that’s you! 🥇',
    'Hello daylight, hello greatness 🌄',
    'Wake up and glow up! 💡',
    'New dawn, new you 🌅',
    'Ready to conquer? ⚔️',
    'Let’s turn today into a masterpiece 🖼️',
    'Good morning, secret weapon! 🔑',
    'Today’s menu: Success + Confidence 📜',
    'Rise and radiate 💥',
    'Warning: This day contains 24 hours of potential 🕛',
    'Mornings don’t lie – you’ve got this! 💪',
    'Let’s brew confidence ☕✨',
    'Wake up and level up 🎮',
    'Bonjour! Let’s sparkle 🇫🇷✨',
    'Buenos días, go-getter! 🇪🇸💃',
    'Guten Morgen, superstar! 🇩🇪🌟',
    'Buongiorno, beautiful! 🇮🇹🌞',
    'Morning mantra: I am unstoppable 🧘‍♀️',
    'Alert: Today needs your magic 🧚‍♀️',
    'It’s glow o’clock! 💅',
    'New day, new slay 💇‍♀️',
    'Rise like royalty 👑',
    'You vs. the day – we know who’ll win 🥊',
    'Today’s forecast: 100% chance of awesome 🌦️',
    'Wake up and warrior up! 🛡️',
    'Let’s make today Instagram-worthy 📸',
    'Morning fuel: Ambition + Coffee ⛽☕',
    'Today’s agenda: Be fabulous 📃',
    'Warning: Confidence overload incoming 💥',
    'Ready to collect daily wins? 🏅',
    'It’s a bright new day! 😎',
    'Another 24, let’s make it count ⏳',
    'What’s your superpower today? 🦸‍♀️',
  ];
  List<String> get afternoonGreetings => [
    'Afternoon vibes, glow champion! 🌤️',
    'Lunch break? More like glow break! 🥗✨',
    'Hello sunshine, part two! 🌞',
    'Midday magic incoming... ✨',
    'Fuel up & glow on! ⛽💄',
    'Afternoon agenda: Slay remaining hours ⏳',
    'You’re over the hump – coast downhill now 🏔️',
    'Post-lunch power surge activated 💥',
    'Rise from the food coma – we’ve got glowing to do! 🍝💫',
    'Golden hour? More like golden you! 🌇',
    'Afternoon reminder: You’re doing amazing! 👏',
    'Coffee break = Glow prep time ☕💅',
    'Don’t afternoon slump – afternoon JUMP! 🦘',
    'Make the PM as fierce as the AM 🐅',
    'Sun’s still up – so is your potential! ☀️',
    'Afternoon energy refresh: 100% charged 🔋',
    'Kon\'nichiwa, gorgeous! 🇯🇷🌸 (Good afternoon!)',
    'Boa tarde, glow warrior! 🇵🇹⚔️',
    'Afternoon glow checklist: ✔️ Hydration ✔️ Confidence',
    'Warning: Second wind incoming 🌬️',
    'Day half full? Let’s make it overflow! 🥂',
    'Tea time = Self-care time 🍵💆♀️',
    'Don’t count hours – make hours count! ⏰',
    'Afternoon ambition level: Unstoppable 🚂',
    'Slump? What slump? Let’s sparkle! 💎',
    'Pro tip: Glow brighter after lunch 💡',
    'Midday mantra: I own this day 🧘♂️',
    'Afternoon forecast: 100% chance of fabulous 🌦️',
    'Power through like the queen you are 👑',
    'Need energy? Here’s some virtual matcha! 🍵💚',
    'Afternoon game plan: Smash goals → Glow 💥',
    'Remember: Even sunsets glow 🌅',
    'Day 50% complete – 50% more to conquer! 🎯',
    'Afternoon energy hack: Power pose time! 🦸♀️',
    'Buenas tardes, radiant one! 🇪🇸🌻',
    'Afternoon reset: Shoulders back, glow on! 💃',
    'Make the PM your personal victory lap 🏁',
    'Alert: Second act glow-up incoming 🎭',
    'Afternoon fuel: Ambition + Green tea 🍃',
    'Slay the afternoon like it’s morning 2.0 ⏱️',
    'Don’t dusk till you glow! 🌆',
    'Midday check: Still fabulous? ✔️',
    'Afternoon challenge: Out‑shine the sun 🔆',
    'Productivity tip: Glow while you work 💻✨',
    'Afternoon mood: Quietly unstoppable 🤫💪',
    'Day halfway done? Let’s make the rest fun! 🎉',
    'Afternoon zen mode: Activated 🧘♀️',
    'Pro reminder: Hydration = Glow foundation 💦',
    'Afternoon stretch → Glow upgrade 🧘♂️💫',
    'Make the world your golden hour 🌟',
    'Afternoon secret: You improve as day progresses 📈',
  ];
  List<String> get eveningGreetings => [
    'Evening glow protocol activated 🌆✨',
    'Sunset check: Did you glow today? 🌇',
    'Bonsoir, beautiful! Time to recharge 🇫🇷🌙',
    'Evening agenda: Unwind & shine down 🌠',
    'Golden hour → Golden you 🌟',
    'Dusk reminder: You were fabulous today 🌄',
    'Prep your beauty sleep throne 🛌💤',
    'Nightly ritual: Wash away the day 🧼✨',
    'Evening mantra: I am at peace 🧘♀️',
    'Buonasera, radiant soul! 🇮🇷🌌',
    'Moonrise = Your time to glow 🌕💫',
    'Evening check: 3 hydration stars today? 💦⭐️⭐️⭐️',
    'Twilight challenge: Reflect & glow 🌆',
    'Nighttime glow secret: Pillow magic 🛌✨',
    'Evening forecast: 100% chance of self-care 🌧️💆♀️',
    'Candlelit glow time 🕯️🌸',
    'Today\'s final act: Radiant relaxation 🎭✨',
    'Evening equation: Skincare + Gratitude = 💖',
    'Otsukaresama deshita! (Great work today!) 🇯🇵🎐',
    'Unplug to recharge 📵🔋',
    'Nightly reset: Tomorrow\'s canvas awaits 🎨',
    'Evening glow booster: Smile at today\'s wins 😊🏆',
    'Moonlit reminder: Rest is productive 🌝💤',
    'Bathing in starlight tonight? 🌠🛁',
    'Evening ritual: Wash off day, layer on glow 🧴💫',
    'Goodnight oil: Apply self-compassion 💧💖',
    'Today\'s final glow checkpoint ✨✅',
    'Evening fuel: Herbal tea + Kind thoughts 🍵💭',
    'Night mode: Silent glow activation 🤫✨',
    'Final light check: Still shining? 💡✔️',
    'Evening alchemy: Turn rest into beauty 💤➡️💅',
    'Tuck in your ambitions – they\'ll bloom tomorrow 🌷',
    'Tonight\'s assignment: Dream in HD 📺💭',
    'Night owl? Let’s glow responsibly 🦉✨',
    'Evening whisper: Tomorrow needs your light 💡',
    'Bedtime countdown: 3 skincare steps...2...1 🧖♀️⏳',
    'Starry night = Starry you 🌟👩🦰',
    'Evening science: Sleep = Beauty catalyst 🧪💤',
    'Moon phase: Full glow tonight 🌕💫',
    'Nightly prep: Tomorrow’s confidence starts now 📅💪',
    'Evening meditation: Breathe out today, in tomorrow 🌬️',
    'Final glow note: You’re worth the care 💌',
    'Tonight’s secret: Pillowcase magic (satin approved) 🌛',
    'Evening affirmation: You’re the brightest constellation 🌌',
    'Night owl? Let’s glow mindfully 🦉🧴',
    'Evening equation: Cleanse + Moisturize = 😴➡️😍',
    'Tuck today’s wins under your pillow 💤🏅',
    'Nightly reminder: Skin repairs while you sleep 🛌🔧',
    'Evening haiku: Wash, tone, treat/ Today’s glow settles deep/ Morning awaits 🌙',
    'Final glow alert: Tomorrow needs YOU 2.0 ⏰✨',
  ];
}

// Path: personalInfoStep
class TranslationsPersonalInfoStepEn {
  TranslationsPersonalInfoStepEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get workLabel => 'What do you do for living..?';
  String get birthDateLabel => 'Birth date';
  String get sexLabel => 'Gender';
  String get male => 'Male';
  String get female => 'Female';
  String get activityLabel => 'How do you spend your day?';
  String get mostlySitting => 'Mostly sitting';
  String get mostlyStanding => 'Mostly standing';
  String get moveAround => 'I move around a lot';
  String get workoutScheduleLabel => 'How often do you workout?';
  String get noWorkout => 'I don\'t workout';
  String get k3DayAWeekOrLess => '3 days a week or less';
  String get k3DayAWeekOrMore => 'more that 3 days a week';
  String get hobbiesLabel => 'What do you do in your free time?';
}

// Path: personalGoalStep
class TranslationsPersonalGoalStepEn {
  TranslationsPersonalGoalStepEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get goalsLabel => 'what\'s your goal from this glow up?';
  String get notesLabel => 'Any notes to take in consideration';
}

// Path: imagePickerStep
class TranslationsImagePickerStepEn {
  TranslationsImagePickerStepEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get dialogTitle => 'Would you like to';
  String get selectFromGallery => 'Select From Gallery';
  String get takePhoto => 'Take a photo';
  String get description => 'We can provide more efficient schedule based on a clear photo of you..';
  String get photoFull => 'Full length photo';
  String get photoHead => 'Head Shot';
  String get photoSide => 'Side Profile';
}

// Path: updateActionBottomSheet
class TranslationsUpdateActionBottomSheetEn {
  TranslationsUpdateActionBottomSheetEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Title';
  String get description => 'Description';
  String get repeat => 'Repeat';
  List<String> get weekdays => ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
}

// Path: profileScreen
class TranslationsProfileScreenEn {
  TranslationsProfileScreenEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get personalInfo => 'Personal Information';
  String get language => 'Language';
  String get privacyPolicy => 'Privacy policy';
  String get privacyPolicyLaunchError => 'Oops! Couldn’t open the Privacy Policy.';
  late final TranslationsProfileScreenUpdateProfileImageBottomSheetEn updateProfileImageBottomSheet =
      TranslationsProfileScreenUpdateProfileImageBottomSheetEn.internal(_root);
  late final TranslationsProfileScreenLanguageBottomSheetEn languageBottomSheet = TranslationsProfileScreenLanguageBottomSheetEn.internal(_root);
}

// Path: editProfileScreen
class TranslationsEditProfileScreenEn {
  TranslationsEditProfileScreenEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get nameLabel => 'Name';
  String get bioLabel => 'Bio';
  String get nameRequired => 'Name is required';
  String get updateError => 'Couldn\'t update';
}

// Path: calendarScreen
class TranslationsCalendarScreenEn {
  TranslationsCalendarScreenEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get today => 'Today';
  String get empty => 'Your days are wide open! ready to change your life?';
}

// Path: userProfileSummary
class TranslationsUserProfileSummaryEn {
  TranslationsUserProfileSummaryEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get title => 'Personal Details';
  String get editButton => 'Re-generate prompt';
  String get job => 'Job';
  String get birthDate => 'BirthDate';
  String get gender => 'Gender';
  String get activity => 'Activity Level';
  String get hobbies => 'Hobbies';
  String get notes => 'Note';
}

// Path: profileScreen.updateProfileImageBottomSheet
class TranslationsProfileScreenUpdateProfileImageBottomSheetEn {
  TranslationsProfileScreenUpdateProfileImageBottomSheetEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get removeCurrentPhoto => 'remove current photo';
}

// Path: profileScreen.languageBottomSheet
class TranslationsProfileScreenLanguageBottomSheetEn {
  TranslationsProfileScreenLanguageBottomSheetEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get description => 'Select your preferred language';
  String get arLang => 'العربية';
  String get engLang => 'English';
}
