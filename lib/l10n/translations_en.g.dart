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
  Translations(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
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
  String get homeScreenTitle => 'Next in your Schedule.. ⏭️';
  String get emptyActionList => 'No tasks at the moment. Enjoy your time!';
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

// Path: profileScreen
class TranslationsProfileScreenEn {
  TranslationsProfileScreenEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  String get personalInfo => 'Personal Information';
  String get language => 'Language';
  String get privacyPolicy => 'Privacy policy';
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
  String get empty => 'No actions for this day';
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
