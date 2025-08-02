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
  late final _TranslationsUpdateActionBottomSheetAr updateActionBottomSheet = _TranslationsUpdateActionBottomSheetAr._(_root);
  @override
  late final _TranslationsHomeScreenAr homeScreen = _TranslationsHomeScreenAr._(_root);
  @override
  late final _TranslationsPhotoUseDisclaimerAr photoUseDisclaimer = _TranslationsPhotoUseDisclaimerAr._(_root);
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
  String get cancel => 'إلغاء';
  @override
  String get done => 'تم';
  @override
  String get back => 'الرجوع';
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

// Path: updateActionBottomSheet
class _TranslationsUpdateActionBottomSheetAr extends TranslationsUpdateActionBottomSheetEn {
  _TranslationsUpdateActionBottomSheetAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'العنوان';
  @override
  String get description => 'الوصف';
  @override
  String get repeat => 'التكرار';
  @override
  List<String> get weekdays => ['أحد', 'اثنين', 'ثلاثاء', 'إربعاء', 'خميس', 'جمعة', 'سبت'];
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
  @override
  List<String> get morningGreetings => [
    'صباح الخير يا متألقة! 🌞',
    'انهضي وتألقِي! وقتك لتلمعي ✨',
    'مرحباً أيتها الشمس! ☀️ جاهزة للتوهج؟',
    'يوم جديد، توهج جديد 💫',
    'استيقظي يا جميلة! 🌼',
    'الصباحات أجمل بوجودك 😊',
    'لنبدع هذا اليوم! 💪',
    'صباح الخير وأطيب الأمنيات! ☕',
    'انهضي وتفتحي مثل الزهرة 🌸',
    'اليوم لوحتك – اجعليها ملونة 🎨',
    'مرحباً أيتها الرائعة! حان وقت التألق 💄',
    'استيقظي واشعري بالإمكانات! 🌈',
    'أنتِ + الصباح = سحر ✨',
    'لنجعل اليوم أسطورياً 🌟',
    'صباح الخير، يا من تسعين للتطور! 💯',
    'انهضي كالبطلة التي أنتِ عليها 🏆',
    'بداية جديدة... جاهزة 100% 🚀',
    'اليوم يناديك – ويقول أنكِ ستتألقين 🤘',
    'الصباح للأقوياء – وأنتِ منهم! 🥇',
    'مرحباً بالنور، مرحباً بالعظمة 🌄',
    'استيقظي وابدئي التوهج! 💡',
    'فجر جديد، أنتِ جديدة 🌅',
    'جاهزة للانتصار؟ ⚔️',
    'لنحوّل اليوم إلى لوحة فنية 🖼️',
    'صباح الخير، يا سر النجاح! 🔑',
    'قائمة اليوم: النجاح + الثقة 📜',
    'انهضي وتألقِي 💥',
    'تحذير: هذا اليوم مليء بالإمكانات 🕛',
    'الصباح لا يكذب – أنتِ قادرة 💪',
    'لنحضر بعض الثقة ☕✨',
    'استيقظي وتطوري 🎮',
    'صباح الخير! لنلمع اليوم 🇫🇷✨',
    'بوينوس دياس، يا من تسعين للأفضل! 🇪🇸💃',
    'غوتن مورغن، نجمة الصباح! 🇩🇪🌟',
    'بونجورنو، يا جميلة! 🇮🇹🌞',
    'تركيز الصباح: أنا لا أُهزم 🧘‍♀️',
    'تنبيه: اليوم يحتاج سحرك 🧚‍♀️',
    'حان وقت التوهج! 💅',
    'يوم جديد، تألق جديد 💇‍♀️',
    'انهضي كأنك ملكة 👑',
    'أنتِ ضد اليوم – ونحن نعرف من الفائز 🥊',
    'توقعات اليوم: فرصة 100٪ من الروعة 🌦️',
    'استيقظي وكوني المحاربة! 🛡️',
    'لنجعل اليوم يستحق الإنستغرام 📸',
    'وقود الصباح: الطموح + القهوة ⛽☕',
    'جدول اليوم: كوني مذهلة 📃',
    'تحذير: جرعة زائدة من الثقة قادمة 💥',
    'جاهزة لحصد الانتصارات اليومية؟ 🏅',
    'يوم جديد مشرق! 😎',
    '24 ساعة أخرى، لنجعلها ذات قيمة ⏳',
    'ما هي قوتك الخارقة اليوم؟ 🦸‍♀️',
  ];
  @override
  List<String> get afternoonGreetings => [
    'أجواء الظهر، أيها البطل المتألق! 🌤️',
    'استراحة الغداء؟ بل استراحة للتوهج! 🥗✨',
    'مرحبًا بالشمس مجددًا! 🌞',
    'سحر منتصف اليوم على الأبواب... ✨',
    'اشحن طاقتك وتألق! ⛽💄',
    'جدول الظهر: انهي ساعاتك بقوة ⏳',
    'لقد تجاوزت الذروة – الآن فقط الانطلاق 🏔️',
    'انفجار طاقة ما بعد الغداء 💥',
    'انهضي من سبات الطعام – لدينا تألق لنحققه! 🍝💫',
    'الساعة الذهبية؟ أنت الذهب الحقيقي! 🌇',
    'تذكير وقت الظهر: أنت تفعلين رائعًا! 👏',
    'استراحة القهوة = وقت تجهيز التوهج ☕💅',
    'لا للهبوط بعد الظهر – بل للقفزة! 🦘',
    'اجعلي فترة المساء قوية مثل صباحك 🐅',
    'الشمس لا تزال مشرقة – وممكناتك أيضًا! ☀️',
    'تحديث طاقة الظهر: الشحن الكامل 100% 🔋',
    'كونيتشيوا، يا جميلة! 🇯🇷🌸 (مساء الخير)',
    'بوا تاردي، أيها المحارب المضيء! 🇵🇹⚔️',
    'قائمة تألق العصر: ✔️ ترطيب ✔️ ثقة',
    'تنبيه: دفعة الطاقة الثانية قادمة 🌬️',
    'هل اليوم نصفه مكتمل؟ فلنملأه أكثر! 🥂',
    'وقت الشاي = وقت العناية الذاتية 🍵💆♀️',
    'لا تحصي الساعات – اجعلي الساعات تحسب! ⏰',
    'طموح بعد الظهر: لا يُوقف 🚂',
    'هبوط؟ أي هبوط؟ لنلمع! 💎',
    'نصيحة احترافية: تألقي أكثر بعد الغداء 💡',
    'شعاري في منتصف اليوم: أنا أملك هذا اليوم 🧘♂️',
    'توقعات المساء: إحتمالية 100% للروعة 🌦️',
    'اجعلي القوة تتدفق مثل الملكة التي أنتِ 👑',
    'تحتاجين طاقة؟ إليك بعض الماتشا الافتراضية! 🍵💚',
    'خطة مرحلتك: حققي أهدافك → تألقي 💥',
    'تذكري: حتى الغروب يتوهج 🌅',
    'النصف الأول من اليوم انتهى – الآن نصفه الآخر لك! 🎯',
    'خدعة طاقة الظهر: وقت وضعية القوة! 🦸♀️',
    'مساء الخير، أيها المضيء! 🇪🇸🌻',
    'إعادة شحن الظهر: انقبي ظهرك، وابدئي التألق! 💃',
    'اجعلي فترة بعد الظهر ميدالية انتصارك 🏁',
    'تنبيه: دورك الثاني للتوهج قادم 🎭',
    'وقود الظهر: طموح + شاي أخضر 🍃',
    'تألقي بعد الظهر كما لو كان صباح 2.0 ⏱️',
    'لا للغسق حتى تتألق! 🌆',
    'تدقيق منتصف النهار: ما زلت رائعة؟ ✔️',
    'تحدي الظهر: أتفوق على الشمس 🔆',
    'نصيحة إنتاجية: تألقي أثناء العمل 💻✨',
    'مزاج بعد الظهر: لا يُوقف في صمت 🤫💪',
    'نصف اليوم انتهى؟ لنجعل الباقي ممتعًا! 🎉',
    'وضع التأمل بعد الظهر: نشط 🧘♀️',
    'تذكير احترافي: الترطيب = أساس التوهج 💦',
    'تمديد الظهر → ترقية التوهج 🧘♂️💫',
    'اجعلي العالم ساعتك الذهبية 🌟',
    'سر طاقتك بعد الظهر: تتحسن كلما مر اليوم 📈',
  ];
  @override
  List<String> get eveningGreetings => [
    'تم تفعيل بروتوكول التوهج المسائي 🌆✨',
    'تحقّق الغروب: هل أضأت يومك؟ 🌇',
    'مساء الخير، جميلة! حان وقت الاسترخاء 🇫🇷🌙',
    'جدول المساء: استرخِ وتألق 🌠',
    'الساعة الذهبية = أنت الذهبية 🌟',
    'تذكير عند الغسق: كنتِ رائعة اليوم 🌄',
    'حضّري عرش نوم الجمال 🛌💤',
    'طقس المساء: اغسلي تعب اليوم 🧼✨',
    'مانترا المساء: أنا في سلام 🧘‍♀️',
    'مساء الخير، روح مضيئة! 🇮🇷🌌',
    'طلوع القمر = وقتك للتألق 🌕💫',
    'تحقّق مسائي: ٣ نجوم ترطيب؟ 💦⭐️⭐️⭐️',
    'تحدي الغروب: تأمل وتألق 🌆',
    'سر التوهج الليلي: سحر الوسادة 🛌✨',
    'توقعات المساء: ١٠٠٪ عناية ذاتية 🌧️💆‍♀️',
    'وقت التوهج على ضوء الشموع 🕯️🌸',
    'المشهد الأخير اليوم: استرخاء مشرق 🎭✨',
    'معادلة المساء: عناية بالبشرة + امتنان = 💖',
    'عمل رائع اليوم! 🇯🇵🎐',
    'افصل لتستعيد طاقتك 📵🔋',
    'إعادة ضبط مسائية: غدًا في انتظارك 🎨',
    'معزز التوهج: ابتسم لإنجازاتك اليوم 😊🏆',
    'تذكير تحت ضوء القمر: الراحة إنتاجية 🌝💤',
    'هل تستحم تحت ضوء النجوم الليلة؟ 🌠🛁',
    'طقس المساء: اغسلي اليوم، ضعي التوهج 🧴💫',
    'زيت ما قبل النوم: طبّقي التعاطف الذاتي 💧💖',
    'نقطة التوهج الأخيرة لليوم ✨✅',
    'وقود المساء: شاي أعشاب + أفكار لطيفة 🍵💭',
    'وضعية الليل: تفعيل التوهج الصامت 🤫✨',
    'تحقّق نهائي: لا زلتِ تضيئين؟ 💡✔️',
    'كيمياء المساء: اجعلي الراحة مصدر جمال 💤➡️💅',
    'اخفي طموحاتك الليلة – ستزهر غدًا 🌷',
    'مهمة الليلة: احلمي بجودة عالية 📺💭',
    'محبة السهر؟ تألقي بمسؤولية 🦉✨',
    'همسة مسائية: غدًا بحاجة لنورك 💡',
    'عد تنازلي للنوم: ٣ خطوات عناية...٢...١ 🧖‍♀️⏳',
    'ليلة مليئة بالنجوم = أنت نجمها 🌟👩🦰',
    'علم المساء: النوم = محفّز الجمال 🧪💤',
    'طور القمر: توهج كامل الليلة 🌕💫',
    'تحضير ليلي: ثقة الغد تبدأ الآن 📅💪',
    'تأمل مسائي: زفير اليوم، شهيق الغد 🌬️',
    'ملاحظة توهج أخيرة: أنتِ تستحقين العناية 💌',
    'سر الليلة: وسادة حريرية = سحر 🌛',
    'توكيد مسائي: أنتِ ألمع كوكبة 🌌',
    'تحبين السهر؟ فلنتوهج بوعي 🦉🧴',
    'معادلة المساء: نظفي + رطبي = 😴➡️😍',
    'اخفي إنجازاتك تحت الوسادة 💤🏅',
    'تذكير ليلي: بشرتك تُصلح نفسها أثناء النوم 🛌🔧',
    'هايكو المساء: نظفي، ضعي التونر، عالجي/ توهج اليوم يتعمق/ صباح ينتظر 🌙',
    'تنبيه التوهج الأخير: الغد بحاجة لإصدارك الأفضل ⏰✨',
  ];
}

// Path: photoUseDisclaimer
class _TranslationsPhotoUseDisclaimerAr extends TranslationsPhotoUseDisclaimerEn {
  _TranslationsPhotoUseDisclaimerAr._(TranslationsAr root) : this._root = root, super.internal(root);

  final TranslationsAr _root; // ignore: unused_field

  // Translations
  @override
  String get disclaimerTitlePart1 => 'بالاستمرار أنت توافق على';
  @override
  String get disclaimerTitle => 'تنبيه استخدام الصورة';
  @override
  String get disclaimerDescription =>
      'يستخدم Glowr نموذج ذكاء اصطناعي (واجهة Gemini من Google) للمساعدة في تخصيص جدولك بناءً على صورتك.\n\n🔒 نحن لا نقوم بحفظ صورتك. يتم إرسال صورتك مرة واحدة إلى Gemini AI لتحليلها، ثم يتم حذفها.\n\n📤 المعالجة من طرف ثالث:  يتم إرسال الصورة إلى خوادم Google ومعالجتها بموجب شروط وخصوصية Google للذكاء الاصطناعي. لا يتحكم Glowr في كيفية استخدام Google لهذه البيانات أو تخزينها.\n\nبمتابعة الاستخدام، فإنك توافق على هذا الاستخدام لأغراض التخصيص.\n';
  @override
  String get disclaimerTitlePart2 => 'لأغراض التخصيص.';
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
  String get privacyPolicyLaunchError => 'عذرًا! تعذّر فتح سياسة الخصوصية.';
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
