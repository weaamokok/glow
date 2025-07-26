///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsAr extends Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsAr({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ar,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ar>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsAr _root = this; // ignore: unused_field

  @override
  TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

  // Translations
  @override
  String get locale => 'ar';
  @override
  late final _TranslationsCoreAr core = _TranslationsCoreAr._(_root);
  @override
  late final _TranslationsHomeScreenAr homeScreen = _TranslationsHomeScreenAr._(_root);
  @override
  String get noActionsToday => 'لا مهام اليوم — خذ لحظة للتوهج والراحة أو يمكنك إضافة مهمة لنفسك';
  @override
  String get loginSubtitle => 'سجل الدخول  على حسابك';
  @override
  String get userNameFieldHint => 'اسم المستخدم';
  @override
  String get passwordFieldHint => 'كلمة المرور';
  @override
  String get userNameValidation => 'الرجاء إدخال اسم المستخدم';
  @override
  String get passwordValidation => 'الرجاء إدخال كلمة المرور';
  @override
  String get imageUploadValidation => 'لإعطاءك أفضل نتائج يجب أن تحمل صورة شخصية واحدة على الاقل';
  @override
  String get scheduleCreationLoading => 'اصنع خطة التحوّل المثالية الخاصة بك\nاستعد للتألّق! ✨';
  @override
  late final _TranslationsPersonalInfoStepAr personalInfoStep = _TranslationsPersonalInfoStepAr._(_root);
  @override
  late final _TranslationsPersonalGoalStepAr personalGoalStep = _TranslationsPersonalGoalStepAr._(_root);
  @override
  late final _TranslationsImagePickerStepAr imagePickerStep = _TranslationsImagePickerStepAr._(_root);
  @override
  late final _TranslationsProfileScreenAr profileScreen = _TranslationsProfileScreenAr._(_root);
  @override
  late final _TranslationsEditProfileScreenAr editProfileScreen = _TranslationsEditProfileScreenAr._(_root);
  @override
  late final _TranslationsCalendarScreenAr calendarScreen = _TranslationsCalendarScreenAr._(_root);
  @override
  late final _TranslationsUserProfileSummaryAr userProfileSummary = _TranslationsUserProfileSummaryAr._(_root);
}

// Path: core
class _TranslationsCoreAr extends TranslationsCoreEn {
  _TranslationsCoreAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get somethingWentWrong => 'حدث خطأ ما';
  @override
  String get confirm => 'تأكيد';
  @override
  String get kContinue => 'استمرار';
  @override
  String get cancel => 'إلغاءdart';
  @override
  String get done => 'تم';
  @override
  String get requestCancelled => 'تم إلغاء الطلب';
  @override
  String get connectionTimeout => 'انتهت مهلة الاتصال';
  @override
  String get connectionError => 'خطأ في الاتصال';
  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';
  @override
  String get serverMaintenance => 'الخادم قيد الصيانة';
  @override
  String get networkUnreachable => 'الشبكة غير متاحة';
  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';
  @override
  String get unauthorizedRequest => 'طلب غير مصرح به';
  @override
  String get badRequest => 'طلب غير صالح';
  @override
  String get notFound => 'لم يتم العثور على المورد';
  @override
  String get requestTimeout => 'انتهت مهلة الطلب';
  @override
  String get internalServerError => 'خطأ في الخادم الداخلي';
  @override
  String get serviceUnavailable => 'الخدمة غير متوفرة';
  @override
  String get sslHandshakeFailed => 'فشل في التحقق من شهادة SSL';
  @override
  String get formatException => 'تنسيق الاستجابة غير صحيح';
  @override
  String get invalidJsonStructure => 'هيكل JSON غير صالح';
  @override
  String get typeMismatch => 'عدم تطابق في النوع أثناء المعالجة';
  @override
  String get unknownError => 'خطأ غير معروف';
  @override
  String get badCertificate => 'شهادة SSL غير صالحة';
}

// Path: homeScreen
class _TranslationsHomeScreenAr extends TranslationsHomeScreenEn {
  _TranslationsHomeScreenAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'التالي في جدولك..⏭️';
  @override
  String get emptyScheduleMessage => 'لا توجد خطط بعد — هذه فرصتك لصنع ساعتك الذهبية ✨';
  @override
  String get emptyScheduleTitle => 'أنت المتحكم في وقتك';
  @override
  String get emptyScheduleSubTitle => 'خطط لشيء يضيء حياتك ✨';
  @override
  String get createScheduleCta => 'ابدأ رحلة التوهج';
}

// Path: personalInfoStep
class _TranslationsPersonalInfoStepAr extends TranslationsPersonalInfoStepEn {
  _TranslationsPersonalInfoStepAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get workLabel => 'ماهي طبيعة عملك..؟';
  @override
  String get birthDateLabel => 'تاريخ الميلاد';
  @override
  String get sexLabel => 'الجنس';
  @override
  String get male => 'ذكر';
  @override
  String get female => 'أنثى';
  @override
  String get activityLabel => 'كيف تقضي يومك؟';
  @override
  String get mostlySitting => 'أجلس معظم الوقت';
  @override
  String get mostlyStanding => 'أقف معظم الوقت';
  @override
  String get moveAround => 'أتحرك كثيرًا';
  @override
  String get workoutScheduleLabel => 'كم مرة تمارس التمارين الرياضية؟';
  @override
  String get noWorkout => 'لا أمارس التمارين';
  @override
  String get k3DayAWeekOrLess => '3 أيام في الأسبوع أو أقل';
  @override
  String get k3DayAWeekOrMore => 'أكثر من 3 أيام في الأسبوع';
  @override
  String get hobbiesLabel => 'ماذا تفعل في وقت فراغك؟';
}

// Path: personalGoalStep
class _TranslationsPersonalGoalStepAr extends TranslationsPersonalGoalStepEn {
  _TranslationsPersonalGoalStepAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get goalsLabel => 'ما هو هدفك من هذا الـglow-up؟';
  @override
  String get notesLabel => 'هل هناك أي ملاحظات يجب أخذها بعين الاعتبار؟';
}

// Path: imagePickerStep
class _TranslationsImagePickerStepAr extends TranslationsImagePickerStepEn {
  _TranslationsImagePickerStepAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get dialogTitle => 'هل ترغب في';
  @override
  String get selectFromGallery => 'اختر من المعرض';
  @override
  String get takePhoto => 'التقط صورة';
  @override
  String get description => 'يمكننا توفير جدول أكثر دقة بناءً على صورة واضحة لك..';
  @override
  String get photoFull => 'صورة لكامل الجسم';
  @override
  String get photoHead => 'صورة للرأس';
  @override
  String get photoSide => 'صورة جانبية';
}

// Path: profileScreen
class _TranslationsProfileScreenAr extends TranslationsProfileScreenEn {
  _TranslationsProfileScreenAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get personalInfo => 'المعلومات الشخصية';
  @override
  String get language => 'اللغة';
  @override
  String get privacyPolicy => 'سياسة الخصوصية';
  @override
  late final _TranslationsProfileScreenUpdateProfileImageBottomSheetAr updateProfileImageBottomSheet =
      _TranslationsProfileScreenUpdateProfileImageBottomSheetAr._(_root);
  @override
  late final _TranslationsProfileScreenLanguageBottomSheetAr languageBottomSheet = _TranslationsProfileScreenLanguageBottomSheetAr._(_root);
}

// Path: editProfileScreen
class _TranslationsEditProfileScreenAr extends TranslationsEditProfileScreenEn {
  _TranslationsEditProfileScreenAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get nameLabel => 'الاسم';
  @override
  String get bioLabel => 'نبذة';
  @override
  String get nameRequired => 'الاسم مطلوب';
  @override
  String get updateError => 'تعذر التحديث';
}

// Path: calendarScreen
class _TranslationsCalendarScreenAr extends TranslationsCalendarScreenEn {
  _TranslationsCalendarScreenAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get today => 'اليوم';
  @override
  String get empty => 'أيام من الانجازات في انتظارك! هل أنت مستعد لتغيير حياتك؟';
}

// Path: userProfileSummary
class _TranslationsUserProfileSummaryAr extends TranslationsUserProfileSummaryEn {
  _TranslationsUserProfileSummaryAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'التفاصيل الشخصية';
  @override
  String get editButton => 'إعادة إنشاء الجدول';
  @override
  String get job => 'الوظيفة';
  @override
  String get birthDate => 'تاريخ الميلاد';
  @override
  String get gender => 'الجنس';
  @override
  String get activity => 'مستوى النشاط';
  @override
  String get hobbies => 'الهوايات';
  @override
  String get notes => 'ملاحظات';
}

// Path: profileScreen.updateProfileImageBottomSheet
class _TranslationsProfileScreenUpdateProfileImageBottomSheetAr extends TranslationsProfileScreenUpdateProfileImageBottomSheetEn {
  _TranslationsProfileScreenUpdateProfileImageBottomSheetAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get removeCurrentPhoto => 'إزالة الصورة الحالية';
}

// Path: profileScreen.languageBottomSheet
class _TranslationsProfileScreenLanguageBottomSheetAr extends TranslationsProfileScreenLanguageBottomSheetEn {
  _TranslationsProfileScreenLanguageBottomSheetAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get description => 'اختر اللغة التي تفضلها';
  @override
  String get arLang => 'العربية';
  @override
  String get engLang => 'English';
}
