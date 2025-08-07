// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: '# member', other: '# members')}";

  static String m1(seconds) => "Resend in";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountSection": MessageLookupByLibrary.simpleMessage("Account"),
        "alreadyHaveAPendingRequest": MessageLookupByLibrary.simpleMessage(
            "You already have a pending change request"),
        "alreadyHaveAccount":
            MessageLookupByLibrary.simpleMessage("I already have an account"),
        "amount": MessageLookupByLibrary.simpleMessage("amount"),
        "amountHint": MessageLookupByLibrary.simpleMessage("Enter amount"),
        "appTitle": MessageLookupByLibrary.simpleMessage("My Accounting App"),
        "appearanceSection": MessageLookupByLibrary.simpleMessage("Appearance"),
        "apply": MessageLookupByLibrary.simpleMessage("Apply"),
        "approve": MessageLookupByLibrary.simpleMessage("Approve"),
        "approveTransaction":
            MessageLookupByLibrary.simpleMessage("Approve Transaction"),
        "approved": MessageLookupByLibrary.simpleMessage("Approved"),
        "approvedSuccessfully":
            MessageLookupByLibrary.simpleMessage("User approved successfully"),
        "attachFile": MessageLookupByLibrary.simpleMessage("Attach file"),
        "balancePerMember":
            MessageLookupByLibrary.simpleMessage("Balance per member"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotDeleteCategoryWithTxns": MessageLookupByLibrary.simpleMessage(
            "Cannot delete a category that has transactions."),
        "changeEmail": MessageLookupByLibrary.simpleMessage("Change Email"),
        "changeHistory": MessageLookupByLibrary.simpleMessage("Change History"),
        "changeName": MessageLookupByLibrary.simpleMessage("Change Name"),
        "changePhone": MessageLookupByLibrary.simpleMessage("Change Phone"),
        "changeRequestSentForApproval": MessageLookupByLibrary.simpleMessage(
            "Change request sent for approval"),
        "codeHint":
            MessageLookupByLibrary.simpleMessage("Enter verification code"),
        "confirmApproveTransaction":
            MessageLookupByLibrary.simpleMessage("ConfirmApprove Transaction"),
        "confirmDeleteCategory": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this category?"),
        "confirmDeleteContent": MessageLookupByLibrary.simpleMessage(
            "This action can’t be undone."),
        "confirmDeleteTitle":
            MessageLookupByLibrary.simpleMessage("Delete this transaction?"),
        "copyJoinCode": MessageLookupByLibrary.simpleMessage("Copy Join Code"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createGroup":
            MessageLookupByLibrary.simpleMessage("Create a new Group"),
        "dailyReminderSetting":
            MessageLookupByLibrary.simpleMessage("Daily Reminder"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "date": MessageLookupByLibrary.simpleMessage("date"),
        "debtsReminderSetting":
            MessageLookupByLibrary.simpleMessage("Debts Reminders"),
        "deleteCategory":
            MessageLookupByLibrary.simpleMessage("Delete Category"),
        "deleteTransaction":
            MessageLookupByLibrary.simpleMessage("Delete Transaction"),
        "description": MessageLookupByLibrary.simpleMessage("description"),
        "descriptionHint":
            MessageLookupByLibrary.simpleMessage("Enter description"),
        "descriptionOptional":
            MessageLookupByLibrary.simpleMessage("Description (optional)"),
        "editCategory": MessageLookupByLibrary.simpleMessage("Edit Category"),
        "editTransaction":
            MessageLookupByLibrary.simpleMessage("Edit Transaction"),
        "enterAmount":
            MessageLookupByLibrary.simpleMessage("Please enter an amount"),
        "enterDescription":
            MessageLookupByLibrary.simpleMessage("Please enter a description"),
        "enterJoinCode":
            MessageLookupByLibrary.simpleMessage("Enter group code manually"),
        "errorCreatingGroup": MessageLookupByLibrary.simpleMessage(
            "Error Creating the Group try later"),
        "errorJoiningGroup":
            MessageLookupByLibrary.simpleMessage("Failed to join the group"),
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Error Loading the Data"),
        "expense": MessageLookupByLibrary.simpleMessage("Expense"),
        "fieldCategoryName":
            MessageLookupByLibrary.simpleMessage("Category Name"),
        "fieldRequired":
            MessageLookupByLibrary.simpleMessage("This Field is required"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "fromTo": MessageLookupByLibrary.simpleMessage("From To"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full name"),
        "fullNameHint":
            MessageLookupByLibrary.simpleMessage("Enter your full name"),
        "getexcel": MessageLookupByLibrary.simpleMessage("Download"),
        "groupDetails":
            MessageLookupByLibrary.simpleMessage("Group Transactions"),
        "groupList": MessageLookupByLibrary.simpleMessage("Groups"),
        "groupName": MessageLookupByLibrary.simpleMessage("Group name"),
        "groupsTab": MessageLookupByLibrary.simpleMessage("Groups"),
        "income": MessageLookupByLibrary.simpleMessage("Income"),
        "incomeThisMonth":
            MessageLookupByLibrary.simpleMessage("Income this month"),
        "invalidNumber":
            MessageLookupByLibrary.simpleMessage("Invalid number value"),
        "invitee": MessageLookupByLibrary.simpleMessage("Invitee"),
        "joinCode": MessageLookupByLibrary.simpleMessage("Join"),
        "joinNewGroup": MessageLookupByLibrary.simpleMessage("Join"),
        "joinRequestSent": MessageLookupByLibrary.simpleMessage(
            "Join request sent successfully"),
        "joinRequestsTab":
            MessageLookupByLibrary.simpleMessage("Join Requests"),
        "languageArabic": MessageLookupByLibrary.simpleMessage("Arabic"),
        "languageEnglish": MessageLookupByLibrary.simpleMessage("English"),
        "languageSection": MessageLookupByLibrary.simpleMessage("Language"),
        "lastUpdated": MessageLookupByLibrary.simpleMessage("Last Updated"),
        "login": MessageLookupByLibrary.simpleMessage("Log in "),
        "loginWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome back! Please choose a login method"),
        "loginWithApple":
            MessageLookupByLibrary.simpleMessage("Sign in with APPLE"),
        "loginWithEmail":
            MessageLookupByLibrary.simpleMessage("Continue with Email"),
        "loginWithGoogle":
            MessageLookupByLibrary.simpleMessage("Continue with Google"),
        "loginWithPhone":
            MessageLookupByLibrary.simpleMessage("Continue with Phone"),
        "logout": MessageLookupByLibrary.simpleMessage("Log Out"),
        "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to sign out?"),
        "memberBalance": MessageLookupByLibrary.simpleMessage("Balance"),
        "memberLabelAdmin": MessageLookupByLibrary.simpleMessage("Admin"),
        "memberLabelYou": MessageLookupByLibrary.simpleMessage("You"),
        "members": MessageLookupByLibrary.simpleMessage("Members"),
        "membersCountLabel": m0,
        "membersTabTitle": MessageLookupByLibrary.simpleMessage("Members"),
        "nameRequired":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "newCategoryHint": MessageLookupByLibrary.simpleMessage("New category"),
        "newTransaction":
            MessageLookupByLibrary.simpleMessage("New Transaction"),
        "newsUpdatesSetting":
            MessageLookupByLibrary.simpleMessage("News & Updates"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "noData": MessageLookupByLibrary.simpleMessage("No data available"),
        "noGroupsFound":
            MessageLookupByLibrary.simpleMessage("No groups found!"),
        "noMembersFound":
            MessageLookupByLibrary.simpleMessage("No members found."),
        "noReportData":
            MessageLookupByLibrary.simpleMessage("No data for this period."),
        "noTemplatesYet":
            MessageLookupByLibrary.simpleMessage("No templates yet"),
        "noTransactions":
            MessageLookupByLibrary.simpleMessage("No available data"),
        "noTransactionsYet":
            MessageLookupByLibrary.simpleMessage("No transactions yet."),
        "notificationsEnabled":
            MessageLookupByLibrary.simpleMessage("Enable Notifications"),
        "notificationsSection":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "onlyAdminsCanViewRequests": MessageLookupByLibrary.simpleMessage(
            "Only the admin can view and approve join requests."),
        "or": MessageLookupByLibrary.simpleMessage("or"),
        "passwordHint": MessageLookupByLibrary.simpleMessage("Enter Password"),
        "payer": MessageLookupByLibrary.simpleMessage("Payer"),
        "pending": MessageLookupByLibrary.simpleMessage("Pending"),
        "pendingRequests":
            MessageLookupByLibrary.simpleMessage("Pending Requests"),
        "personalTab": MessageLookupByLibrary.simpleMessage("Personal"),
        "personalTracker": MessageLookupByLibrary.simpleMessage(
            "To Track My Personal Expenses"),
        "phoneHint":
            MessageLookupByLibrary.simpleMessage("Enter your phone number"),
        "phoneRequired":
            MessageLookupByLibrary.simpleMessage("Phone number is required"),
        "pickFromGallery":
            MessageLookupByLibrary.simpleMessage("Pick from gallery"),
        "project": MessageLookupByLibrary.simpleMessage(
            "Project Financial Management"),
        "projectIsComing": MessageLookupByLibrary.simpleMessage(
            "Buckle up — something epic is about to drop!"),
        "projectsTab": MessageLookupByLibrary.simpleMessage("Projects"),
        "rangeCustom": MessageLookupByLibrary.simpleMessage("Custom"),
        "rangeMonth": MessageLookupByLibrary.simpleMessage("Month"),
        "rangeToday": MessageLookupByLibrary.simpleMessage("Today"),
        "rangeWeek": MessageLookupByLibrary.simpleMessage("Week"),
        "rangeYear": MessageLookupByLibrary.simpleMessage("Year"),
        "received": MessageLookupByLibrary.simpleMessage("Received"),
        "receiver": MessageLookupByLibrary.simpleMessage("Receiver"),
        "reject": MessageLookupByLibrary.simpleMessage("Reject"),
        "rejectedSuccessfully":
            MessageLookupByLibrary.simpleMessage("User rejected successfully"),
        "rememberMe": MessageLookupByLibrary.simpleMessage("Remember me"),
        "reportTypeExpense": MessageLookupByLibrary.simpleMessage("Expenses"),
        "reportTypeIncome": MessageLookupByLibrary.simpleMessage("Income"),
        "reportTypeNet": MessageLookupByLibrary.simpleMessage("Net"),
        "reportsDateRangeLabel":
            MessageLookupByLibrary.simpleMessage("Select date range"),
        "reportsLoading":
            MessageLookupByLibrary.simpleMessage("Loading report…"),
        "reportsTab": MessageLookupByLibrary.simpleMessage("Reports"),
        "reportsTitle": MessageLookupByLibrary.simpleMessage("Reports"),
        "reportsTypeLabel": MessageLookupByLibrary.simpleMessage("View"),
        "requestApproved":
            MessageLookupByLibrary.simpleMessage("Request Approved!"),
        "requestChange": MessageLookupByLibrary.simpleMessage("Request Change"),
        "requestDate": MessageLookupByLibrary.simpleMessage("Requested on"),
        "requestRejected":
            MessageLookupByLibrary.simpleMessage("Request Rejected!"),
        "requester": MessageLookupByLibrary.simpleMessage("Requester"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend Code"),
        "resendIn": m1,
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
        "scanToJoin": MessageLookupByLibrary.simpleMessage(
            "They can scan the QR code or enter this code:"),
        "searchHint":
            MessageLookupByLibrary.simpleMessage("Search name or description"),
        "selectColor": MessageLookupByLibrary.simpleMessage("Select Color"),
        "selectIcon": MessageLookupByLibrary.simpleMessage("Select Icon"),
        "selectOrAddCategory": MessageLookupByLibrary.simpleMessage(
            "You must select a category from the chips below, or add a new category by typing its name and tap on the + button"),
        "sendCode": MessageLookupByLibrary.simpleMessage("Send Code"),
        "settingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
        "shareGroupInfo": MessageLookupByLibrary.simpleMessage(
            "Share this group with others"),
        "sharing":
            MessageLookupByLibrary.simpleMessage("Shared Accounts/Track Debts"),
        "spent": MessageLookupByLibrary.simpleMessage("Spent"),
        "spentThisMonth":
            MessageLookupByLibrary.simpleMessage("Spent this month"),
        "splashTitle": MessageLookupByLibrary.simpleMessage(
            "How do you want to use MyAccounting?\n(select all that apply)"),
        "status": MessageLookupByLibrary.simpleMessage("status"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit "),
        "summary": MessageLookupByLibrary.simpleMessage("Summary"),
        "tableView": MessageLookupByLibrary.simpleMessage("Table View"),
        "takePhoto": MessageLookupByLibrary.simpleMessage("Take a photo"),
        "tapHere": MessageLookupByLibrary.simpleMessage("Tap Here"),
        "timelineView": MessageLookupByLibrary.simpleMessage("Timeline View"),
        "transactionApproved":
            MessageLookupByLibrary.simpleMessage("Transaction Approved"),
        "transactionCreated":
            MessageLookupByLibrary.simpleMessage("Transaction Created"),
        "transactionDeleted":
            MessageLookupByLibrary.simpleMessage("Transaction deleted"),
        "transactionUpdated":
            MessageLookupByLibrary.simpleMessage("Transaction updated"),
        "transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
        "transactionsTab": MessageLookupByLibrary.simpleMessage("Transactions"),
        "updateProfile": MessageLookupByLibrary.simpleMessage("Update Profile"),
        "updateProfilePrompt": MessageLookupByLibrary.simpleMessage(
            "To use Groups & Projects, please add your full name and phone number so others can find you."),
        "uploadFailed":
            MessageLookupByLibrary.simpleMessage("File upload failed"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "waitFor1Minute":
            MessageLookupByLibrary.simpleMessage("new code in a minute"),
        "yesDelete": MessageLookupByLibrary.simpleMessage("Delete")
      };
}
