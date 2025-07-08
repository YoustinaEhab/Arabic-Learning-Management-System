// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(answer) => "الإجابة الصحيحة: ${answer}";

  static String m1(contentName) => "هل أنت متأكد أنك تريد حذف ${contentName}؟";

  static String m2(Content) => "تم حذف المحتوى بنجاح";

  static String m3(error) => "فشل تحميل الملفات: ${error}";

  static String m4(error) => "فشل تحميل الاختبارات: ${error}";

  static String m5(error) => "خطأ في اختيار الملف: ${error}";

  static String m6(error) => "خطأ في إنشاء الاختبار: ${error}";

  static String m7(count) => "عدد الأسئلة: ${count}";

  static String m8(count) => "عدد الأسئلة: ${count}";

  static String m9(option) => "${option}";

  static String m10(question) => "${question}";

  static String m11(error) => "خطأ في تسليم الاختبار: ${error}";

  static String m12(time) => "${time}";

  static String m13(error) => "خطأ في حفظ الاختبار: ${error}";

  static String m14(correct, total) => "${correct} من أصل ${total}";

  static String m15(percent) => "${percent}% مكتمل";

  static String m16(taskDate) => "${taskDate}";

  static String m17(taskSubtitle) => "${taskSubtitle}";

  static String m18(taskTitle) => "${taskTitle}";

  static String m19(lesson) => "ملف درس التاريخ ${lesson}";

  static String m20(quizNum, qestionsNum) =>
      "اختبار التاريخ ${quizNum} - ${qestionsNum} أسئلة";

  static String m21(number) => "خيار ${number}";

  static String m22(number) => "سؤال نموذجي ${number} حول محتوى الـملف؟";

  static String m23(fileName) => "الملف: ${fileName}";

  static String m24(answer) => "إجابتك: ${answer}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AuthFailed": MessageLookupByLibrary.simpleMessage("فشل العملية"),
    "AuthSuccess": MessageLookupByLibrary.simpleMessage("تم العملية بنجاح"),
    "Home": MessageLookupByLibrary.simpleMessage("الصفحة الرئيسية"),
    "averageScoreLabel": MessageLookupByLibrary.simpleMessage("متوسط الدرجات"),
    "backToQuizzes": MessageLookupByLibrary.simpleMessage(
      "العودة إلى الاختبارات",
    ),
    "cancelButton": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("تغيير اللغة"),
    "chemistry": MessageLookupByLibrary.simpleMessage("الكيمياء"),
    "chooseLangTitle": MessageLookupByLibrary.simpleMessage("اختر اللغة:"),
    "chooseLanguage": MessageLookupByLibrary.simpleMessage("اختر اللغة"),
    "confirmPasswordHint": MessageLookupByLibrary.simpleMessage(
      "أعد إدخال كلمة المرور الجديدة",
    ),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "تأكيد كلمة المرور",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("متابعة"),
    "correctAnswer": m0,
    "deleteConfirmationCancle": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "deleteConfirmationDelete": MessageLookupByLibrary.simpleMessage("مسح"),
    "deleteConfirmationError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ. يرجى المحاولة مرة أخرى.",
    ),
    "deleteConfirmationQuest": m1,
    "deleteConfirmationSuccess": m2,
    "deleteConfirmationTitle": MessageLookupByLibrary.simpleMessage("مسح"),
    "downloadingText": MessageLookupByLibrary.simpleMessage("جاري التحميل..."),
    "emailHint": MessageLookupByLibrary.simpleMessage("أدخل البريد الإلكتروني"),
    "emailInvalid": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال بريد إلكتروني صحيح",
    ),
    "emailLabel": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "english": MessageLookupByLibrary.simpleMessage("اللغة الإنجليزية"),
    "existingPdfTitle": MessageLookupByLibrary.simpleMessage("ملف PDF الموجود"),
    "explore": MessageLookupByLibrary.simpleMessage("استكشف"),
    "exploreScreenTitle": MessageLookupByLibrary.simpleMessage(
      "استكشف عالماً من المعرفة",
    ),
    "exportQuizButton": MessageLookupByLibrary.simpleMessage("تنزيل الاختبار"),
    "failedDownloadingText": MessageLookupByLibrary.simpleMessage(
      "فشل التحميل، يُرجى المحاولة مرة أخرى",
    ),
    "failedToLoadPDFs": m3,
    "failedToLoadQuizzes": m4,
    "featureComingSoon": MessageLookupByLibrary.simpleMessage(
      "هذه الميزة قادمة قريباً",
    ),
    "fileError": m5,
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "fullNameHint": MessageLookupByLibrary.simpleMessage("أدخل الاسم الكامل"),
    "fullNameLabel": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "generateButton": MessageLookupByLibrary.simpleMessage("إنشاء الاختبار"),
    "generateQuizTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء اختبار من PDF",
    ),
    "generatedQuestionsTitle": MessageLookupByLibrary.simpleMessage(
      "الأسئلة المولدة",
    ),
    "generatingButton": MessageLookupByLibrary.simpleMessage("جاري الإنشاء..."),
    "generationError": m6,
    "geography": MessageLookupByLibrary.simpleMessage("الجغرافيا"),
    "highestScoreLabel": MessageLookupByLibrary.simpleMessage("أعلى درجة"),
    "history": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "logOut": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "lowestScoreLabel": MessageLookupByLibrary.simpleMessage("أقل درجة"),
    "materialsDownloadTitle": MessageLookupByLibrary.simpleMessage(
      "تحميل المواد",
    ),
    "materialsSectionTitle": MessageLookupByLibrary.simpleMessage(
      "المواد التعليمية",
    ),
    "mathematics": MessageLookupByLibrary.simpleMessage("الرياضيات"),
    "myAccount": MessageLookupByLibrary.simpleMessage("حسابي"),
    "navDashboard": MessageLookupByLibrary.simpleMessage("لوحة التحكم"),
    "navHome": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "navProfile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "navSubjects": MessageLookupByLibrary.simpleMessage("المواد"),
    "newPasswordHint": MessageLookupByLibrary.simpleMessage(
      "أدخل كلمة المرور الجديدة",
    ),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور الجديدة",
    ),
    "noFileSelected": MessageLookupByLibrary.simpleMessage("لم يتم اختيار ملف"),
    "noMaterialsText": MessageLookupByLibrary.simpleMessage(
      "لا توجد مواد مرفوعة بعد",
    ),
    "noQuizResults": MessageLookupByLibrary.simpleMessage(
      "لا توجد نتائج اختبار متاحة حتى الآن",
    ),
    "noQuizzesText": MessageLookupByLibrary.simpleMessage(
      "لا توجد اختبارات بعد",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على نتائج. جرب بحثًا مختلفًا.",
    ),
    "notAnswered": MessageLookupByLibrary.simpleMessage("لم يتم الإجابة"),
    "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "numberOfQuestions": m7,
    "onBoardingSubTitle1": MessageLookupByLibrary.simpleMessage(
      "تصفح الدورات، تتبع تقدمك، وحقق أهدافك في مكان واحد",
    ),
    "onBoardingSubTitle2": MessageLookupByLibrary.simpleMessage(
      "اكتشف دورات مصممة خصيصًا لاهتماماتك ومستواك",
    ),
    "onBoardingSubTitle3": MessageLookupByLibrary.simpleMessage(
      "تتبع إنجازاتك، أكمل الدروس، وافتح آفاقًا جديدة",
    ),
    "onBoardingTitle1": MessageLookupByLibrary.simpleMessage(
      "ابدأ رحلتك التعليمية",
    ),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage("تعلّم بطريقتك"),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage("تابع تقدّمك"),
    "orSignUpUsing": MessageLookupByLibrary.simpleMessage("أو سجل باستخدام"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("أدخل كلمة المرور"),
    "passwordInvalid": MessageLookupByLibrary.simpleMessage(
      "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل وتحتوي على رقم وحرف",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage(
      "فشل في إعادة تعيين كلمة المرور.",
    ),
    "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
      "تمت إعادة تعيين كلمة المرور بنجاح!",
    ),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "كلمتا المرور غير متطابقتين",
    ),
    "physics": MessageLookupByLibrary.simpleMessage("الفيزياء"),
    "profileTitle": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "profileUpdated": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الملف الشخصي بنجاح.",
    ),
    "questionReview": MessageLookupByLibrary.simpleMessage("مراجعة الأسئلة"),
    "questionsCount": m8,
    "quizConfigTitle": MessageLookupByLibrary.simpleMessage("إعدادات الاختبار"),
    "quizExportedMessage": MessageLookupByLibrary.simpleMessage(
      "تم تصدير الاختبار كملف",
    ),
    "quizNameDropMenu": MessageLookupByLibrary.simpleMessage("أختر اختبار"),
    "quizOption": m9,
    "quizQuestion": m10,
    "quizResultsSubtitle": MessageLookupByLibrary.simpleMessage(
      "عرض أداء الطلاب",
    ),
    "quizResultsTitle": MessageLookupByLibrary.simpleMessage("نتائج الاختبار"),
    "quizSavedMessage": MessageLookupByLibrary.simpleMessage(
      "تم حفظ الاختبار و رفعه",
    ),
    "quizScoresTitle": MessageLookupByLibrary.simpleMessage("نتائج الاختبارات"),
    "quizSubmitError": m11,
    "quizTimeLabel": MessageLookupByLibrary.simpleMessage(
      "مدة الاختبار (بالدقائق):",
    ),
    "quizTimeRemaining": m12,
    "quizzesSectionTitle": MessageLookupByLibrary.simpleMessage("الاختبارات"),
    "recommendedYoutubeResources": MessageLookupByLibrary.simpleMessage(
      "موارد يوتيوب الموصى بها",
    ),
    "requiredField": MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
    "resetButton": MessageLookupByLibrary.simpleMessage("إعادة التعيين"),
    "saveButton": MessageLookupByLibrary.simpleMessage("حفظ"),
    "saveQuizButton": MessageLookupByLibrary.simpleMessage("حفظ الاختبار"),
    "saveQuizError": m13,
    "scoreText": m14,
    "searchForATopic": MessageLookupByLibrary.simpleMessage("ابحث عن موضوع..."),
    "selectFromUploaded": MessageLookupByLibrary.simpleMessage(
      "اختيار من الملفات المرفوعة",
    ),
    "selectNewPdf": MessageLookupByLibrary.simpleMessage("اختيار ملف PDF جديد"),
    "selectPdfButton": MessageLookupByLibrary.simpleMessage("اختر ملف PDF"),
    "selectPdfSource": MessageLookupByLibrary.simpleMessage(
      "اختر مصدر ملف PDF",
    ),
    "selectPdfTitle": MessageLookupByLibrary.simpleMessage("اختر ملف PDF"),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "signInAuthFailed": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ. يرجى التحقق من بيانات الاعتماد الخاصة بك.",
    ),
    "signInButton": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInNoAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟ "),
    "signInSignUpLink": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "signInWelcome": MessageLookupByLibrary.simpleMessage("مرحبًا بعودتك"),
    "signUpAlreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "signUpAuthFailed": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ. يرجى المحاولة مرة أخرى.",
    ),
    "signUpButton": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "signUpSignInLink": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signUpTitle": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
    "startQuizCancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "startQuizConfirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "startQuizMessage": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد البدء في هذا الاختبار؟",
    ),
    "startQuizTitle": MessageLookupByLibrary.simpleMessage("ابدأ الاختبار"),
    "studentCompleted": m15,
    "studentHomeAppBarTitle": MessageLookupByLibrary.simpleMessage(
      "Arabic LMS",
    ),
    "studentHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مرحبًا أيها الطالب!",
    ),
    "studentOverallProgress": MessageLookupByLibrary.simpleMessage(
      "التقدم العام",
    ),
    "studentProgressTitle": MessageLookupByLibrary.simpleMessage(
      "تقدمك التعليمي",
    ),
    "studentRole": MessageLookupByLibrary.simpleMessage("طالب"),
    "studentScoresLabel": MessageLookupByLibrary.simpleMessage("درجات الطلاب:"),
    "studentTaskDate": m16,
    "studentTaskSubtitle": m17,
    "studentTaskTitle": m18,
    "studentUpcomingTasks": MessageLookupByLibrary.simpleMessage(
      "المهام القادمة",
    ),
    "subjectDetailTitle": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "subjectLabel": MessageLookupByLibrary.simpleMessage("عنوان الاختبار"),
    "subjectsTitle": MessageLookupByLibrary.simpleMessage("المواد الدراسية"),
    "submitQuiz": MessageLookupByLibrary.simpleMessage("تسليم الاختبار"),
    "submittingQuiz": MessageLookupByLibrary.simpleMessage("جاري التسليم..."),
    "successDownloadingText": MessageLookupByLibrary.simpleMessage(
      "تم حفظ ملف PDF في ملف التنزيلات!",
    ),
    "tapToUpload": MessageLookupByLibrary.simpleMessage("انقر لرفع ملف"),
    "teacherHomeGenerateButton": MessageLookupByLibrary.simpleMessage(
      "إنشاء \n الأسئلة",
    ),
    "teacherHomeMaterial": m19,
    "teacherHomeQuiz": m20,
    "teacherHomeSubtitle1": MessageLookupByLibrary.simpleMessage(
      "المواد المرفوعة",
    ),
    "teacherHomeSubtitle2": MessageLookupByLibrary.simpleMessage(
      "الاختبارات المولدة",
    ),
    "teacherHomeTitle": MessageLookupByLibrary.simpleMessage(
      "مرحبًا أيها المعلم!",
    ),
    "teacherHomeUploadButton": MessageLookupByLibrary.simpleMessage(
      "رفع \n المواد",
    ),
    "teacherHomeViewButton": MessageLookupByLibrary.simpleMessage(
      "عرض \n التقارير",
    ),
    "teacherNoMaterials": MessageLookupByLibrary.simpleMessage(
      "لا يوجد مواد مرفوعة",
    ),
    "teacherRole": MessageLookupByLibrary.simpleMessage("معلّم"),
    "tempOptionText": m21,
    "tempSampleQuestion": m22,
    "topicLabel": MessageLookupByLibrary.simpleMessage("الموضوع"),
    "totalAttemptsLabel": MessageLookupByLibrary.simpleMessage(
      "إجمالي المحاولات",
    ),
    "untitledMaterial": MessageLookupByLibrary.simpleMessage("مادة بدون عنوان"),
    "untitledPdf": MessageLookupByLibrary.simpleMessage("ملف PDF بدون عنوان"),
    "untitledQuiz": MessageLookupByLibrary.simpleMessage("اختبار بدون عنوان"),
    "updateFailed": MessageLookupByLibrary.simpleMessage(
      "فشل في تحديث الملف الشخصي.",
    ),
    "uploadError": MessageLookupByLibrary.simpleMessage(
      "الرجاء رفع ملف وتعبئة جميع الحقول",
    ),
    "uploadFileDescription": MessageLookupByLibrary.simpleMessage("الوصف"),
    "uploadFileTag": MessageLookupByLibrary.simpleMessage("أضف وسم"),
    "uploadFileTagsTitle": MessageLookupByLibrary.simpleMessage("الوسوم"),
    "uploadFileText": m23,
    "uploadFileTitle": MessageLookupByLibrary.simpleMessage("العنوان"),
    "uploadMaterial": MessageLookupByLibrary.simpleMessage("رفع المادة"),
    "uploadMaterialButton": MessageLookupByLibrary.simpleMessage("رفع المادة"),
    "uploadPdfTitle": MessageLookupByLibrary.simpleMessage("رفع ملف PDF"),
    "uploadSuccess": MessageLookupByLibrary.simpleMessage(
      "تم رفع المادة بنجاح!",
    ),
    "useExistingPdf": MessageLookupByLibrary.simpleMessage(
      "استخدام ملف PDF موجود",
    ),
    "userTypeTitle": MessageLookupByLibrary.simpleMessage("اختر دورك"),
    "watchButton": MessageLookupByLibrary.simpleMessage("شاهد"),
    "watchOnYoutube": MessageLookupByLibrary.simpleMessage("شاهد على يوتيوب"),
    "welcomeSignInButton": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "welcomeSignUpButton": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "welcomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "أدخل التفاصيل الشخصية لحساب المستخدم الخاص بك",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage("مرحبًا بك!\n"),
    "yourAnswer": m24,
    "yourScore": MessageLookupByLibrary.simpleMessage("نقاطك"),
  };
}
