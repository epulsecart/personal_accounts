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

  static String m0(count) =>
      "${Intl.plural(count, one: 'عضو واحد', other: '# أعضاء')}";

  static String m1(seconds) => "إعادة الإرسال خلال";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountSection": MessageLookupByLibrary.simpleMessage("الحساب"),
        "alreadyHaveAPendingRequest": MessageLookupByLibrary.simpleMessage(
            "يوجد طلب تعديل معلق الرجاء الموافقة عليك اولا"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("لديّ حساب مسبق"),
        "amount": MessageLookupByLibrary.simpleMessage("المبلغ "),
        "amountHint": MessageLookupByLibrary.simpleMessage("أدخل المبلغ"),
        "appTitle": MessageLookupByLibrary.simpleMessage("تطبيقي المحاسبي"),
        "appearanceSection": MessageLookupByLibrary.simpleMessage("المظهر"),
        "apply": MessageLookupByLibrary.simpleMessage("تطبيق"),
        "approve": MessageLookupByLibrary.simpleMessage("Approve"),
        "approveTransaction":
            MessageLookupByLibrary.simpleMessage("الموافقة على العملية"),
        "approved": MessageLookupByLibrary.simpleMessage("Approved"),
        "approvedSuccessfully":
            MessageLookupByLibrary.simpleMessage("تم قبول المستخدم بنجاح"),
        "attachFile": MessageLookupByLibrary.simpleMessage("إرفاق ملف"),
        "balancePerMember":
            MessageLookupByLibrary.simpleMessage("الرصيد لكل عضو"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "cannotDeleteCategoryWithTxns": MessageLookupByLibrary.simpleMessage(
            "لا يمكن حذف فئة تحتوي على معاملات."),
        "changeEmail":
            MessageLookupByLibrary.simpleMessage("تغيير البريد الإلكتروني"),
        "changeHistory": MessageLookupByLibrary.simpleMessage("تاريخ الطلبات"),
        "changeName": MessageLookupByLibrary.simpleMessage("تغيير الاسم"),
        "changePhone": MessageLookupByLibrary.simpleMessage("تغيير رقم الهاتف"),
        "changeRequestSentForApproval": MessageLookupByLibrary.simpleMessage(
            "تم ارسال طلب التعديل يجب الموافقه من الطرف الاخر"),
        "codeHint": MessageLookupByLibrary.simpleMessage("أدخل رمز التحقق"),
        "confirmApproveTransaction":
            MessageLookupByLibrary.simpleMessage("تاكيد العملية"),
        "confirmDeleteCategory": MessageLookupByLibrary.simpleMessage(
            "هل أنت متأكد أنك تريد حذف هذه الفئة؟"),
        "confirmDeleteContent": MessageLookupByLibrary.simpleMessage(
            "لا يمكن التراجع عن هذا الإجراء."),
        "confirmDeleteTitle":
            MessageLookupByLibrary.simpleMessage("هل تريد حذف هذه المعاملة؟"),
        "copyJoinCode":
            MessageLookupByLibrary.simpleMessage("نسخ رمز الانضمام"),
        "create": MessageLookupByLibrary.simpleMessage("انشاء"),
        "createGroup": MessageLookupByLibrary.simpleMessage("انشاء مجموعة"),
        "dailyReminderSetting":
            MessageLookupByLibrary.simpleMessage("التذكير اليومي"),
        "darkMode": MessageLookupByLibrary.simpleMessage("الوضع الداكن"),
        "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
        "debtsReminderSetting":
            MessageLookupByLibrary.simpleMessage("تذكير الديون"),
        "deleteCategory": MessageLookupByLibrary.simpleMessage("حذف الفئة"),
        "deleteTransaction":
            MessageLookupByLibrary.simpleMessage("حذف المعاملة"),
        "description": MessageLookupByLibrary.simpleMessage("الوصف"),
        "descriptionHint": MessageLookupByLibrary.simpleMessage("أدخل الوصف"),
        "descriptionOptional":
            MessageLookupByLibrary.simpleMessage("وصف المجموعة"),
        "editCategory": MessageLookupByLibrary.simpleMessage("تعديل الفئة"),
        "editTransaction":
            MessageLookupByLibrary.simpleMessage("تعديل المعاملة"),
        "enterAmount":
            MessageLookupByLibrary.simpleMessage("الرجاء إدخال مبلغ"),
        "enterDescription":
            MessageLookupByLibrary.simpleMessage("الرجاء إدخال الوصف"),
        "enterJoinCode":
            MessageLookupByLibrary.simpleMessage("ادخل كود المجموعة يدوياً"),
        "errorCreatingGroup": MessageLookupByLibrary.simpleMessage(
            "حصلت مشكله عند انشاء المجموعة"),
        "errorJoiningGroup":
            MessageLookupByLibrary.simpleMessage("فشل الانضمام للمجموعة"),
        "errorLoadingData": MessageLookupByLibrary.simpleMessage(
            "هناك مشكله في تحميل البيانات"),
        "expense": MessageLookupByLibrary.simpleMessage("مصروف"),
        "fieldCategoryName": MessageLookupByLibrary.simpleMessage("اسم الفئة"),
        "fieldRequired":
            MessageLookupByLibrary.simpleMessage("هذا الحقل مطلوب"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور"),
        "fromTo": MessageLookupByLibrary.simpleMessage("من -> الى"),
        "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
        "fullNameHint":
            MessageLookupByLibrary.simpleMessage("أدخل اسمك الكامل"),
        "getexcel": MessageLookupByLibrary.simpleMessage("تحميل"),
        "groupDetails": MessageLookupByLibrary.simpleMessage("عمليات المجموعة"),
        "groupList": MessageLookupByLibrary.simpleMessage("المجموعات"),
        "groupName": MessageLookupByLibrary.simpleMessage("اسم المجموعة"),
        "groupsTab": MessageLookupByLibrary.simpleMessage("مجموعات"),
        "income": MessageLookupByLibrary.simpleMessage("دخل"),
        "incomeThisMonth":
            MessageLookupByLibrary.simpleMessage("الإيرادات هذا الشهر"),
        "invalidNumber":
            MessageLookupByLibrary.simpleMessage("الرقم المدخل غير صحيح"),
        "invitee": MessageLookupByLibrary.simpleMessage("الشخص المدعو"),
        "joinCode": MessageLookupByLibrary.simpleMessage("انضمام"),
        "joinNewGroup": MessageLookupByLibrary.simpleMessage("إنظم"),
        "joinRequestSent":
            MessageLookupByLibrary.simpleMessage("تم طلب الانضمام بنجاح"),
        "joinRequestsTab":
            MessageLookupByLibrary.simpleMessage("طلبات الانضمام"),
        "languageArabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
        "languageSection": MessageLookupByLibrary.simpleMessage("اللغة"),
        "lastUpdated": MessageLookupByLibrary.simpleMessage("اخر تحديث"),
        "login": MessageLookupByLibrary.simpleMessage("دخول"),
        "loginWelcome": MessageLookupByLibrary.simpleMessage(
            "مرحبًا بعودتك! الرجاء اختيار طريقة تسجيل الدخول"),
        "loginWithApple":
            MessageLookupByLibrary.simpleMessage("دخول عبر حساب APPLE"),
        "loginWithEmail": MessageLookupByLibrary.simpleMessage(
            "متابعة عبر البريد الإلكتروني"),
        "loginWithGoogle":
            MessageLookupByLibrary.simpleMessage("متابعة عبر جوجل"),
        "loginWithPhone":
            MessageLookupByLibrary.simpleMessage("متابعة عبر الجوال"),
        "logout": MessageLookupByLibrary.simpleMessage("تسجيل خروج"),
        "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
            "هل أنت متأكد أنّك تريد الخروج؟"),
        "memberBalance": MessageLookupByLibrary.simpleMessage("الرصيد"),
        "memberLabelAdmin": MessageLookupByLibrary.simpleMessage("المسؤول"),
        "memberLabelYou": MessageLookupByLibrary.simpleMessage("أنت"),
        "members": MessageLookupByLibrary.simpleMessage("الاعضاء"),
        "membersCountLabel": m0,
        "membersTabTitle": MessageLookupByLibrary.simpleMessage("الأعضاء"),
        "nameRequired": MessageLookupByLibrary.simpleMessage("الاسم مطلوب"),
        "newCategoryHint": MessageLookupByLibrary.simpleMessage("فئة جديدة"),
        "newTransaction": MessageLookupByLibrary.simpleMessage("عملية جديدة"),
        "newsUpdatesSetting":
            MessageLookupByLibrary.simpleMessage("أخبار وتحديثات"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "noData": MessageLookupByLibrary.simpleMessage("لا توجد بيانات"),
        "noGroupsFound":
            MessageLookupByLibrary.simpleMessage("لم يتم اضافتك الى اي قروب"),
        "noMembersFound":
            MessageLookupByLibrary.simpleMessage("لا يوجد أعضاء."),
        "noReportData":
            MessageLookupByLibrary.simpleMessage("لا توجد بيانات لهذه الفترة."),
        "noTemplatesYet":
            MessageLookupByLibrary.simpleMessage("لا توجد قوالب بعد"),
        "noTransactions":
            MessageLookupByLibrary.simpleMessage("لا يوجد اي عمليه سابقة"),
        "noTransactionsYet":
            MessageLookupByLibrary.simpleMessage("No transactions yet."),
        "notificationsEnabled":
            MessageLookupByLibrary.simpleMessage("تفعيل الإشعارات"),
        "notificationsSection":
            MessageLookupByLibrary.simpleMessage("الإشعارات"),
        "onlyAdminsCanViewRequests": MessageLookupByLibrary.simpleMessage(
            "فقط المدير يمكنه رؤية والموافقة على طلبات الانضمام."),
        "or": MessageLookupByLibrary.simpleMessage("او"),
        "passwordHint": MessageLookupByLibrary.simpleMessage("كلمه المرور"),
        "payer": MessageLookupByLibrary.simpleMessage("من "),
        "pending": MessageLookupByLibrary.simpleMessage("Pending"),
        "pendingRequests":
            MessageLookupByLibrary.simpleMessage("الطلبات المعلقة"),
        "personalTab": MessageLookupByLibrary.simpleMessage("شخصي"),
        "personalTracker":
            MessageLookupByLibrary.simpleMessage("مصروفاتي الشخصية"),
        "phoneHint": MessageLookupByLibrary.simpleMessage("أدخل رقم هاتفك"),
        "phoneRequired":
            MessageLookupByLibrary.simpleMessage("رقم الهاتف مطلوب"),
        "pickFromGallery":
            MessageLookupByLibrary.simpleMessage("اختيار من المعرض"),
        "project": MessageLookupByLibrary.simpleMessage("إدارة مشروع"),
        "projectIsComing": MessageLookupByLibrary.simpleMessage(
            "اربط الحزام — شيء رهيب على وشك الانطلاق!"),
        "projectsTab": MessageLookupByLibrary.simpleMessage("مشاريع"),
        "rangeCustom": MessageLookupByLibrary.simpleMessage("مخصص"),
        "rangeMonth": MessageLookupByLibrary.simpleMessage("هذا الشهر"),
        "rangeToday": MessageLookupByLibrary.simpleMessage("اليوم"),
        "rangeWeek": MessageLookupByLibrary.simpleMessage("هذا الأسبوع"),
        "rangeYear": MessageLookupByLibrary.simpleMessage("هذا العام"),
        "received": MessageLookupByLibrary.simpleMessage("استلمت"),
        "receiver": MessageLookupByLibrary.simpleMessage("ل "),
        "reject": MessageLookupByLibrary.simpleMessage("رفض"),
        "rejectedSuccessfully":
            MessageLookupByLibrary.simpleMessage("تم رفض المستخدم بنجاح"),
        "rememberMe": MessageLookupByLibrary.simpleMessage("تذكرني"),
        "reportTypeExpense": MessageLookupByLibrary.simpleMessage("المصروفات"),
        "reportTypeIncome": MessageLookupByLibrary.simpleMessage("الإيرادات"),
        "reportTypeNet": MessageLookupByLibrary.simpleMessage("الصافي"),
        "reportsDateRangeLabel":
            MessageLookupByLibrary.simpleMessage("اختر فترة التاريخ"),
        "reportsLoading":
            MessageLookupByLibrary.simpleMessage("جارٍ تحميل التقرير…"),
        "reportsTab": MessageLookupByLibrary.simpleMessage("التقارير"),
        "reportsTitle": MessageLookupByLibrary.simpleMessage("التقارير"),
        "reportsTypeLabel": MessageLookupByLibrary.simpleMessage("عرض"),
        "requestApproved": MessageLookupByLibrary.simpleMessage("تمت الموافقة"),
        "requestChange": MessageLookupByLibrary.simpleMessage("طلب تعديل"),
        "requestDate": MessageLookupByLibrary.simpleMessage("تم الطلب في"),
        "requestRejected": MessageLookupByLibrary.simpleMessage("تم الرفض"),
        "requester": MessageLookupByLibrary.simpleMessage("طالب الانضمام"),
        "resendCode": MessageLookupByLibrary.simpleMessage("إعادة إرسال الرمز"),
        "resendIn": m1,
        "retry": MessageLookupByLibrary.simpleMessage("اعادة المحاولة"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("حفظ التغييرات"),
        "scanToJoin": MessageLookupByLibrary.simpleMessage(
            "يمكنهم مسح رمز QR أو إدخال هذا الرمز:"),
        "searchHint":
            MessageLookupByLibrary.simpleMessage("ابحث بالاسم أو الوصف"),
        "selectColor": MessageLookupByLibrary.simpleMessage("اختر اللون"),
        "selectIcon": MessageLookupByLibrary.simpleMessage("اختر الأيقونة"),
        "selectOrAddCategory": MessageLookupByLibrary.simpleMessage(
            "اختار التصنيف من بطائق التصنيفات او قم ب انشاء تصنيف جديد عن طريق كتابه الاسم ثم اضغط على +"),
        "sendCode": MessageLookupByLibrary.simpleMessage("أرسل الرمز"),
        "settingsTitle": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "shareGroupInfo": MessageLookupByLibrary.simpleMessage(
            "شارك هذه المجموعة مع الآخرين"),
        "sharing": MessageLookupByLibrary.simpleMessage("حساب مشترك / ديون"),
        "spent": MessageLookupByLibrary.simpleMessage("انفقت"),
        "spentThisMonth":
            MessageLookupByLibrary.simpleMessage("المصروفات هذا الشهر"),
        "splashTitle": MessageLookupByLibrary.simpleMessage(
            "كيف تريد استخدام المحاسبي؟\n(اختر كل ما ينطبق)"),
        "status": MessageLookupByLibrary.simpleMessage("الحالة"),
        "submit": MessageLookupByLibrary.simpleMessage("حفظ "),
        "summary": MessageLookupByLibrary.simpleMessage("الملخص"),
        "tableView": MessageLookupByLibrary.simpleMessage("Table View"),
        "takePhoto": MessageLookupByLibrary.simpleMessage("التقاط صورة"),
        "tapHere": MessageLookupByLibrary.simpleMessage("اضفط هنا"),
        "timelineView": MessageLookupByLibrary.simpleMessage("Timeline View"),
        "transactionApproved":
            MessageLookupByLibrary.simpleMessage("Transaction Approved"),
        "transactionCreated":
            MessageLookupByLibrary.simpleMessage("تم انشاء العملية"),
        "transactionDeleted":
            MessageLookupByLibrary.simpleMessage("تم حذف المعاملة"),
        "transactionUpdated":
            MessageLookupByLibrary.simpleMessage("تم تعديل المعاملة"),
        "transactions": MessageLookupByLibrary.simpleMessage("العمليات"),
        "transactionsTab": MessageLookupByLibrary.simpleMessage("المعاملات"),
        "updateProfile":
            MessageLookupByLibrary.simpleMessage("تحديث الملف الشخصي"),
        "updateProfilePrompt": MessageLookupByLibrary.simpleMessage(
            "لتتمكن من استخدام المجموعات والمشاريع، يرجى إضافة اسمك الكامل ورقم هاتفك حتى يتمكن الآخرون من العثور عليك."),
        "uploadFailed": MessageLookupByLibrary.simpleMessage("فشل رفع الملف"),
        "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
        "waitFor1Minute":
            MessageLookupByLibrary.simpleMessage("طلب رمز جديد خلال دقيقة!"),
        "yesDelete": MessageLookupByLibrary.simpleMessage("حذف")
      };
}
