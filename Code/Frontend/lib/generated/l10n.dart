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
    final name =
        (locale.countryCode?.isEmpty ?? false)
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

  /// `Choose Language`
  String get chooseLanguage {
    return Intl.message(
      'Choose Language',
      name: 'chooseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Start Growing`
  String get onBoardingTitle1 {
    return Intl.message(
      'Start Growing',
      name: 'onBoardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Browse courses, track your progress, and achieve your goals all in one place`
  String get onBoardingSubTitle1 {
    return Intl.message(
      'Browse courses, track your progress, and achieve your goals all in one place',
      name: 'onBoardingSubTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Learn Your Way`
  String get onBoardingTitle2 {
    return Intl.message(
      'Learn Your Way',
      name: 'onBoardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Discover courses tailored to your interests and level`
  String get onBoardingSubTitle2 {
    return Intl.message(
      'Discover courses tailored to your interests and level',
      name: 'onBoardingSubTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Track Your Progress`
  String get onBoardingTitle3 {
    return Intl.message(
      'Track Your Progress',
      name: 'onBoardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Monitor your achievements, complete lessons, and unlock new horizons`
  String get onBoardingSubTitle3 {
    return Intl.message(
      'Monitor your achievements, complete lessons, and unlock new horizons',
      name: 'onBoardingSubTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Home Page`
  String get Home {
    return Intl.message('Home Page', name: 'Home', desc: '', args: []);
  }

  /// `Choose A Language:`
  String get chooseLangTitle {
    return Intl.message(
      'Choose A Language:',
      name: 'chooseLangTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, Teacher!`
  String get teacherHomeTitle {
    return Intl.message(
      'Welcome, Teacher!',
      name: 'teacherHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded Materials`
  String get teacherHomeSubtitle1 {
    return Intl.message(
      'Uploaded Materials',
      name: 'teacherHomeSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Generated Quizzes`
  String get teacherHomeSubtitle2 {
    return Intl.message(
      'Generated Quizzes',
      name: 'teacherHomeSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `History Lesson {lesson} PDF`
  String teacherHomeMaterial(Object lesson) {
    return Intl.message(
      'History Lesson $lesson PDF',
      name: 'teacherHomeMaterial',
      desc: '',
      args: [lesson],
    );
  }

  /// `History Quiz {quizNum} - {qestionsNum} Questions`
  String teacherHomeQuiz(Object quizNum, Object qestionsNum) {
    return Intl.message(
      'History Quiz $quizNum - $qestionsNum Questions',
      name: 'teacherHomeQuiz',
      desc: '',
      args: [quizNum, qestionsNum],
    );
  }

  /// `Upload Materials`
  String get teacherHomeUploadButton {
    return Intl.message(
      'Upload Materials',
      name: 'teacherHomeUploadButton',
      desc: '',
      args: [],
    );
  }

  /// `Generate Questions`
  String get teacherHomeGenerateButton {
    return Intl.message(
      'Generate Questions',
      name: 'teacherHomeGenerateButton',
      desc: '',
      args: [],
    );
  }

  /// `View \n Reports`
  String get teacherHomeViewButton {
    return Intl.message(
      'View \n Reports',
      name: 'teacherHomeViewButton',
      desc: '',
      args: [],
    );
  }

  /// `No materials found`
  String get teacherNoMaterials {
    return Intl.message(
      'No materials found',
      name: 'teacherNoMaterials',
      desc: '',
      args: [],
    );
  }

  /// `Upload Material`
  String get uploadMaterial {
    return Intl.message(
      'Upload Material',
      name: 'uploadMaterial',
      desc: '',
      args: [],
    );
  }

  /// `Tap to upload a file`
  String get tapToUpload {
    return Intl.message(
      'Tap to upload a file',
      name: 'tapToUpload',
      desc: '',
      args: [],
    );
  }

  /// `File: {fileName}`
  String uploadFileText(Object fileName) {
    return Intl.message(
      'File: $fileName',
      name: 'uploadFileText',
      desc: '',
      args: [fileName],
    );
  }

  /// `Title`
  String get uploadFileTitle {
    return Intl.message('Title', name: 'uploadFileTitle', desc: '', args: []);
  }

  /// `Description`
  String get uploadFileDescription {
    return Intl.message(
      'Description',
      name: 'uploadFileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get uploadFileTagsTitle {
    return Intl.message(
      'Tags',
      name: 'uploadFileTagsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add a tag`
  String get uploadFileTag {
    return Intl.message('Add a tag', name: 'uploadFileTag', desc: '', args: []);
  }

  /// `Upload Material`
  String get uploadMaterialButton {
    return Intl.message(
      'Upload Material',
      name: 'uploadMaterialButton',
      desc: '',
      args: [],
    );
  }

  /// `Material uploaded successfully!`
  String get uploadSuccess {
    return Intl.message(
      'Material uploaded successfully!',
      name: 'uploadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a file and fill all fields.`
  String get uploadError {
    return Intl.message(
      'Please upload a file and fill all fields.',
      name: 'uploadError',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, Student!`
  String get studentHomeTitle {
    return Intl.message(
      'Welcome, Student!',
      name: 'studentHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Arabic LMS`
  String get studentHomeAppBarTitle {
    return Intl.message(
      'Arabic LMS',
      name: 'studentHomeAppBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Learning Progress`
  String get studentProgressTitle {
    return Intl.message(
      'Your Learning Progress',
      name: 'studentProgressTitle',
      desc: '',
      args: [],
    );
  }

  /// `Overall Progress`
  String get studentOverallProgress {
    return Intl.message(
      'Overall Progress',
      name: 'studentOverallProgress',
      desc: '',
      args: [],
    );
  }

  /// `{percent}% completed`
  String studentCompleted(Object percent) {
    return Intl.message(
      '$percent% completed',
      name: 'studentCompleted',
      desc: '',
      args: [percent],
    );
  }

  /// `Upcoming Tasks`
  String get studentUpcomingTasks {
    return Intl.message(
      'Upcoming Tasks',
      name: 'studentUpcomingTasks',
      desc: '',
      args: [],
    );
  }

  /// `{taskTitle}`
  String studentTaskTitle(Object taskTitle) {
    return Intl.message(
      '$taskTitle',
      name: 'studentTaskTitle',
      desc: '',
      args: [taskTitle],
    );
  }

  /// `{taskSubtitle}`
  String studentTaskSubtitle(Object taskSubtitle) {
    return Intl.message(
      '$taskSubtitle',
      name: 'studentTaskSubtitle',
      desc: '',
      args: [taskSubtitle],
    );
  }

  /// `{taskDate}`
  String studentTaskDate(Object taskDate) {
    return Intl.message(
      '$taskDate',
      name: 'studentTaskDate',
      desc: '',
      args: [taskDate],
    );
  }

  /// `Select Your Role`
  String get userTypeTitle {
    return Intl.message(
      'Select Your Role',
      name: 'userTypeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacherRole {
    return Intl.message('Teacher', name: 'teacherRole', desc: '', args: []);
  }

  /// `Student`
  String get studentRole {
    return Intl.message('Student', name: 'studentRole', desc: '', args: []);
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Generate Quiz from PDF`
  String get generateQuizTitle {
    return Intl.message(
      'Generate Quiz from PDF',
      name: 'generateQuizTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload PDF`
  String get uploadPdfTitle {
    return Intl.message(
      'Upload PDF',
      name: 'uploadPdfTitle',
      desc: '',
      args: [],
    );
  }

  /// `No file selected`
  String get noFileSelected {
    return Intl.message(
      'No file selected',
      name: 'noFileSelected',
      desc: '',
      args: [],
    );
  }

  /// `Select PDF File`
  String get selectPdfButton {
    return Intl.message(
      'Select PDF File',
      name: 'selectPdfButton',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Configuration`
  String get quizConfigTitle {
    return Intl.message(
      'Quiz Configuration',
      name: 'quizConfigTitle',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Title`
  String get subjectLabel {
    return Intl.message('Quiz Title', name: 'subjectLabel', desc: '', args: []);
  }

  /// `Number of Questions: {count}`
  String numberOfQuestions(Object count) {
    return Intl.message(
      'Number of Questions: $count',
      name: 'numberOfQuestions',
      desc: '',
      args: [count],
    );
  }

  /// `Generate Quiz`
  String get generateButton {
    return Intl.message(
      'Generate Quiz',
      name: 'generateButton',
      desc: '',
      args: [],
    );
  }

  /// `Generating...`
  String get generatingButton {
    return Intl.message(
      'Generating...',
      name: 'generatingButton',
      desc: '',
      args: [],
    );
  }

  /// `Generated Questions`
  String get generatedQuestionsTitle {
    return Intl.message(
      'Generated Questions',
      name: 'generatedQuestionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save and Upload Quiz`
  String get saveQuizButton {
    return Intl.message(
      'Save and Upload Quiz',
      name: 'saveQuizButton',
      desc: '',
      args: [],
    );
  }

  /// `Export Quiz`
  String get exportQuizButton {
    return Intl.message(
      'Export Quiz',
      name: 'exportQuizButton',
      desc: '',
      args: [],
    );
  }

  /// `Quiz saved and Uploaded`
  String get quizSavedMessage {
    return Intl.message(
      'Quiz saved and Uploaded',
      name: 'quizSavedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Quiz exported as PDF`
  String get quizExportedMessage {
    return Intl.message(
      'Quiz exported as PDF',
      name: 'quizExportedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error selecting file: {error}`
  String fileError(Object error) {
    return Intl.message(
      'Error selecting file: $error',
      name: 'fileError',
      desc: '',
      args: [error],
    );
  }

  /// `Error generating quiz: {error}`
  String generationError(Object error) {
    return Intl.message(
      'Error generating quiz: $error',
      name: 'generationError',
      desc: '',
      args: [error],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message('Profile', name: 'profileTitle', desc: '', args: []);
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message('Log Out', name: 'logOut', desc: '', args: []);
  }

  /// `Process failed`
  String get AuthFailed {
    return Intl.message(
      'Process failed',
      name: 'AuthFailed',
      desc: '',
      args: [],
    );
  }

  /// `Process successful`
  String get AuthSuccess {
    return Intl.message(
      'Process successful',
      name: 'AuthSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Sample question {number} about the PDF content?`
  String tempSampleQuestion(Object number) {
    return Intl.message(
      'Sample question $number about the PDF content?',
      name: 'tempSampleQuestion',
      desc: '',
      args: [number],
    );
  }

  /// `Option {number}`
  String tempOptionText(Object number) {
    return Intl.message(
      'Option $number',
      name: 'tempOptionText',
      desc: '',
      args: [number],
    );
  }

  /// `Subjects`
  String get subjectsTitle {
    return Intl.message('Subjects', name: 'subjectsTitle', desc: '', args: []);
  }

  /// `Mathematics`
  String get mathematics {
    return Intl.message('Mathematics', name: 'mathematics', desc: '', args: []);
  }

  /// `Chemistry`
  String get chemistry {
    return Intl.message('Chemistry', name: 'chemistry', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Geography`
  String get geography {
    return Intl.message('Geography', name: 'geography', desc: '', args: []);
  }

  /// `Physics`
  String get physics {
    return Intl.message('Physics', name: 'physics', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `{time}`
  String quizTimeRemaining(Object time) {
    return Intl.message(
      '$time',
      name: 'quizTimeRemaining',
      desc: '',
      args: [time],
    );
  }

  /// `Submit Quiz`
  String get submitQuiz {
    return Intl.message('Submit Quiz', name: 'submitQuiz', desc: '', args: []);
  }

  /// `Submitting...`
  String get submittingQuiz {
    return Intl.message(
      'Submitting...',
      name: 'submittingQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Error submitting quiz: {error}`
  String quizSubmitError(Object error) {
    return Intl.message(
      'Error submitting quiz: $error',
      name: 'quizSubmitError',
      desc: '',
      args: [error],
    );
  }

  /// `{question}`
  String quizQuestion(Object question) {
    return Intl.message(
      '$question',
      name: 'quizQuestion',
      desc: '',
      args: [question],
    );
  }

  /// `{option}`
  String quizOption(Object option) {
    return Intl.message(
      '$option',
      name: 'quizOption',
      desc: '',
      args: [option],
    );
  }

  /// `Quiz Results`
  String get quizResultsTitle {
    return Intl.message(
      'Quiz Results',
      name: 'quizResultsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Score`
  String get yourScore {
    return Intl.message('Your Score', name: 'yourScore', desc: '', args: []);
  }

  /// `{correct} out of {total}`
  String scoreText(Object correct, Object total) {
    return Intl.message(
      '$correct out of $total',
      name: 'scoreText',
      desc: '',
      args: [correct, total],
    );
  }

  /// `Question Review`
  String get questionReview {
    return Intl.message(
      'Question Review',
      name: 'questionReview',
      desc: '',
      args: [],
    );
  }

  /// `Your answer: {answer}`
  String yourAnswer(Object answer) {
    return Intl.message(
      'Your answer: $answer',
      name: 'yourAnswer',
      desc: '',
      args: [answer],
    );
  }

  /// `Not answered`
  String get notAnswered {
    return Intl.message(
      'Not answered',
      name: 'notAnswered',
      desc: '',
      args: [],
    );
  }

  /// `Correct answer: {answer}`
  String correctAnswer(Object answer) {
    return Intl.message(
      'Correct answer: $answer',
      name: 'correctAnswer',
      desc: '',
      args: [answer],
    );
  }

  /// `Back to Quizzes`
  String get backToQuizzes {
    return Intl.message(
      'Back to Quizzes',
      name: 'backToQuizzes',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get navHome {
    return Intl.message('Home', name: 'navHome', desc: '', args: []);
  }

  /// `Subjects`
  String get navSubjects {
    return Intl.message('Subjects', name: 'navSubjects', desc: '', args: []);
  }

  /// `Dashboard`
  String get navDashboard {
    return Intl.message('Dashboard', name: 'navDashboard', desc: '', args: []);
  }

  /// `Profile`
  String get navProfile {
    return Intl.message('Profile', name: 'navProfile', desc: '', args: []);
  }

  /// `Welcome!\n`
  String get welcomeTitle {
    return Intl.message('Welcome!\n', name: 'welcomeTitle', desc: '', args: []);
  }

  /// `Enter personal details to your user account`
  String get welcomeSubtitle {
    return Intl.message(
      'Enter personal details to your user account',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get welcomeSignInButton {
    return Intl.message(
      'Sign in',
      name: 'welcomeSignInButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get welcomeSignUpButton {
    return Intl.message(
      'Sign up',
      name: 'welcomeSignUpButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get signInWelcome {
    return Intl.message(
      'Welcome back',
      name: 'signInWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Enter Email`
  String get emailHint {
    return Intl.message('Enter Email', name: 'emailHint', desc: '', args: []);
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Enter Password`
  String get passwordHint {
    return Intl.message(
      'Enter Password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signInButton {
    return Intl.message('Sign in', name: 'signInButton', desc: '', args: []);
  }

  /// `or Sign in using`
  String get orSignInUsing {
    return Intl.message(
      'or Sign in using',
      name: 'orSignInUsing',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get signInNoAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'signInNoAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signInSignUpLink {
    return Intl.message(
      'Sign up',
      name: 'signInSignUpLink',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please check your credentials.`
  String get signInAuthFailed {
    return Intl.message(
      'Authentication failed. Please check your credentials.',
      name: 'signInAuthFailed',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get signUpTitle {
    return Intl.message('Get Started', name: 'signUpTitle', desc: '', args: []);
  }

  /// `Full Name`
  String get fullNameLabel {
    return Intl.message('Full Name', name: 'fullNameLabel', desc: '', args: []);
  }

  /// `Enter Full Name`
  String get fullNameHint {
    return Intl.message(
      'Enter Full Name',
      name: 'fullNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUpButton {
    return Intl.message('Sign up', name: 'signUpButton', desc: '', args: []);
  }

  /// `or Sign up using`
  String get orSignUpUsing {
    return Intl.message(
      'or Sign up using',
      name: 'orSignUpUsing',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get signUpAlreadyHaveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'signUpAlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signUpSignInLink {
    return Intl.message(
      'Sign in',
      name: 'signUpSignInLink',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please try again.`
  String get signUpAuthFailed {
    return Intl.message(
      'Authentication failed. Please try again.',
      name: 'signUpAuthFailed',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get subjectDetailTitle {
    return Intl.message(
      'History',
      name: 'subjectDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Materials`
  String get materialsSectionTitle {
    return Intl.message(
      'Materials',
      name: 'materialsSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Quizzes`
  String get quizzesSectionTitle {
    return Intl.message(
      'Quizzes',
      name: 'quizzesSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `No materials uploaded yet`
  String get noMaterialsText {
    return Intl.message(
      'No materials uploaded yet',
      name: 'noMaterialsText',
      desc: '',
      args: [],
    );
  }

  /// `No quizzes created yet`
  String get noQuizzesText {
    return Intl.message(
      'No quizzes created yet',
      name: 'noQuizzesText',
      desc: '',
      args: [],
    );
  }

  /// `Untitled Material`
  String get untitledMaterial {
    return Intl.message(
      'Untitled Material',
      name: 'untitledMaterial',
      desc: '',
      args: [],
    );
  }

  /// `Untitled Quiz`
  String get untitledQuiz {
    return Intl.message(
      'Untitled Quiz',
      name: 'untitledQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Questions: {count}`
  String questionsCount(Object count) {
    return Intl.message(
      'Questions: $count',
      name: 'questionsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Failed to load PDFs: {error}`
  String failedToLoadPDFs(Object error) {
    return Intl.message(
      'Failed to load PDFs: $error',
      name: 'failedToLoadPDFs',
      desc: '',
      args: [error],
    );
  }

  /// `Save`
  String get saveButton {
    return Intl.message('Save', name: 'saveButton', desc: '', args: []);
  }

  /// `Failed to load Quizzes: {error}`
  String failedToLoadQuizzes(Object error) {
    return Intl.message(
      'Failed to load Quizzes: $error',
      name: 'failedToLoadQuizzes',
      desc: '',
      args: [error],
    );
  }

  /// `Error saving quiz: {error}`
  String saveQuizError(Object error) {
    return Intl.message(
      'Error saving quiz: $error',
      name: 'saveQuizError',
      desc: '',
      args: [error],
    );
  }

  /// `Start Quiz`
  String get startQuizTitle {
    return Intl.message(
      'Start Quiz',
      name: 'startQuizTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to start this quiz?`
  String get startQuizMessage {
    return Intl.message(
      'Are you sure you want to start this quiz?',
      name: 'startQuizMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get startQuizCancel {
    return Intl.message('Cancel', name: 'startQuizCancel', desc: '', args: []);
  }

  /// `Confirm`
  String get startQuizConfirm {
    return Intl.message(
      'Confirm',
      name: 'startQuizConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteConfirmationTitle {
    return Intl.message(
      'Delete',
      name: 'deleteConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete {contentName}?`
  String deleteConfirmationQuest(Object contentName) {
    return Intl.message(
      'Are you sure you want to delete $contentName?',
      name: 'deleteConfirmationQuest',
      desc: '',
      args: [contentName],
    );
  }

  /// `Delete`
  String get deleteConfirmationDelete {
    return Intl.message(
      'Delete',
      name: 'deleteConfirmationDelete',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get deleteConfirmationCancle {
    return Intl.message(
      'Cancel',
      name: 'deleteConfirmationCancle',
      desc: '',
      args: [],
    );
  }

  /// `{Content} deleted successfully`
  String deleteConfirmationSuccess(Object Content) {
    return Intl.message(
      '$Content deleted successfully',
      name: 'deleteConfirmationSuccess',
      desc: '',
      args: [Content],
    );
  }

  /// `An error occurred. Please try again.`
  String get deleteConfirmationError {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'deleteConfirmationError',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Select PDF Source`
  String get selectPdfSource {
    return Intl.message(
      'Select PDF Source',
      name: 'selectPdfSource',
      desc: '',
      args: [],
    );
  }

  /// `Use Existing PDF`
  String get useExistingPdf {
    return Intl.message(
      'Use Existing PDF',
      name: 'useExistingPdf',
      desc: '',
      args: [],
    );
  }

  /// `Select New PDF`
  String get selectNewPdf {
    return Intl.message(
      'Select New PDF',
      name: 'selectNewPdf',
      desc: '',
      args: [],
    );
  }

  /// `Existing PDF`
  String get existingPdfTitle {
    return Intl.message(
      'Existing PDF',
      name: 'existingPdfTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select from Uploaded`
  String get selectFromUploaded {
    return Intl.message(
      'Select from Uploaded',
      name: 'selectFromUploaded',
      desc: '',
      args: [],
    );
  }

  /// `This feature is coming soon`
  String get featureComingSoon {
    return Intl.message(
      'This feature is coming soon',
      name: 'featureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Select PDF`
  String get selectPdfTitle {
    return Intl.message(
      'Select PDF',
      name: 'selectPdfTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Untitled PDF`
  String get untitledPdf {
    return Intl.message(
      'Untitled PDF',
      name: 'untitledPdf',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully.`
  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully.',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update profile.`
  String get updateFailed {
    return Intl.message(
      'Failed to update profile.',
      name: 'updateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Results`
  String get quizScoresTitle {
    return Intl.message(
      'Quiz Results',
      name: 'quizScoresTitle',
      desc: '',
      args: [],
    );
  }

  /// `View Students Performance`
  String get quizResultsSubtitle {
    return Intl.message(
      'View Students Performance',
      name: 'quizResultsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `No quiz results available yet`
  String get noQuizResults {
    return Intl.message(
      'No quiz results available yet',
      name: 'noQuizResults',
      desc: '',
      args: [],
    );
  }

  /// `Select Quiz`
  String get quizNameDropMenu {
    return Intl.message(
      'Select Quiz',
      name: 'quizNameDropMenu',
      desc: '',
      args: [],
    );
  }

  /// `Total Attempts`
  String get totalAttemptsLabel {
    return Intl.message(
      'Total Attempts',
      name: 'totalAttemptsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Average Score`
  String get averageScoreLabel {
    return Intl.message(
      'Average Score',
      name: 'averageScoreLabel',
      desc: '',
      args: [],
    );
  }

  /// `Highest Score`
  String get highestScoreLabel {
    return Intl.message(
      'Highest Score',
      name: 'highestScoreLabel',
      desc: '',
      args: [],
    );
  }

  /// `Lowest Score`
  String get lowestScoreLabel {
    return Intl.message(
      'Lowest Score',
      name: 'lowestScoreLabel',
      desc: '',
      args: [],
    );
  }

  /// `Student Scores:`
  String get studentScoresLabel {
    return Intl.message(
      'Student Scores:',
      name: 'studentScoresLabel',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordLabel {
    return Intl.message(
      'New Password',
      name: 'newPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password`
  String get newPasswordHint {
    return Intl.message(
      'Enter new password',
      name: 'newPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter new password`
  String get confirmPasswordHint {
    return Intl.message(
      'Re-enter new password',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get resetButton {
    return Intl.message('Reset', name: 'resetButton', desc: '', args: []);
  }

  /// `Password has been reset successfully!`
  String get passwordResetSuccess {
    return Intl.message(
      'Password has been reset successfully!',
      name: 'passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reset password.`
  String get passwordResetFailed {
    return Intl.message(
      'Failed to reset password.',
      name: 'passwordResetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get downloadingText {
    return Intl.message(
      'Downloading...',
      name: 'downloadingText',
      desc: '',
      args: [],
    );
  }

  /// `Failed Downloading, Please Try Again`
  String get failedDownloadingText {
    return Intl.message(
      'Failed Downloading, Please Try Again',
      name: 'failedDownloadingText',
      desc: '',
      args: [],
    );
  }

  /// `PDF saved to Downloads folder!`
  String get successDownloadingText {
    return Intl.message(
      'PDF saved to Downloads folder!',
      name: 'successDownloadingText',
      desc: '',
      args: [],
    );
  }

  /// `Download\nMaterials`
  String get materialsDownloadTitle {
    return Intl.message(
      'Download\nMaterials',
      name: 'materialsDownloadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message('Sign Up', name: 'signup', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `User Type`
  String get userType {
    return Intl.message('User Type', name: 'userType', desc: '', args: []);
  }

  /// `Student`
  String get student {
    return Intl.message('Student', name: 'student', desc: '', args: []);
  }

  /// `Teacher`
  String get teacher {
    return Intl.message('Teacher', name: 'teacher', desc: '', args: []);
  }

  /// `Explore`
  String get explore {
    return Intl.message('Explore', name: 'explore', desc: '', args: []);
  }

  /// `Search for a topic...`
  String get searchForATopic {
    return Intl.message(
      'Search for a topic...',
      name: 'searchForATopic',
      desc: '',
      args: [],
    );
  }

  /// `No results found. Try a different search.`
  String get noResultsFound {
    return Intl.message(
      'No results found. Try a different search.',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Explore a World of Knowledge`
  String get exploreScreenTitle {
    return Intl.message(
      'Explore a World of Knowledge',
      name: 'exploreScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recommended YouTube Resources`
  String get recommendedYoutubeResources {
    return Intl.message(
      'Recommended YouTube Resources',
      name: 'recommendedYoutubeResources',
      desc: '',
      args: [],
    );
  }

  /// `Watch on YouTube`
  String get watchOnYoutube {
    return Intl.message(
      'Watch on YouTube',
      name: 'watchOnYoutube',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get watchButton {
    return Intl.message('Watch', name: 'watchButton', desc: '', args: []);
  }

  /// `Quiz Time (minutes):`
  String get quizTimeLabel {
    return Intl.message(
      'Quiz Time (minutes):',
      name: 'quizTimeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get topicLabel {
    return Intl.message('Topic', name: 'topicLabel', desc: '', args: []);
  }

  /// `Please enter a valid email address`
  String get emailInvalid {
    return Intl.message(
      'Please enter a valid email address',
      name: 'emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters, include a number and a letter`
  String get passwordInvalid {
    return Intl.message(
      'Password must be at least 6 characters, include a number and a letter',
      name: 'passwordInvalid',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
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
