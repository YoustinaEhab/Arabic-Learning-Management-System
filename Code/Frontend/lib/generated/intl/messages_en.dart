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

  static String m0(answer) => "Correct answer: ${answer}";

  static String m1(contentName) =>
      "Are you sure you want to delete ${contentName}?";

  static String m2(Content) => "${Content} deleted successfully";

  static String m3(error) => "Failed to load PDFs: ${error}";

  static String m4(error) => "Failed to load Quizzes: ${error}";

  static String m5(error) => "Error selecting file: ${error}";

  static String m6(error) => "Error generating quiz: ${error}";

  static String m7(count) => "Number of Questions: ${count}";

  static String m8(count) => "Questions: ${count}";

  static String m9(option) => "${option}";

  static String m10(question) => "${question}";

  static String m11(error) => "Error submitting quiz: ${error}";

  static String m12(time) => "${time}";

  static String m13(error) => "Error saving quiz: ${error}";

  static String m14(correct, total) => "${correct} out of ${total}";

  static String m15(percent) => "${percent}% completed";

  static String m16(taskDate) => "${taskDate}";

  static String m17(taskSubtitle) => "${taskSubtitle}";

  static String m18(taskTitle) => "${taskTitle}";

  static String m19(lesson) => "History Lesson ${lesson} PDF";

  static String m20(quizNum, qestionsNum) =>
      "History Quiz ${quizNum} - ${qestionsNum} Questions";

  static String m21(number) => "Option ${number}";

  static String m22(number) =>
      "Sample question ${number} about the PDF content?";

  static String m23(fileName) => "File: ${fileName}";

  static String m24(answer) => "Your answer: ${answer}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "AuthFailed": MessageLookupByLibrary.simpleMessage("Process failed"),
    "AuthSuccess": MessageLookupByLibrary.simpleMessage("Process successful"),
    "Home": MessageLookupByLibrary.simpleMessage("Home Page"),
    "averageScoreLabel": MessageLookupByLibrary.simpleMessage("Average Score"),
    "backToQuizzes": MessageLookupByLibrary.simpleMessage("Back to Quizzes"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "changeLanguage": MessageLookupByLibrary.simpleMessage("Change Language"),
    "chemistry": MessageLookupByLibrary.simpleMessage("Chemistry"),
    "chooseLangTitle": MessageLookupByLibrary.simpleMessage(
      "Choose A Language:",
    ),
    "chooseLanguage": MessageLookupByLibrary.simpleMessage("Choose Language"),
    "confirmPasswordHint": MessageLookupByLibrary.simpleMessage(
      "Re-enter new password",
    ),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "correctAnswer": m0,
    "deleteConfirmationCancle": MessageLookupByLibrary.simpleMessage("Cancel"),
    "deleteConfirmationDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteConfirmationError": MessageLookupByLibrary.simpleMessage(
      "An error occurred. Please try again.",
    ),
    "deleteConfirmationQuest": m1,
    "deleteConfirmationSuccess": m2,
    "deleteConfirmationTitle": MessageLookupByLibrary.simpleMessage("Delete"),
    "downloadingText": MessageLookupByLibrary.simpleMessage("Downloading..."),
    "emailHint": MessageLookupByLibrary.simpleMessage("Enter Email"),
    "emailInvalid": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "existingPdfTitle": MessageLookupByLibrary.simpleMessage("Existing PDF"),
    "explore": MessageLookupByLibrary.simpleMessage("Explore"),
    "exploreScreenTitle": MessageLookupByLibrary.simpleMessage(
      "Explore a World of Knowledge",
    ),
    "exportQuizButton": MessageLookupByLibrary.simpleMessage("Export Quiz"),
    "failedDownloadingText": MessageLookupByLibrary.simpleMessage(
      "Failed Downloading, Please Try Again",
    ),
    "failedToLoadPDFs": m3,
    "failedToLoadQuizzes": m4,
    "featureComingSoon": MessageLookupByLibrary.simpleMessage(
      "This feature is coming soon",
    ),
    "fileError": m5,
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "fullNameHint": MessageLookupByLibrary.simpleMessage("Enter Full Name"),
    "fullNameLabel": MessageLookupByLibrary.simpleMessage("Full Name"),
    "generateButton": MessageLookupByLibrary.simpleMessage("Generate Quiz"),
    "generateQuizTitle": MessageLookupByLibrary.simpleMessage(
      "Generate Quiz from PDF",
    ),
    "generatedQuestionsTitle": MessageLookupByLibrary.simpleMessage(
      "Generated Questions",
    ),
    "generatingButton": MessageLookupByLibrary.simpleMessage("Generating..."),
    "generationError": m6,
    "geography": MessageLookupByLibrary.simpleMessage("Geography"),
    "highestScoreLabel": MessageLookupByLibrary.simpleMessage("Highest Score"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "logOut": MessageLookupByLibrary.simpleMessage("Log Out"),
    "lowestScoreLabel": MessageLookupByLibrary.simpleMessage("Lowest Score"),
    "materialsDownloadTitle": MessageLookupByLibrary.simpleMessage(
      "Download\nMaterials",
    ),
    "materialsSectionTitle": MessageLookupByLibrary.simpleMessage("Materials"),
    "mathematics": MessageLookupByLibrary.simpleMessage("Mathematics"),
    "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "navDashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "navHome": MessageLookupByLibrary.simpleMessage("Home"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Profile"),
    "navSubjects": MessageLookupByLibrary.simpleMessage("Subjects"),
    "newPasswordHint": MessageLookupByLibrary.simpleMessage(
      "Enter new password",
    ),
    "newPasswordLabel": MessageLookupByLibrary.simpleMessage("New Password"),
    "noFileSelected": MessageLookupByLibrary.simpleMessage("No file selected"),
    "noMaterialsText": MessageLookupByLibrary.simpleMessage(
      "No materials uploaded yet",
    ),
    "noQuizResults": MessageLookupByLibrary.simpleMessage(
      "No quiz results available yet",
    ),
    "noQuizzesText": MessageLookupByLibrary.simpleMessage(
      "No quizzes created yet",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage(
      "No results found. Try a different search.",
    ),
    "notAnswered": MessageLookupByLibrary.simpleMessage("Not answered"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "numberOfQuestions": m7,
    "onBoardingSubTitle1": MessageLookupByLibrary.simpleMessage(
      "Browse courses, track your progress, and achieve your goals all in one place",
    ),
    "onBoardingSubTitle2": MessageLookupByLibrary.simpleMessage(
      "Discover courses tailored to your interests and level",
    ),
    "onBoardingSubTitle3": MessageLookupByLibrary.simpleMessage(
      "Monitor your achievements, complete lessons, and unlock new horizons",
    ),
    "onBoardingTitle1": MessageLookupByLibrary.simpleMessage("Start Growing"),
    "onBoardingTitle2": MessageLookupByLibrary.simpleMessage("Learn Your Way"),
    "onBoardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Track Your Progress",
    ),
    "orSignInUsing": MessageLookupByLibrary.simpleMessage("or Sign in using"),
    "orSignUpUsing": MessageLookupByLibrary.simpleMessage("or Sign up using"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("Enter Password"),
    "passwordInvalid": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters, include a number and a letter",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordResetFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to reset password.",
    ),
    "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Password has been reset successfully!",
    ),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "physics": MessageLookupByLibrary.simpleMessage("Physics"),
    "profileTitle": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileUpdated": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully.",
    ),
    "questionReview": MessageLookupByLibrary.simpleMessage("Question Review"),
    "questionsCount": m8,
    "quizConfigTitle": MessageLookupByLibrary.simpleMessage(
      "Quiz Configuration",
    ),
    "quizExportedMessage": MessageLookupByLibrary.simpleMessage(
      "Quiz exported as PDF",
    ),
    "quizNameDropMenu": MessageLookupByLibrary.simpleMessage("Select Quiz"),
    "quizOption": m9,
    "quizQuestion": m10,
    "quizResultsSubtitle": MessageLookupByLibrary.simpleMessage(
      "View Students Performance",
    ),
    "quizResultsTitle": MessageLookupByLibrary.simpleMessage("Quiz Results"),
    "quizSavedMessage": MessageLookupByLibrary.simpleMessage(
      "Quiz saved and Uploaded",
    ),
    "quizScoresTitle": MessageLookupByLibrary.simpleMessage("Quiz Results"),
    "quizSubmitError": m11,
    "quizTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Quiz Time (minutes):",
    ),
    "quizTimeRemaining": m12,
    "quizzesSectionTitle": MessageLookupByLibrary.simpleMessage("Quizzes"),
    "recommendedYoutubeResources": MessageLookupByLibrary.simpleMessage(
      "Recommended YouTube Resources",
    ),
    "requiredField": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "resetButton": MessageLookupByLibrary.simpleMessage("Reset"),
    "saveButton": MessageLookupByLibrary.simpleMessage("Save"),
    "saveQuizButton": MessageLookupByLibrary.simpleMessage(
      "Save and Upload Quiz",
    ),
    "saveQuizError": m13,
    "scoreText": m14,
    "searchForATopic": MessageLookupByLibrary.simpleMessage(
      "Search for a topic...",
    ),
    "selectFromUploaded": MessageLookupByLibrary.simpleMessage(
      "Select from Uploaded",
    ),
    "selectNewPdf": MessageLookupByLibrary.simpleMessage("Select New PDF"),
    "selectPdfButton": MessageLookupByLibrary.simpleMessage("Select PDF File"),
    "selectPdfSource": MessageLookupByLibrary.simpleMessage(
      "Select PDF Source",
    ),
    "selectPdfTitle": MessageLookupByLibrary.simpleMessage("Select PDF"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "signInAuthFailed": MessageLookupByLibrary.simpleMessage(
      "Authentication failed. Please check your credentials.",
    ),
    "signInButton": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signInNoAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "signInSignUpLink": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signInWelcome": MessageLookupByLibrary.simpleMessage("Welcome back"),
    "signUpAlreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "signUpAuthFailed": MessageLookupByLibrary.simpleMessage(
      "Authentication failed. Please try again.",
    ),
    "signUpButton": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signUpSignInLink": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signUpTitle": MessageLookupByLibrary.simpleMessage("Get Started"),
    "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "startQuizCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "startQuizConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "startQuizMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to start this quiz?",
    ),
    "startQuizTitle": MessageLookupByLibrary.simpleMessage("Start Quiz"),
    "student": MessageLookupByLibrary.simpleMessage("Student"),
    "studentCompleted": m15,
    "studentHomeAppBarTitle": MessageLookupByLibrary.simpleMessage(
      "Arabic LMS",
    ),
    "studentHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Welcome, Student!",
    ),
    "studentOverallProgress": MessageLookupByLibrary.simpleMessage(
      "Overall Progress",
    ),
    "studentProgressTitle": MessageLookupByLibrary.simpleMessage(
      "Your Learning Progress",
    ),
    "studentRole": MessageLookupByLibrary.simpleMessage("Student"),
    "studentScoresLabel": MessageLookupByLibrary.simpleMessage(
      "Student Scores:",
    ),
    "studentTaskDate": m16,
    "studentTaskSubtitle": m17,
    "studentTaskTitle": m18,
    "studentUpcomingTasks": MessageLookupByLibrary.simpleMessage(
      "Upcoming Tasks",
    ),
    "subjectDetailTitle": MessageLookupByLibrary.simpleMessage("History"),
    "subjectLabel": MessageLookupByLibrary.simpleMessage("Quiz Title"),
    "subjectsTitle": MessageLookupByLibrary.simpleMessage("Subjects"),
    "submitQuiz": MessageLookupByLibrary.simpleMessage("Submit Quiz"),
    "submittingQuiz": MessageLookupByLibrary.simpleMessage("Submitting..."),
    "successDownloadingText": MessageLookupByLibrary.simpleMessage(
      "PDF saved to Downloads folder!",
    ),
    "tapToUpload": MessageLookupByLibrary.simpleMessage("Tap to upload a file"),
    "teacher": MessageLookupByLibrary.simpleMessage("Teacher"),
    "teacherHomeGenerateButton": MessageLookupByLibrary.simpleMessage(
      "Generate Questions",
    ),
    "teacherHomeMaterial": m19,
    "teacherHomeQuiz": m20,
    "teacherHomeSubtitle1": MessageLookupByLibrary.simpleMessage(
      "Uploaded Materials",
    ),
    "teacherHomeSubtitle2": MessageLookupByLibrary.simpleMessage(
      "Generated Quizzes",
    ),
    "teacherHomeTitle": MessageLookupByLibrary.simpleMessage(
      "Welcome, Teacher!",
    ),
    "teacherHomeUploadButton": MessageLookupByLibrary.simpleMessage(
      "Upload Materials",
    ),
    "teacherHomeViewButton": MessageLookupByLibrary.simpleMessage(
      "View \n Reports",
    ),
    "teacherNoMaterials": MessageLookupByLibrary.simpleMessage(
      "No materials found",
    ),
    "teacherRole": MessageLookupByLibrary.simpleMessage("Teacher"),
    "tempOptionText": m21,
    "tempSampleQuestion": m22,
    "topicLabel": MessageLookupByLibrary.simpleMessage("Topic"),
    "totalAttemptsLabel": MessageLookupByLibrary.simpleMessage(
      "Total Attempts",
    ),
    "untitledMaterial": MessageLookupByLibrary.simpleMessage(
      "Untitled Material",
    ),
    "untitledPdf": MessageLookupByLibrary.simpleMessage("Untitled PDF"),
    "untitledQuiz": MessageLookupByLibrary.simpleMessage("Untitled Quiz"),
    "updateFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to update profile.",
    ),
    "uploadError": MessageLookupByLibrary.simpleMessage(
      "Please upload a file and fill all fields.",
    ),
    "uploadFileDescription": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "uploadFileTag": MessageLookupByLibrary.simpleMessage("Add a tag"),
    "uploadFileTagsTitle": MessageLookupByLibrary.simpleMessage("Tags"),
    "uploadFileText": m23,
    "uploadFileTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "uploadMaterial": MessageLookupByLibrary.simpleMessage("Upload Material"),
    "uploadMaterialButton": MessageLookupByLibrary.simpleMessage(
      "Upload Material",
    ),
    "uploadPdfTitle": MessageLookupByLibrary.simpleMessage("Upload PDF"),
    "uploadSuccess": MessageLookupByLibrary.simpleMessage(
      "Material uploaded successfully!",
    ),
    "useExistingPdf": MessageLookupByLibrary.simpleMessage("Use Existing PDF"),
    "userType": MessageLookupByLibrary.simpleMessage("User Type"),
    "userTypeTitle": MessageLookupByLibrary.simpleMessage("Select Your Role"),
    "watchButton": MessageLookupByLibrary.simpleMessage("Watch"),
    "watchOnYoutube": MessageLookupByLibrary.simpleMessage("Watch on YouTube"),
    "welcomeSignInButton": MessageLookupByLibrary.simpleMessage("Sign in"),
    "welcomeSignUpButton": MessageLookupByLibrary.simpleMessage("Sign up"),
    "welcomeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter personal details to your user account",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage("Welcome!\n"),
    "yourAnswer": m24,
    "yourScore": MessageLookupByLibrary.simpleMessage("Your Score"),
  };
}
