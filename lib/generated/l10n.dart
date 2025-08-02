// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `تطبيقي المحاسبي`
  String get appTitle {
    return Intl.message(
      'تطبيقي المحاسبي',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `كيف تريد استخدام المحاسبي؟\n(اختر كل ما ينطبق)`
  String get splashTitle {
    return Intl.message(
      'كيف تريد استخدام المحاسبي؟\n(اختر كل ما ينطبق)',
      name: 'splashTitle',
      desc: '',
      args: [],
    );
  }

  /// `التالي`
  String get next {
    return Intl.message('التالي', name: 'next', desc: '', args: []);
  }

  /// `لديّ حساب مسبق`
  String get alreadyHaveAccount {
    return Intl.message(
      'لديّ حساب مسبق',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `مصروفاتي الشخصية`
  String get personalTracker {
    return Intl.message(
      'مصروفاتي الشخصية',
      name: 'personalTracker',
      desc: '',
      args: [],
    );
  }

  /// `حساب مشترك / ديون`
  String get sharing {
    return Intl.message(
      'حساب مشترك / ديون',
      name: 'sharing',
      desc: '',
      args: [],
    );
  }

  /// `إدارة مشروع`
  String get project {
    return Intl.message('إدارة مشروع', name: 'project', desc: '', args: []);
  }

  /// `مرحبًا بعودتك! الرجاء اختيار طريقة تسجيل الدخول`
  String get loginWelcome {
    return Intl.message(
      'مرحبًا بعودتك! الرجاء اختيار طريقة تسجيل الدخول',
      name: 'loginWelcome',
      desc: '',
      args: [],
    );
  }

  /// `متابعة عبر جوجل`
  String get loginWithGoogle {
    return Intl.message(
      'متابعة عبر جوجل',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `متابعة عبر الجوال`
  String get loginWithPhone {
    return Intl.message(
      'متابعة عبر الجوال',
      name: 'loginWithPhone',
      desc: '',
      args: [],
    );
  }

  /// `متابعة عبر البريد الإلكتروني`
  String get loginWithEmail {
    return Intl.message(
      'متابعة عبر البريد الإلكتروني',
      name: 'loginWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `كلمه المرور`
  String get passwordHint {
    return Intl.message(
      'كلمه المرور',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `تذكرني`
  String get rememberMe {
    return Intl.message('تذكرني', name: 'rememberMe', desc: '', args: []);
  }

  /// `نسيت كلمة المرور`
  String get forgotPassword {
    return Intl.message(
      'نسيت كلمة المرور',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `دخول`
  String get login {
    return Intl.message('دخول', name: 'login', desc: '', args: []);
  }

  /// `او`
  String get or {
    return Intl.message('او', name: 'or', desc: '', args: []);
  }

  /// `دخول عبر حساب APPLE`
  String get loginWithApple {
    return Intl.message(
      'دخول عبر حساب APPLE',
      name: 'loginWithApple',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رقم هاتفك`
  String get phoneHint {
    return Intl.message(
      'أدخل رقم هاتفك',
      name: 'phoneHint',
      desc: 'تعليمات لحقل إدخال رقم الهاتف',
      args: [],
    );
  }

  /// `أرسل الرمز`
  String get sendCode {
    return Intl.message(
      'أرسل الرمز',
      name: 'sendCode',
      desc: 'نص زر لإرسال رمز التحقق',
      args: [],
    );
  }

  /// `أدخل رمز التحقق`
  String get codeHint {
    return Intl.message(
      'أدخل رمز التحقق',
      name: 'codeHint',
      desc: 'تعليمات لحقل إدخال رمز التحقق',
      args: [],
    );
  }

  /// `تحقق`
  String get verify {
    return Intl.message(
      'تحقق',
      name: 'verify',
      desc: 'نص زر للتحقق من الرمز',
      args: [],
    );
  }

  /// `إعادة إرسال الرمز`
  String get resendCode {
    return Intl.message(
      'إعادة إرسال الرمز',
      name: 'resendCode',
      desc: 'نص زر لإعادة إرسال الرمز بعد انتهاء العداد',
      args: [],
    );
  }

  /// `إعادة الإرسال خلال {seconds}ث`
  String resendIn(Object seconds) {
    return Intl.message(
      'إعادة الإرسال خلال $secondsث',
      name: 'resendIn',
      desc: 'النص الذي يعرض العداد قبل تفعيل زر الإرسال',
      args: [seconds],
    );
  }

  /// `شخصي`
  String get personalTab {
    return Intl.message('شخصي', name: 'personalTab', desc: '', args: []);
  }

  /// `مجموعات`
  String get groupsTab {
    return Intl.message('مجموعات', name: 'groupsTab', desc: '', args: []);
  }

  /// `مشاريع`
  String get projectsTab {
    return Intl.message('مشاريع', name: 'projectsTab', desc: '', args: []);
  }

  /// `ابحث بالاسم أو الوصف`
  String get searchHint {
    return Intl.message(
      'ابحث بالاسم أو الوصف',
      name: 'searchHint',
      desc: 'نص الحقل المُوَجَّه في شريط البحث في شاشة لوحة القيادة',
      args: [],
    );
  }

  /// `المصروفات هذا الشهر`
  String get spentThisMonth {
    return Intl.message(
      'المصروفات هذا الشهر',
      name: 'spentThisMonth',
      desc: 'التسمية لإجمالي المصروفات في الشهر الحالي',
      args: [],
    );
  }

  /// `الإيرادات هذا الشهر`
  String get incomeThisMonth {
    return Intl.message(
      'الإيرادات هذا الشهر',
      name: 'incomeThisMonth',
      desc: 'التسمية لإجمالي الإيرادات في الشهر الحالي',
      args: [],
    );
  }

  /// `المعاملات`
  String get transactionsTab {
    return Intl.message(
      'المعاملات',
      name: 'transactionsTab',
      desc: 'التسمية لتبويب عرض المعاملات',
      args: [],
    );
  }

  /// `التقارير`
  String get reportsTab {
    return Intl.message(
      'التقارير',
      name: 'reportsTab',
      desc: 'التسمية لتبويب عرض التقارير',
      args: [],
    );
  }

  /// `لا توجد قوالب بعد`
  String get noTemplatesYet {
    return Intl.message(
      'لا توجد قوالب بعد',
      name: 'noTemplatesYet',
      desc: '',
      args: [],
    );
  }

  /// `التقاط صورة`
  String get takePhoto {
    return Intl.message('التقاط صورة', name: 'takePhoto', desc: '', args: []);
  }

  /// `اختيار من المعرض`
  String get pickFromGallery {
    return Intl.message(
      'اختيار من المعرض',
      name: 'pickFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `فشل رفع الملف`
  String get uploadFailed {
    return Intl.message(
      'فشل رفع الملف',
      name: 'uploadFailed',
      desc: '',
      args: [],
    );
  }

  /// `أدخل المبلغ`
  String get amountHint {
    return Intl.message('أدخل المبلغ', name: 'amountHint', desc: '', args: []);
  }

  /// `الرجاء إدخال مبلغ`
  String get enterAmount {
    return Intl.message(
      'الرجاء إدخال مبلغ',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `أدخل الوصف`
  String get descriptionHint {
    return Intl.message(
      'أدخل الوصف',
      name: 'descriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال الوصف`
  String get enterDescription {
    return Intl.message(
      'الرجاء إدخال الوصف',
      name: 'enterDescription',
      desc: '',
      args: [],
    );
  }

  /// `إرفاق ملف`
  String get attachFile {
    return Intl.message('إرفاق ملف', name: 'attachFile', desc: '', args: []);
  }

  /// `فئة جديدة`
  String get newCategoryHint {
    return Intl.message(
      'فئة جديدة',
      name: 'newCategoryHint',
      desc: '',
      args: [],
    );
  }

  /// `دخل`
  String get income {
    return Intl.message('دخل', name: 'income', desc: '', args: []);
  }

  /// `لا يوجد اي عمليه سابقة`
  String get noTransactions {
    return Intl.message(
      'لا يوجد اي عمليه سابقة',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `مصروف`
  String get expense {
    return Intl.message('مصروف', name: 'expense', desc: '', args: []);
  }

  /// `تعديل الفئة`
  String get editCategory {
    return Intl.message(
      'تعديل الفئة',
      name: 'editCategory',
      desc: 'عنوان زر لتعديل فئة',
      args: [],
    );
  }

  /// `حذف الفئة`
  String get deleteCategory {
    return Intl.message(
      'حذف الفئة',
      name: 'deleteCategory',
      desc: 'عنوان زر لحذف فئة',
      args: [],
    );
  }

  /// `اسم الفئة`
  String get fieldCategoryName {
    return Intl.message(
      'اسم الفئة',
      name: 'fieldCategoryName',
      desc: 'تسمية حقل نص اسم الفئة',
      args: [],
    );
  }

  /// `اختر اللون`
  String get selectColor {
    return Intl.message(
      'اختر اللون',
      name: 'selectColor',
      desc: 'تسمية لفتح منتقي الألوان',
      args: [],
    );
  }

  /// `اختر الأيقونة`
  String get selectIcon {
    return Intl.message(
      'اختر الأيقونة',
      name: 'selectIcon',
      desc: 'تسمية لفتح منتقي الأيقونات',
      args: [],
    );
  }

  /// `تطبيق`
  String get apply {
    return Intl.message(
      'تطبيق',
      name: 'apply',
      desc: 'نص زر عام للتأكيد',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message(
      'إلغاء',
      name: 'cancel',
      desc: 'نص زر عام للإلغاء',
      args: [],
    );
  }

  /// `هل أنت متأكد أنك تريد حذف هذه الفئة؟`
  String get confirmDeleteCategory {
    return Intl.message(
      'هل أنت متأكد أنك تريد حذف هذه الفئة؟',
      name: 'confirmDeleteCategory',
      desc: 'رسالة تأكيد قبل حذف الفئة',
      args: [],
    );
  }

  /// `لا يمكن حذف فئة تحتوي على معاملات.`
  String get cannotDeleteCategoryWithTxns {
    return Intl.message(
      'لا يمكن حذف فئة تحتوي على معاملات.',
      name: 'cannotDeleteCategoryWithTxns',
      desc: 'رسالة خطأ عند محاولة حذف فئة مرتبطة بمعاملات',
      args: [],
    );
  }

  /// `تعديل المعاملة`
  String get editTransaction {
    return Intl.message(
      'تعديل المعاملة',
      name: 'editTransaction',
      desc: '',
      args: [],
    );
  }

  /// `حفظ التغييرات`
  String get saveChanges {
    return Intl.message(
      'حفظ التغييرات',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `حذف المعاملة`
  String get deleteTransaction {
    return Intl.message(
      'حذف المعاملة',
      name: 'deleteTransaction',
      desc: '',
      args: [],
    );
  }

  /// `هل تريد حذف هذه المعاملة؟`
  String get confirmDeleteTitle {
    return Intl.message(
      'هل تريد حذف هذه المعاملة؟',
      name: 'confirmDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `لا يمكن التراجع عن هذا الإجراء.`
  String get confirmDeleteContent {
    return Intl.message(
      'لا يمكن التراجع عن هذا الإجراء.',
      name: 'confirmDeleteContent',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get yesDelete {
    return Intl.message('حذف', name: 'yesDelete', desc: '', args: []);
  }

  /// `تم تعديل المعاملة`
  String get transactionUpdated {
    return Intl.message(
      'تم تعديل المعاملة',
      name: 'transactionUpdated',
      desc: '',
      args: [],
    );
  }

  /// `هذا الحقل مطلوب`
  String get fieldRequired {
    return Intl.message(
      'هذا الحقل مطلوب',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `الرقم المدخل غير صحيح`
  String get invalidNumber {
    return Intl.message(
      'الرقم المدخل غير صحيح',
      name: 'invalidNumber',
      desc: '',
      args: [],
    );
  }

  /// `تم حذف المعاملة`
  String get transactionDeleted {
    return Intl.message(
      'تم حذف المعاملة',
      name: 'transactionDeleted',
      desc: '',
      args: [],
    );
  }

  /// `المصروفات`
  String get reportTypeExpense {
    return Intl.message(
      'المصروفات',
      name: 'reportTypeExpense',
      desc: '',
      args: [],
    );
  }

  /// `الإيرادات`
  String get reportTypeIncome {
    return Intl.message(
      'الإيرادات',
      name: 'reportTypeIncome',
      desc: '',
      args: [],
    );
  }

  /// `الصافي`
  String get reportTypeNet {
    return Intl.message('الصافي', name: 'reportTypeNet', desc: '', args: []);
  }

  /// `اليوم`
  String get rangeToday {
    return Intl.message('اليوم', name: 'rangeToday', desc: '', args: []);
  }

  /// `هذا الأسبوع`
  String get rangeWeek {
    return Intl.message('هذا الأسبوع', name: 'rangeWeek', desc: '', args: []);
  }

  /// `هذا الشهر`
  String get rangeMonth {
    return Intl.message('هذا الشهر', name: 'rangeMonth', desc: '', args: []);
  }

  /// `هذا العام`
  String get rangeYear {
    return Intl.message('هذا العام', name: 'rangeYear', desc: '', args: []);
  }

  /// `مخصص`
  String get rangeCustom {
    return Intl.message('مخصص', name: 'rangeCustom', desc: '', args: []);
  }

  /// `لا توجد بيانات لهذه الفترة.`
  String get noReportData {
    return Intl.message(
      'لا توجد بيانات لهذه الفترة.',
      name: 'noReportData',
      desc: '',
      args: [],
    );
  }

  /// `التقارير`
  String get reportsTitle {
    return Intl.message('التقارير', name: 'reportsTitle', desc: '', args: []);
  }

  /// `اختر فترة التاريخ`
  String get reportsDateRangeLabel {
    return Intl.message(
      'اختر فترة التاريخ',
      name: 'reportsDateRangeLabel',
      desc: '',
      args: [],
    );
  }

  /// `عرض`
  String get reportsTypeLabel {
    return Intl.message('عرض', name: 'reportsTypeLabel', desc: '', args: []);
  }

  /// `جارٍ تحميل التقرير…`
  String get reportsLoading {
    return Intl.message(
      'جارٍ تحميل التقرير…',
      name: 'reportsLoading',
      desc: '',
      args: [],
    );
  }

  /// `الإعدادات`
  String get settingsTitle {
    return Intl.message('الإعدادات', name: 'settingsTitle', desc: '', args: []);
  }

  /// `المظهر`
  String get appearanceSection {
    return Intl.message(
      'المظهر',
      name: 'appearanceSection',
      desc: '',
      args: [],
    );
  }

  /// `الوضع الداكن`
  String get darkMode {
    return Intl.message('الوضع الداكن', name: 'darkMode', desc: '', args: []);
  }

  /// `اللغة`
  String get languageSection {
    return Intl.message('اللغة', name: 'languageSection', desc: '', args: []);
  }

  /// `English`
  String get languageEnglish {
    return Intl.message('English', name: 'languageEnglish', desc: '', args: []);
  }

  /// `العربية`
  String get languageArabic {
    return Intl.message('العربية', name: 'languageArabic', desc: '', args: []);
  }

  /// `الإشعارات`
  String get notificationsSection {
    return Intl.message(
      'الإشعارات',
      name: 'notificationsSection',
      desc: '',
      args: [],
    );
  }

  /// `تفعيل الإشعارات`
  String get notificationsEnabled {
    return Intl.message(
      'تفعيل الإشعارات',
      name: 'notificationsEnabled',
      desc: '',
      args: [],
    );
  }

  /// `تذكير الديون`
  String get debtsReminderSetting {
    return Intl.message(
      'تذكير الديون',
      name: 'debtsReminderSetting',
      desc: '',
      args: [],
    );
  }

  /// `التذكير اليومي`
  String get dailyReminderSetting {
    return Intl.message(
      'التذكير اليومي',
      name: 'dailyReminderSetting',
      desc: '',
      args: [],
    );
  }

  /// `أخبار وتحديثات`
  String get newsUpdatesSetting {
    return Intl.message(
      'أخبار وتحديثات',
      name: 'newsUpdatesSetting',
      desc: '',
      args: [],
    );
  }

  /// `الحساب`
  String get accountSection {
    return Intl.message('الحساب', name: 'accountSection', desc: '', args: []);
  }

  /// `تغيير الاسم`
  String get changeName {
    return Intl.message('تغيير الاسم', name: 'changeName', desc: '', args: []);
  }

  /// `تغيير البريد الإلكتروني`
  String get changeEmail {
    return Intl.message(
      'تغيير البريد الإلكتروني',
      name: 'changeEmail',
      desc: '',
      args: [],
    );
  }

  /// `تغيير رقم الهاتف`
  String get changePhone {
    return Intl.message(
      'تغيير رقم الهاتف',
      name: 'changePhone',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل خروج`
  String get logout {
    return Intl.message('تسجيل خروج', name: 'logout', desc: '', args: []);
  }

  /// `هل أنت متأكد أنّك تريد الخروج؟`
  String get logoutConfirmation {
    return Intl.message(
      'هل أنت متأكد أنّك تريد الخروج؟',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `لتتمكن من استخدام المجموعات والمشاريع، يرجى إضافة اسمك الكامل ورقم هاتفك حتى يتمكن الآخرون من العثور عليك.`
  String get updateProfilePrompt {
    return Intl.message(
      'لتتمكن من استخدام المجموعات والمشاريع، يرجى إضافة اسمك الكامل ورقم هاتفك حتى يتمكن الآخرون من العثور عليك.',
      name: 'updateProfilePrompt',
      desc:
          'Prompt explaining why we need name & phone before entering groups/projects',
      args: [],
    );
  }

  /// `الاسم الكامل`
  String get fullName {
    return Intl.message(
      'الاسم الكامل',
      name: 'fullName',
      desc: 'Label for the full name field',
      args: [],
    );
  }

  /// `أدخل اسمك الكامل`
  String get fullNameHint {
    return Intl.message(
      'أدخل اسمك الكامل',
      name: 'fullNameHint',
      desc: 'Hint text for the full name field',
      args: [],
    );
  }

  /// `الاسم مطلوب`
  String get nameRequired {
    return Intl.message(
      'الاسم مطلوب',
      name: 'nameRequired',
      desc: 'Validation message when name is left empty',
      args: [],
    );
  }

  /// `رقم الهاتف مطلوب`
  String get phoneRequired {
    return Intl.message(
      'رقم الهاتف مطلوب',
      name: 'phoneRequired',
      desc: 'Validation message when phone is left empty',
      args: [],
    );
  }

  /// `تحديث الملف الشخصي`
  String get updateProfile {
    return Intl.message(
      'تحديث الملف الشخصي',
      name: 'updateProfile',
      desc: 'Button text to submit the profile update',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
