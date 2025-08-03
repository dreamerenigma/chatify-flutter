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

  /// `Chatify`
  String get appName {
    return Intl.message('Chatify', name: 'appName', desc: '', args: []);
  }

  /// `Welcome to Chatify`
  String get welcome {
    return Intl.message(
      'Welcome to Chatify',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Select a language to get started`
  String get selectLanguageGetStarted {
    return Intl.message(
      'Select a language to get started',
      name: 'selectLanguageGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Create in`
  String get createIn {
    return Intl.message('Create in', name: 'createIn', desc: '', args: []);
  }

  /// `Login with `
  String get loginWith {
    return Intl.message('Login with ', name: 'loginWith', desc: '', args: []);
  }

  /// `By clicking on the button, you confirm that you are familiar with the Terms of Personal Data Processing.`
  String get confirmTerms {
    return Intl.message(
      'By clicking on the button, you confirm that you are familiar with the Terms of Personal Data Processing.',
      name: 'confirmTerms',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Something Went Wrong (Check Internet!)`
  String get checkInternet {
    return Intl.message(
      'Something Went Wrong (Check Internet!)',
      name: 'checkInternet',
      desc: '',
      args: [],
    );
  }

  /// `Name, Email, ...`
  String get nameEmail {
    return Intl.message(
      'Name, Email, ...',
      name: 'nameEmail',
      desc: '',
      args: [],
    );
  }

  /// `  Add User`
  String get addUser {
    return Intl.message('  Add User', name: 'addUser', desc: '', args: []);
  }

  /// `Email or Id`
  String get emailOrId {
    return Intl.message('Email or Id', name: 'emailOrId', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Hey! I'm using Chatify!`
  String get aboutText {
    return Intl.message(
      'Hey! I\'m using Chatify!',
      name: 'aboutText',
      desc: '',
      args: [],
    );
  }

  /// `Hello!`
  String get statusText {
    return Intl.message('Hello!', name: 'statusText', desc: '', args: []);
  }

  /// `User does not Exists!`
  String get userNotExists {
    return Intl.message(
      'User does not Exists!',
      name: 'userNotExists',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Community`
  String get community {
    return Intl.message('Community', name: 'community', desc: '', args: []);
  }

  /// `Stay connected with the community`
  String get connectedCommunity {
    return Intl.message(
      'Stay connected with the community',
      name: 'connectedCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Communities unite participants into thematic groups and make it easier to receive updates from the admin. All the communities you are a member of will be displayed here.`
  String get communityThematic {
    return Intl.message(
      'Communities unite participants into thematic groups and make it easier to receive updates from the admin. All the communities you are a member of will be displayed here.',
      name: 'communityThematic',
      desc: '',
      args: [],
    );
  }

  /// `View examples of communities`
  String get communityExamples {
    return Intl.message(
      'View examples of communities',
      name: 'communityExamples',
      desc: '',
      args: [],
    );
  }

  /// `Create your community`
  String get createCommunity {
    return Intl.message(
      'Create your community',
      name: 'createCommunity',
      desc: '',
      args: [],
    );
  }

  /// `New community`
  String get newCommunity {
    return Intl.message(
      'New community',
      name: 'newCommunity',
      desc: '',
      args: [],
    );
  }

  /// `View examples `
  String get viewExamples {
    return Intl.message(
      'View examples ',
      name: 'viewExamples',
      desc: '',
      args: [],
    );
  }

  /// `of different communities`
  String get differentCommunities {
    return Intl.message(
      'of different communities',
      name: 'differentCommunities',
      desc: '',
      args: [],
    );
  }

  /// `Change photo`
  String get changePhoto {
    return Intl.message(
      'Change photo',
      name: 'changePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Community name`
  String get communityName {
    return Intl.message(
      'Community name',
      name: 'communityName',
      desc: '',
      args: [],
    );
  }

  /// `Welcome! In this community, members can communicate in thematic groups and receive important updates.`
  String get welcomeCommunity {
    return Intl.message(
      'Welcome! In this community, members can communicate in thematic groups and receive important updates.',
      name: 'welcomeCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Community created successfully!`
  String get communityCreatedSuccessfully {
    return Intl.message(
      'Community created successfully!',
      name: 'communityCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed created community!`
  String get communityCreationFailed {
    return Intl.message(
      'Failed created community!',
      name: 'communityCreationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Calls`
  String get calls {
    return Intl.message('Calls', name: 'calls', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// ` Settings `
  String get settings {
    return Intl.message(' Settings ', name: 'settings', desc: '', args: []);
  }

  /// `New Group`
  String get newGroup {
    return Intl.message('New Group', name: 'newGroup', desc: '', args: []);
  }

  /// `New newsletters`
  String get newNewsletters {
    return Intl.message(
      'New newsletters',
      name: 'newNewsletters',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter created successfully!`
  String get newslettersCreatedSuccessfully {
    return Intl.message(
      'Newsletter created successfully!',
      name: 'newslettersCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed created newsletter!`
  String get newsletterCreationFailed {
    return Intl.message(
      'Failed created newsletter!',
      name: 'newsletterCreationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Favorite messages`
  String get favoriteMessages {
    return Intl.message(
      'Favorite messages',
      name: 'favoriteMessages',
      desc: '',
      args: [],
    );
  }

  /// `Confidentiality status`
  String get confidentialityStatus {
    return Intl.message(
      'Confidentiality status',
      name: 'confidentialityStatus',
      desc: '',
      args: [],
    );
  }

  /// `Clear list`
  String get clearList {
    return Intl.message('Clear list', name: 'clearList', desc: '', args: []);
  }

  /// `Say Hii!👋`
  String get hello {
    return Intl.message('Say Hii!👋', name: 'hello', desc: '', args: []);
  }

  /// `Type something...`
  String get typeSomething {
    return Intl.message(
      'Type something...',
      name: 'typeSomething',
      desc: '',
      args: [],
    );
  }

  /// `Hold to record, release to send`
  String get holdRecord {
    return Intl.message(
      'Hold to record, release to send',
      name: 'holdRecord',
      desc: '',
      args: [],
    );
  }

  /// `Select images`
  String get selectImages {
    return Intl.message(
      'Select images',
      name: 'selectImages',
      desc: '',
      args: [],
    );
  }

  /// `Select videos`
  String get selectVideos {
    return Intl.message(
      'Select videos',
      name: 'selectVideos',
      desc: '',
      args: [],
    );
  }

  /// `Select documents`
  String get selectDocuments {
    return Intl.message(
      'Select documents',
      name: 'selectDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Unknown document`
  String get unknownDocument {
    return Intl.message(
      'Unknown document',
      name: 'unknownDocument',
      desc: '',
      args: [],
    );
  }

  /// `Document successfully saved!`
  String get documentSuccessfullySaved {
    return Intl.message(
      'Document successfully saved!',
      name: 'documentSuccessfullySaved',
      desc: '',
      args: [],
    );
  }

  /// `Failed to download document`
  String get failedDownloadDocument {
    return Intl.message(
      'Failed to download document',
      name: 'failedDownloadDocument',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get takePhoto {
    return Intl.message('Take a photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Record video`
  String get recordVideo {
    return Intl.message(
      'Record video',
      name: 'recordVideo',
      desc: '',
      args: [],
    );
  }

  /// `Write`
  String get write {
    return Intl.message('Write', name: 'write', desc: '', args: []);
  }

  /// `Call`
  String get call {
    return Intl.message('Call', name: 'call', desc: '', args: []);
  }

  /// `About: `
  String get about {
    return Intl.message('About: ', name: 'about', desc: '', args: []);
  }

  /// `Email Copied!`
  String get emailCopied {
    return Intl.message(
      'Email Copied!',
      name: 'emailCopied',
      desc: '',
      args: [],
    );
  }

  /// `Joined on: `
  String get joinedOn {
    return Intl.message('Joined on: ', name: 'joinedOn', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Open in address book`
  String get openAddressBook {
    return Intl.message(
      'Open in address book',
      name: 'openAddressBook',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your security code`
  String get confirmSecureCode {
    return Intl.message(
      'Confirm your security code',
      name: 'confirmSecureCode',
      desc: '',
      args: [],
    );
  }

  /// `Screen`
  String get screen {
    return Intl.message('Screen', name: 'screen', desc: '', args: []);
  }

  /// `Themes`
  String get themes {
    return Intl.message('Themes', name: 'themes', desc: '', args: []);
  }

  /// `Wallpapers`
  String get wallpapers {
    return Intl.message('Wallpapers', name: 'wallpapers', desc: '', args: []);
  }

  /// `Chat Settings`
  String get chatSettings {
    return Intl.message(
      'Chat Settings',
      name: 'chatSettings',
      desc: '',
      args: [],
    );
  }

  /// `Please enter message text`
  String get pleaseEnterTextMessage {
    return Intl.message(
      'Please enter message text',
      name: 'pleaseEnterTextMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send with Enter Key`
  String get sendEnterKey {
    return Intl.message(
      'Send with Enter Key',
      name: 'sendEnterKey',
      desc: '',
      args: [],
    );
  }

  /// `Pressing Enter key sends the message`
  String get subtitleSendEnterKey {
    return Intl.message(
      'Pressing Enter key sends the message',
      name: 'subtitleSendEnterKey',
      desc: '',
      args: [],
    );
  }

  /// `Media visibility`
  String get mediaVisibility {
    return Intl.message(
      'Media visibility',
      name: 'mediaVisibility',
      desc: '',
      args: [],
    );
  }

  /// `Show recently downloaded media files in device galleries`
  String get subtitleMediaVisibility {
    return Intl.message(
      'Show recently downloaded media files in device galleries',
      name: 'subtitleMediaVisibility',
      desc: '',
      args: [],
    );
  }

  /// `Font size`
  String get fontSize {
    return Intl.message('Font size', name: 'fontSize', desc: '', args: []);
  }

  /// `Select font`
  String get selectFont {
    return Intl.message('Select font', name: 'selectFont', desc: '', args: []);
  }

  /// `Small`
  String get small {
    return Intl.message('Small', name: 'small', desc: '', args: []);
  }

  /// `Average`
  String get average {
    return Intl.message('Average', name: 'average', desc: '', args: []);
  }

  /// `Big`
  String get big {
    return Intl.message('Big', name: 'big', desc: '', args: []);
  }

  /// `Archived chats`
  String get archivedChats {
    return Intl.message(
      'Archived chats',
      name: 'archivedChats',
      desc: '',
      args: [],
    );
  }

  /// `Archived chats`
  String get subtitleArchivedChats {
    return Intl.message(
      'Archived chats',
      name: 'subtitleArchivedChats',
      desc: '',
      args: [],
    );
  }

  /// `Archived chats will not be unarchived when a new message is received`
  String get archivedChatsUnarchived {
    return Intl.message(
      'Archived chats will not be unarchived when a new message is received',
      name: 'archivedChatsUnarchived',
      desc: '',
      args: [],
    );
  }

  /// `Chat backup`
  String get chatsBackup {
    return Intl.message('Chat backup', name: 'chatsBackup', desc: '', args: []);
  }

  /// `Chats transfer `
  String get transferChats {
    return Intl.message(
      'Chats transfer ',
      name: 'transferChats',
      desc: '',
      args: [],
    );
  }

  /// `Chat histories`
  String get historiesChats {
    return Intl.message(
      'Chat histories',
      name: 'historiesChats',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Surname`
  String get surname {
    return Intl.message('Surname', name: 'surname', desc: '', args: []);
  }

  /// `eg. Happy Singh`
  String get hintName {
    return Intl.message(
      'eg. Happy Singh',
      name: 'hintName',
      desc: '',
      args: [],
    );
  }

  /// `eg. Feeling Happy`
  String get hintAbout {
    return Intl.message(
      'eg. Feeling Happy',
      name: 'hintAbout',
      desc: '',
      args: [],
    );
  }

  /// `About me`
  String get aboutField {
    return Intl.message('About me', name: 'aboutField', desc: '', args: []);
  }

  /// `eg. On Vacation`
  String get hintStatus {
    return Intl.message(
      'eg. On Vacation',
      name: 'hintStatus',
      desc: '',
      args: [],
    );
  }

  /// `eg. +7 999 999-99-99`
  String get hintPhoneNumber {
    return Intl.message(
      'eg. +7 999 999-99-99',
      name: 'hintPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get phoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get requiredField {
    return Intl.message(
      'Required field',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully!`
  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully!',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Updating...`
  String get update {
    return Intl.message('Updating...', name: 'update', desc: '', args: []);
  }

  /// `Logout`
  String get logoutAccount {
    return Intl.message('Logout', name: 'logoutAccount', desc: '', args: []);
  }

  /// `Are you sure you want to log out of your account?`
  String get sureLogoutAccount {
    return Intl.message(
      'Are you sure you want to log out of your account?',
      name: 'sureLogoutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sure`
  String get sure {
    return Intl.message('Sure', name: 'sure', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Search...`
  String get settingsSearch {
    return Intl.message(
      'Search...',
      name: 'settingsSearch',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Security notices, phone number changes`
  String get subtitleAccount {
    return Intl.message(
      'Security notices, phone number changes',
      name: 'subtitleAccount',
      desc: '',
      args: [],
    );
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

  /// `Sounds of messages, groups and calls`
  String get subtitleNotifications {
    return Intl.message(
      'Sounds of messages, groups and calls',
      name: 'subtitleNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Data and storage`
  String get dataStorage {
    return Intl.message(
      'Data and storage',
      name: 'dataStorage',
      desc: '',
      args: [],
    );
  }

  /// `Network usage, startup`
  String get subtitleDataStorage {
    return Intl.message(
      'Network usage, startup',
      name: 'subtitleDataStorage',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message('Privacy', name: 'privacy', desc: '', args: []);
  }

  /// `Blocking contacts, disappearing messages`
  String get subtitlePrivacy {
    return Intl.message(
      'Blocking contacts, disappearing messages',
      name: 'subtitlePrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Lists`
  String get lists {
    return Intl.message('Lists', name: 'lists', desc: '', args: []);
  }

  /// `Managing contacts and groups`
  String get subtitleLists {
    return Intl.message(
      'Managing contacts and groups',
      name: 'subtitleLists',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message('Favorite', name: 'favorite', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Add, reorder, remove`
  String get subtitleFavorite {
    return Intl.message(
      'Add, reorder, remove',
      name: 'subtitleFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Themes, wallpapers, chat history`
  String get subtitleChats {
    return Intl.message(
      'Themes, wallpapers, chat history',
      name: 'subtitleChats',
      desc: '',
      args: [],
    );
  }

  /// `Special features`
  String get specialFeatures {
    return Intl.message(
      'Special features',
      name: 'specialFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Animation`
  String get subtitleSpecialFeatures {
    return Intl.message(
      'Animation',
      name: 'subtitleSpecialFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Application language`
  String get applicationLanguage {
    return Intl.message(
      'Application language',
      name: 'applicationLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Select application language`
  String get subtitleLanguage {
    return Intl.message(
      'Select application language',
      name: 'subtitleLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message('Help', name: 'help', desc: '', args: []);
  }

  /// `Help Center, Contact Us, Privacy Policy`
  String get subtitleHelp {
    return Intl.message(
      'Help Center, Contact Us, Privacy Policy',
      name: 'subtitleHelp',
      desc: '',
      args: [],
    );
  }

  /// `Report a bug`
  String get reportBug {
    return Intl.message('Report a bug', name: 'reportBug', desc: '', args: []);
  }

  /// `Technical problems and errors`
  String get subtitleReportBug {
    return Intl.message(
      'Technical problems and errors',
      name: 'subtitleReportBug',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get helpCenter {
    return Intl.message('Help Center', name: 'helpCenter', desc: '', args: []);
  }

  /// `Help, contact us`
  String get subtitleHelpCenter {
    return Intl.message(
      'Help, contact us',
      name: 'subtitleHelpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Terms and privacy policy`
  String get termsPrivacyPolicy {
    return Intl.message(
      'Terms and privacy policy',
      name: 'termsPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Complaints about channels`
  String get complaints {
    return Intl.message(
      'Complaints about channels',
      name: 'complaints',
      desc: '',
      args: [],
    );
  }

  /// `No complaints`
  String get noComplaints {
    return Intl.message(
      'No complaints',
      name: 'noComplaints',
      desc: '',
      args: [],
    );
  }

  /// `Submitting complaint...`
  String get submittingComplaint {
    return Intl.message(
      'Submitting complaint...',
      name: 'submittingComplaint',
      desc: '',
      args: [],
    );
  }

  /// `About the app`
  String get subtitleAbout {
    return Intl.message(
      'About the app',
      name: 'subtitleAbout',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Licenses`
  String get licenses {
    return Intl.message('Licenses', name: 'licenses', desc: '', args: []);
  }

  /// `Select language`
  String get selectLanguage {
    return Intl.message(
      'Select language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message('Languages', name: 'languages', desc: '', args: []);
  }

  /// `Afrikaans`
  String get africanLanguage {
    return Intl.message(
      'Afrikaans',
      name: 'africanLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Arab`
  String get arabianLanguage {
    return Intl.message('Arab', name: 'arabianLanguage', desc: '', args: []);
  }

  /// `Bulgarian`
  String get bulgarianLanguage {
    return Intl.message(
      'Bulgarian',
      name: 'bulgarianLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Bengal`
  String get bengalianLanguage {
    return Intl.message(
      'Bengal',
      name: 'bengalianLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Catalan`
  String get catalianLanguage {
    return Intl.message(
      'Catalan',
      name: 'catalianLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Czech`
  String get czechLanguage {
    return Intl.message('Czech', name: 'czechLanguage', desc: '', args: []);
  }

  /// `Danish`
  String get danianLanguage {
    return Intl.message('Danish', name: 'danianLanguage', desc: '', args: []);
  }

  /// `Greek`
  String get greekLanguage {
    return Intl.message('Greek', name: 'greekLanguage', desc: '', args: []);
  }

  /// `Russian`
  String get russianLanguage {
    return Intl.message('Russian', name: 'russianLanguage', desc: '', args: []);
  }

  /// `English`
  String get englishLanguage {
    return Intl.message('English', name: 'englishLanguage', desc: '', args: []);
  }

  /// `Spanish`
  String get spanishLanguage {
    return Intl.message('Spanish', name: 'spanishLanguage', desc: '', args: []);
  }

  /// `German`
  String get deutschLanguage {
    return Intl.message('German', name: 'deutschLanguage', desc: '', args: []);
  }

  /// `French`
  String get frenchLanguage {
    return Intl.message('French', name: 'frenchLanguage', desc: '', args: []);
  }

  /// `Italian`
  String get italianLanguage {
    return Intl.message('Italian', name: 'italianLanguage', desc: '', args: []);
  }

  /// `Portuguese`
  String get portugueseLanguage {
    return Intl.message(
      'Portuguese',
      name: 'portugueseLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Select theme`
  String get selectTheme {
    return Intl.message(
      'Select theme',
      name: 'selectTheme',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get system {
    return Intl.message('Default', name: 'system', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Pick profile picture`
  String get pickProfilePicture {
    return Intl.message(
      'Pick profile picture',
      name: 'pickProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Copy text`
  String get copyText {
    return Intl.message('Copy text', name: 'copyText', desc: '', args: []);
  }

  /// `Save image`
  String get saveImage {
    return Intl.message('Save image', name: 'saveImage', desc: '', args: []);
  }

  /// `Edit message`
  String get editMessage {
    return Intl.message(
      'Edit message',
      name: 'editMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete message`
  String get deleteMessage {
    return Intl.message(
      'Delete message',
      name: 'deleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete messages?`
  String get deleteMessages {
    return Intl.message(
      'Delete messages?',
      name: 'deleteMessages',
      desc: '',
      args: [],
    );
  }

  /// `Save video`
  String get saveVideo {
    return Intl.message('Save video', name: 'saveVideo', desc: '', args: []);
  }

  /// `Video saved!`
  String get videoSaved {
    return Intl.message('Video saved!', name: 'videoSaved', desc: '', args: []);
  }

  /// `Sent at:`
  String get sentAt {
    return Intl.message('Sent at:', name: 'sentAt', desc: '', args: []);
  }

  /// `Read at:`
  String get readAt {
    return Intl.message('Read at:', name: 'readAt', desc: '', args: []);
  }

  /// `Read At: Not seen yet`
  String get readAtSeenYet {
    return Intl.message(
      'Read At: Not seen yet',
      name: 'readAtSeenYet',
      desc: '',
      args: [],
    );
  }

  /// `Image successfully saved!`
  String get imageSaved {
    return Intl.message(
      'Image successfully saved!',
      name: 'imageSaved',
      desc: '',
      args: [],
    );
  }

  /// `Text copied!`
  String get textCopied {
    return Intl.message('Text copied!', name: 'textCopied', desc: '', args: []);
  }

  /// `Update message`
  String get updateMessage {
    return Intl.message(
      'Update message',
      name: 'updateMessage',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo`
  String get profilePhoto {
    return Intl.message(
      'Profile photo',
      name: 'profilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Delete profile photo?`
  String get deleteProfilePhoto {
    return Intl.message(
      'Delete profile photo?',
      name: 'deleteProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `All media`
  String get allMedia {
    return Intl.message('All media', name: 'allMedia', desc: '', args: []);
  }

  /// `Show in chat`
  String get showInChat {
    return Intl.message('Show in chat', name: 'showInChat', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `View in galleries`
  String get viewGalleries {
    return Intl.message(
      'View in galleries',
      name: 'viewGalleries',
      desc: '',
      args: [],
    );
  }

  /// `Rotation`
  String get rotation {
    return Intl.message('Rotation', name: 'rotation', desc: '', args: []);
  }

  /// `Add contact`
  String get addContact {
    return Intl.message('Add contact', name: 'addContact', desc: '', args: []);
  }

  /// `Profile photo removed`
  String get profilePhotoDeleted {
    return Intl.message(
      'Profile photo removed',
      name: 'profilePhotoDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo not deleted`
  String get profilePhotoDeleteFailed {
    return Intl.message(
      'Profile photo not deleted',
      name: 'profilePhotoDeleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Security notices`
  String get securityNotices {
    return Intl.message(
      'Security notices',
      name: 'securityNotices',
      desc: '',
      args: [],
    );
  }

  /// `Access keys`
  String get accessKeys {
    return Intl.message('Access keys', name: 'accessKeys', desc: '', args: []);
  }

  /// `Email address`
  String get emailAddress {
    return Intl.message(
      'Email address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Two-step verification`
  String get twoStepVerification {
    return Intl.message(
      'Two-step verification',
      name: 'twoStepVerification',
      desc: '',
      args: [],
    );
  }

  /// `Change number`
  String get changeNumber {
    return Intl.message(
      'Change number',
      name: 'changeNumber',
      desc: '',
      args: [],
    );
  }

  /// `Request account information`
  String get requestAccountInfo {
    return Intl.message(
      'Request account information',
      name: 'requestAccountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Add account`
  String get addAccount {
    return Intl.message('Add account', name: 'addAccount', desc: '', args: []);
  }

  /// `Delete this account`
  String get deleteAccount {
    return Intl.message(
      'Delete this account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `If you delete your account:`
  String get deleteAccountWarning {
    return Intl.message(
      'If you delete your account:',
      name: 'deleteAccountWarning',
      desc: '',
      args: [],
    );
  }

  /// `Account will be deleted in Chatify`
  String get accountWillBeDeleted {
    return Intl.message(
      'Account will be deleted in Chatify',
      name: 'accountWillBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Your message history will be deleted.`
  String get messageHistoryWillBeDeleted {
    return Intl.message(
      'Your message history will be deleted.',
      name: 'messageHistoryWillBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `You will be removed from all Chatify groups you are a member of.`
  String get removedFromAllGroups {
    return Intl.message(
      'You will be removed from all Chatify groups you are a member of.',
      name: 'removedFromAllGroups',
      desc: '',
      args: [],
    );
  }

  /// `Your backup in the Input Studios storage will be deleted.`
  String get backupWillBeDeleted {
    return Intl.message(
      'Your backup in the Input Studios storage will be deleted.',
      name: 'backupWillBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `To delete your account, confirm your country code and enter your phone number`
  String get confirmCountryCodeAndPhoneNumber {
    return Intl.message(
      'To delete your account, confirm your country code and enter your phone number',
      name: 'confirmCountryCodeAndPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Select country`
  String get selectCountry {
    return Intl.message(
      'Select country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted!`
  String get accountDeleted {
    return Intl.message(
      'Account deleted!',
      name: 'accountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Last seen not available`
  String get lastSeenNotAvailable {
    return Intl.message(
      'Last seen not available',
      name: 'lastSeenNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `was`
  String get prefixDate {
    return Intl.message('was', name: 'prefixDate', desc: '', args: []);
  }

  /// `was today in`
  String get lastSeenToday {
    return Intl.message(
      'was today in',
      name: 'lastSeenToday',
      desc: '',
      args: [],
    );
  }

  /// `was yesterday in`
  String get lastSeenYesterday {
    return Intl.message(
      'was yesterday in',
      name: 'lastSeenYesterday',
      desc: '',
      args: [],
    );
  }

  /// `was in`
  String get lastSeenWeek {
    return Intl.message('was in', name: 'lastSeenWeek', desc: '', args: []);
  }

  /// `in `
  String get lastSeenTime {
    return Intl.message('in ', name: 'lastSeenTime', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `No profile picture available!`
  String get noProfilePicture {
    return Intl.message(
      'No profile picture available!',
      name: 'noProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message('Photo', name: 'photo', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `No profile photo`
  String get noProfilePhoto {
    return Intl.message(
      'No profile photo',
      name: 'noProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `GIF`
  String get gif {
    return Intl.message('GIF', name: 'gif', desc: '', args: []);
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Select audio`
  String get selectAudio {
    return Intl.message(
      'Select audio',
      name: 'selectAudio',
      desc: '',
      args: [],
    );
  }

  /// `Save audio`
  String get saveAudio {
    return Intl.message('Save audio', name: 'saveAudio', desc: '', args: []);
  }

  /// `Audio successfully saved!`
  String get audioSaved {
    return Intl.message(
      'Audio successfully saved!',
      name: 'audioSaved',
      desc: '',
      args: [],
    );
  }

  /// `Add status`
  String get addStatus {
    return Intl.message('Add status', name: 'addStatus', desc: '', args: []);
  }

  /// `Disappears after 24 hours`
  String get addNewStatus {
    return Intl.message(
      'Disappears after 24 hours',
      name: 'addNewStatus',
      desc: '',
      args: [],
    );
  }

  /// `Your status updates are protected by `
  String get statusUpdatesEncryption {
    return Intl.message(
      'Your status updates are protected by ',
      name: 'statusUpdatesEncryption',
      desc: '',
      args: [],
    );
  }

  /// `end-to-end encryption`
  String get endToEndEncryption {
    return Intl.message(
      'end-to-end encryption',
      name: 'endToEndEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Who can see my status updates`
  String get seeStatusUpdates {
    return Intl.message(
      'Who can see my status updates',
      name: 'seeStatusUpdates',
      desc: '',
      args: [],
    );
  }

  /// `My contacts`
  String get myContacts {
    return Intl.message('My contacts', name: 'myContacts', desc: '', args: []);
  }

  /// `Contacts, except...`
  String get contactsExcept {
    return Intl.message(
      'Contacts, except...',
      name: 'contactsExcept',
      desc: '',
      args: [],
    );
  }

  /// `Only...`
  String get only {
    return Intl.message('Only...', name: 'only', desc: '', args: []);
  }

  /// `Changes to your privacy settings will not affect status updates you've already sent`
  String get changesAffectStatus {
    return Intl.message(
      'Changes to your privacy settings will not affect status updates you\'ve already sent',
      name: 'changesAffectStatus',
      desc: '',
      args: [],
    );
  }

  /// `Exc.`
  String get exception {
    return Intl.message('Exc.', name: 'exception', desc: '', args: []);
  }

  /// `On`
  String get on {
    return Intl.message('On', name: 'on', desc: '', args: []);
  }

  /// `Your settings have been saved`
  String get settingsSaved {
    return Intl.message(
      'Your settings have been saved',
      name: 'settingsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message('Feedback', name: 'feedback', desc: '', args: []);
  }

  /// `What would you like to do?`
  String get feedbackWhatWouldLike {
    return Intl.message(
      'What would you like to do?',
      name: 'feedbackWhatWouldLike',
      desc: '',
      args: [],
    );
  }

  /// `Report a problem`
  String get feedbackRepostProblem {
    return Intl.message(
      'Report a problem',
      name: 'feedbackRepostProblem',
      desc: '',
      args: [],
    );
  }

  /// `Suggest a new feature`
  String get feedbackSuggestFeature {
    return Intl.message(
      'Suggest a new feature',
      name: 'feedbackSuggestFeature',
      desc: '',
      args: [],
    );
  }

  /// `Report a problem with your order`
  String get feedbackProblemOrder {
    return Intl.message(
      'Report a problem with your order',
      name: 'feedbackProblemOrder',
      desc: '',
      args: [],
    );
  }

  /// `Your suggestion`
  String get yourSuggestion {
    return Intl.message(
      'Your suggestion',
      name: 'yourSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Describe your proposal. We will not be able to answer you personally, but we will certainly take into account your wishes.`
  String get describeProposal {
    return Intl.message(
      'Describe your proposal. We will not be able to answer you personally, but we will certainly take into account your wishes.',
      name: 'describeProposal',
      desc: '',
      args: [],
    );
  }

  /// `Your email address`
  String get enterEmailAddress {
    return Intl.message(
      'Your email address',
      name: 'enterEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Not all fields are filled!`
  String get notAllFields {
    return Intl.message(
      'Not all fields are filled!',
      name: 'notAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get sendFeedbackMessage {
    return Intl.message(
      'Send',
      name: 'sendFeedbackMessage',
      desc: '',
      args: [],
    );
  }

  /// `This page is intended for feedback and suggestions on the application. If you want to open a dispute, please go to my orders.`
  String get feedbackApplication {
    return Intl.message(
      'This page is intended for feedback and suggestions on the application. If you want to open a dispute, please go to my orders.',
      name: 'feedbackApplication',
      desc: '',
      args: [],
    );
  }

  /// `Choose an action`
  String get chooseAction {
    return Intl.message(
      'Choose an action',
      name: 'chooseAction',
      desc: '',
      args: [],
    );
  }

  /// `To make a photo`
  String get makePhoto {
    return Intl.message(
      'To make a photo',
      name: 'makePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Select available`
  String get selectAvailable {
    return Intl.message(
      'Select available',
      name: 'selectAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get feedbackCancelButton {
    return Intl.message(
      'Cancel',
      name: 'feedbackCancelButton',
      desc: '',
      args: [],
    );
  }

  /// `No images found.`
  String get noImagesFound {
    return Intl.message(
      'No images found.',
      name: 'noImagesFound',
      desc: '',
      args: [],
    );
  }

  /// `Send feedback`
  String get sendFeedback {
    return Intl.message(
      'Send feedback',
      name: 'sendFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Feedback sent successfully!`
  String get feedbackSentSuccessfully {
    return Intl.message(
      'Feedback sent successfully!',
      name: 'feedbackSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send feedback.`
  String get feedbackSentFailed {
    return Intl.message(
      'Failed to send feedback.',
      name: 'feedbackSentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Edit image`
  String get editImage {
    return Intl.message('Edit image', name: 'editImage', desc: '', args: []);
  }

  /// `No Connection Found!`
  String get noConnectionFound {
    return Intl.message(
      'No Connection Found!',
      name: 'noConnectionFound',
      desc: '',
      args: [],
    );
  }

  /// `How can we help?`
  String get howCanHelp {
    return Intl.message(
      'How can we help?',
      name: 'howCanHelp',
      desc: '',
      args: [],
    );
  }

  /// `Search the Help Center`
  String get searchHelpCenter {
    return Intl.message(
      'Search the Help Center',
      name: 'searchHelpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Help Topics`
  String get helpTopics {
    return Intl.message('Help Topics', name: 'helpTopics', desc: '', args: []);
  }

  /// `Beginning of work`
  String get beginningWork {
    return Intl.message(
      'Beginning of work',
      name: 'beginningWork',
      desc: '',
      args: [],
    );
  }

  /// `Communication with companies`
  String get communicationCompanies {
    return Intl.message(
      'Communication with companies',
      name: 'communicationCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Communities`
  String get communities {
    return Intl.message('Communities', name: 'communities', desc: '', args: []);
  }

  /// `Privacy and Security`
  String get privacySecurity {
    return Intl.message(
      'Privacy and Security',
      name: 'privacySecurity',
      desc: '',
      args: [],
    );
  }

  /// `Account and blocking`
  String get accountBlocking {
    return Intl.message(
      'Account and blocking',
      name: 'accountBlocking',
      desc: '',
      args: [],
    );
  }

  /// `Popular articles`
  String get popularArticles {
    return Intl.message(
      'Popular articles',
      name: 'popularArticles',
      desc: '',
      args: [],
    );
  }

  /// `How to manage notifications`
  String get howManageNotifications {
    return Intl.message(
      'How to manage notifications',
      name: 'howManageNotifications',
      desc: '',
      args: [],
    );
  }

  /// `How to update Chatify manually`
  String get howUpdateManually {
    return Intl.message(
      'How to update Chatify manually',
      name: 'howUpdateManually',
      desc: '',
      args: [],
    );
  }

  /// `How to recover chat history`
  String get howRecoverChatHistory {
    return Intl.message(
      'How to recover chat history',
      name: 'howRecoverChatHistory',
      desc: '',
      args: [],
    );
  }

  /// `How to register a phone number`
  String get howRegisterPhoneNumber {
    return Intl.message(
      'How to register a phone number',
      name: 'howRegisterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `How to make video calls`
  String get howMakeVideoCalls {
    return Intl.message(
      'How to make video calls',
      name: 'howMakeVideoCalls',
      desc: '',
      args: [],
    );
  }

  /// `Temporary account blocking`
  String get temporaryAccountBlocking {
    return Intl.message(
      'Temporary account blocking',
      name: 'temporaryAccountBlocking',
      desc: '',
      args: [],
    );
  }

  /// `Advertising in Chatify status and channels`
  String get adStatusAndChannels {
    return Intl.message(
      'Advertising in Chatify status and channels',
      name: 'adStatusAndChannels',
      desc: '',
      args: [],
    );
  }

  /// `Connect with us`
  String get connectWithUs {
    return Intl.message(
      'Connect with us',
      name: 'connectWithUs',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `You are offline. Playback is only possible for cached videos.`
  String get offlineCachedVideos {
    return Intl.message(
      'You are offline. Playback is only possible for cached videos.',
      name: 'offlineCachedVideos',
      desc: '',
      args: [],
    );
  }

  /// `To invite a friend`
  String get inviteFriend {
    return Intl.message(
      'To invite a friend',
      name: 'inviteFriend',
      desc: '',
      args: [],
    );
  }

  /// `Jan.`
  String get jan {
    return Intl.message('Jan.', name: 'jan', desc: '', args: []);
  }

  /// `Feb.`
  String get feb {
    return Intl.message('Feb.', name: 'feb', desc: '', args: []);
  }

  /// `Mar.`
  String get mar {
    return Intl.message('Mar.', name: 'mar', desc: '', args: []);
  }

  /// `Apr.`
  String get apr {
    return Intl.message('Apr.', name: 'apr', desc: '', args: []);
  }

  /// `May.`
  String get may {
    return Intl.message('May.', name: 'may', desc: '', args: []);
  }

  /// `Jun.`
  String get jun {
    return Intl.message('Jun.', name: 'jun', desc: '', args: []);
  }

  /// `Jul.`
  String get jul {
    return Intl.message('Jul.', name: 'jul', desc: '', args: []);
  }

  /// `Aug.`
  String get aug {
    return Intl.message('Aug.', name: 'aug', desc: '', args: []);
  }

  /// `Sep.`
  String get sep {
    return Intl.message('Sep.', name: 'sep', desc: '', args: []);
  }

  /// `Oct.`
  String get oct {
    return Intl.message('Oct.', name: 'oct', desc: '', args: []);
  }

  /// `Nov.`
  String get nov {
    return Intl.message('Nov.', name: 'nov', desc: '', args: []);
  }

  /// `Dec.`
  String get dec {
    return Intl.message('Dec.', name: 'dec', desc: '', args: []);
  }

  /// `No image of the mailing list`
  String get noImageMailingList {
    return Intl.message(
      'No image of the mailing list',
      name: 'noImageMailingList',
      desc: '',
      args: [],
    );
  }

  /// `Invalid country code length (maximum 1-3 characters).`
  String get invalidCountryCodeLength {
    return Intl.message(
      'Invalid country code length (maximum 1-3 characters).',
      name: 'invalidCountryCodeLength',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhoneNum {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhoneNum',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connected {
    return Intl.message('Connecting...', name: 'connected', desc: '', args: []);
  }

  /// `Enter your phone number`
  String get enterYourPhoneNum {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourPhoneNum',
      desc: '',
      args: [],
    );
  }

  /// `Bind as auxiliary device`
  String get bindAuxiliaryDevice {
    return Intl.message(
      'Bind as auxiliary device',
      name: 'bindAuxiliaryDevice',
      desc: '',
      args: [],
    );
  }

  /// `Chatify needs to verify your phone number. Carrier rates may apply. `
  String get verifyYourPhoneNum {
    return Intl.message(
      'Chatify needs to verify your phone number. Carrier rates may apply. ',
      name: 'verifyYourPhoneNum',
      desc: '',
      args: [],
    );
  }

  /// `What is my number?`
  String get whatMyNumber {
    return Intl.message(
      'What is my number?',
      name: 'whatMyNumber',
      desc: '',
      args: [],
    );
  }

  /// `There is no answer to my question here`
  String get thereNoAnswerMyQuestion {
    return Intl.message(
      'There is no answer to my question here',
      name: 'thereNoAnswerMyQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Problem detected`
  String get problemDetected {
    return Intl.message(
      'Problem detected',
      name: 'problemDetected',
      desc: '',
      args: [],
    );
  }

  /// `The phone number you entered is not a valid number in your country. Make sure you enter a phone number that is linked to an active SIM card. We do not support landline or VoIP numbers.`
  String get enteredNotValidNumber {
    return Intl.message(
      'The phone number you entered is not a valid number in your country. Make sure you enter a phone number that is linked to an active SIM card. We do not support landline or VoIP numbers.',
      name: 'enteredNotValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please return to the previous screen and enter a valid number in full international format:`
  String get returnPreviousScreen {
    return Intl.message(
      'Please return to the previous screen and enter a valid number in full international format:',
      name: 'returnPreviousScreen',
      desc: '',
      args: [],
    );
  }

  /// `Select a country from the list of suggested countries. This will automatically fill in the country code.`
  String get listSuggestedCountries {
    return Intl.message(
      'Select a country from the list of suggested countries. This will automatically fill in the country code.',
      name: 'listSuggestedCountries',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number. Do not enter 0 before the phone number.`
  String get doNotEnterZero {
    return Intl.message(
      'Enter your phone number. Do not enter 0 before the phone number.',
      name: 'doNotEnterZero',
      desc: '',
      args: [],
    );
  }

  /// `For example, the correct phone number for Russia is +7 (926) 456-78-90.`
  String get correctPhoneNumYourCountry {
    return Intl.message(
      'For example, the correct phone number for Russia is +7 (926) 456-78-90.',
      name: 'correctPhoneNumYourCountry',
      desc: '',
      args: [],
    );
  }

  /// `For more detailed information, please read our `
  String get moreDetailedInfo {
    return Intl.message(
      'For more detailed information, please read our ',
      name: 'moreDetailedInfo',
      desc: '',
      args: [],
    );
  }

  /// `article in FAQ`
  String get articleFaq {
    return Intl.message(
      'article in FAQ',
      name: 'articleFaq',
      desc: '',
      args: [],
    );
  }

  /// `Describe the problem`
  String get describeProblem {
    return Intl.message(
      'Describe the problem',
      name: 'describeProblem',
      desc: '',
      args: [],
    );
  }

  /// `Add up to 3 screenshots or recordings`
  String get addScreenshots {
    return Intl.message(
      'Add up to 3 screenshots or recordings',
      name: 'addScreenshots',
      desc: '',
      args: [],
    );
  }

  /// `Visit our help center`
  String get visitHelpCenter {
    return Intl.message(
      'Visit our help center',
      name: 'visitHelpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Binding an auxiliary device`
  String get bindingAuxiliaryDevice {
    return Intl.message(
      'Binding an auxiliary device',
      name: 'bindingAuxiliaryDevice',
      desc: '',
      args: [],
    );
  }

  /// `Register a new account`
  String get registerNewAccount {
    return Intl.message(
      'Register a new account',
      name: 'registerNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Scan this code to use Chatify on multiple phones. Sign in to your primary phone every 14 days to keep that phone connected.`
  String get scanCodeUse {
    return Intl.message(
      'Scan this code to use Chatify on multiple phones. Sign in to your primary phone every 14 days to keep that phone connected.',
      name: 'scanCodeUse',
      desc: '',
      args: [],
    );
  }

  /// `The QR code has expired`
  String get qrCodeExpired {
    return Intl.message(
      'The QR code has expired',
      name: 'qrCodeExpired',
      desc: '',
      args: [],
    );
  }

  /// `Reboot`
  String get reboot {
    return Intl.message('Reboot', name: 'reboot', desc: '', args: []);
  }

  /// `Open Chatify on your primary phone`
  String get openAppYourPrimary {
    return Intl.message(
      'Open Chatify on your primary phone',
      name: 'openAppYourPrimary',
      desc: '',
      args: [],
    );
  }

  /// `Press `
  String get press {
    return Intl.message('Press ', name: 'press', desc: '', args: []);
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `on Android or`
  String get onAndroid {
    return Intl.message('on Android or', name: 'onAndroid', desc: '', args: []);
  }

  /// ` on iPhone`
  String get oniPhone {
    return Intl.message(' on iPhone', name: 'oniPhone', desc: '', args: []);
  }

  /// `Related Devices`
  String get appRelatedDevices {
    return Intl.message(
      'Related Devices',
      name: 'appRelatedDevices',
      desc: '',
      args: [],
    );
  }

  /// ` Linked Devices, `
  String get relatedDevices {
    return Intl.message(
      ' Linked Devices, ',
      name: 'relatedDevices',
      desc: '',
      args: [],
    );
  }

  /// ` then `
  String get then {
    return Intl.message(' then ', name: 'then', desc: '', args: []);
  }

  /// `Link Device`
  String get linkingDevice {
    return Intl.message(
      'Link Device',
      name: 'linkingDevice',
      desc: '',
      args: [],
    );
  }

  /// `Point your phone at this screen to scan the QR-code`
  String get pointYourPhone {
    return Intl.message(
      'Point your phone at this screen to scan the QR-code',
      name: 'pointYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Adding an account`
  String get addingAccount {
    return Intl.message(
      'Adding an account',
      name: 'addingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please read our `
  String get checkOutOur {
    return Intl.message(
      'Please read our ',
      name: 'checkOutOur',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `. Click «Accept and Continue» to accept the `
  String get acceptContinue {
    return Intl.message(
      '. Click «Accept and Continue» to accept the ',
      name: 'acceptContinue',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Accept and Continue`
  String get acceptAndContinue {
    return Intl.message(
      'Accept and Continue',
      name: 'acceptAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `By default`
  String get byDefault {
    return Intl.message('By default', name: 'byDefault', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `Launch Chatify when you sign in`
  String get launchOnLogin {
    return Intl.message(
      'Launch Chatify when you sign in',
      name: 'launchOnLogin',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get off {
    return Intl.message('Off', name: 'off', desc: '', args: []);
  }

  /// `Enter`
  String get enter {
    return Intl.message('Enter', name: 'enter', desc: '', args: []);
  }

  /// `Change your input settings for autocorrect and fingerprint highlighting in `
  String get changeInputSettings {
    return Intl.message(
      'Change your input settings for autocorrect and fingerprint highlighting in ',
      name: 'changeInputSettings',
      desc: '',
      args: [],
    );
  }

  /// `Windows settings`
  String get windowsSettings {
    return Intl.message(
      'Windows settings',
      name: 'windowsSettings',
      desc: '',
      args: [],
    );
  }

  /// `Replacing text with emoji`
  String get replacingTextEmoticons {
    return Intl.message(
      'Replacing text with emoji',
      name: 'replacingTextEmoticons',
      desc: '',
      args: [],
    );
  }

  /// `Some text combinations will be replaced with emoji as you type.`
  String get textCombinationsReplaced {
    return Intl.message(
      'Some text combinations will be replaced with emoji as you type.',
      name: 'textCombinationsReplaced',
      desc: '',
      args: [],
    );
  }

  /// `View a list of text symbols`
  String get viewListTextSymbols {
    return Intl.message(
      'View a list of text symbols',
      name: 'viewListTextSymbols',
      desc: '',
      args: [],
    );
  }

  /// `To `
  String get to {
    return Intl.message('To ', name: 'to', desc: '', args: []);
  }

  /// `sign out`
  String get signOut {
    return Intl.message('sign out', name: 'signOut', desc: '', args: []);
  }

  /// `from Chatify on this computer, go to your `
  String get onComputerGoYour {
    return Intl.message(
      'from Chatify on this computer, go to your ',
      name: 'onComputerGoYour',
      desc: '',
      args: [],
    );
  }

  /// `profile`
  String get profileLink {
    return Intl.message('profile', name: 'profileLink', desc: '', args: []);
  }

  /// `If this setting is enabled, the following Below, text symbols will be replaced with emoticons when typing.`
  String get replacedEmoticonsYouType {
    return Intl.message(
      'If this setting is enabled, the following Below, text symbols will be replaced with emoticons when typing.',
      name: 'replacedEmoticonsYouType',
      desc: '',
      args: [],
    );
  }

  /// `recipient`
  String get recipient {
    return Intl.message('recipient', name: 'recipient', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Group photo removed`
  String get groupPhotoRemoved {
    return Intl.message(
      'Group photo removed',
      name: 'groupPhotoRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete group photo.`
  String get failedDeleteGroupPhoto {
    return Intl.message(
      'Failed to delete group photo.',
      name: 'failedDeleteGroupPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Error!`
  String get error {
    return Intl.message('Error!', name: 'error', desc: '', args: []);
  }

  /// `Control on your phone`
  String get controlYourPhone {
    return Intl.message(
      'Control on your phone',
      name: 'controlYourPhone',
      desc: '',
      args: [],
    );
  }

  /// `Last seen time in "online" status`
  String get lastSeenTimeOnlineStatus {
    return Intl.message(
      'Last seen time in "online" status',
      name: 'lastSeenTimeOnlineStatus',
      desc: '',
      args: [],
    );
  }

  /// `My Contacts, All`
  String get myContactsAll {
    return Intl.message(
      'My Contacts, All',
      name: 'myContactsAll',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get intelligence {
    return Intl.message(
      'Information',
      name: 'intelligence',
      desc: '',
      args: [],
    );
  }

  /// `Adding to groups`
  String get addingGroups {
    return Intl.message(
      'Adding to groups',
      name: 'addingGroups',
      desc: '',
      args: [],
    );
  }

  /// `Read receipts`
  String get readingReports {
    return Intl.message(
      'Read receipts',
      name: 'readingReports',
      desc: '',
      args: [],
    );
  }

  /// `Read receipts cannot be disabled for group chats.`
  String get readReceiptsCannotDisabled {
    return Intl.message(
      'Read receipts cannot be disabled for group chats.',
      name: 'readReceiptsCannotDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Blocked contacts`
  String get blockedContacts {
    return Intl.message(
      'Blocked contacts',
      name: 'blockedContacts',
      desc: '',
      args: [],
    );
  }

  /// `No blocked contacts`
  String get noBlockedContacts {
    return Intl.message(
      'No blocked contacts',
      name: 'noBlockedContacts',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message('Security', name: 'security', desc: '', args: []);
  }

  /// `Your chats and calls are private`
  String get chatsCallsConfidential {
    return Intl.message(
      'Your chats and calls are private',
      name: 'chatsCallsConfidential',
      desc: '',
      args: [],
    );
  }

  /// `End-to-end encryption keeps your messages and calls private between you and the people you choose. No one outside the chat, not even Chatify, can read, listen, or share them. This includes:`
  String get encryptionKeepsYourMessages {
    return Intl.message(
      'End-to-end encryption keeps your messages and calls private between you and the people you choose. No one outside the chat, not even Chatify, can read, listen, or share them. This includes:',
      name: 'encryptionKeepsYourMessages',
      desc: '',
      args: [],
    );
  }

  /// `Text and voice messages`
  String get textVoiceMessages {
    return Intl.message(
      'Text and voice messages',
      name: 'textVoiceMessages',
      desc: '',
      args: [],
    );
  }

  /// `Audio and video calls`
  String get audioVideoCalls {
    return Intl.message(
      'Audio and video calls',
      name: 'audioVideoCalls',
      desc: '',
      args: [],
    );
  }

  /// `Photos, videos, and documents`
  String get photosVideosDocuments {
    return Intl.message(
      'Photos, videos, and documents',
      name: 'photosVideosDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Location sharing`
  String get locationSharing {
    return Intl.message(
      'Location sharing',
      name: 'locationSharing',
      desc: '',
      args: [],
    );
  }

  /// `Status update`
  String get statusUpdate {
    return Intl.message(
      'Status update',
      name: 'statusUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Learn more`
  String get readMore {
    return Intl.message('Learn more', name: 'readMore', desc: '', args: []);
  }

  /// `Show security notifications on this computer`
  String get securityNotifyComputer {
    return Intl.message(
      'Show security notifications on this computer',
      name: 'securityNotifyComputer',
      desc: '',
      args: [],
    );
  }

  /// `Get notified when a contact's phone security code changes. If you have multiple devices, you must enable this setting separately on each device where you want to receive these notifications. `
  String get receiveNotifyPhoneSecurityCode {
    return Intl.message(
      'Get notified when a contact\'s phone security code changes. If you have multiple devices, you must enable this setting separately on each device where you want to receive these notifications. ',
      name: 'receiveNotifyPhoneSecurityCode',
      desc: '',
      args: [],
    );
  }

  /// `How to delete your account`
  String get howDeleteYourAccount {
    return Intl.message(
      'How to delete your account',
      name: 'howDeleteYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful, you are logged in!`
  String get registrationSuccessful {
    return Intl.message(
      'Registration successful, you are logged in!',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Error during registration`
  String get errorRegistration {
    return Intl.message(
      'Error during registration',
      name: 'errorRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error during registration`
  String get unknownErrorRegistration {
    return Intl.message(
      'Unknown error during registration',
      name: 'unknownErrorRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Login by email`
  String get loginByMail {
    return Intl.message(
      'Login by email',
      name: 'loginByMail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and password to log in to Chatify.`
  String get enterYourEmailLogInApp {
    return Intl.message(
      'Enter your email and password to log in to Chatify.',
      name: 'enterYourEmailLogInApp',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `To install Chatify on your computer:`
  String get installYourComputer {
    return Intl.message(
      'To install Chatify on your computer:',
      name: 'installYourComputer',
      desc: '',
      args: [],
    );
  }

  /// `Connect by phone number`
  String get contactPhoneNumber {
    return Intl.message(
      'Connect by phone number',
      name: 'contactPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Number confirmation`
  String get numberConfirm {
    return Intl.message(
      'Number confirmation',
      name: 'numberConfirm',
      desc: '',
      args: [],
    );
  }

  /// `SMS sent to number \n`
  String get smsSentNumber {
    return Intl.message(
      'SMS sent to number \n',
      name: 'smsSentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Invalid number?`
  String get invalidNumber {
    return Intl.message(
      'Invalid number?',
      name: 'invalidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive code?`
  String get noReceiveCode {
    return Intl.message(
      'Didn\'t receive code?',
      name: 'noReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful.`
  String get registrationSuccess {
    return Intl.message(
      'Registration successful.',
      name: 'registrationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Warning!`
  String get warning {
    return Intl.message('Warning!', name: 'warning', desc: '', args: []);
  }

  /// `Incorrect OTP code`
  String get incorrectOtpCode {
    return Intl.message(
      'Incorrect OTP code',
      name: 'incorrectOtpCode',
      desc: '',
      args: [],
    );
  }

  /// `Error checking OTP code.`
  String get errorCheckingOtpCode {
    return Intl.message(
      'Error checking OTP code.',
      name: 'errorCheckingOtpCode',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Didn't receive your confirmation code?`
  String get receiveYourConfirmCode {
    return Intl.message(
      'Didn\'t receive your confirmation code?',
      name: 'receiveYourConfirmCode',
      desc: '',
      args: [],
    );
  }

  /// `Please check your SMS messages before requesting a new code.`
  String get pleaseCheckYourSmsMessagesNewCode {
    return Intl.message(
      'Please check your SMS messages before requesting a new code.',
      name: 'pleaseCheckYourSmsMessagesNewCode',
      desc: '',
      args: [],
    );
  }

  /// `Repeat SMS`
  String get repeatSms {
    return Intl.message('Repeat SMS', name: 'repeatSms', desc: '', args: []);
  }

  /// `Call me`
  String get callMe {
    return Intl.message('Call me', name: 'callMe', desc: '', args: []);
  }

  /// `Is this the correct number?`
  String get isCorrectNumber {
    return Intl.message(
      'Is this the correct number?',
      name: 'isCorrectNumber',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Who can see my status updates`
  String get seeMyStatusUpdates {
    return Intl.message(
      'Who can see my status updates',
      name: 'seeMyStatusUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Contacts except...`
  String get contactsOtherThan {
    return Intl.message(
      'Contacts except...',
      name: 'contactsOtherThan',
      desc: '',
      args: [],
    );
  }

  /// `Excl. 0`
  String get exceptions {
    return Intl.message('Excl. 0', name: 'exceptions', desc: '', args: []);
  }

  /// `On 0`
  String get onZero {
    return Intl.message('On 0', name: 'onZero', desc: '', args: []);
  }

  /// `Done`
  String get ready {
    return Intl.message('Done', name: 'ready', desc: '', args: []);
  }

  /// `Add signature...`
  String get addSignature {
    return Intl.message(
      'Add signature...',
      name: 'addSignature',
      desc: '',
      args: [],
    );
  }

  /// `Please select only messages from one user.`
  String get pleaseSelectOnlyMessages {
    return Intl.message(
      'Please select only messages from one user.',
      name: 'pleaseSelectOnlyMessages',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Pin it`
  String get pinIt {
    return Intl.message('Pin it', name: 'pinIt', desc: '', args: []);
  }

  /// `Complain`
  String get complain {
    return Intl.message('Complain', name: 'complain', desc: '', args: []);
  }

  /// `Search for contacts`
  String get searchContacts {
    return Intl.message(
      'Search for contacts',
      name: 'searchContacts',
      desc: '',
      args: [],
    );
  }

  /// `Contacts to send`
  String get contactsSending {
    return Intl.message(
      'Contacts to send',
      name: 'contactsSending',
      desc: '',
      args: [],
    );
  }

  /// `Selected: 0 of 256`
  String get selected {
    return Intl.message(
      'Selected: 0 of 256',
      name: 'selected',
      desc: '',
      args: [],
    );
  }

  /// `At least 2 contacts must be selected`
  String get atLeastTwoContactsSelected {
    return Intl.message(
      'At least 2 contacts must be selected',
      name: 'atLeastTwoContactsSelected',
      desc: '',
      args: [],
    );
  }

  /// `Error creating mailing list`
  String get errorCreatingMailingList {
    return Intl.message(
      'Error creating mailing list',
      name: 'errorCreatingMailingList',
      desc: '',
      args: [],
    );
  }

  /// `Create Poll`
  String get createPoll {
    return Intl.message('Create Poll', name: 'createPoll', desc: '', args: []);
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Ask a question`
  String get askQuestion {
    return Intl.message(
      'Ask a question',
      name: 'askQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message('Options', name: 'options', desc: '', args: []);
  }

  /// `+ add`
  String get addPlus {
    return Intl.message('+ add', name: 'addPlus', desc: '', args: []);
  }

  /// `Allow multiple answers`
  String get allowMultipleAnswers {
    return Intl.message(
      'Allow multiple answers',
      name: 'allowMultipleAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Add a question or at least two answer options`
  String get addQuestionTwoAnswerOptions {
    return Intl.message(
      'Add a question or at least two answer options',
      name: 'addQuestionTwoAnswerOptions',
      desc: '',
      args: [],
    );
  }

  /// `Group Permissions`
  String get groupPermissions {
    return Intl.message(
      'Group Permissions',
      name: 'groupPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Participants can:`
  String get participantsCan {
    return Intl.message(
      'Participants can:',
      name: 'participantsCan',
      desc: '',
      args: [],
    );
  }

  /// `Change settings`
  String get changeSettings {
    return Intl.message(
      'Change settings',
      name: 'changeSettings',
      desc: '',
      args: [],
    );
  }

  /// `groups`
  String get groups {
    return Intl.message('groups', name: 'groups', desc: '', args: []);
  }

  /// `This includes the group name, picture, and description, the disappearing message timer, and the settings for saving and pinning messages.`
  String get groupIncludes {
    return Intl.message(
      'This includes the group name, picture, and description, the disappearing message timer, and the settings for saving and pinning messages.',
      name: 'groupIncludes',
      desc: '',
      args: [],
    );
  }

  /// `Send messages`
  String get sendMessages {
    return Intl.message(
      'Send messages',
      name: 'sendMessages',
      desc: '',
      args: [],
    );
  }

  /// `Add other participants`
  String get addOtherParticipants {
    return Intl.message(
      'Add other participants',
      name: 'addOtherParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Admins can:`
  String get adminsCan {
    return Intl.message('Admins can:', name: 'adminsCan', desc: '', args: []);
  }

  /// `Confirm new members`
  String get confirmNewMembers {
    return Intl.message(
      'Confirm new members',
      name: 'confirmNewMembers',
      desc: '',
      args: [],
    );
  }

  /// `If enabled, admins will need to confirm all requests to join the group.`
  String get enabledAdminsJoinGroup {
    return Intl.message(
      'If enabled, admins will need to confirm all requests to join the group.',
      name: 'enabledAdminsJoinGroup',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get pressAgainExit {
    return Intl.message(
      'Press again to exit',
      name: 'pressAgainExit',
      desc: '',
      args: [],
    );
  }

  /// `Unable to delete other users' chats`
  String get unableDeleteUsersChats {
    return Intl.message(
      'Unable to delete other users\' chats',
      name: 'unableDeleteUsersChats',
      desc: '',
      args: [],
    );
  }

  /// `Your contact list has been updated!`
  String get yourContactListUpdated {
    return Intl.message(
      'Your contact list has been updated!',
      name: 'yourContactListUpdated',
      desc: '',
      args: [],
    );
  }

  /// `New mailing`
  String get newMailing {
    return Intl.message('New mailing', name: 'newMailing', desc: '', args: []);
  }

  /// `Choose`
  String get choose {
    return Intl.message('Choose', name: 'choose', desc: '', args: []);
  }

  /// ` contacts`
  String get totalCountContacts {
    return Intl.message(
      ' contacts',
      name: 'totalCountContacts',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Contacts`
  String get contacts {
    return Intl.message('Contacts', name: 'contacts', desc: '', args: []);
  }

  /// `New contact`
  String get newContact {
    return Intl.message('New contact', name: 'newContact', desc: '', args: []);
  }

  /// `Contacts in Chatify`
  String get contactsOnApp {
    return Intl.message(
      'Contacts in Chatify',
      name: 'contactsOnApp',
      desc: '',
      args: [],
    );
  }

  /// `Invite to Chatify`
  String get inviteOnApp {
    return Intl.message(
      'Invite to Chatify',
      name: 'inviteOnApp',
      desc: '',
      args: [],
    );
  }

  /// `Let's chat in Chatify. This is a fast, convenient and safe application for free communication with each other. Download https://inputstudios.ru/download`
  String get letsChatInApp {
    return Intl.message(
      'Let\'s chat in Chatify. This is a fast, convenient and safe application for free communication with each other. Download https://inputstudios.ru/download',
      name: 'letsChatInApp',
      desc: '',
      args: [],
    );
  }

  /// `Failed to open contacts`
  String get failedOpenContacts {
    return Intl.message(
      'Failed to open contacts',
      name: 'failedOpenContacts',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 contact must be selected`
  String get atLeastOneContactSelected {
    return Intl.message(
      'At least 1 contact must be selected',
      name: 'atLeastOneContactSelected',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter`
  String get newsletter {
    return Intl.message('Newsletter', name: 'newsletter', desc: '', args: []);
  }

  /// `Only contacts with +7 999 888-77-66 in their address books will receive your bulk message.`
  String get onlyContactsPhoneNumber {
    return Intl.message(
      'Only contacts with +7 999 888-77-66 in their address books will receive your bulk message.',
      name: 'onlyContactsPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `A minimum of 2 contacts must be selected`
  String get leastTwoContactsMustBeSelected {
    return Intl.message(
      'A minimum of 2 contacts must be selected',
      name: 'leastTwoContactsMustBeSelected',
      desc: '',
      args: [],
    );
  }

  /// `With end-to-end encryption, your private messages and calls stay between you and the people you're communicating with. Not even Chatify can access them. These include:`
  String get yourPrivateMessagesAndCalls {
    return Intl.message(
      'With end-to-end encryption, your private messages and calls stay between you and the people you\'re communicating with. Not even Chatify can access them. These include:',
      name: 'yourPrivateMessagesAndCalls',
      desc: '',
      args: [],
    );
  }

  /// ` Messages and calls are protected by end-to-end encryption. Third parties, including Chatify, cannot read your messages or listen to your calls. Click to learn more.`
  String get messagesCallsProtectedEncryption {
    return Intl.message(
      ' Messages and calls are protected by end-to-end encryption. Third parties, including Chatify, cannot read your messages or listen to your calls. Click to learn more.',
      name: 'messagesCallsProtectedEncryption',
      desc: '',
      args: [],
    );
  }

  /// `You have created a mailing list with `
  String get youCreatedMailingList {
    return Intl.message(
      'You have created a mailing list with ',
      name: 'youCreatedMailingList',
      desc: '',
      args: [],
    );
  }

  /// `recipients`
  String get recipients {
    return Intl.message('recipients', name: 'recipients', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Error loading names`
  String get errorLoadingNames {
    return Intl.message(
      'Error loading names',
      name: 'errorLoadingNames',
      desc: '',
      args: [],
    );
  }

  /// `No members`
  String get noMembers {
    return Intl.message('No members', name: 'noMembers', desc: '', args: []);
  }

  /// `Unknown user`
  String get unknownUser {
    return Intl.message(
      'Unknown user',
      name: 'unknownUser',
      desc: '',
      args: [],
    );
  }

  /// `Mailing list data`
  String get mailingListData {
    return Intl.message(
      'Mailing list data',
      name: 'mailingListData',
      desc: '',
      args: [],
    );
  }

  /// `Mailing list media`
  String get mediaMailings {
    return Intl.message(
      'Mailing list media',
      name: 'mediaMailings',
      desc: '',
      args: [],
    );
  }

  /// `Wallpaper`
  String get wallpaper {
    return Intl.message('Wallpaper', name: 'wallpaper', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Add chat icon to screen`
  String get addChatIconScreen {
    return Intl.message(
      'Add chat icon to screen',
      name: 'addChatIconScreen',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Community`
  String get unknownCommunity {
    return Intl.message(
      'Unknown Community',
      name: 'unknownCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Date not specified`
  String get dateNotSpecified {
    return Intl.message(
      'Date not specified',
      name: 'dateNotSpecified',
      desc: '',
      args: [],
    );
  }

  /// `Invalid date`
  String get invalidDate {
    return Intl.message(
      'Invalid date',
      name: 'invalidDate',
      desc: '',
      args: [],
    );
  }

  /// `Open navigation`
  String get openNavigation {
    return Intl.message(
      'Open navigation',
      name: 'openNavigation',
      desc: '',
      args: [],
    );
  }

  /// `In archive`
  String get inArchive {
    return Intl.message('In archive', name: 'inArchive', desc: '', args: []);
  }

  /// `Search in chat archive`
  String get searchInChatSArchive {
    return Intl.message(
      'Search in chat archive',
      name: 'searchInChatSArchive',
      desc: '',
      args: [],
    );
  }

  /// `Archiving settings`
  String get settingsArchive {
    return Intl.message(
      'Archiving settings',
      name: 'settingsArchive',
      desc: '',
      args: [],
    );
  }

  /// `New link to call`
  String get newLinkCall {
    return Intl.message(
      'New link to call',
      name: 'newLinkCall',
      desc: '',
      args: [],
    );
  }

  /// `Call number`
  String get callNumber {
    return Intl.message('Call number', name: 'callNumber', desc: '', args: []);
  }

  /// `New call (Ctrl+Shift+C)`
  String get newCall {
    return Intl.message(
      'New call (Ctrl+Shift+C)',
      name: 'newCall',
      desc: '',
      args: [],
    );
  }

  /// `Search or new call`
  String get searchNewCall {
    return Intl.message(
      'Search or new call',
      name: 'searchNewCall',
      desc: '',
      args: [],
    );
  }

  /// `Search or new chat`
  String get searchNewChat {
    return Intl.message(
      'Search or new chat',
      name: 'searchNewChat',
      desc: '',
      args: [],
    );
  }

  /// `Search favorite messages`
  String get searchFavoriteMessages {
    return Intl.message(
      'Search favorite messages',
      name: 'searchFavoriteMessages',
      desc: '',
      args: [],
    );
  }

  /// `No results`
  String get noResults {
    return Intl.message('No results', name: 'noResults', desc: '', args: []);
  }

  /// `Your private messages are protected `
  String get yourPrivateMessagesProtected {
    return Intl.message(
      'Your private messages are protected ',
      name: 'yourPrivateMessagesProtected',
      desc: '',
      args: [],
    );
  }

  /// `Your chats and calls are private`
  String get yourChatsCallsConfidential {
    return Intl.message(
      'Your chats and calls are private',
      name: 'yourChatsCallsConfidential',
      desc: '',
      args: [],
    );
  }

  /// `Chatify for Windows`
  String get appForWindows {
    return Intl.message(
      'Chatify for Windows',
      name: 'appForWindows',
      desc: '',
      args: [],
    );
  }

  /// `You can send and receive messages without having to leave your phone connected. Use Chatify on up to four linked devices and one phone at a time.`
  String get sendReceiveMessagesFourLinkDevice {
    return Intl.message(
      'You can send and receive messages without having to leave your phone connected. Use Chatify on up to four linked devices and one phone at a time.',
      name: 'sendReceiveMessagesFourLinkDevice',
      desc: '',
      args: [],
    );
  }

  /// `Protected with end-to-end encryption`
  String get protectedEncryption {
    return Intl.message(
      'Protected with end-to-end encryption',
      name: 'protectedEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Tap a contact's name to see their status`
  String get clickContactNameStatus {
    return Intl.message(
      'Tap a contact\'s name to see their status',
      name: 'clickContactNameStatus',
      desc: '',
      args: [],
    );
  }

  /// `Status updates are protected with end-to-end encryption`
  String get statusUpdatesProtectedEncryption {
    return Intl.message(
      'Status updates are protected with end-to-end encryption',
      name: 'statusUpdatesProtectedEncryption',
      desc: '',
      args: [],
    );
  }

  /// `My status`
  String get myStatus {
    return Intl.message('My status', name: 'myStatus', desc: '', args: []);
  }

  /// `No updates`
  String get noUpdates {
    return Intl.message('No updates', name: 'noUpdates', desc: '', args: []);
  }

  /// `No new status`
  String get noNewStatus {
    return Intl.message(
      'No new status',
      name: 'noNewStatus',
      desc: '',
      args: [],
    );
  }

  /// `Video and Audio`
  String get videoAudio {
    return Intl.message(
      'Video and Audio',
      name: 'videoAudio',
      desc: '',
      args: [],
    );
  }

  /// `Personalization`
  String get personalization {
    return Intl.message(
      'Personalization',
      name: 'personalization',
      desc: '',
      args: [],
    );
  }

  /// `Storage`
  String get storage {
    return Intl.message('Storage', name: 'storage', desc: '', args: []);
  }

  /// `Hotkeys`
  String get hotKeys {
    return Intl.message('Hotkeys', name: 'hotKeys', desc: '', args: []);
  }

  /// `Links`
  String get links {
    return Intl.message('Links', name: 'links', desc: '', args: []);
  }

  /// `Adding data about`
  String get addDataAbout {
    return Intl.message(
      'Adding data about',
      name: 'addDataAbout',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Error playing sound`
  String get errorPlayingSound {
    return Intl.message(
      'Error playing sound',
      name: 'errorPlayingSound',
      desc: '',
      args: [],
    );
  }

  /// `Error signing in with Google`
  String get errorSigningInWithGoogle {
    return Intl.message(
      'Error signing in with Google',
      name: 'errorSigningInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Google Authorization`
  String get googleAuthorization {
    return Intl.message(
      'Google Authorization',
      name: 'googleAuthorization',
      desc: '',
      args: [],
    );
  }

  /// `Click on the link to log in:`
  String get clickOnLinkToLogIn {
    return Intl.message(
      'Click on the link to log in:',
      name: 'clickOnLinkToLogIn',
      desc: '',
      args: [],
    );
  }

  /// `Verification Error`
  String get verificationError {
    return Intl.message(
      'Verification Error',
      name: 'verificationError',
      desc: '',
      args: [],
    );
  }

  /// `Chatify Support`
  String get chatifySupport {
    return Intl.message(
      'Chatify Support',
      name: 'chatifySupport',
      desc: '',
      args: [],
    );
  }

  /// `Select Messages`
  String get selectMessages {
    return Intl.message(
      'Select Messages',
      name: 'selectMessages',
      desc: '',
      args: [],
    );
  }

  /// `Open Chat in Another Window`
  String get openChatInAnotherWindow {
    return Intl.message(
      'Open Chat in Another Window',
      name: 'openChatInAnotherWindow',
      desc: '',
      args: [],
    );
  }

  /// `Close Chat`
  String get closeChat {
    return Intl.message('Close Chat', name: 'closeChat', desc: '', args: []);
  }

  /// `You are communicating with the official Chatify Support account. Click here to learn more.`
  String get officialAppSupportAccount {
    return Intl.message(
      'You are communicating with the official Chatify Support account. Click here to learn more.',
      name: 'officialAppSupportAccount',
      desc: '',
      args: [],
    );
  }

  /// `You are communicating with the official "Chatify Support" business account.`
  String get officialAppSupportBusinessAccount {
    return Intl.message(
      'You are communicating with the official "Chatify Support" business account.',
      name: 'officialAppSupportBusinessAccount',
      desc: '',
      args: [],
    );
  }

  /// `Chatify confirms that this is the official "Chatify Support" business account.`
  String get appConfirmsOfficialAppSupport {
    return Intl.message(
      'Chatify confirms that this is the official "Chatify Support" business account.',
      name: 'appConfirmsOfficialAppSupport',
      desc: '',
      args: [],
    );
  }

  /// `Messages may be AI-generated and may be inaccurate or inappropriate. Click to learn more.`
  String get messagesAIGeneratedInappropriate {
    return Intl.message(
      'Messages may be AI-generated and may be inaccurate or inappropriate. Click to learn more.',
      name: 'messagesAIGeneratedInappropriate',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Swipe up to accept`
  String get swipeUpToAccept {
    return Intl.message(
      'Swipe up to accept',
      name: 'swipeUpToAccept',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Error starting ringtone`
  String get errorStartingRingingTone {
    return Intl.message(
      'Error starting ringtone',
      name: 'errorStartingRingingTone',
      desc: '',
      args: [],
    );
  }

  /// `Error stopping ringtone`
  String get errorStopingRingingTone {
    return Intl.message(
      'Error stopping ringtone',
      name: 'errorStopingRingingTone',
      desc: '',
      args: [],
    );
  }

  /// `Protected with end-to-end encryption`
  String get protectedWithEndToEndEncryption {
    return Intl.message(
      'Protected with end-to-end encryption',
      name: 'protectedWithEndToEndEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Switch to video call`
  String get switchToVideoCall {
    return Intl.message(
      'Switch to video call',
      name: 'switchToVideoCall',
      desc: '',
      args: [],
    );
  }

  /// `Toggle`
  String get toggle {
    return Intl.message('Toggle', name: 'toggle', desc: '', args: []);
  }

  /// `Microphone access denied`
  String get microPermissionDenied {
    return Intl.message(
      'Microphone access denied',
      name: 'microPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Error initializing camera`
  String get errorInitCamera {
    return Intl.message(
      'Error initializing camera',
      name: 'errorInitCamera',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission denied`
  String get cameraPermissionDenied {
    return Intl.message(
      'Camera permission denied',
      name: 'cameraPermissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `No cameras available`
  String get noCamerasAvailable {
    return Intl.message(
      'No cameras available',
      name: 'noCamerasAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Error initializing recorder`
  String get errorInitRecorder {
    return Intl.message(
      'Error initializing recorder',
      name: 'errorInitRecorder',
      desc: '',
      args: [],
    );
  }

  /// `Error starting video recording`
  String get errorStartingVideoRecording {
    return Intl.message(
      'Error starting video recording',
      name: 'errorStartingVideoRecording',
      desc: '',
      args: [],
    );
  }

  /// `Error stopping video recording`
  String get errorStoppingVideoRecording {
    return Intl.message(
      'Error stopping video recording',
      name: 'errorStoppingVideoRecording',
      desc: '',
      args: [],
    );
  }

  /// `Error switching camera`
  String get errorSwitchingCamera {
    return Intl.message(
      'Error switching camera',
      name: 'errorSwitchingCamera',
      desc: '',
      args: [],
    );
  }

  /// `Error starting microphone recording`
  String get errorStartingMicroRecording {
    return Intl.message(
      'Error starting microphone recording',
      name: 'errorStartingMicroRecording',
      desc: '',
      args: [],
    );
  }

  /// `Error stopping microphone recording`
  String get errorStoppingMicroRecording {
    return Intl.message(
      'Error stopping microphone recording',
      name: 'errorStoppingMicroRecording',
      desc: '',
      args: [],
    );
  }

  /// `Recorder initialized`
  String get recorderInitialized {
    return Intl.message(
      'Recorder initialized',
      name: 'recorderInitialized',
      desc: '',
      args: [],
    );
  }

  /// `Error in onTap`
  String get errorInOnTap {
    return Intl.message(
      'Error in onTap',
      name: 'errorInOnTap',
      desc: '',
      args: [],
    );
  }

  /// `Add to Favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to Favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Adding Participants`
  String get addingParticipants {
    return Intl.message(
      'Adding Participants',
      name: 'addingParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Share a link`
  String get shareLink {
    return Intl.message('Share a link', name: 'shareLink', desc: '', args: []);
  }

  /// `Other contacts`
  String get otherContacts {
    return Intl.message(
      'Other contacts',
      name: 'otherContacts',
      desc: '',
      args: [],
    );
  }

  /// `Join my Chatify audio call using this link`
  String get joinMyAppAudioCallLink {
    return Intl.message(
      'Join my Chatify audio call using this link',
      name: 'joinMyAppAudioCallLink',
      desc: '',
      args: [],
    );
  }

  /// `Failed to open the SMS app.`
  String get failedToOpenSMSApp {
    return Intl.message(
      'Failed to open the SMS app.',
      name: 'failedToOpenSMSApp',
      desc: '',
      args: [],
    );
  }

  /// `To call contacts who have Chatify, `
  String get toCallContactsWhoHaveApp {
    return Intl.message(
      'To call contacts who have Chatify, ',
      name: 'toCallContactsWhoHaveApp',
      desc: '',
      args: [],
    );
  }

  /// `click the call icon at the bottom of the screen`
  String get clickOnCallIconBottomScreen {
    return Intl.message(
      'click the call icon at the bottom of the screen',
      name: 'clickOnCallIconBottomScreen',
      desc: '',
      args: [],
    );
  }

  /// `Recent`
  String get recent {
    return Intl.message('Recent', name: 'recent', desc: '', args: []);
  }

  /// `Create a call link`
  String get createCallLink {
    return Intl.message(
      'Create a call link',
      name: 'createCallLink',
      desc: '',
      args: [],
    );
  }

  /// `Any Chatify user can join a call using this link. Only share it with people you trust.`
  String get anyAppUserJoinCallUsingLink {
    return Intl.message(
      'Any Chatify user can join a call using this link. Only share it with people you trust.',
      name: 'anyAppUserJoinCallUsingLink',
      desc: '',
      args: [],
    );
  }

  /// `Select call type`
  String get selectCallType {
    return Intl.message(
      'Select call type',
      name: 'selectCallType',
      desc: '',
      args: [],
    );
  }

  /// `Call type`
  String get callType {
    return Intl.message('Call type', name: 'callType', desc: '', args: []);
  }

  /// `Send link via Chatify`
  String get sendLinkViaApp {
    return Intl.message(
      'Send link via Chatify',
      name: 'sendLinkViaApp',
      desc: '',
      args: [],
    );
  }

  /// `Link copied`
  String get linkCopied {
    return Intl.message('Link copied', name: 'linkCopied', desc: '', args: []);
  }

  /// `Copy link`
  String get copyLink {
    return Intl.message('Copy link', name: 'copyLink', desc: '', args: []);
  }

  /// `Call Link`
  String get callLink {
    return Intl.message('Call Link', name: 'callLink', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Join`
  String get join {
    return Intl.message('Join', name: 'join', desc: '', args: []);
  }

  /// `Chatify Call`
  String get appCall {
    return Intl.message('Chatify Call', name: 'appCall', desc: '', args: []);
  }

  /// `Waiting for other participants`
  String get waitingOtherParticipants {
    return Intl.message(
      'Waiting for other participants',
      name: 'waitingOtherParticipants',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message('You', name: 'you', desc: '', args: []);
  }

  /// `(you)`
  String get youCall {
    return Intl.message('(you)', name: 'youCall', desc: '', args: []);
  }

  /// `Failed to open the add contact screen.`
  String get failedToOpenContactAddScreen {
    return Intl.message(
      'Failed to open the add contact screen.',
      name: 'failedToOpenContactAddScreen',
      desc: '',
      args: [],
    );
  }

  /// `Add info`
  String get addInfo {
    return Intl.message('Add info', name: 'addInfo', desc: '', args: []);
  }

  /// `contact`
  String get selectContacts {
    return Intl.message('contact', name: 'selectContacts', desc: '', args: []);
  }

  /// `Add up to 31 people`
  String get addUpToThirtyOnePeople {
    return Intl.message(
      'Add up to 31 people',
      name: 'addUpToThirtyOnePeople',
      desc: '',
      args: [],
    );
  }

  /// `Schedule a call`
  String get scheduleCall {
    return Intl.message(
      'Schedule a call',
      name: 'scheduleCall',
      desc: '',
      args: [],
    );
  }

  /// `Call number: `
  String get callsNumber {
    return Intl.message(
      'Call number: ',
      name: 'callsNumber',
      desc: '',
      args: [],
    );
  }

  /// `Call via mobile operator`
  String get callViaMobileOperator {
    return Intl.message(
      'Call via mobile operator',
      name: 'callViaMobileOperator',
      desc: '',
      args: [],
    );
  }

  /// `Phone call permission not granted granted`
  String get phoneCallPermissionNotGranted {
    return Intl.message(
      'Phone call permission not granted granted',
      name: 'phoneCallPermissionNotGranted',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear all call logs?`
  String get areYouSureClearAllCallLogs {
    return Intl.message(
      'Are you sure you want to clear all call logs?',
      name: 'areYouSureClearAllCallLogs',
      desc: '',
      args: [],
    );
  }

  /// `Create a new contact or add to an existing one?`
  String get createNewContactOrAddExistingOne {
    return Intl.message(
      'Create a new contact or add to an existing one?',
      name: 'createNewContactOrAddExistingOne',
      desc: '',
      args: [],
    );
  }

  /// `Existing`
  String get existing {
    return Intl.message('Existing', name: 'existing', desc: '', args: []);
  }

  /// `New`
  String get createNewContact {
    return Intl.message('New', name: 'createNewContact', desc: '', args: []);
  }

  /// `Speakers`
  String get speakers {
    return Intl.message('Speakers', name: 'speakers', desc: '', args: []);
  }

  /// `Speaker`
  String get speaker {
    return Intl.message('Speaker', name: 'speaker', desc: '', args: []);
  }

  /// `Default Communication Device`
  String get defaultCommunicationDevice {
    return Intl.message(
      'Default Communication Device',
      name: 'defaultCommunicationDevice',
      desc: '',
      args: [],
    );
  }

  /// `Can't talk. What happened?`
  String get cantTalkWhatHappened {
    return Intl.message(
      'Can\'t talk. What happened?',
      name: 'cantTalkWhatHappened',
      desc: '',
      args: [],
    );
  }

  /// `I'll call you back now.`
  String get callYouBackNow {
    return Intl.message(
      'I\'ll call you back now.',
      name: 'callYouBackNow',
      desc: '',
      args: [],
    );
  }

  /// `I'll call you back later.`
  String get callBackLater {
    return Intl.message(
      'I\'ll call you back later.',
      name: 'callBackLater',
      desc: '',
      args: [],
    );
  }

  /// `Can't talk. Call you back later?`
  String get cantTalkCallBackLater {
    return Intl.message(
      'Can\'t talk. Call you back later?',
      name: 'cantTalkCallBackLater',
      desc: '',
      args: [],
    );
  }

  /// `Write a message...`
  String get writeMessage {
    return Intl.message(
      'Write a message...',
      name: 'writeMessage',
      desc: '',
      args: [],
    );
  }

  /// `New call`
  String get newCallDialog {
    return Intl.message('New call', name: 'newCallDialog', desc: '', args: []);
  }

  /// `Video call`
  String get videoCall {
    return Intl.message('Video call', name: 'videoCall', desc: '', args: []);
  }

  /// `Audio call`
  String get audioCall {
    return Intl.message('Audio call', name: 'audioCall', desc: '', args: []);
  }

  /// `Communicate often`
  String get doYouCommunicateOften {
    return Intl.message(
      'Communicate often',
      name: 'doYouCommunicateOften',
      desc: '',
      args: [],
    );
  }

  /// `All contacts`
  String get allContacts {
    return Intl.message(
      'All contacts',
      name: 'allContacts',
      desc: '',
      args: [],
    );
  }

  /// `Share screen`
  String get shareScreen {
    return Intl.message(
      'Share screen',
      name: 'shareScreen',
      desc: '',
      args: [],
    );
  }

  /// `Send message`
  String get sendMessage {
    return Intl.message(
      'Send message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Good connection`
  String get goodConnection {
    return Intl.message(
      'Good connection',
      name: 'goodConnection',
      desc: '',
      args: [],
    );
  }

  /// `No videos available`
  String get noVideosAvailable {
    return Intl.message(
      'No videos available',
      name: 'noVideosAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Error initializing media_kit video`
  String get errorInitializingMediaKitVideo {
    return Intl.message(
      'Error initializing media_kit video',
      name: 'errorInitializingMediaKitVideo',
      desc: '',
      args: [],
    );
  }

  /// `Device is online.`
  String get deviceIsOnline {
    return Intl.message(
      'Device is online.',
      name: 'deviceIsOnline',
      desc: '',
      args: [],
    );
  }

  /// `Call from`
  String get callFrom {
    return Intl.message('Call from', name: 'callFrom', desc: '', args: []);
  }

  /// `Swipe up to select filters`
  String get swipeUpToSelectFilters {
    return Intl.message(
      'Swipe up to select filters',
      name: 'swipeUpToSelectFilters',
      desc: '',
      args: [],
    );
  }

  /// `Status (Contacts)`
  String get statusContacts {
    return Intl.message(
      'Status (Contacts)',
      name: 'statusContacts',
      desc: '',
      args: [],
    );
  }

  /// `Error adding status`
  String get errorAddingStatus {
    return Intl.message(
      'Error adding status',
      name: 'errorAddingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Enter status`
  String get enterStatus {
    return Intl.message(
      'Enter status',
      name: 'enterStatus',
      desc: '',
      args: [],
    );
  }

  /// `Viewed`
  String get viewed {
    return Intl.message('Viewed', name: 'viewed', desc: '', args: []);
  }

  /// `Your status and chats are private`
  String get yourStatusAndChatsPrivate {
    return Intl.message(
      'Your status and chats are private',
      name: 'yourStatusAndChatsPrivate',
      desc: '',
      args: [],
    );
  }

  /// `The status updates and private messages you exchange with the contacts you choose are end-to-end encrypted. Not even Chatify can access them. These include:`
  String get statusUpdatesAndPrivateMessages {
    return Intl.message(
      'The status updates and private messages you exchange with the contacts you choose are end-to-end encrypted. Not even Chatify can access them. These include:',
      name: 'statusUpdatesAndPrivateMessages',
      desc: '',
      args: [],
    );
  }

  /// `Adding Status`
  String get addingStatus {
    return Intl.message(
      'Adding Status',
      name: 'addingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message('Text', name: 'text', desc: '', args: []);
  }

  /// `Layout`
  String get layout {
    return Intl.message('Layout', name: 'layout', desc: '', args: []);
  }

  /// `Voice`
  String get voice {
    return Intl.message('Voice', name: 'voice', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Delete Text?`
  String get deleteText {
    return Intl.message('Delete Text?', name: 'deleteText', desc: '', args: []);
  }

  /// `Newsletters`
  String get newsletters {
    return Intl.message('Newsletters', name: 'newsletters', desc: '', args: []);
  }

  /// `No newsletter`
  String get noNewsletter {
    return Intl.message(
      'No newsletter',
      name: 'noNewsletter',
      desc: '',
      args: [],
    );
  }

  /// `Read all`
  String get readAll {
    return Intl.message('Read all', name: 'readAll', desc: '', args: []);
  }

  /// `Name can't be empty`
  String get nameCannotBeEmpty {
    return Intl.message(
      'Name can\'t be empty',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currentCall {
    return Intl.message('Current', name: 'currentCall', desc: '', args: []);
  }

  /// `See more "Favorites"`
  String get seeMoreFavorites {
    return Intl.message(
      'See more "Favorites"',
      name: 'seeMoreFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Current video call`
  String get currentVideoCall {
    return Intl.message(
      'Current video call',
      name: 'currentVideoCall',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `New chat (Ctrl+N) \nNew group (Ctrl+Shift+N)`
  String get newChatNewGroup {
    return Intl.message(
      'New chat (Ctrl+N) \nNew group (Ctrl+Shift+N)',
      name: 'newChatNewGroup',
      desc: '',
      args: [],
    );
  }

  /// `Chat filter`
  String get chatFilter {
    return Intl.message('Chat filter', name: 'chatFilter', desc: '', args: []);
  }

  /// `Message text`
  String get messageText {
    return Intl.message(
      'Message text',
      name: 'messageText',
      desc: '',
      args: [],
    );
  }

  /// `No unread chats`
  String get noUnreadChats {
    return Intl.message(
      'No unread chats',
      name: 'noUnreadChats',
      desc: '',
      args: [],
    );
  }

  /// `View all chats`
  String get viewAllChats {
    return Intl.message(
      'View all chats',
      name: 'viewAllChats',
      desc: '',
      args: [],
    );
  }

  /// `Top up your Favorites`
  String get topUpYourFavorites {
    return Intl.message(
      'Top up your Favorites',
      name: 'topUpYourFavorites',
      desc: '',
      args: [],
    );
  }

  /// `View Favorites in the "Chats" and "Calls" tabs. You can add an unlimited number of users and groups.`
  String get viewFavoritesChatsAndCalls {
    return Intl.message(
      'View Favorites in the "Chats" and "Calls" tabs. You can add an unlimited number of users and groups.',
      name: 'viewFavoritesChatsAndCalls',
      desc: '',
      args: [],
    );
  }

  /// `Add users or groups`
  String get addUsersOrGroups {
    return Intl.message(
      'Add users or groups',
      name: 'addUsersOrGroups',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Unread`
  String get unread {
    return Intl.message('Unread', name: 'unread', desc: '', args: []);
  }

  /// `Photos and Videos`
  String get photosAndVideos {
    return Intl.message(
      'Photos and Videos',
      name: 'photosAndVideos',
      desc: '',
      args: [],
    );
  }

  /// `Status Privacy`
  String get statusPrivacy {
    return Intl.message(
      'Status Privacy',
      name: 'statusPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Status Privacy Settings.`
  String get statusPrivacySettings {
    return Intl.message(
      'Status Privacy Settings.',
      name: 'statusPrivacySettings',
      desc: '',
      args: [],
    );
  }

  /// `Always`
  String get always {
    return Intl.message('Always', name: 'always', desc: '', args: []);
  }

  /// `Never`
  String get never {
    return Intl.message('Never', name: 'never', desc: '', args: []);
  }

  /// `Only when the app is open`
  String get onlyWhenAppOpen {
    return Intl.message(
      'Only when the app is open',
      name: 'onlyWhenAppOpen',
      desc: '',
      args: [],
    );
  }

  /// `Change color scheme?`
  String get changeColorScheme {
    return Intl.message(
      'Change color scheme?',
      name: 'changeColorScheme',
      desc: '',
      args: [],
    );
  }

  /// `This action will restart the app. Continue?`
  String get actionWillRestartApp {
    return Intl.message(
      'This action will restart the app. Continue?',
      name: 'actionWillRestartApp',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get blueColor {
    return Intl.message('Blue', name: 'blueColor', desc: '', args: []);
  }

  /// `Red`
  String get redColor {
    return Intl.message('Red', name: 'redColor', desc: '', args: []);
  }

  /// `Green`
  String get greenColor {
    return Intl.message('Green', name: 'greenColor', desc: '', args: []);
  }

  /// `Orange`
  String get orangeColor {
    return Intl.message('Orange', name: 'orangeColor', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Warning`
  String get alert {
    return Intl.message('Warning', name: 'alert', desc: '', args: []);
  }

  /// `Apply new theme?`
  String get applyNewTheme {
    return Intl.message(
      'Apply new theme?',
      name: 'applyNewTheme',
      desc: '',
      args: [],
    );
  }

  /// `Change theme?`
  String get changeTopic {
    return Intl.message(
      'Change theme?',
      name: 'changeTopic',
      desc: '',
      args: [],
    );
  }

  /// `Chatify will need to be restarted to apply the new theme.`
  String get appWillNeedToBeRestartedApplyNewTheme {
    return Intl.message(
      'Chatify will need to be restarted to apply the new theme.',
      name: 'appWillNeedToBeRestartedApplyNewTheme',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get systemTheme {
    return Intl.message('System', name: 'systemTheme', desc: '', args: []);
  }

  /// `Synced with phone`
  String get syncedWithPhone {
    return Intl.message(
      'Synced with phone',
      name: 'syncedWithPhone',
      desc: '',
      args: [],
    );
  }

  /// `Archive all chats`
  String get archiveAllChats {
    return Intl.message(
      'Archive all chats',
      name: 'archiveAllChats',
      desc: '',
      args: [],
    );
  }

  /// `You will still receive new messages in archived chats.`
  String get receiveNewMessagesInArchivedChats {
    return Intl.message(
      'You will still receive new messages in archived chats.',
      name: 'receiveNewMessagesInArchivedChats',
      desc: '',
      args: [],
    );
  }

  /// `Delete all messages`
  String get deleteAllMessages {
    return Intl.message(
      'Delete all messages',
      name: 'deleteAllMessages',
      desc: '',
      args: [],
    );
  }

  /// `Delete all messages from chats and groups`
  String get deleteAllMessagesChatsAndGroups {
    return Intl.message(
      'Delete all messages from chats and groups',
      name: 'deleteAllMessagesChatsAndGroups',
      desc: '',
      args: [],
    );
  }

  /// `Delete all chats`
  String get deleteAllChats {
    return Intl.message(
      'Delete all chats',
      name: 'deleteAllChats',
      desc: '',
      args: [],
    );
  }

  /// `Delete all messages and clear your chat history`
  String get deleteAllMessagesAndClearChatHistory {
    return Intl.message(
      'Delete all messages and clear your chat history',
      name: 'deleteAllMessagesAndClearChatHistory',
      desc: '',
      args: [],
    );
  }

  /// `To enable this option, go to your computer Settings > Applications > Startup and enable Chatify to start at login`
  String get enableThisOption {
    return Intl.message(
      'To enable this option, go to your computer Settings > Applications > Startup and enable Chatify to start at login',
      name: 'enableThisOption',
      desc: '',
      args: [],
    );
  }

  /// `Let us know`
  String get writeToUs {
    return Intl.message('Let us know', name: 'writeToUs', desc: '', args: []);
  }

  /// `We want to know what you think about this app.`
  String get weThinkAboutThisApp {
    return Intl.message(
      'We want to know what you think about this app.',
      name: 'weThinkAboutThisApp',
      desc: '',
      args: [],
    );
  }

  /// `Rate the app`
  String get rateApp {
    return Intl.message('Rate the app', name: 'rateApp', desc: '', args: []);
  }

  /// `Add participants`
  String get addParticipants {
    return Intl.message(
      'Add participants',
      name: 'addParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Change group name`
  String get changeGroupName {
    return Intl.message(
      'Change group name',
      name: 'changeGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get aboutGroups {
    return Intl.message('Group', name: 'aboutGroups', desc: '', args: []);
  }

  /// `member`
  String get participant {
    return Intl.message('member', name: 'participant', desc: '', args: []);
  }

  /// `Add a description for the group`
  String get addGroupDescription {
    return Intl.message(
      'Add a description for the group',
      name: 'addGroupDescription',
      desc: '',
      args: [],
    );
  }

  /// `Group created by you, `
  String get groupCreatedByYou {
    return Intl.message(
      'Group created by you, ',
      name: 'groupCreatedByYou',
      desc: '',
      args: [],
    );
  }

  /// `Media, links, and documents`
  String get mediaLinksAndDocuments {
    return Intl.message(
      'Media, links, and documents',
      name: 'mediaLinksAndDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Encryption`
  String get encryption {
    return Intl.message('Encryption', name: 'encryption', desc: '', args: []);
  }

  /// `Messages and calls are protected end-to-end encrypted. Only members of this chat can read, listen to, or forward them. Select to learn more.`
  String get messagesCallsProtectedEndToEndEncryption {
    return Intl.message(
      'Messages and calls are protected end-to-end encrypted. Only members of this chat can read, listen to, or forward them. Select to learn more.',
      name: 'messagesCallsProtectedEndToEndEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Disappearing messages`
  String get disappearingMessages {
    return Intl.message(
      'Disappearing messages',
      name: 'disappearingMessages',
      desc: '',
      args: [],
    );
  }

  /// `Closing chat`
  String get closingChat {
    return Intl.message(
      'Closing chat',
      name: 'closingChat',
      desc: '',
      args: [],
    );
  }

  /// `Close and hide this chat on this device.`
  String get closeAndHideChatDevice {
    return Intl.message(
      'Close and hide this chat on this device.',
      name: 'closeAndHideChatDevice',
      desc: '',
      args: [],
    );
  }

  /// `Add a group to a community`
  String get addGroupToCommunity {
    return Intl.message(
      'Add a group to a community',
      name: 'addGroupToCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Combine participants \n' 'into thematic groups`
  String get combineParticipantsThematicGroups {
    return Intl.message(
      'Combine participants \n\' \'into thematic groups',
      name: 'combineParticipantsThematicGroups',
      desc: '',
      args: [],
    );
  }

  /// `Invite via link`
  String get inviteViaLink {
    return Intl.message(
      'Invite via link',
      name: 'inviteViaLink',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from Favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Add to list`
  String get addToList {
    return Intl.message('Add to list', name: 'addToList', desc: '', args: []);
  }

  /// `Please wait`
  String get pleaseWait {
    return Intl.message('Please wait', name: 'pleaseWait', desc: '', args: []);
  }

  /// `Leave group`
  String get leaveGroup {
    return Intl.message('Leave group', name: 'leaveGroup', desc: '', args: []);
  }

  /// `Report group`
  String get reportGroup {
    return Intl.message(
      'Report group',
      name: 'reportGroup',
      desc: '',
      args: [],
    );
  }

  /// `Search by name or phone number`
  String get searchByNameOrPhoneNumber {
    return Intl.message(
      'Search by name or phone number',
      name: 'searchByNameOrPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Forward...`
  String get forward {
    return Intl.message('Forward...', name: 'forward', desc: '', args: []);
  }

  /// `Send location`
  String get sendLocation {
    return Intl.message(
      'Send location',
      name: 'sendLocation',
      desc: '',
      args: [],
    );
  }

  /// `Share geodata`
  String get shareGeodata {
    return Intl.message(
      'Share geodata',
      name: 'shareGeodata',
      desc: '',
      args: [],
    );
  }

  /// `Nearest places`
  String get nearestPlaces {
    return Intl.message(
      'Nearest places',
      name: 'nearestPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Send current location`
  String get sendCurrentLocation {
    return Intl.message(
      'Send current location',
      name: 'sendCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `To send the nearest place or your location, allow Chatify to access location. Go to Settings > Permissions and turn on Location.`
  String get settingsSendCurrentLocation {
    return Intl.message(
      'To send the nearest place or your location, allow Chatify to access location. Go to Settings > Permissions and turn on Location.',
      name: 'settingsSendCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Error opening app settings`
  String get errorOpeningAppSettings {
    return Intl.message(
      'Error opening app settings',
      name: 'errorOpeningAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Unknown size`
  String get unknownSize {
    return Intl.message(
      'Unknown size',
      name: 'unknownSize',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `File`
  String get file {
    return Intl.message('File', name: 'file', desc: '', args: []);
  }

  /// `Save as...`
  String get saveAs {
    return Intl.message('Save as...', name: 'saveAs', desc: '', args: []);
  }

  /// `Group data`
  String get groupData {
    return Intl.message('Group data', name: 'groupData', desc: '', args: []);
  }

  /// `Media groups`
  String get mediaGroups {
    return Intl.message(
      'Media groups',
      name: 'mediaGroups',
      desc: '',
      args: [],
    );
  }

  /// `No sound`
  String get noSound {
    return Intl.message('No sound', name: 'noSound', desc: '', args: []);
  }

  /// `contact details`
  String get contactDetails {
    return Intl.message(
      'contact details',
      name: 'contactDetails',
      desc: '',
      args: [],
    );
  }

  /// `Printing...`
  String get printing {
    return Intl.message('Printing...', name: 'printing', desc: '', args: []);
  }

  /// `Enlarge to desired size`
  String get enlargeToDesiredSize {
    return Intl.message(
      'Enlarge to desired size',
      name: 'enlargeToDesiredSize',
      desc: '',
      args: [],
    );
  }

  /// `Enlarge to original size`
  String get enlargeToOriginalSize {
    return Intl.message(
      'Enlarge to original size',
      name: 'enlargeToOriginalSize',
      desc: '',
      args: [],
    );
  }

  /// `Enlarge (Ctrl +)`
  String get zoomIn {
    return Intl.message('Enlarge (Ctrl +)', name: 'zoomIn', desc: '', args: []);
  }

  /// `Zoom (Ctrl -)`
  String get zoomOut {
    return Intl.message('Zoom (Ctrl -)', name: 'zoomOut', desc: '', args: []);
  }

  /// `Add to Favorites`
  String get imageAddToFavorites {
    return Intl.message(
      'Add to Favorites',
      name: 'imageAddToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `React to message`
  String get reactToMessage {
    return Intl.message(
      'React to message',
      name: 'reactToMessage',
      desc: '',
      args: [],
    );
  }

  /// `Other options hidden`
  String get otherOptionsHidden {
    return Intl.message(
      'Other options hidden',
      name: 'otherOptionsHidden',
      desc: '',
      args: [],
    );
  }

  /// `Delete from me`
  String get deleteFromMe {
    return Intl.message(
      'Delete from me',
      name: 'deleteFromMe',
      desc: '',
      args: [],
    );
  }

  /// `Delete from everyone`
  String get deleteFromAll {
    return Intl.message(
      'Delete from everyone',
      name: 'deleteFromAll',
      desc: '',
      args: [],
    );
  }

  /// `This message has been deleted.`
  String get messageHasBeenRemoved {
    return Intl.message(
      'This message has been deleted.',
      name: 'messageHasBeenRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Create new contact`
  String get createNewContactDialog {
    return Intl.message(
      'Create new contact',
      name: 'createNewContactDialog',
      desc: '',
      args: [],
    );
  }

  /// `Add to existing contact`
  String get addExistingContact {
    return Intl.message(
      'Add to existing contact',
      name: 'addExistingContact',
      desc: '',
      args: [],
    );
  }

  /// `To send a nearby place or your location, allow Chatify to access your location.`
  String get sendNearbyPlaceLocation {
    return Intl.message(
      'To send a nearby place or your location, allow Chatify to access your location.',
      name: 'sendNearbyPlaceLocation',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get notNow {
    return Intl.message('Not now', name: 'notNow', desc: '', args: []);
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Add...`
  String get addUserDialog {
    return Intl.message('Add...', name: 'addUserDialog', desc: '', args: []);
  }

  /// `Review`
  String get review {
    return Intl.message('Review', name: 'review', desc: '', args: []);
  }

  /// `Media`
  String get media {
    return Intl.message('Media', name: 'media', desc: '', args: []);
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Failed to delete message`
  String get failedToDeleteMessage {
    return Intl.message(
      'Failed to delete message',
      name: 'failedToDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete message from`
  String get deleteMessageFrom {
    return Intl.message(
      'Delete message from',
      name: 'deleteMessageFrom',
      desc: '',
      args: [],
    );
  }

  /// `messages from `
  String get messagesFrom {
    return Intl.message(
      'messages from ',
      name: 'messagesFrom',
      desc: '',
      args: [],
    );
  }

  /// `Open in another app`
  String get openInAnotherApp {
    return Intl.message(
      'Open in another app',
      name: 'openInAnotherApp',
      desc: '',
      args: [],
    );
  }

  /// `Insert`
  String get insert {
    return Intl.message('Insert', name: 'insert', desc: '', args: []);
  }

  /// `Reply`
  String get answer {
    return Intl.message('Reply', name: 'answer', desc: '', args: []);
  }

  /// `To Favorites`
  String get addToFavoritesDialog {
    return Intl.message(
      'To Favorites',
      name: 'addToFavoritesDialog',
      desc: '',
      args: [],
    );
  }

  /// `You can delete the message from everyone or just yourself.`
  String get youCanDeleteMessageYourself {
    return Intl.message(
      'You can delete the message from everyone or just yourself.',
      name: 'youCanDeleteMessageYourself',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get data {
    return Intl.message('Data', name: 'data', desc: '', args: []);
  }

  /// `No Images Available`
  String get noImagesAvailable {
    return Intl.message(
      'No Images Available',
      name: 'noImagesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Error Loading GIF`
  String get errorLoadingGif {
    return Intl.message(
      'Error Loading GIF',
      name: 'errorLoadingGif',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get documents {
    return Intl.message('Documents', name: 'documents', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Location...`
  String get location {
    return Intl.message('Location...', name: 'location', desc: '', args: []);
  }

  /// `Survey`
  String get survey {
    return Intl.message('Survey', name: 'survey', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Call Ended`
  String get callEnded {
    return Intl.message('Call Ended', name: 'callEnded', desc: '', args: []);
  }

  /// `Turn on Camera`
  String get turnOnCamera {
    return Intl.message(
      'Turn on Camera',
      name: 'turnOnCamera',
      desc: '',
      args: [],
    );
  }

  /// `Microphone`
  String get microphone {
    return Intl.message('Microphone', name: 'microphone', desc: '', args: []);
  }

  /// `Turn off Microphone`
  String get turnOffMicrophone {
    return Intl.message(
      'Turn off Microphone',
      name: 'turnOffMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `Turn on Microphone`
  String get turnOnMicrophone {
    return Intl.message(
      'Turn on Microphone',
      name: 'turnOnMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `Open Chat`
  String get openChat {
    return Intl.message('Open Chat', name: 'openChat', desc: '', args: []);
  }

  /// `Call Back`
  String get callBack {
    return Intl.message('Call Back', name: 'callBack', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `⚠️ WARNING: Empty microphone selected!`
  String get warningEmptyMicrophoneSelected {
    return Intl.message(
      '⚠️ WARNING: Empty microphone selected!',
      name: 'warningEmptyMicrophoneSelected',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ WARNING: An empty speaker has been selected!`
  String get warningEmptySpeakerSelected {
    return Intl.message(
      '⚠️ WARNING: An empty speaker has been selected!',
      name: 'warningEmptySpeakerSelected',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch`
  String get couldNotLaunch {
    return Intl.message(
      'Could not launch',
      name: 'couldNotLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Call from user`
  String get callFromUser {
    return Intl.message(
      'Call from user',
      name: 'callFromUser',
      desc: '',
      args: [],
    );
  }

  /// `Call scheduling`
  String get callPlanning {
    return Intl.message(
      'Call scheduling',
      name: 'callPlanning',
      desc: '',
      args: [],
    );
  }

  /// `Call name`
  String get callName {
    return Intl.message('Call name', name: 'callName', desc: '', args: []);
  }

  /// `Description (optional)`
  String get descriptionOptional {
    return Intl.message(
      'Description (optional)',
      name: 'descriptionOptional',
      desc: '',
      args: [],
    );
  }

  /// `Remove event end time`
  String get removeEventEndTime {
    return Intl.message(
      'Remove event end time',
      name: 'removeEventEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Add event end time`
  String get addEventEndTime {
    return Intl.message(
      'Add event end time',
      name: 'addEventEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Call preview timed out`
  String get callPreviewTimedOut {
    return Intl.message(
      'Call preview timed out',
      name: 'callPreviewTimedOut',
      desc: '',
      args: [],
    );
  }

  /// `Please try again.`
  String get pleaseTryAgain {
    return Intl.message(
      'Please try again.',
      name: 'pleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for other participants...`
  String get waitingForOtherParticipants {
    return Intl.message(
      'Waiting for other participants...',
      name: 'waitingForOtherParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Any user with this link can join.`
  String get anyUserLinkCanJoin {
    return Intl.message(
      'Any user with this link can join.',
      name: 'anyUserLinkCanJoin',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get invite {
    return Intl.message('Invite', name: 'invite', desc: '', args: []);
  }

  /// `Add groups`
  String get addGroups {
    return Intl.message('Add groups', name: 'addGroups', desc: '', args: []);
  }

  /// `Community data`
  String get communityData {
    return Intl.message(
      'Community data',
      name: 'communityData',
      desc: '',
      args: [],
    );
  }

  /// `Invite participants`
  String get inviteParticipants {
    return Intl.message(
      'Invite participants',
      name: 'inviteParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Community settings`
  String get communitySettings {
    return Intl.message(
      'Community settings',
      name: 'communitySettings',
      desc: '',
      args: [],
    );
  }

  /// `Other groups added to the community will be displayed here. Community members can join these groups`
  String get groupsAddedCommunityDisplayed {
    return Intl.message(
      'Other groups added to the community will be displayed here. Community members can join these groups',
      name: 'groupsAddedCommunityDisplayed',
      desc: '',
      args: [],
    );
  }

  /// `Add a group`
  String get addGroup {
    return Intl.message('Add a group', name: 'addGroup', desc: '', args: []);
  }

  /// `Create a new community`
  String get createNewCommunity {
    return Intl.message(
      'Create a new community',
      name: 'createNewCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Organize communication for your district, school, or other groups. Create thematic groups and use the convenient function of sending announcements from the admin.`
  String get organizeCommunicationEducational {
    return Intl.message(
      'Organize communication for your district, school, or other groups. Create thematic groups and use the convenient function of sending announcements from the admin.',
      name: 'organizeCommunicationEducational',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get begin {
    return Intl.message('Get started', name: 'begin', desc: '', args: []);
  }

  /// `Change community`
  String get changeCommunity {
    return Intl.message(
      'Change community',
      name: 'changeCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Please select an image for the community.`
  String get pleaseSelectImageCommunity {
    return Intl.message(
      'Please select an image for the community.',
      name: 'pleaseSelectImageCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Emoji picker`
  String get emojiPicker {
    return Intl.message(
      'Emoji picker',
      name: 'emojiPicker',
      desc: '',
      args: [],
    );
  }

  /// `Admins only`
  String get onlyAdmins {
    return Intl.message('Admins only', name: 'onlyAdmins', desc: '', args: []);
  }

  /// `Community permissions`
  String get communityPermissions {
    return Intl.message(
      'Community permissions',
      name: 'communityPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Who can add new members`
  String get whoCanAddNewMembers {
    return Intl.message(
      'Who can add new members',
      name: 'whoCanAddNewMembers',
      desc: '',
      args: [],
    );
  }

  /// `Who can add to new groups`
  String get whoCanAddToNewGroups {
    return Intl.message(
      'Who can add to new groups',
      name: 'whoCanAddToNewGroups',
      desc: '',
      args: [],
    );
  }

  /// `All community members can add other members.`
  String get allCommunityMembersAddOtherMembers {
    return Intl.message(
      'All community members can add other members.',
      name: 'allCommunityMembersAddOtherMembers',
      desc: '',
      args: [],
    );
  }

  /// `Only group and community admins can add other members.`
  String get onlyAdminsGroupAndCommunitiesOtherMembers {
    return Intl.message(
      'Only group and community admins can add other members.',
      name: 'onlyAdminsGroupAndCommunitiesOtherMembers',
      desc: '',
      args: [],
    );
  }

  /// `Who can add new groups`
  String get addNewGroups {
    return Intl.message(
      'Who can add new groups',
      name: 'addNewGroups',
      desc: '',
      args: [],
    );
  }

  /// `Members can always propose groups for admin approval. Community admins can delete any groups. `
  String get membersCanAlwaysProposeGroups {
    return Intl.message(
      'Members can always propose groups for admin approval. Community admins can delete any groups. ',
      name: 'membersCanAlwaysProposeGroups',
      desc: '',
      args: [],
    );
  }

  /// `All community members can add groups`
  String get allCommunityMembersAddGroups {
    return Intl.message(
      'All community members can add groups',
      name: 'allCommunityMembersAddGroups',
      desc: '',
      args: [],
    );
  }

  /// `Only community admins`
  String get communityAdminsOnly {
    return Intl.message(
      'Only community admins',
      name: 'communityAdminsOnly',
      desc: '',
      args: [],
    );
  }

  /// `Only community admins can add groups. Members can propose groups for admin approval.`
  String get onlyCommunityAdminsAddGroups {
    return Intl.message(
      'Only community admins can add groups. Members can propose groups for admin approval.',
      name: 'onlyCommunityAdminsAddGroups',
      desc: '',
      args: [],
    );
  }

  /// `No community`
  String get noCommunity {
    return Intl.message(
      'No community',
      name: 'noCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Announcements`
  String get announcements {
    return Intl.message(
      'Announcements',
      name: 'announcements',
      desc: '',
      args: [],
    );
  }

  /// `Unnamed Community`
  String get unnamedCommunity {
    return Intl.message(
      'Unnamed Community',
      name: 'unnamedCommunity',
      desc: '',
      args: [],
    );
  }

  /// `No description`
  String get noDescription {
    return Intl.message(
      'No description',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `No phone`
  String get noPhone {
    return Intl.message('No phone', name: 'noPhone', desc: '', args: []);
  }

  /// `Unable to open the messages app`
  String get unableOpenMessagesApp {
    return Intl.message(
      'Unable to open the messages app',
      name: 'unableOpenMessagesApp',
      desc: '',
      args: [],
    );
  }

  /// `Contact does not contain a phone number`
  String get contactContainPhoneNumber {
    return Intl.message(
      'Contact does not contain a phone number',
      name: 'contactContainPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Community Picture`
  String get communityPicture {
    return Intl.message(
      'Community Picture',
      name: 'communityPicture',
      desc: '',
      args: [],
    );
  }

  /// `Emoji`
  String get emoji {
    return Intl.message('Emoji', name: 'emoji', desc: '', args: []);
  }

  /// `With end-to-end encryption, the contents of your private messages and calls stay between you and the people you communicate with. No one can read, listen to, or forward them, not even Chatify employees. The following are protected:`
  String get endToEndEncryptionMessagesCalls {
    return Intl.message(
      'With end-to-end encryption, the contents of your private messages and calls stay between you and the people you communicate with. No one can read, listen to, or forward them, not even Chatify employees. The following are protected:',
      name: 'endToEndEncryptionMessagesCalls',
      desc: '',
      args: [],
    );
  }

  /// `Your location`
  String get yourLocation {
    return Intl.message(
      'Your location',
      name: 'yourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Status updates`
  String get statusUpdates {
    return Intl.message(
      'Status updates',
      name: 'statusUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Groups you are a member of`
  String get groupsYouMember {
    return Intl.message(
      'Groups you are a member of',
      name: 'groupsYouMember',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to our community!`
  String get welcomeToCommunity {
    return Intl.message(
      'Welcome to our community!',
      name: 'welcomeToCommunity',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get generalCommunity {
    return Intl.message(
      'General',
      name: 'generalCommunity',
      desc: '',
      args: [],
    );
  }

  /// `New community members will no longer be added automatically.`
  String get newCommunityMembersAddedAuto {
    return Intl.message(
      'New community members will no longer be added automatically.',
      name: 'newCommunityMembersAddedAuto',
      desc: '',
      args: [],
    );
  }

  /// `No date`
  String get noDate {
    return Intl.message('No date', name: 'noDate', desc: '', args: []);
  }

  /// `Managing Groups`
  String get managingGroups {
    return Intl.message(
      'Managing Groups',
      name: 'managingGroups',
      desc: '',
      args: [],
    );
  }

  /// `Add existing groups`
  String get addNounGroup {
    return Intl.message(
      'Add existing groups',
      name: 'addNounGroup',
      desc: '',
      args: [],
    );
  }

  /// `Members can propose existing groups to admins for review and add new groups themselves. Open community settings`
  String get membersCanProposeExistingGroups {
    return Intl.message(
      'Members can propose existing groups to admins for review and add new groups themselves. Open community settings',
      name: 'membersCanProposeExistingGroups',
      desc: '',
      args: [],
    );
  }

  /// `Groups in this community`
  String get groupsInCommunity {
    return Intl.message(
      'Groups in this community',
      name: 'groupsInCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching groups`
  String get errorFetchingGroups {
    return Intl.message(
      'Error fetching groups',
      name: 'errorFetchingGroups',
      desc: '',
      args: [],
    );
  }

  /// `Group name (required)`
  String get groupNameRequired {
    return Intl.message(
      'Group name (required)',
      name: 'groupNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get participants {
    return Intl.message(
      'Participants',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a group name`
  String get pleaseEnterGroupName {
    return Intl.message(
      'Please enter a group name',
      name: 'pleaseEnterGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one participant`
  String get addLeastOneParticipant {
    return Intl.message(
      'Add at least one participant',
      name: 'addLeastOneParticipant',
      desc: '',
      args: [],
    );
  }

  /// `Please select an image for the group`
  String get pleaseSelectImageGroup {
    return Intl.message(
      'Please select an image for the group',
      name: 'pleaseSelectImageGroup',
      desc: '',
      args: [],
    );
  }

  /// `Error creating group`
  String get errorCreatingGroup {
    return Intl.message(
      'Error creating group',
      name: 'errorCreatingGroup',
      desc: '',
      args: [],
    );
  }

  /// `24 hours`
  String get duration24h {
    return Intl.message('24 hours', name: 'duration24h', desc: '', args: []);
  }

  /// `7 days`
  String get duration7d {
    return Intl.message('7 days', name: 'duration7d', desc: '', args: []);
  }

  /// `90 days`
  String get duration90d {
    return Intl.message('90 days', name: 'duration90d', desc: '', args: []);
  }

  /// `Off`
  String get durationOff {
    return Intl.message('Off', name: 'durationOff', desc: '', args: []);
  }

  /// `Group Description`
  String get groupDescription {
    return Intl.message(
      'Group Description',
      name: 'groupDescription',
      desc: '',
      args: [],
    );
  }

  /// `The group description is visible to all its members, as well as to users invited to the group.`
  String get groupDescriptionVisible {
    return Intl.message(
      'The group description is visible to all its members, as well as to users invited to the group.',
      name: 'groupDescriptionVisible',
      desc: '',
      args: [],
    );
  }

  /// `You created this group`
  String get youCreatedGroup {
    return Intl.message(
      'You created this group',
      name: 'youCreatedGroup',
      desc: '',
      args: [],
    );
  }

  /// `Add a description...`
  String get addDescription {
    return Intl.message(
      'Add a description...',
      name: 'addDescription',
      desc: '',
      args: [],
    );
  }

  /// `About the group`
  String get aboutGroup {
    return Intl.message(
      'About the group',
      name: 'aboutGroup',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one participant.`
  String get pleaseSelectLeastOneParticipant {
    return Intl.message(
      'Please select at least one participant.',
      name: 'pleaseSelectLeastOneParticipant',
      desc: '',
      args: [],
    );
  }

  /// `Emoticons, GIFs, stickers (Ctrl+Shift+E,G,S)`
  String get emoticonsGifsStickers {
    return Intl.message(
      'Emoticons, GIFs, stickers (Ctrl+Shift+E,G,S)',
      name: 'emoticonsGifsStickers',
      desc: '',
      args: [],
    );
  }

  /// `Enter a message`
  String get enterYourMessage {
    return Intl.message(
      'Enter a message',
      name: 'enterYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Record a voice message`
  String get recordVoiceMessage {
    return Intl.message(
      'Record a voice message',
      name: 'recordVoiceMessage',
      desc: '',
      args: [],
    );
  }

  /// `Voice message`
  String get voiceMessage {
    return Intl.message(
      'Voice message',
      name: 'voiceMessage',
      desc: '',
      args: [],
    );
  }

  /// `These chats will be unarchived when new messages are received. Click to edit.`
  String get chatsUnarchivedNewMessagesReceived {
    return Intl.message(
      'These chats will be unarchived when new messages are received. Click to edit.',
      name: 'chatsUnarchivedNewMessagesReceived',
      desc: '',
      args: [],
    );
  }

  /// `Archived chats will not be unzipped when a new message is received`
  String get archivedChatsWillNotUnarchived {
    return Intl.message(
      'Archived chats will not be unzipped when a new message is received',
      name: 'archivedChatsWillNotUnarchived',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching newsletters`
  String get errorFetchingNewsletters {
    return Intl.message(
      'Error fetching newsletters',
      name: 'errorFetchingNewsletters',
      desc: '',
      args: [],
    );
  }

  /// `Device Status`
  String get deviceStatus {
    return Intl.message(
      'Device Status',
      name: 'deviceStatus',
      desc: '',
      args: [],
    );
  }

  /// `Select devices to sign out.`
  String get selectDevicesSignOut {
    return Intl.message(
      'Select devices to sign out.',
      name: 'selectDevicesSignOut',
      desc: '',
      args: [],
    );
  }

  /// `You can link other devices to this account. `
  String get linkOtherDevicesToAccount {
    return Intl.message(
      'You can link other devices to this account. ',
      name: 'linkOtherDevicesToAccount',
      desc: '',
      args: [],
    );
  }

  /// `Organize Lists`
  String get organizeLists {
    return Intl.message(
      'Organize Lists',
      name: 'organizeLists',
      desc: '',
      args: [],
    );
  }

  /// `New Chat`
  String get newChat {
    return Intl.message('New Chat', name: 'newChat', desc: '', args: []);
  }

  /// `Close App`
  String get closeApp {
    return Intl.message('Close App', name: 'closeApp', desc: '', args: []);
  }

  /// `Search in Chat`
  String get searchInChat {
    return Intl.message(
      'Search in Chat',
      name: 'searchInChat',
      desc: '',
      args: [],
    );
  }

  /// `Mute Chat`
  String get muteChat {
    return Intl.message('Mute Chat', name: 'muteChat', desc: '', args: []);
  }

  /// `Mark as read/unread`
  String get markAsReadUnread {
    return Intl.message(
      'Mark as read/unread',
      name: 'markAsReadUnread',
      desc: '',
      args: [],
    );
  }

  /// `Emoji Panel`
  String get emojiPanel {
    return Intl.message('Emoji Panel', name: 'emojiPanel', desc: '', args: []);
  }

  /// `GIF Panel`
  String get gifPanel {
    return Intl.message('GIF Panel', name: 'gifPanel', desc: '', args: []);
  }

  /// `Sticker Panel`
  String get stickerPanel {
    return Intl.message(
      'Sticker Panel',
      name: 'stickerPanel',
      desc: '',
      args: [],
    );
  }

  /// `Previous Chat`
  String get previousChat {
    return Intl.message(
      'Previous Chat',
      name: 'previousChat',
      desc: '',
      args: [],
    );
  }

  /// `Next Chat`
  String get nextChat {
    return Intl.message('Next Chat', name: 'nextChat', desc: '', args: []);
  }

  /// `Edit Last Message`
  String get editLastMessage {
    return Intl.message(
      'Edit Last Message',
      name: 'editLastMessage',
      desc: '',
      args: [],
    );
  }

  /// `Decrease font size`
  String get decreaseFontSize {
    return Intl.message(
      'Decrease font size',
      name: 'decreaseFontSize',
      desc: '',
      args: [],
    );
  }

  /// `Increase font size`
  String get increaseFontSize {
    return Intl.message(
      'Increase font size',
      name: 'increaseFontSize',
      desc: '',
      args: [],
    );
  }

  /// `Reset font size`
  String get resetFontSize {
    return Intl.message(
      'Reset font size',
      name: 'resetFontSize',
      desc: '',
      args: [],
    );
  }

  /// `Keyboard shortcuts`
  String get keyboardShortcuts {
    return Intl.message(
      'Keyboard shortcuts',
      name: 'keyboardShortcuts',
      desc: '',
      args: [],
    );
  }

  /// `Quick emojis`
  String get quickEmoticons {
    return Intl.message(
      'Quick emojis',
      name: 'quickEmoticons',
      desc: '',
      args: [],
    );
  }

  /// `When typing a message, use the colon sign to quickly search for emojis.`
  String get typingMessageUseColonSymbol {
    return Intl.message(
      'When typing a message, use the colon sign to quickly search for emojis.',
      name: 'typingMessageUseColonSymbol',
      desc: '',
      args: [],
    );
  }

  /// `Cat`
  String get cat {
    return Intl.message('Cat', name: 'cat', desc: '', args: []);
  }

  /// `Hat`
  String get hat {
    return Intl.message('Hat', name: 'hat', desc: '', args: []);
  }

  /// `Show banner notifications`
  String get showBannerNotify {
    return Intl.message(
      'Show banner notifications',
      name: 'showBannerNotify',
      desc: '',
      args: [],
    );
  }

  /// `Show notification icon on taskbar`
  String get showNotifyIconTaskbar {
    return Intl.message(
      'Show notification icon on taskbar',
      name: 'showNotifyIconTaskbar',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Reactions`
  String get reactions {
    return Intl.message('Reactions', name: 'reactions', desc: '', args: []);
  }

  /// `Show notifications about reactions to messages you've sent`
  String get showNotifyAboutReactions {
    return Intl.message(
      'Show notifications about reactions to messages you\'ve sent',
      name: 'showNotifyAboutReactions',
      desc: '',
      args: [],
    );
  }

  /// `Status reactions`
  String get statusReactions {
    return Intl.message(
      'Status reactions',
      name: 'statusReactions',
      desc: '',
      args: [],
    );
  }

  /// `Show notifications for status likes`
  String get showNotificationsStatusLikes {
    return Intl.message(
      'Show notifications for status likes',
      name: 'showNotificationsStatusLikes',
      desc: '',
      args: [],
    );
  }

  /// `Text preview`
  String get previewText {
    return Intl.message(
      'Text preview',
      name: 'previewText',
      desc: '',
      args: [],
    );
  }

  /// `Show message text in notification window`
  String get showMessageTextNotifyWindow {
    return Intl.message(
      'Show message text in notification window',
      name: 'showMessageTextNotifyWindow',
      desc: '',
      args: [],
    );
  }

  /// `Media preview`
  String get mediaPreview {
    return Intl.message(
      'Media preview',
      name: 'mediaPreview',
      desc: '',
      args: [],
    );
  }

  /// `Show media images in new message notification window`
  String get showMediaImagesNewMessageNotifyWindow {
    return Intl.message(
      'Show media images in new message notification window',
      name: 'showMediaImagesNewMessageNotifyWindow',
      desc: '',
      args: [],
    );
  }

  /// `Notification sounds`
  String get notifySounds {
    return Intl.message(
      'Notification sounds',
      name: 'notifySounds',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Application color theme`
  String get appColorTheme {
    return Intl.message(
      'Application color theme',
      name: 'appColorTheme',
      desc: '',
      args: [],
    );
  }

  /// `Application color`
  String get appColor {
    return Intl.message(
      'Application color',
      name: 'appColor',
      desc: '',
      args: [],
    );
  }

  /// `Chat wallpaper`
  String get chatWallpaper {
    return Intl.message(
      'Chat wallpaper',
      name: 'chatWallpaper',
      desc: '',
      args: [],
    );
  }

  /// `Chatify drawings`
  String get appDrawings {
    return Intl.message(
      'Chatify drawings',
      name: 'appDrawings',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Increase or decrease font size with Ctrl +/-`
  String get increaseOrDecreaseFontSize {
    return Intl.message(
      'Increase or decrease font size with Ctrl +/-',
      name: 'increaseOrDecreaseFontSize',
      desc: '',
      args: [],
    );
  }

  /// `How are you?`
  String get howAreYou {
    return Intl.message('How are you?', name: 'howAreYou', desc: '', args: []);
  }

  /// `No file selected`
  String get fileNotSelected {
    return Intl.message(
      'No file selected',
      name: 'fileNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Unable to edit your name`
  String get unableChangeYourName {
    return Intl.message(
      'Unable to edit your name',
      name: 'unableChangeYourName',
      desc: '',
      args: [],
    );
  }

  /// `Your name cannot be empty`
  String get yourNameCannotEmpty {
    return Intl.message(
      'Your name cannot be empty',
      name: 'yourNameCannotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Unable to edit your details`
  String get unableEditYourDetails {
    return Intl.message(
      'Unable to edit your details',
      name: 'unableEditYourDetails',
      desc: '',
      args: [],
    );
  }

  /// `Details cannot be empty`
  String get informationCannotEmpty {
    return Intl.message(
      'Details cannot be empty',
      name: 'informationCannotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message('Select All', name: 'selectAll', desc: '', args: []);
  }

  /// `Confirm Logout`
  String get confirmExit {
    return Intl.message(
      'Confirm Logout',
      name: 'confirmExit',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get areYouSureYouLogout {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'areYouSureYouLogout',
      desc: '',
      args: [],
    );
  }

  /// `The chat history on this computer will be cleared when you sign out.`
  String get chatHistoryComputerClearedSignOut {
    return Intl.message(
      'The chat history on this computer will be cleared when you sign out.',
      name: 'chatHistoryComputerClearedSignOut',
      desc: '',
      args: [],
    );
  }

  /// `Autoload`
  String get autoload {
    return Intl.message('Autoload', name: 'autoload', desc: '', args: []);
  }

  /// `Choose which media files are downloaded automatically from messages you receive.`
  String get chooseMediaFilesDownloadedAutoMessages {
    return Intl.message(
      'Choose which media files are downloaded automatically from messages you receive.',
      name: 'chooseMediaFilesDownloadedAutoMessages',
      desc: '',
      args: [],
    );
  }

  /// `Default device`
  String get defaultDevice {
    return Intl.message(
      'Default device',
      name: 'defaultDevice',
      desc: '',
      args: [],
    );
  }

  /// `Play a sound to test`
  String get playSoundCheck {
    return Intl.message(
      'Play a sound to test',
      name: 'playSoundCheck',
      desc: '',
      args: [],
    );
  }

  /// `Allow Chatify to access your microphone?`
  String get allowAppAccessYourMicro {
    return Intl.message(
      'Allow Chatify to access your microphone?',
      name: 'allowAppAccessYourMicro',
      desc: '',
      args: [],
    );
  }

  /// `You can change this later in Settings.`
  String get changeSettingLaterGoing {
    return Intl.message(
      'You can change this later in Settings.',
      name: 'changeSettingLaterGoing',
      desc: '',
      args: [],
    );
  }

  /// `Allow Chatify to access your camera?`
  String get allowAppAccessCamera {
    return Intl.message(
      'Allow Chatify to access your camera?',
      name: 'allowAppAccessCamera',
      desc: '',
      args: [],
    );
  }

  /// `You can always change this in Settings.`
  String get alwaysChangeSettings {
    return Intl.message(
      'You can always change this in Settings.',
      name: 'alwaysChangeSettings',
      desc: '',
      args: [],
    );
  }

  /// `Stop playing sound`
  String get stopPlayingSound {
    return Intl.message(
      'Stop playing sound',
      name: 'stopPlayingSound',
      desc: '',
      args: [],
    );
  }

  /// `Camera permissions`
  String get cameraPermissions {
    return Intl.message(
      'Camera permissions',
      name: 'cameraPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Camera permissions are disabled in Windows Settings. Enable permissions to participate in video calls.`
  String get cameraPermissionsDisabledWindowsSettings {
    return Intl.message(
      'Camera permissions are disabled in Windows Settings. Enable permissions to participate in video calls.',
      name: 'cameraPermissionsDisabledWindowsSettings',
      desc: '',
      args: [],
    );
  }

  /// `Windows Settings: Camera`
  String get windowsSettingsCamera {
    return Intl.message(
      'Windows Settings: Camera',
      name: 'windowsSettingsCamera',
      desc: '',
      args: [],
    );
  }

  /// `Unknown device`
  String get unknownDevice {
    return Intl.message(
      'Unknown device',
      name: 'unknownDevice',
      desc: '',
      args: [],
    );
  }

  /// `Camera not found`
  String get cameraNotFound {
    return Intl.message(
      'Camera not found',
      name: 'cameraNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Test`
  String get test {
    return Intl.message('Test', name: 'test', desc: '', args: []);
  }

  /// `Click to check if others can hear you.`
  String get clickCheckOthers {
    return Intl.message(
      'Click to check if others can hear you.',
      name: 'clickCheckOthers',
      desc: '',
      args: [],
    );
  }

  /// `Recording from microphone`
  String get recordMicrophoneInProgress {
    return Intl.message(
      'Recording from microphone',
      name: 'recordMicrophoneInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Record from microphone`
  String get recordFromMicrophone {
    return Intl.message(
      'Record from microphone',
      name: 'recordFromMicrophone',
      desc: '',
      args: [],
    );
  }

  /// `Click to check if you can hear other users.`
  String get clickCheckHearOtherUsers {
    return Intl.message(
      'Click to check if you can hear other users.',
      name: 'clickCheckHearOtherUsers',
      desc: '',
      args: [],
    );
  }

  /// `Contact the official Chatify Support Team for help`
  String get contactingOfficialAppSupport {
    return Intl.message(
      'Contact the official Chatify Support Team for help',
      name: 'contactingOfficialAppSupport',
      desc: '',
      args: [],
    );
  }

  /// `Protect your chats with Chatify`
  String get protectChatsApp {
    return Intl.message(
      'Protect your chats with Chatify',
      name: 'protectChatsApp',
      desc: '',
      args: [],
    );
  }

  /// `Answers may be AI-generated`
  String get answersGeneratedAi {
    return Intl.message(
      'Answers may be AI-generated',
      name: 'answersGeneratedAi',
      desc: '',
      args: [],
    );
  }

  /// `Leave feedback to help us improve`
  String get leaveReviewHelpImprove {
    return Intl.message(
      'Leave feedback to help us improve',
      name: 'leaveReviewHelpImprove',
      desc: '',
      args: [],
    );
  }

  /// `Some answers are AI-generated using secure technology from Input Studios. Chatify uses your conversations with Chatify Support to provide relevant answers to your questions. Your private messages and calls are still protected with end-to-end encryption.`
  String get answersAiGeneratedSecureTechnology {
    return Intl.message(
      'Some answers are AI-generated using secure technology from Input Studios. Chatify uses your conversations with Chatify Support to provide relevant answers to your questions. Your private messages and calls are still protected with end-to-end encryption.',
      name: 'answersAiGeneratedSecureTechnology',
      desc: '',
      args: [],
    );
  }

  /// `Start a chat`
  String get startChat {
    return Intl.message('Start a chat', name: 'startChat', desc: '', args: []);
  }

  /// `Edit Favorites`
  String get editFavorites {
    return Intl.message(
      'Edit Favorites',
      name: 'editFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Creating call link...`
  String get creatingCallLink {
    return Intl.message(
      'Creating call link...',
      name: 'creatingCallLink',
      desc: '',
      args: [],
    );
  }

  /// `For 8 hours`
  String get forNineHours {
    return Intl.message(
      'For 8 hours',
      name: 'forNineHours',
      desc: '',
      args: [],
    );
  }

  /// `For 1 week`
  String get forOneWeek {
    return Intl.message('For 1 week', name: 'forOneWeek', desc: '', args: []);
  }

  /// `Silent until`
  String get noSoundUntil {
    return Intl.message(
      'Silent until',
      name: 'noSoundUntil',
      desc: '',
      args: [],
    );
  }

  /// `Always silent`
  String get alwaysSilent {
    return Intl.message(
      'Always silent',
      name: 'alwaysSilent',
      desc: '',
      args: [],
    );
  }

  /// `Unmute`
  String get turnOnSound {
    return Intl.message('Unmute', name: 'turnOnSound', desc: '', args: []);
  }

  /// `Chatify Support Team AI chat information`
  String get appAiSupportChatInfo {
    return Intl.message(
      'Chatify Support Team AI chat information',
      name: 'appAiSupportChatInfo',
      desc: '',
      args: [],
    );
  }

  /// `Get help faster`
  String get getHelpFaster {
    return Intl.message(
      'Get help faster',
      name: 'getHelpFaster',
      desc: '',
      args: [],
    );
  }

  /// `Chatify Support Team can use AI to answer your questions quickly 24/7.`
  String get appSupportTeamAiQuestions {
    return Intl.message(
      'Chatify Support Team can use AI to answer your questions quickly 24/7.',
      name: 'appSupportTeamAiQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Find out which chats use AI`
  String get findOutChatsUseAi {
    return Intl.message(
      'Find out which chats use AI',
      name: 'findOutChatsUseAi',
      desc: '',
      args: [],
    );
  }

  /// `Check out the Help Center for more information`
  String get moreInfoVisitHelpCenter {
    return Intl.message(
      'Check out the Help Center for more information',
      name: 'moreInfoVisitHelpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Visit the Help Center to find answers to your questions and read articles about the AI-powered messages we use.`
  String get visitHelpCenterFindAnswers {
    return Intl.message(
      'Visit the Help Center to find answers to your questions and read articles about the AI-powered messages we use.',
      name: 'visitHelpCenterFindAnswers',
      desc: '',
      args: [],
    );
  }

  /// `Messages generated by Input Studios' AI are marked with a . `
  String get aiGeneratedMessagesMarkedSymbol {
    return Intl.message(
      'Messages generated by Input Studios\' AI are marked with a . ',
      name: 'aiGeneratedMessagesMarkedSymbol',
      desc: '',
      args: [],
    );
  }

  /// `You can provide feedback on your AI-powered messages to help Chatify improve their quality.`
  String get feedbackAiGeneratedMessagesAppQuality {
    return Intl.message(
      'You can provide feedback on your AI-powered messages to help Chatify improve their quality.',
      name: 'feedbackAiGeneratedMessagesAppQuality',
      desc: '',
      args: [],
    );
  }

  /// `Reset an unsent message?`
  String get resetUnsentMessage {
    return Intl.message(
      'Reset an unsent message?',
      name: 'resetUnsentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your message and attached media will not be sent if you close this screen.`
  String get messageAttachedMediaScreen {
    return Intl.message(
      'Your message and attached media will not be sent if you close this screen.',
      name: 'messageAttachedMediaScreen',
      desc: '',
      args: [],
    );
  }

  /// `Add details`
  String get addDetails {
    return Intl.message('Add details', name: 'addDetails', desc: '', args: []);
  }

  /// `Failed to open the add contact screen.`
  String get failedOpenContactAddScreen {
    return Intl.message(
      'Failed to open the add contact screen.',
      name: 'failedOpenContactAddScreen',
      desc: '',
      args: [],
    );
  }

  /// `Search for country/region`
  String get searchCountryRegion {
    return Intl.message(
      'Search for country/region',
      name: 'searchCountryRegion',
      desc: '',
      args: [],
    );
  }

  /// `Message to yourself`
  String get messageMyself {
    return Intl.message(
      'Message to yourself',
      name: 'messageMyself',
      desc: '',
      args: [],
    );
  }

  /// `Sync contact on phone`
  String get syncContactOnPhone {
    return Intl.message(
      'Sync contact on phone',
      name: 'syncContactOnPhone',
      desc: '',
      args: [],
    );
  }

  /// `This contact will be added to your phone's address book.`
  String get contactAddYourPhoneAddressBook {
    return Intl.message(
      'This contact will be added to your phone\'s address book.',
      name: 'contactAddYourPhoneAddressBook',
      desc: '',
      args: [],
    );
  }

  /// `Delete chats`
  String get deleteChats {
    return Intl.message(
      'Delete chats',
      name: 'deleteChats',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete chat`
  String get failedDeleteChat {
    return Intl.message(
      'Failed to delete chat',
      name: 'failedDeleteChat',
      desc: '',
      args: [],
    );
  }

  /// `All new messages in this chat will disappear after the selected amount of time.`
  String get allNewMessagesDisappearSelected {
    return Intl.message(
      'All new messages in this chat will disappear after the selected amount of time.',
      name: 'allNewMessagesDisappearSelected',
      desc: '',
      args: [],
    );
  }

  /// `Delete image`
  String get deleteImage {
    return Intl.message(
      'Delete image',
      name: 'deleteImage',
      desc: '',
      args: [],
    );
  }

  /// `View image`
  String get viewImage {
    return Intl.message('View image', name: 'viewImage', desc: '', args: []);
  }

  /// `Change image`
  String get changeImage {
    return Intl.message(
      'Change image',
      name: 'changeImage',
      desc: '',
      args: [],
    );
  }

  /// `Mark as unread`
  String get markAsUnread {
    return Intl.message(
      'Mark as unread',
      name: 'markAsUnread',
      desc: '',
      args: [],
    );
  }

  /// `Pin to top`
  String get pinToTop {
    return Intl.message('Pin to top', name: 'pinToTop', desc: '', args: []);
  }

  /// `Archive`
  String get archive {
    return Intl.message('Archive', name: 'archive', desc: '', args: []);
  }

  /// `Not contacts`
  String get areNotContacts {
    return Intl.message(
      'Not contacts',
      name: 'areNotContacts',
      desc: '',
      args: [],
    );
  }

  /// `Drafts`
  String get drafts {
    return Intl.message('Drafts', name: 'drafts', desc: '', args: []);
  }

  /// `Return to the chat list`
  String get returnChatList {
    return Intl.message(
      'Return to the chat list',
      name: 'returnChatList',
      desc: '',
      args: [],
    );
  }

  /// `Select a country/region`
  String get selectCountryRegion {
    return Intl.message(
      'Select a country/region',
      name: 'selectCountryRegion',
      desc: '',
      args: [],
    );
  }

  /// `Enter a phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter a phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter a phone number to start a chat.`
  String get startChatPleaseEnterPhoneNumber {
    return Intl.message(
      'Enter a phone number to start a chat.',
      name: 'startChatPleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `New list`
  String get newList {
    return Intl.message('New list', name: 'newList', desc: '', args: []);
  }

  /// `List title`
  String get listTitle {
    return Intl.message('List title', name: 'listTitle', desc: '', args: []);
  }

  /// `Examples: "Work", "Friends"`
  String get examples {
    return Intl.message(
      'Examples: "Work", "Friends"',
      name: 'examples',
      desc: '',
      args: [],
    );
  }

  /// `Any list you create becomes a filter at the top of the Chats tab.`
  String get listCreateFilterChatsTab {
    return Intl.message(
      'Any list you create becomes a filter at the top of the Chats tab.',
      name: 'listCreateFilterChatsTab',
      desc: '',
      args: [],
    );
  }

  /// `Add people or groups`
  String get addPeopleOrGroups {
    return Intl.message(
      'Add people or groups',
      name: 'addPeopleOrGroups',
      desc: '',
      args: [],
    );
  }

  /// `Other participants won't see that you've muted the chat. If you are mentioned, you will receive a notification.`
  String get participantsNotifyMentioned {
    return Intl.message(
      'Other participants won\'t see that you\'ve muted the chat. If you are mentioned, you will receive a notification.',
      name: 'participantsNotifyMentioned',
      desc: '',
      args: [],
    );
  }

  /// `8 hours`
  String get nineHours {
    return Intl.message('8 hours', name: 'nineHours', desc: '', args: []);
  }

  /// `1 week`
  String get oneWeek {
    return Intl.message('1 week', name: 'oneWeek', desc: '', args: []);
  }

  /// `Did you want to switch apps?`
  String get switchApps {
    return Intl.message(
      'Did you want to switch apps?',
      name: 'switchApps',
      desc: '',
      args: [],
    );
  }

  /// `Chatify is trying to open Settings.`
  String get appTryingOpenSettings {
    return Intl.message(
      'Chatify is trying to open Settings.',
      name: 'appTryingOpenSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select color scheme`
  String get selectColorScheme {
    return Intl.message(
      'Select color scheme',
      name: 'selectColorScheme',
      desc: '',
      args: [],
    );
  }

  /// `Decoding voice messages`
  String get decodingVoiceMessages {
    return Intl.message(
      'Decoding voice messages',
      name: 'decodingVoiceMessages',
      desc: '',
      args: [],
    );
  }

  /// `Read new voice messages`
  String get readNewVoiceMessages {
    return Intl.message(
      'Read new voice messages',
      name: 'readNewVoiceMessages',
      desc: '',
      args: [],
    );
  }

  /// `Bright`
  String get bright {
    return Intl.message('Bright', name: 'bright', desc: '', args: []);
  }

  /// `Select a chat`
  String get selectChat {
    return Intl.message(
      'Select a chat',
      name: 'selectChat',
      desc: '',
      args: [],
    );
  }

  /// `Ensure secure login and protect your account`
  String get ensureSecureLoginProtectAcc {
    return Intl.message(
      'Ensure secure login and protect your account',
      name: 'ensureSecureLoginProtectAcc',
      desc: '',
      args: [],
    );
  }

  /// `Create an access key so you have a secure and easy way to sign in to your account.`
  String get createAccessKeySecureSignInAcc {
    return Intl.message(
      'Create an access key so you have a secure and easy way to sign in to your account.',
      name: 'createAccessKeySecureSignInAcc',
      desc: '',
      args: [],
    );
  }

  /// `Log in to Chatify with face or fingerprint recognition, or with the screen lock feature.`
  String get logInAppFaceFingerprintRecognition {
    return Intl.message(
      'Log in to Chatify with face or fingerprint recognition, or with the screen lock feature.',
      name: 'logInAppFaceFingerprintRecognition',
      desc: '',
      args: [],
    );
  }

  /// `Your access key is securely stored in your password manager.`
  String get accessKeySecurelyStoredPassManager {
    return Intl.message(
      'Your access key is securely stored in your password manager.',
      name: 'accessKeySecurelyStoredPassManager',
      desc: '',
      args: [],
    );
  }

  /// `Password created`
  String get passkeyCreated {
    return Intl.message(
      'Password created',
      name: 'passkeyCreated',
      desc: '',
      args: [],
    );
  }

  /// `Create access key`
  String get createAccessKey {
    return Intl.message(
      'Create access key',
      name: 'createAccessKey',
      desc: '',
      args: [],
    );
  }

  /// `Error signing out. Please try again.`
  String get errorLogout {
    return Intl.message(
      'Error signing out. Please try again.',
      name: 'errorLogout',
      desc: '',
      args: [],
    );
  }

  /// `Error signing out. Please try again.`
  String get errorDuringLogout {
    return Intl.message(
      'Error signing out. Please try again.',
      name: 'errorDuringLogout',
      desc: '',
      args: [],
    );
  }

  /// `Enter your old phone number with country code:`
  String get enterPhoneNumberCountryCode {
    return Intl.message(
      'Enter your old phone number with country code:',
      name: 'enterPhoneNumberCountryCode',
      desc: '',
      args: [],
    );
  }

  /// `This is required`
  String get thisFieldRequired {
    return Intl.message(
      'This is required',
      name: 'thisFieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new phone number with country code:`
  String get enterNewPhoneNumCountryCode {
    return Intl.message(
      'Enter your new phone number with country code:',
      name: 'enterNewPhoneNumCountryCode',
      desc: '',
      args: [],
    );
  }

  /// `Add an email address`
  String get addEmailAddress {
    return Intl.message(
      'Add an email address',
      name: 'addEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `We will send a confirmation code to this email address.`
  String get sendConfirmCodeEmailAddress {
    return Intl.message(
      'We will send a confirmation code to this email address.',
      name: 'sendConfirmCodeEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Unknown country`
  String get unknownCountry {
    return Intl.message(
      'Unknown country',
      name: 'unknownCountry',
      desc: '',
      args: [],
    );
  }

  /// `Invalid country code`
  String get invalidCountryCode {
    return Intl.message(
      'Invalid country code',
      name: 'invalidCountryCode',
      desc: '',
      args: [],
    );
  }

  /// `Changing your phone number will move your groups, settings, and account data.`
  String get changingYourPhoneNumber {
    return Intl.message(
      'Changing your phone number will move your groups, settings, and account data.',
      name: 'changingYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Before continuing, make sure you can receive text messages or calls on your new number.`
  String get beforeContinueReceiveCallsNumber {
    return Intl.message(
      'Before continuing, make sure you can receive text messages or calls on your new number.',
      name: 'beforeContinueReceiveCallsNumber',
      desc: '',
      args: [],
    );
  }

  /// `If you have changed both your phone and number, change your number on your old phone first.`
  String get changedPhoneYourNumber {
    return Intl.message(
      'If you have changed both your phone and number, change your number on your old phone first.',
      name: 'changedPhoneYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add an email address, to secure your account`
  String get addEmailAddressSecureAccount {
    return Intl.message(
      'Add an email address, to secure your account',
      name: 'addEmailAddressSecureAccount',
      desc: '',
      args: [],
    );
  }

  /// `Verify your account even without SMS.`
  String get confirmAccountEven {
    return Intl.message(
      'Verify your account even without SMS.',
      name: 'confirmAccountEven',
      desc: '',
      args: [],
    );
  }

  /// `An email address will help us contact you for security issues or to provide support.`
  String get emailAddressContactProvideSupport {
    return Intl.message(
      'An email address will help us contact you for security issues or to provide support.',
      name: 'emailAddressContactProvideSupport',
      desc: '',
      args: [],
    );
  }

  /// `Your email address will not be displayed to other users.`
  String get emailAddressDisplayedUsers {
    return Intl.message(
      'Your email address will not be displayed to other users.',
      name: 'emailAddressDisplayedUsers',
      desc: '',
      args: [],
    );
  }

  /// `Create a 6-digit PIN you can remember`
  String get createSixDigitRemember {
    return Intl.message(
      'Create a 6-digit PIN you can remember',
      name: 'createSixDigitRemember',
      desc: '',
      args: [],
    );
  }

  /// `With end-to-end encryption, your private messages stay between you and the people you message. Not even Chatify can access them. These include:`
  String get endToEndEncryptionPrivateMessages {
    return Intl.message(
      'With end-to-end encryption, your private messages stay between you and the people you message. Not even Chatify can access them. These include:',
      name: 'endToEndEncryptionPrivateMessages',
      desc: '',
      args: [],
    );
  }

  /// `Open in browser`
  String get openInBrowser {
    return Intl.message(
      'Open in browser',
      name: 'openInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Show security notifications on this device`
  String get securityNotificationsDevice {
    return Intl.message(
      'Show security notifications on this device',
      name: 'securityNotificationsDevice',
      desc: '',
      args: [],
    );
  }

  /// `Get notified when the security code \n changes on your phone and the phone of a \n end-to-end encrypted chat contact. If you have \n multiple devices, you must enable this setting \n separately on each device you want to \n receive notifications on. `
  String get notifySecurityCodeEndToEndEncrypted {
    return Intl.message(
      'Get notified when the security code \n changes on your phone and the phone of a \n end-to-end encrypted chat contact. If you have \n multiple devices, you must enable this setting \n separately on each device you want to \n receive notifications on. ',
      name: 'notifySecurityCodeEndToEndEncrypted',
      desc: '',
      args: [],
    );
  }

  /// `Generate a report of your Chatify account \n information and settings that you can \n view or export to another app. This report does not \n include your messages. `
  String get generateReportAppAccountInfo {
    return Intl.message(
      'Generate a report of your Chatify account \n information and settings that you can \n view or export to another app. This report does not \n include your messages. ',
      name: 'generateReportAppAccountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get accountInfo {
    return Intl.message(
      'Account Info',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Request Report`
  String get requestReport {
    return Intl.message(
      'Request Report',
      name: 'requestReport',
      desc: '',
      args: [],
    );
  }

  /// `Generate a report of your Chatify account \n information and settings that you can \n view or export to another app. This report does not \n include your messages. `
  String get generateReportInfoSettings {
    return Intl.message(
      'Generate a report of your Chatify account \n information and settings that you can \n view or export to another app. This report does not \n include your messages. ',
      name: 'generateReportInfoSettings',
      desc: '',
      args: [],
    );
  }

  /// `Generate reports \n automatically`
  String get generateReportsAuto {
    return Intl.message(
      'Generate reports \n automatically',
      name: 'generateReportsAuto',
      desc: '',
      args: [],
    );
  }

  /// `A new report will be generated monthly. `
  String get newReportGeneratedMonthly {
    return Intl.message(
      'A new report will be generated monthly. ',
      name: 'newReportGeneratedMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Search countries`
  String get searchCountries {
    return Intl.message(
      'Search countries',
      name: 'searchCountries',
      desc: '',
      args: [],
    );
  }

  /// `For an extra layer of security, enable two-step verification, which will require a PIN when re-registering your number to Chatify. `
  String get extraLayerSecurityTwoStepVerify {
    return Intl.message(
      'For an extra layer of security, enable two-step verification, which will require a PIN when re-registering your number to Chatify. ',
      name: 'extraLayerSecurityTwoStepVerify',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get turnOn {
    return Intl.message('Enable', name: 'turnOn', desc: '', args: []);
  }

  /// `Backup settings. Create backup copies of your chats and media files to your Input Studios account storage. You can restore them on a new phone after downloading Chatify.'`
  String get backupSettingsAccountStorage {
    return Intl.message(
      'Backup settings. Create backup copies of your chats and media files to your Input Studios account storage. You can restore them on a new phone after downloading Chatify.\'',
      name: 'backupSettingsAccountStorage',
      desc: '',
      args: [],
    );
  }

  /// `Create backup`
  String get createBackupCopy {
    return Intl.message(
      'Create backup',
      name: 'createBackupCopy',
      desc: '',
      args: [],
    );
  }

  /// `Export chat`
  String get exportChat {
    return Intl.message('Export chat', name: 'exportChat', desc: '', args: []);
  }

  /// `Clear all chats`
  String get clearAllChats {
    return Intl.message(
      'Clear all chats',
      name: 'clearAllChats',
      desc: '',
      args: [],
    );
  }

  /// `Seasons`
  String get seasons {
    return Intl.message('Seasons', name: 'seasons', desc: '', args: []);
  }

  /// `Dark`
  String get darkWallpaper {
    return Intl.message('Dark', name: 'darkWallpaper', desc: '', args: []);
  }

  /// `Bright`
  String get brightWallpaper {
    return Intl.message('Bright', name: 'brightWallpaper', desc: '', args: []);
  }

  /// `Solid Colors`
  String get solidColors {
    return Intl.message(
      'Solid Colors',
      name: 'solidColors',
      desc: '',
      args: [],
    );
  }

  /// `My Photos`
  String get myPhotos {
    return Intl.message('My Photos', name: 'myPhotos', desc: '', args: []);
  }

  /// `Dark theme wallpaper`
  String get wallpaperDarkTheme {
    return Intl.message(
      'Dark theme wallpaper',
      name: 'wallpaperDarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light theme wallpaper`
  String get wallpaperLightTheme {
    return Intl.message(
      'Light theme wallpaper',
      name: 'wallpaperLightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Reset wallpaper settings`
  String get resetWallpaperSettings {
    return Intl.message(
      'Reset wallpaper settings',
      name: 'resetWallpaperSettings',
      desc: '',
      args: [],
    );
  }

  /// `Default wallpaper`
  String get defaultWallpaper {
    return Intl.message(
      'Default wallpaper',
      name: 'defaultWallpaper',
      desc: '',
      args: [],
    );
  }

  /// `Transfer chat history to Android devices`
  String get transferChatHistoryAndroidDevices {
    return Intl.message(
      'Transfer chat history to Android devices',
      name: 'transferChatHistoryAndroidDevices',
      desc: '',
      args: [],
    );
  }

  /// `Privately export your chat history and save recent messages without using Input Studios storage. You must grant permissions to connect to a new device.`
  String get privatelyExportHistorySaveRecentMessages {
    return Intl.message(
      'Privately export your chat history and save recent messages without using Input Studios storage. You must grant permissions to connect to a new device.',
      name: 'privatelyExportHistorySaveRecentMessages',
      desc: '',
      args: [],
    );
  }

  /// `This is the default Chatify wallpaper`
  String get defaultAppWallpaper {
    return Intl.message(
      'This is the default Chatify wallpaper',
      name: 'defaultAppWallpaper',
      desc: '',
      args: [],
    );
  }

  /// `Swipe left to view more wallpapers`
  String get swipeLeftViewMoreWallpapers {
    return Intl.message(
      'Swipe left to view more wallpapers',
      name: 'swipeLeftViewMoreWallpapers',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Set the dark theme wallpaper`
  String get setWallpaperDarkTheme {
    return Intl.message(
      'Set the dark theme wallpaper',
      name: 'setWallpaperDarkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Set wallpaper for light theme`
  String get setWallpaperLightTheme {
    return Intl.message(
      'Set wallpaper for light theme',
      name: 'setWallpaperLightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Set wallpaper`
  String get setWallpaper {
    return Intl.message(
      'Set wallpaper',
      name: 'setWallpaper',
      desc: '',
      args: [],
    );
  }

  /// `Wallpaper installed`
  String get wallpaperInstalled {
    return Intl.message(
      'Wallpaper installed',
      name: 'wallpaperInstalled',
      desc: '',
      args: [],
    );
  }

  /// `Wallpaper not installed, no image selected`
  String get wallpaperImageSelected {
    return Intl.message(
      'Wallpaper not installed, no image selected',
      name: 'wallpaperImageSelected',
      desc: '',
      args: [],
    );
  }

  /// `Wallpaper not installed`
  String get wallpaperNotInstalled {
    return Intl.message(
      'Wallpaper not installed',
      name: 'wallpaperNotInstalled',
      desc: '',
      args: [],
    );
  }

  /// `Contact name`
  String get contactName {
    return Intl.message(
      'Contact name',
      name: 'contactName',
      desc: '',
      args: [],
    );
  }

  /// `Darkening wallpaper`
  String get darkeningWallpaper {
    return Intl.message(
      'Darkening wallpaper',
      name: 'darkeningWallpaper',
      desc: '',
      args: [],
    );
  }

  /// `To change the wallpaper for light theme, enable light theme: Settings > Chats > Theme.`
  String get changeWallpaperLightTheme {
    return Intl.message(
      'To change the wallpaper for light theme, enable light theme: Settings > Chats > Theme.',
      name: 'changeWallpaperLightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Tap and hold a message or channel post to add it to Favorites. This makes it easy to find content later.`
  String get longPressMessageChannelFavorites {
    return Intl.message(
      'Tap and hold a message or channel post to add it to Favorites. This makes it easy to find content later.',
      name: 'longPressMessageChannelFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Make it easier to find the people and groups that matter to you in Chatify.`
  String get easierFindPeopleGroups {
    return Intl.message(
      'Make it easier to find the people and groups that matter to you in Chatify.',
      name: 'easierFindPeopleGroups',
      desc: '',
      args: [],
    );
  }

  /// `You can edit your Favorites here or change the order in which Favorites appear in the Calls tab.`
  String get favoritesChangeFavoritesCalls {
    return Intl.message(
      'You can edit your Favorites here or change the order in which Favorites appear in the Calls tab.',
      name: 'favoritesChangeFavoritesCalls',
      desc: '',
      args: [],
    );
  }

  /// `Please describe what happened and attach images or additional details if necessary. This will help our team quickly understand the situation and offer a solution.`
  String get pleaseDescribeHappenedAttachImages {
    return Intl.message(
      'Please describe what happened and attach images or additional details if necessary. This will help our team quickly understand the situation and offer a solution.',
      name: 'pleaseDescribeHappenedAttachImages',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to Chatify reviewing your technical account information so that our team can provide you with assistance with this issue.`
  String get continuingAgreeAppTechInfo {
    return Intl.message(
      'By continuing, you agree to Chatify reviewing your technical account information so that our team can provide you with assistance with this issue.',
      name: 'continuingAgreeAppTechInfo',
      desc: '',
      args: [],
    );
  }

  /// `We will answer you in Chatify`
  String get answerAppChat {
    return Intl.message(
      'We will answer you in Chatify',
      name: 'answerAppChat',
      desc: '',
      args: [],
    );
  }

  /// `How to stay safe on Chatify`
  String get howStaySafeApp {
    return Intl.message(
      'How to stay safe on Chatify',
      name: 'howStaySafeApp',
      desc: '',
      args: [],
    );
  }

  /// `You received a verification code even though you didn't ask for it`
  String get receivedVerifyCode {
    return Intl.message(
      'You received a verification code even though you didn\'t ask for it',
      name: 'receivedVerifyCode',
      desc: '',
      args: [],
    );
  }

  /// `How to change your phone number`
  String get howChangePhoneNumber {
    return Intl.message(
      'How to change your phone number',
      name: 'howChangePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `How to block and report a user`
  String get howBlockReportUser {
    return Intl.message(
      'How to block and report a user',
      name: 'howBlockReportUser',
      desc: '',
      args: [],
    );
  }

  /// `All Popular Articles`
  String get allPopularArticles {
    return Intl.message(
      'All Popular Articles',
      name: 'allPopularArticles',
      desc: '',
      args: [],
    );
  }

  /// `You can send a complaint`
  String get youSendComplaint {
    return Intl.message(
      'You can send a complaint',
      name: 'youSendComplaint',
      desc: '',
      args: [],
    );
  }

  /// `About our app`
  String get aboutOurApp {
    return Intl.message(
      'About our app',
      name: 'aboutOurApp',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found`
  String get nothingFound {
    return Intl.message(
      'Nothing found',
      name: 'nothingFound',
      desc: '',
      args: [],
    );
  }

  /// `Check your spelling or use other keywords.`
  String get pleaseCheckSpellingDifferentKeywords {
    return Intl.message(
      'Check your spelling or use other keywords.',
      name: 'pleaseCheckSpellingDifferentKeywords',
      desc: '',
      args: [],
    );
  }

  /// `Let's chat in Chatify. It's a fast, convenient and safe app for communicating with each other for free. Download https://inputstudios.ru/download`
  String get appConvenientCommunication {
    return Intl.message(
      'Let\'s chat in Chatify. It\'s a fast, convenient and safe app for communicating with each other for free. Download https://inputstudios.ru/download',
      name: 'appConvenientCommunication',
      desc: '',
      args: [],
    );
  }

  /// `From contacts`
  String get fromContacts {
    return Intl.message(
      'From contacts',
      name: 'fromContacts',
      desc: '',
      args: [],
    );
  }

  /// `Only you can see who is in your lists`
  String get onlyYouSeeWhoLists {
    return Intl.message(
      'Only you can see who is in your lists',
      name: 'onlyYouSeeWhoLists',
      desc: '',
      args: [],
    );
  }

  /// `Use the pencil to change the order of lists on the "Chats" tab.`
  String get usePencilChangeOrderLists {
    return Intl.message(
      'Use the pencil to change the order of lists on the "Chats" tab.',
      name: 'usePencilChangeOrderLists',
      desc: '',
      args: [],
    );
  }

  /// `Included in the list`
  String get includedInList {
    return Intl.message(
      'Included in the list',
      name: 'includedInList',
      desc: '',
      args: [],
    );
  }

  /// `Add people or groups`
  String get addPeopleOrGroupsFavorite {
    return Intl.message(
      'Add people or groups',
      name: 'addPeopleOrGroupsFavorite',
      desc: '',
      args: [],
    );
  }

  /// `You can edit your Favorites here or change the order in which Favorites appear on the Calls tab`
  String get editYourFavoritesChange {
    return Intl.message(
      'You can edit your Favorites here or change the order in which Favorites appear on the Calls tab',
      name: 'editYourFavoritesChange',
      desc: '',
      args: [],
    );
  }

  /// `This list is updated automatically for you to display all group chats.`
  String get listUpdatedAutoDisplayGroupChats {
    return Intl.message(
      'This list is updated automatically for you to display all group chats.',
      name: 'listUpdatedAutoDisplayGroupChats',
      desc: '',
      args: [],
    );
  }

  /// `Group chats`
  String get groupChats {
    return Intl.message('Group chats', name: 'groupChats', desc: '', args: []);
  }

  /// `Any list you create becomes a filter at the top of the Chats tab.`
  String get listCreateFilterTopChats {
    return Intl.message(
      'Any list you create becomes a filter at the top of the Chats tab.',
      name: 'listCreateFilterTopChats',
      desc: '',
      args: [],
    );
  }

  /// `Create your own list`
  String get createYourOwnList {
    return Intl.message(
      'Create your own list',
      name: 'createYourOwnList',
      desc: '',
      args: [],
    );
  }

  /// `Your lists`
  String get yourLists {
    return Intl.message('Your lists', name: 'yourLists', desc: '', args: []);
  }

  /// `Preset`
  String get preset {
    return Intl.message('Preset', name: 'preset', desc: '', args: []);
  }

  /// `Available presets`
  String get availablePresets {
    return Intl.message(
      'Available presets',
      name: 'availablePresets',
      desc: '',
      args: [],
    );
  }

  /// `If you delete one of the preset lists, such as "Unread" or "Groups", it will be available here.`
  String get deleteOnePresetListsUnreadGroups {
    return Intl.message(
      'If you delete one of the preset lists, such as "Unread" or "Groups", it will be available here.',
      name: 'deleteOnePresetListsUnreadGroups',
      desc: '',
      args: [],
    );
  }

  /// `This list is automatically deleted for you, showing all chats with unread messages.`
  String get listAutoChatsUnreadMessages {
    return Intl.message(
      'This list is automatically deleted for you, showing all chats with unread messages.',
      name: 'listAutoChatsUnreadMessages',
      desc: '',
      args: [],
    );
  }

  /// `Unread chats`
  String get unreadChats {
    return Intl.message(
      'Unread chats',
      name: 'unreadChats',
      desc: '',
      args: [],
    );
  }

  /// `Reset notification settings`
  String get resetNotifySettings {
    return Intl.message(
      'Reset notification settings',
      name: 'resetNotifySettings',
      desc: '',
      args: [],
    );
  }

  /// `Sounds in chat`
  String get soundsInChat {
    return Intl.message(
      'Sounds in chat',
      name: 'soundsInChat',
      desc: '',
      args: [],
    );
  }

  /// `Play sounds for \nincoming and \noutgoing messages`
  String get playSoundsIncomingOutgoing {
    return Intl.message(
      'Play sounds for \nincoming and \noutgoing messages',
      name: 'playSoundsIncomingOutgoing',
      desc: '',
      args: [],
    );
  }

  /// `Reminders`
  String get reminders {
    return Intl.message('Reminders', name: 'reminders', desc: '', args: []);
  }

  /// `Get periodic \nreminders for status updates you \nmissed seen`
  String get periodicRemindersStatusUpdates {
    return Intl.message(
      'Get periodic \nreminders for status updates you \nmissed seen',
      name: 'periodicRemindersStatusUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Notification sound`
  String get notificationSound {
    return Intl.message(
      'Notification sound',
      name: 'notificationSound',
      desc: '',
      args: [],
    );
  }

  /// `Default (Bongo)`
  String get defaultBongo {
    return Intl.message(
      'Default (Bongo)',
      name: 'defaultBongo',
      desc: '',
      args: [],
    );
  }

  /// `Vibration`
  String get vibration {
    return Intl.message('Vibration', name: 'vibration', desc: '', args: []);
  }

  /// `Pop-up notification`
  String get popPopNotify {
    return Intl.message(
      'Pop-up notification',
      name: 'popPopNotify',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get notAvailable {
    return Intl.message(
      'Not available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get lightNotify {
    return Intl.message('Light', name: 'lightNotify', desc: '', args: []);
  }

  /// `White`
  String get whiteNotify {
    return Intl.message('White', name: 'whiteNotify', desc: '', args: []);
  }

  /// `Priority notifications`
  String get priorityNotifications {
    return Intl.message(
      'Priority notifications',
      name: 'priorityNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Show pop-up \nnotifications at the top of the \nscreen`
  String get showPopUpNotify {
    return Intl.message(
      'Show pop-up \nnotifications at the top of the \nscreen',
      name: 'showPopUpNotify',
      desc: '',
      args: [],
    );
  }

  /// `Reaction notifications`
  String get reactionNotify {
    return Intl.message(
      'Reaction notifications',
      name: 'reactionNotify',
      desc: '',
      args: [],
    );
  }

  /// `Show notifications \nabout reactions to messages you \nsent`
  String get showNotifyReactionsMessagesSend {
    return Intl.message(
      'Show notifications \nabout reactions to messages you \nsent',
      name: 'showNotifyReactionsMessagesSend',
      desc: '',
      args: [],
    );
  }

  /// `Show pop-up \nnotifications at the top of the \nscreen`
  String get showPopUpNotificationsScreen {
    return Intl.message(
      'Show pop-up \nnotifications at the top of the \nscreen',
      name: 'showPopUpNotificationsScreen',
      desc: '',
      args: [],
    );
  }

  /// `Show notifications \n about reactions to messages you send`
  String get showNotifyAboutReactionsSend {
    return Intl.message(
      'Show notifications \n about reactions to messages you send',
      name: 'showNotifyAboutReactionsSend',
      desc: '',
      args: [],
    );
  }

  /// `Melody`
  String get melody {
    return Intl.message('Melody', name: 'melody', desc: '', args: []);
  }

  /// `Default (Huawei Tune Living)`
  String get defaultNotify {
    return Intl.message(
      'Default (Huawei Tune Living)',
      name: 'defaultNotify',
      desc: '',
      args: [],
    );
  }

  /// `Show notifications when a status is \nliked`
  String get showNotifyStatusLiked {
    return Intl.message(
      'Show notifications when a status is \nliked',
      name: 'showNotifyStatusLiked',
      desc: '',
      args: [],
    );
  }

  /// `Automatic timer`
  String get automaticTimer {
    return Intl.message(
      'Automatic timer',
      name: 'automaticTimer',
      desc: '',
      args: [],
    );
  }

  /// `Timer for messages disappearing in new chats:`
  String get timerDisappearingMessagesNewChats {
    return Intl.message(
      'Timer for messages disappearing in new chats:',
      name: 'timerDisappearingMessagesNewChats',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, messages in all new individual chats will disappear after the selected period of time. This will not affect existing chats. `
  String get modeEnabledMessagesNewIndividualChats {
    return Intl.message(
      'When enabled, messages in all new individual chats will disappear after the selected period of time. This will not affect existing chats. ',
      name: 'modeEnabledMessagesNewIndividualChats',
      desc: '',
      args: [],
    );
  }

  /// `This will not affect existing chats. To apply this message timer to existing chats, `
  String get notAffectApplyMessageTimerExistingChats {
    return Intl.message(
      'This will not affect existing chats. To apply this message timer to existing chats, ',
      name: 'notAffectApplyMessageTimerExistingChats',
      desc: '',
      args: [],
    );
  }

  /// `select them. `
  String get selectThem {
    return Intl.message(
      'select them. ',
      name: 'selectThem',
      desc: '',
      args: [],
    );
  }

  /// `Blocked`
  String get blocked {
    return Intl.message('Blocked', name: 'blocked', desc: '', args: []);
  }

  /// `Click the icon`
  String get clickOnIcon {
    return Intl.message(
      'Click the icon',
      name: 'clickOnIcon',
      desc: '',
      args: [],
    );
  }

  /// `to select the contact you want to block`
  String get selectContactYouBlock {
    return Intl.message(
      'to select the contact you want to block',
      name: 'selectContactYouBlock',
      desc: '',
      args: [],
    );
  }

  /// `Blocked contacts will no longer be able to call or message you.`
  String get blockedContactsLongerCallMessage {
    return Intl.message(
      'Blocked contacts will no longer be able to call or message you.',
      name: 'blockedContactsLongerCallMessage',
      desc: '',
      args: [],
    );
  }

  /// `Closed chats are not displayed in the general list`
  String get closedChatsDisplayedGeneralList {
    return Intl.message(
      'Closed chats are not displayed in the general list',
      name: 'closedChatsDisplayedGeneralList',
      desc: '',
      args: [],
    );
  }

  /// `If you have private chats, pull down the chat list or enter your secret code in the search bar to find them. `
  String get youHavePrivateChatsListEnterSearch {
    return Intl.message(
      'If you have private chats, pull down the chat list or enter your secret code in the search bar to find them. ',
      name: 'youHavePrivateChatsListEnterSearch',
      desc: '',
      args: [],
    );
  }

  /// `Open and clear all closed chats`
  String get openClearAllClosedChats {
    return Intl.message(
      'Open and clear all closed chats',
      name: 'openClearAllClosedChats',
      desc: '',
      args: [],
    );
  }

  /// `If you forgot your secret code, you can reset it. This will delete messages, photos, and videos in private chats and open the chats themselves.`
  String get youForgottenYourSecretCode {
    return Intl.message(
      'If you forgot your secret code, you can reset it. This will delete messages, photos, and videos in private chats and open the chats themselves.',
      name: 'youForgottenYourSecretCode',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Check`
  String get privacyCheck {
    return Intl.message(
      'Privacy Check',
      name: 'privacyCheck',
      desc: '',
      args: [],
    );
  }

  /// `Control your personal data`
  String get controlYourPersonalData {
    return Intl.message(
      'Control your personal data',
      name: 'controlYourPersonalData',
      desc: '',
      args: [],
    );
  }

  /// `Choose who can see your activity and online status`
  String get chooseActivityOnlineStatus {
    return Intl.message(
      'Choose who can see your activity and online status',
      name: 'chooseActivityOnlineStatus',
      desc: '',
      args: [],
    );
  }

  /// `Who sees my profile picture`
  String get seesMyProfilePicture {
    return Intl.message(
      'Who sees my profile picture',
      name: 'seesMyProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Choose who can see your profile picture.`
  String get chooseYourProfilePhoto {
    return Intl.message(
      'Choose who can see your profile picture.',
      name: 'chooseYourProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Last seen and online status`
  String get lastSeenOnlineStatus {
    return Intl.message(
      'Last seen and online status',
      name: 'lastSeenOnlineStatus',
      desc: '',
      args: [],
    );
  }

  /// `Choose who can see when you are online.`
  String get chooseWhoOnline {
    return Intl.message(
      'Choose who can see when you are online.',
      name: 'chooseWhoOnline',
      desc: '',
      args: [],
    );
  }

  /// `When read receipts are turned on, other users will see whether you have read your messages.`
  String get readReceiptsTurnedOnUsersMessages {
    return Intl.message(
      'When read receipts are turned on, other users will see whether you have read your messages.',
      name: 'readReceiptsTurnedOnUsersMessages',
      desc: '',
      args: [],
    );
  }

  /// `Geodata`
  String get geodata {
    return Intl.message('Geodata', name: 'geodata', desc: '', args: []);
  }

  /// `You do not share geodata in any chats`
  String get youShareGeodataChat {
    return Intl.message(
      'You do not share geodata in any chats',
      name: 'youShareGeodataChat',
      desc: '',
      args: [],
    );
  }

  /// `Geodata requires background location access. You can change this in your phone.`
  String get geodataRequiresBackgroundLocationAccess {
    return Intl.message(
      'Geodata requires background location access. You can change this in your phone.',
      name: 'geodataRequiresBackgroundLocationAccess',
      desc: '',
      args: [],
    );
  }

  /// `Who sees my information`
  String get whoSeesMyInformation {
    return Intl.message(
      'Who sees my information',
      name: 'whoSeesMyInformation',
      desc: '',
      args: [],
    );
  }

  /// `Nobody`
  String get nobody {
    return Intl.message('Nobody', name: 'nobody', desc: '', args: []);
  }

  /// `If you do not share your last seen time online status, you will not be able to see other users' last seen time and online status.`
  String get shareYourLastSeenTimeOnlineStatus {
    return Intl.message(
      'If you do not share your last seen time online status, you will not be able to see other users\' last seen time and online status.',
      name: 'shareYourLastSeenTimeOnlineStatus',
      desc: '',
      args: [],
    );
  }

  /// `Last seen time`
  String get lastVisitedTime {
    return Intl.message(
      'Last seen time',
      name: 'lastVisitedTime',
      desc: '',
      args: [],
    );
  }

  /// `Who sees my last seen time`
  String get whoSeesMyLastVisitTime {
    return Intl.message(
      'Who sees my last seen time',
      name: 'whoSeesMyLastVisitTime',
      desc: '',
      args: [],
    );
  }

  /// `Who sees when I am online`
  String get whoSeesOnline {
    return Intl.message(
      'Who sees when I am online',
      name: 'whoSeesOnline',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your identity`
  String get pleaseConfirmYourIdentity {
    return Intl.message(
      'Please confirm your identity',
      name: 'pleaseConfirmYourIdentity',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication error`
  String get biometricAuthError {
    return Intl.message(
      'Biometric authentication error',
      name: 'biometricAuthError',
      desc: '',
      args: [],
    );
  }

  /// `Biometric`
  String get biometric {
    return Intl.message('Biometric', name: 'biometric', desc: '', args: []);
  }

  /// `Blocking the application`
  String get blockingApp {
    return Intl.message(
      'Blocking the application',
      name: 'blockingApp',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, Chatify \nwill need to be \nunlocked with your face, \nfingerprint, or other \nunique identifier. You \ncan still receive calls even if Chatify \nis blocked. \n`
  String get enabledAppUnlockedFingerprint {
    return Intl.message(
      'When enabled, Chatify \nwill need to be \nunlocked with your face, \nfingerprint, or other \nunique identifier. You \ncan still receive calls even if Chatify \nis blocked. \n',
      name: 'enabledAppUnlockedFingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Mute unknown \nnumbers`
  String get muteUnknownNumbers {
    return Intl.message(
      'Mute unknown \nnumbers',
      name: 'muteUnknownNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Calls from unknown \nnumbers will be muted. They \nwill still appear in the Calls tab and in notifications. `
  String get callsUnknownNumMutedNotify {
    return Intl.message(
      'Calls from unknown \nnumbers will be muted. They \nwill still appear in the Calls tab and in notifications. ',
      name: 'callsUnknownNumMutedNotify',
      desc: '',
      args: [],
    );
  }

  /// `We care about your privacy`
  String get weCareAboutYourPrivacy {
    return Intl.message(
      'We care about your privacy',
      name: 'weCareAboutYourPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Manage and customize your Chatify privacy settings.`
  String get manageCustomizeAppPrivacySettings {
    return Intl.message(
      'Manage and customize your Chatify privacy settings.',
      name: 'manageCustomizeAppPrivacySettings',
      desc: '',
      args: [],
    );
  }

  /// `Choose who can contact you you`
  String get chooseWhoContactYou {
    return Intl.message(
      'Choose who can contact you you',
      name: 'chooseWhoContactYou',
      desc: '',
      args: [],
    );
  }

  /// `Additional privacy for your information`
  String get additionalPrivacyInformation {
    return Intl.message(
      'Additional privacy for your information',
      name: 'additionalPrivacyInformation',
      desc: '',
      args: [],
    );
  }

  /// `Additional protection for your account`
  String get additionalProtectionYourAccount {
    return Intl.message(
      'Additional protection for your account',
      name: 'additionalProtectionYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Go to `
  String get goTo {
    return Intl.message('Go to ', name: 'goTo', desc: '', args: []);
  }

  /// `to view additional privacy settings.`
  String get viewAdditionalPrivacySettings {
    return Intl.message(
      'to view additional privacy settings.',
      name: 'viewAdditionalPrivacySettings',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get extended {
    return Intl.message('Advanced', name: 'extended', desc: '', args: []);
  }

  /// `Block messages from unknown accounts`
  String get blockMessagesUnknownAccounts {
    return Intl.message(
      'Block messages from unknown accounts',
      name: 'blockMessagesUnknownAccounts',
      desc: '',
      args: [],
    );
  }

  /// `To protect your account and improve your device experience, Chatify will block messages from unknown accounts if they \nexceed a certain threshold. \n`
  String get protectYourAccountAppMessages {
    return Intl.message(
      'To protect your account and improve your device experience, Chatify will block messages from unknown accounts if they \nexceed a certain threshold. \n',
      name: 'protectYourAccountAppMessages',
      desc: '',
      args: [],
    );
  }

  /// `Protect your IP address during calls`
  String get protectYourIpAddressCalls {
    return Intl.message(
      'Protect your IP address during calls',
      name: 'protectYourIpAddressCalls',
      desc: '',
      args: [],
    );
  }

  /// `To make it harder to determine \nyour location, calls \nfrom this device will be routed securely \nthrough Chatify's servers. \nThis will reduce the quality of your calls. \n`
  String get difficultDetermineLocationSecurely {
    return Intl.message(
      'To make it harder to determine \nyour location, calls \nfrom this device will be routed securely \nthrough Chatify\'s servers. \nThis will reduce the quality of your calls. \n',
      name: 'difficultDetermineLocationSecurely',
      desc: '',
      args: [],
    );
  }

  /// `Disable link \npreviews`
  String get disableLinkPreview {
    return Intl.message(
      'Disable link \npreviews',
      name: 'disableLinkPreview',
      desc: '',
      args: [],
    );
  }

  /// `To prevent your IP address from being \ndetected by third-party websites, \npreviews of links you share in chats will be \ndisabled. `
  String get preventIpAddressWebsites {
    return Intl.message(
      'To prevent your IP address from being \ndetected by third-party websites, \npreviews of links you share in chats will be \ndisabled. ',
      name: 'preventIpAddressWebsites',
      desc: '',
      args: [],
    );
  }

  /// `Who can add me to groups`
  String get whoCanAddGroups {
    return Intl.message(
      'Who can add me to groups',
      name: 'whoCanAddGroups',
      desc: '',
      args: [],
    );
  }

  /// `Admins who cannot add you to a group will have the option to send you a personal invite.`
  String get adminsCannotAddGroupOptionSend {
    return Intl.message(
      'Admins who cannot add you to a group will have the option to send you a personal invite.',
      name: 'adminsCannotAddGroupOptionSend',
      desc: '',
      args: [],
    );
  }

  /// `This setting does not apply to community ad sets. When you add yourself to a community, you are automatically added to the community ad set.`
  String get settingApplyCommunityAdSets {
    return Intl.message(
      'This setting does not apply to community ad sets. When you add yourself to a community, you are automatically added to the community ad set.',
      name: 'settingApplyCommunityAdSets',
      desc: '',
      args: [],
    );
  }

  /// `Personal Data Visibility`
  String get visibilityPersonalData {
    return Intl.message(
      'Personal Data Visibility',
      name: 'visibilityPersonalData',
      desc: '',
      args: [],
    );
  }

  /// `If you disable read receipts, you will not be able to send or receive these reports. \n These notifications cannot be \n disabled for group chats.`
  String get disableReadReceiptsSendReceiveNotify {
    return Intl.message(
      'If you disable read receipts, you will not be able to send or receive these reports. \n These notifications cannot be \n disabled for group chats.',
      name: 'disableReadReceiptsSendReceiveNotify',
      desc: '',
      args: [],
    );
  }

  /// `Automatic message timer`
  String get automaticMessageTimer {
    return Intl.message(
      'Automatic message timer',
      name: 'automaticMessageTimer',
      desc: '',
      args: [],
    );
  }

  /// `Start new chats \n with messages that will disappear according to the specified \n timer.`
  String get newChatsMessagesDisappearAccording {
    return Intl.message(
      'Start new chats \n with messages that will disappear according to the specified \n timer.',
      name: 'newChatsMessagesDisappearAccording',
      desc: '',
      args: [],
    );
  }

  /// `Turn off sound for unknown numbers`
  String get turnOffSoundUnknownNum {
    return Intl.message(
      'Turn off sound for unknown numbers',
      name: 'turnOffSoundUnknownNum',
      desc: '',
      args: [],
    );
  }

  /// `Disabled`
  String get disabled {
    return Intl.message('Disabled', name: 'disabled', desc: '', args: []);
  }

  /// `Allow camera effects`
  String get allowCameraEffects {
    return Intl.message(
      'Allow camera effects',
      name: 'allowCameraEffects',
      desc: '',
      args: [],
    );
  }

  /// `Use effects during video calls and \n recordings.`
  String get useEffectsDuringVideoCalls {
    return Intl.message(
      'Use effects during video calls and \n recordings.',
      name: 'useEffectsDuringVideoCalls',
      desc: '',
      args: [],
    );
  }

  /// `Protect your IP address during calls, disable link previews`
  String get protectIpAddressCallsLinkPreviews {
    return Intl.message(
      'Protect your IP address during calls, disable link previews',
      name: 'protectIpAddressCallsLinkPreviews',
      desc: '',
      args: [],
    );
  }

  /// `Manage your privacy and choose the settings that suit you.`
  String get manageYourPrivacyChooseSettings {
    return Intl.message(
      'Manage your privacy and choose the settings that suit you.',
      name: 'manageYourPrivacyChooseSettings',
      desc: '',
      args: [],
    );
  }

  /// `Provide additional protection for your account`
  String get provideAdditionalProtectionYourAccount {
    return Intl.message(
      'Provide additional protection for your account',
      name: 'provideAdditionalProtectionYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Use your fingerprint or face recognition to open Chatify on your device.`
  String get useFingerprintFaceRecognition {
    return Intl.message(
      'Use your fingerprint or face recognition to open Chatify on your device.',
      name: 'useFingerprintFaceRecognition',
      desc: '',
      args: [],
    );
  }

  /// `Create a PIN to re-register your phone number with Chatify.`
  String get createRegisterApp {
    return Intl.message(
      'Create a PIN to re-register your phone number with Chatify.',
      name: 'createRegisterApp',
      desc: '',
      args: [],
    );
  }

  /// `Manage your privacy. Choose who can contact you by blocking calls or messages from unwanted contacts.`
  String get manageYourPrivacyBlockingCalls {
    return Intl.message(
      'Manage your privacy. Choose who can contact you by blocking calls or messages from unwanted contacts.',
      name: 'manageYourPrivacyBlockingCalls',
      desc: '',
      args: [],
    );
  }

  /// `Choose who can add you to groups: everyone or just your contacts`
  String get whoGroupsUsersOrOnlyContacts {
    return Intl.message(
      'Choose who can add you to groups: everyone or just your contacts',
      name: 'whoGroupsUsersOrOnlyContacts',
      desc: '',
      args: [],
    );
  }

  /// `Block calls, messages, and status updates from specific contacts.`
  String get blockCallsMessagesStatusUpdates {
    return Intl.message(
      'Block calls, messages, and status updates from specific contacts.',
      name: 'blockCallsMessagesStatusUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Block calls from unknown numbers.`
  String get blockCallsUnknownNumbers {
    return Intl.message(
      'Block calls from unknown numbers.',
      name: 'blockCallsUnknownNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Changing your privacy settings will not affect your status updates that have already been sent`
  String get changingYourPrivacySettings {
    return Intl.message(
      'Changing your privacy settings will not affect your status updates that have already been sent',
      name: 'changingYourPrivacySettings',
      desc: '',
      args: [],
    );
  }

  /// `The username you add`
  String get addUsername {
    return Intl.message(
      'The username you add',
      name: 'addUsername',
      desc: '',
      args: [],
    );
  }

  /// `will be visible on your Chatify profile.`
  String get visibleYourAppProfile {
    return Intl.message(
      'will be visible on your Chatify profile.',
      name: 'visibleYourAppProfile',
      desc: '',
      args: [],
    );
  }

  /// `Adding links to your Chatify profile helps your contacts easily find your other profiles.`
  String get addingLinksAppProfileContacts {
    return Intl.message(
      'Adding links to your Chatify profile helps your contacts easily find your other profiles.',
      name: 'addingLinksAppProfileContacts',
      desc: '',
      args: [],
    );
  }

  /// `VKontakte`
  String get vkontakte {
    return Intl.message('VKontakte', name: 'vkontakte', desc: '', args: []);
  }

  /// `Odnoklassniki`
  String get odnoklassniki {
    return Intl.message(
      'Odnoklassniki',
      name: 'odnoklassniki',
      desc: '',
      args: [],
    );
  }

  /// `To control who can see your links, go to `
  String get controlWhoSeeYourLinks {
    return Intl.message(
      'To control who can see your links, go to ',
      name: 'controlWhoSeeYourLinks',
      desc: '',
      args: [],
    );
  }

  /// `privacy settings`
  String get privacySettings {
    return Intl.message(
      'privacy settings',
      name: 'privacySettings',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting group photo`
  String get errorDeletingGroupPhoto {
    return Intl.message(
      'Error deleting group photo',
      name: 'errorDeletingGroupPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Group picture`
  String get groupPicture {
    return Intl.message(
      'Group picture',
      name: 'groupPicture',
      desc: '',
      args: [],
    );
  }

  /// `No group picture`
  String get noGroupPicture {
    return Intl.message(
      'No group picture',
      name: 'noGroupPicture',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting profile photo`
  String get errorDeletingProfilePhoto {
    return Intl.message(
      'Error deleting profile photo',
      name: 'errorDeletingProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete profile photo.`
  String get failedDeleteProfilePhoto {
    return Intl.message(
      'Failed to delete profile photo.',
      name: 'failedDeleteProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Error updating user information`
  String get errorUpdatingUserInfo {
    return Intl.message(
      'Error updating user information',
      name: 'errorUpdatingUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `Delete all`
  String get deleteAll {
    return Intl.message('Delete all', name: 'deleteAll', desc: '', args: []);
  }

  /// `Current details`
  String get currentInfo {
    return Intl.message(
      'Current details',
      name: 'currentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Select details`
  String get selectDetails {
    return Intl.message(
      'Select details',
      name: 'selectDetails',
      desc: '',
      args: [],
    );
  }

  /// `Extra privacy for your chats`
  String get extraPrivacyYourChats {
    return Intl.message(
      'Extra privacy for your chats',
      name: 'extraPrivacyYourChats',
      desc: '',
      args: [],
    );
  }

  /// `Use privacy features to protect and restrict access to your messages and media.`
  String get usePrivacyProtectAccessMessageMedia {
    return Intl.message(
      'Use privacy features to protect and restrict access to your messages and media.',
      name: 'usePrivacyProtectAccessMessageMedia',
      desc: '',
      args: [],
    );
  }

  /// `Start new chats with messages that will disappear according to the timer you set.`
  String get newChatsMessagesDisappearSetTimer {
    return Intl.message(
      'Start new chats with messages that will disappear according to the timer you set.',
      name: 'newChatsMessagesDisappearSetTimer',
      desc: '',
      args: [],
    );
  }

  /// `End-to-end encrypted backup`
  String get backupEndToEndEncryption {
    return Intl.message(
      'End-to-end encrypted backup',
      name: 'backupEndToEndEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Enable encryption for your backup so that no one, including Input Studios or Chatify employees, can access it.`
  String get enableEncryptionBackupEmployeesAccess {
    return Intl.message(
      'Enable encryption for your backup so that no one, including Input Studios or Chatify employees, can access it.',
      name: 'enableEncryptionBackupEmployeesAccess',
      desc: '',
      args: [],
    );
  }

  /// `Messages and calls are protected with end-to-end encryption. Tap to confirm.`
  String get callsProtectedEndToEndEncryption {
    return Intl.message(
      'Messages and calls are protected with end-to-end encryption. Tap to confirm.',
      name: 'callsProtectedEndToEndEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Close and hide this chat on this device.`
  String get closeHideChatDevice {
    return Intl.message(
      'Close and hide this chat on this device.',
      name: 'closeHideChatDevice',
      desc: '',
      args: [],
    );
  }

  /// `general group`
  String get generalGroup {
    return Intl.message(
      'general group',
      name: 'generalGroup',
      desc: '',
      args: [],
    );
  }

  /// `general groups`
  String get generalGroups {
    return Intl.message(
      'general groups',
      name: 'generalGroups',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Report`
  String get complainAbout {
    return Intl.message('Report', name: 'complainAbout', desc: '', args: []);
  }

  /// `Last week`
  String get lastWeek {
    return Intl.message('Last week', name: 'lastWeek', desc: '', args: []);
  }

  /// `Last month`
  String get lastMonth {
    return Intl.message('Last month', name: 'lastMonth', desc: '', args: []);
  }

  /// `QR code`
  String get qrCode {
    return Intl.message('QR code', name: 'qrCode', desc: '', args: []);
  }

  /// `Reset QR code`
  String get resetQrCode {
    return Intl.message(
      'Reset QR code',
      name: 'resetQrCode',
      desc: '',
      args: [],
    );
  }

  /// `My code`
  String get myCode {
    return Intl.message('My code', name: 'myCode', desc: '', args: []);
  }

  /// `Scan code`
  String get scanCode {
    return Intl.message('Scan code', name: 'scanCode', desc: '', args: []);
  }

  /// `Chatify contact`
  String get contactApp {
    return Intl.message(
      'Chatify contact',
      name: 'contactApp',
      desc: '',
      args: [],
    );
  }

  /// `Your QR code is private. People you share it with can scan it with the Chatify camera to add you to their contacts.`
  String get yourQrCodePrivateContacts {
    return Intl.message(
      'Your QR code is private. People you share it with can scan it with the Chatify camera to add you to their contacts.',
      name: 'yourQrCodePrivateContacts',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get helloProfile {
    return Intl.message('Hello', name: 'helloProfile', desc: '', args: []);
  }

  /// `Error launching Google Photos`
  String get errorLaunchingGooglePhotos {
    return Intl.message(
      'Error launching Google Photos',
      name: 'errorLaunchingGooglePhotos',
      desc: '',
      args: [],
    );
  }

  /// `Failed to open system gallery`
  String get failedOpenSystemGallery {
    return Intl.message(
      'Failed to open system gallery',
      name: 'failedOpenSystemGallery',
      desc: '',
      args: [],
    );
  }

  /// `The previous QR code will no longer be valid.`
  String get previousQrCodeLongerValid {
    return Intl.message(
      'The previous QR code will no longer be valid.',
      name: 'previousQrCodeLongerValid',
      desc: '',
      args: [],
    );
  }

  /// `Scan Chatify QR code`
  String get scanAppQrCode {
    return Intl.message(
      'Scan Chatify QR code',
      name: 'scanAppQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm by email`
  String get confirmByEmail {
    return Intl.message(
      'Confirm by email',
      name: 'confirmByEmail',
      desc: '',
      args: [],
    );
  }

  /// `Use your email to sign in or recover your account. `
  String get useYourEmailSignInAccountRecover {
    return Intl.message(
      'Use your email to sign in or recover your account. ',
      name: 'useYourEmailSignInAccountRecover',
      desc: '',
      args: [],
    );
  }

  /// `Protect your account`
  String get protectYourAccount {
    return Intl.message(
      'Protect your account',
      name: 'protectYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with face recognition, fingerprint, or screen lock. `
  String get signInFaceRecognitionFingerprint {
    return Intl.message(
      'Sign in with face recognition, fingerprint, or screen lock. ',
      name: 'signInFaceRecognitionFingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Account Download Center`
  String get accountDownloadCenter {
    return Intl.message(
      'Account Download Center',
      name: 'accountDownloadCenter',
      desc: '',
      args: [],
    );
  }

  /// `Account Center`
  String get accountCenter {
    return Intl.message(
      'Account Center',
      name: 'accountCenter',
      desc: '',
      args: [],
    );
  }

  /// `Manage your accounts across Chatify, Blog Sphere, and more in one place.`
  String get manageYourAccountsAppProducts {
    return Intl.message(
      'Manage your accounts across Chatify, Blog Sphere, and more in one place.',
      name: 'manageYourAccountsAppProducts',
      desc: '',
      args: [],
    );
  }

  /// `When animation is enabled, emojis, stickers, and GIFs will move automatically.`
  String get animationEnabledEmojisStickersAuto {
    return Intl.message(
      'When animation is enabled, emojis, stickers, and GIFs will move automatically.',
      name: 'animationEnabledEmojisStickersAuto',
      desc: '',
      args: [],
    );
  }

  /// `Emojis`
  String get emoticons {
    return Intl.message('Emojis', name: 'emoticons', desc: '', args: []);
  }

  /// `Stickers`
  String get stickers {
    return Intl.message('Stickers', name: 'stickers', desc: '', args: []);
  }

  /// `Choose whether stickers and GIFs move automatically.`
  String get chooseStickersGifsMoveAuto {
    return Intl.message(
      'Choose whether stickers and GIFs move automatically.',
      name: 'chooseStickersGifsMoveAuto',
      desc: '',
      args: [],
    );
  }

  /// `Group created`
  String get groupHasBeenCreated {
    return Intl.message(
      'Group created',
      name: 'groupHasBeenCreated',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get copied {
    return Intl.message('Copied', name: 'copied', desc: '', args: []);
  }

  /// `Add links`
  String get addLinks {
    return Intl.message('Add links', name: 'addLinks', desc: '', args: []);
  }

  /// `Screenshots are optional`
  String get screenshotsOptional {
    return Intl.message(
      'Screenshots are optional',
      name: 'screenshotsOptional',
      desc: '',
      args: [],
    );
  }

  /// `How can we help you?`
  String get howCanWeHelpYou {
    return Intl.message(
      'How can we help you?',
      name: 'howCanWeHelpYou',
      desc: '',
      args: [],
    );
  }

  /// `By clicking Next, you agree to Chatify to check diagnostic information and technical specifications of the device, as well as to check metadata associated with your account in order to find and fix the reported problem. `
  String get diagnosticTechnicalInfoAboutDevice {
    return Intl.message(
      'By clicking Next, you agree to Chatify to check diagnostic information and technical specifications of the device, as well as to check metadata associated with your account in order to find and fix the reported problem. ',
      name: 'diagnosticTechnicalInfoAboutDevice',
      desc: '',
      args: [],
    );
  }

  /// `Permission not granted`
  String get permissionNotGranted {
    return Intl.message(
      'Permission not granted',
      name: 'permissionNotGranted',
      desc: '',
      args: [],
    );
  }

  /// `Please enter text`
  String get pleaseEnterText {
    return Intl.message(
      'Please enter text',
      name: 'pleaseEnterText',
      desc: '',
      args: [],
    );
  }

  /// `Hold to record voice message`
  String get holdRecordVoiceMessage {
    return Intl.message(
      'Hold to record voice message',
      name: 'holdRecordVoiceMessage',
      desc: '',
      args: [],
    );
  }

  /// `Signature (optional)`
  String get signatureOptional {
    return Intl.message(
      'Signature (optional)',
      name: 'signatureOptional',
      desc: '',
      args: [],
    );
  }

  /// `No GIF file selected`
  String get gifFileNotSelected {
    return Intl.message(
      'No GIF file selected',
      name: 'gifFileNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Search for emoticons`
  String get searchForEmoticons {
    return Intl.message(
      'Search for emoticons',
      name: 'searchForEmoticons',
      desc: '',
      args: [],
    );
  }

  /// `Emoticons and people`
  String get emoticonsPeople {
    return Intl.message(
      'Emoticons and people',
      name: 'emoticonsPeople',
      desc: '',
      args: [],
    );
  }

  /// `Animals and nature`
  String get animalsNature {
    return Intl.message(
      'Animals and nature',
      name: 'animalsNature',
      desc: '',
      args: [],
    );
  }

  /// `Food and drinks`
  String get foodDrinks {
    return Intl.message(
      'Food and drinks',
      name: 'foodDrinks',
      desc: '',
      args: [],
    );
  }

  /// `Physical activity`
  String get physicalActivity {
    return Intl.message(
      'Physical activity',
      name: 'physicalActivity',
      desc: '',
      args: [],
    );
  }

  /// `Travel and places`
  String get travelPlaces {
    return Intl.message(
      'Travel and places',
      name: 'travelPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Objects`
  String get objects {
    return Intl.message('Objects', name: 'objects', desc: '', args: []);
  }

  /// `Symbols`
  String get symbols {
    return Intl.message('Symbols', name: 'symbols', desc: '', args: []);
  }

  /// `Flags`
  String get flags {
    return Intl.message('Flags', name: 'flags', desc: '', args: []);
  }

  /// `Selected color`
  String get selectedColor {
    return Intl.message(
      'Selected color',
      name: 'selectedColor',
      desc: '',
      args: [],
    );
  }

  /// `Error loading GIFs`
  String get errorLoadingGifs {
    return Intl.message(
      'Error loading GIFs',
      name: 'errorLoadingGifs',
      desc: '',
      args: [],
    );
  }

  /// `Failed to decode GIF`
  String get failedDecodeGif {
    return Intl.message(
      'Failed to decode GIF',
      name: 'failedDecodeGif',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get searchGifTenor {
    return Intl.message('', name: 'searchGifTenor', desc: '', args: []);
  }

  /// `You haven't added any stickers yet`
  String get youAddedStickers {
    return Intl.message(
      'You haven\'t added any stickers yet',
      name: 'youAddedStickers',
      desc: '',
      args: [],
    );
  }

  /// `You haven't added any stickers to your favorites yet`
  String get youAddedStickersFavorites {
    return Intl.message(
      'You haven\'t added any stickers to your favorites yet',
      name: 'youAddedStickersFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Opening`
  String get opening {
    return Intl.message('Opening', name: 'opening', desc: '', args: []);
  }

  /// `File selected`
  String get fileSelected {
    return Intl.message(
      'File selected',
      name: 'fileSelected',
      desc: '',
      args: [],
    );
  }

  /// `You are communicating with the official Chatify Support account. `
  String get youCommunicatingOfficialAppSupport {
    return Intl.message(
      'You are communicating with the official Chatify Support account. ',
      name: 'youCommunicatingOfficialAppSupport',
      desc: '',
      args: [],
    );
  }

  /// `No events to show`
  String get noEventsToShow {
    return Intl.message(
      'No events to show',
      name: 'noEventsToShow',
      desc: '',
      args: [],
    );
  }

  /// `No files`
  String get noFiles {
    return Intl.message('No files', name: 'noFiles', desc: '', args: []);
  }

  /// `File name`
  String get fileName {
    return Intl.message('File name', name: 'fileName', desc: '', args: []);
  }

  /// `No links`
  String get noLinks {
    return Intl.message('No links', name: 'noLinks', desc: '', args: []);
  }

  /// `No media files`
  String get noMediaFiles {
    return Intl.message(
      'No media files',
      name: 'noMediaFiles',
      desc: '',
      args: [],
    );
  }

  /// `Element`
  String get element {
    return Intl.message('Element', name: 'element', desc: '', args: []);
  }

  /// `Change contact`
  String get changeContact {
    return Intl.message(
      'Change contact',
      name: 'changeContact',
      desc: '',
      args: [],
    );
  }

  /// `User is invalid`
  String get userIsNull {
    return Intl.message(
      'User is invalid',
      name: 'userIsNull',
      desc: '',
      args: [],
    );
  }

  /// `User data unavailable`
  String get userDataUnavailable {
    return Intl.message(
      'User data unavailable',
      name: 'userDataUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Was`
  String get was {
    return Intl.message('Was', name: 'was', desc: '', args: []);
  }

  /// `Block Chatify Support company?`
  String get blockAppSupportCompany {
    return Intl.message(
      'Block Chatify Support company?',
      name: 'blockAppSupportCompany',
      desc: '',
      args: [],
    );
  }

  /// `This company will no longer be able to call or message you. Blocking reason:`
  String get companyLongerCallMessageBlocking {
    return Intl.message(
      'This company will no longer be able to call or message you. Blocking reason:',
      name: 'companyLongerCallMessageBlocking',
      desc: '',
      args: [],
    );
  }

  /// `Not interested`
  String get notInterested {
    return Intl.message(
      'Not interested',
      name: 'notInterested',
      desc: '',
      args: [],
    );
  }

  /// `Spam`
  String get spam {
    return Intl.message('Spam', name: 'spam', desc: '', args: []);
  }

  /// `Too many messages`
  String get tooManyMessages {
    return Intl.message(
      'Too many messages',
      name: 'tooManyMessages',
      desc: '',
      args: [],
    );
  }

  /// `No reason`
  String get noReason {
    return Intl.message('No reason', name: 'noReason', desc: '', args: []);
  }

  /// `Report this group to Chatify?`
  String get submitComplaintApp {
    return Intl.message(
      'Report this group to Chatify?',
      name: 'submitComplaintApp',
      desc: '',
      args: [],
    );
  }

  /// `The last 5 messages in this chat will be forwarded to Chatify. This user will not know that you have blocked or reported them.`
  String get lastFiveMessagesAppThisBlocked {
    return Intl.message(
      'The last 5 messages in this chat will be forwarded to Chatify. This user will not know that you have blocked or reported them.',
      name: 'lastFiveMessagesAppThisBlocked',
      desc: '',
      args: [],
    );
  }

  /// `The last 5 messages in this chat will be forwarded to Chatify.`
  String get lastFiveMessagesChatForwardedApp {
    return Intl.message(
      'The last 5 messages in this chat will be forwarded to Chatify.',
      name: 'lastFiveMessagesChatForwardedApp',
      desc: '',
      args: [],
    );
  }

  /// `Messages in this chat may be AI generated.`
  String get messagesChatAiGenerated {
    return Intl.message(
      'Messages in this chat may be AI generated.',
      name: 'messagesChatAiGenerated',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get hide {
    return Intl.message('Hide', name: 'hide', desc: '', args: []);
  }

  /// `This phone number is registered with Chatify`
  String get phoneNumberRegisteredApp {
    return Intl.message(
      'This phone number is registered with Chatify',
      name: 'phoneNumberRegisteredApp',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to archive ALL chats?`
  String get youSureArchiveAllChats {
    return Intl.message(
      'Are you sure you want to archive ALL chats?',
      name: 'youSureArchiveAllChats',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get event {
    return Intl.message('Event', name: 'event', desc: '', args: []);
  }

  /// `Drawing`
  String get drawing {
    return Intl.message('Drawing', name: 'drawing', desc: '', args: []);
  }

  /// `Mobile Network`
  String get mobileNetwork {
    return Intl.message(
      'Mobile Network',
      name: 'mobileNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Also delete media files received in chats from the device gallery`
  String get deleteMediaFilesReceivedChatsDevice {
    return Intl.message(
      'Also delete media files received in chats from the device gallery',
      name: 'deleteMediaFilesReceivedChatsDevice',
      desc: '',
      args: [],
    );
  }

  /// `Delete favorite messages`
  String get deleteFavoritePosts {
    return Intl.message(
      'Delete favorite messages',
      name: 'deleteFavoritePosts',
      desc: '',
      args: [],
    );
  }

  /// `Clear chats`
  String get clearChats {
    return Intl.message('Clear chats', name: 'clearChats', desc: '', args: []);
  }

  /// `Closed chats will be cleared and opened`
  String get closedChatsClearedOpened {
    return Intl.message(
      'Closed chats will be cleared and opened',
      name: 'closedChatsClearedOpened',
      desc: '',
      args: [],
    );
  }

  /// `All messages, photos and videos in closed chats will be deleted, and the chats themselves will become open in the main chat list.`
  String get messagesPhotosVideosClosedChats {
    return Intl.message(
      'All messages, photos and videos in closed chats will be deleted, and the chats themselves will become open in the main chat list.',
      name: 'messagesPhotosVideosClosedChats',
      desc: '',
      args: [],
    );
  }

  /// `Also reset the secret code (if any).`
  String get secretCodeReset {
    return Intl.message(
      'Also reset the secret code (if any).',
      name: 'secretCodeReset',
      desc: '',
      args: [],
    );
  }

  /// `Open and clear`
  String get openClear {
    return Intl.message(
      'Open and clear',
      name: 'openClear',
      desc: '',
      args: [],
    );
  }

  /// `Also delete media files received in chats from the device gallery`
  String get deleteMediaFilesReceivedChats {
    return Intl.message(
      'Also delete media files received in chats from the device gallery',
      name: 'deleteMediaFilesReceivedChats',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete all Information?`
  String get youSureDeleteAllInformation {
    return Intl.message(
      'Are you sure you want to delete all Information?',
      name: 'youSureDeleteAllInformation',
      desc: '',
      args: [],
    );
  }

  /// `Delete the list "Unread"?`
  String get deleteUnreadList {
    return Intl.message(
      'Delete the list "Unread"?',
      name: 'deleteUnreadList',
      desc: '',
      args: [],
    );
  }

  /// `If you delete the preset list, it will be hidden. Your group and individual chats will not be deleted. To get this list back, go to the "Lists" section in settings`
  String get deleteResetListHidden {
    return Intl.message(
      'If you delete the preset list, it will be hidden. Your group and individual chats will not be deleted. To get this list back, go to the "Lists" section in settings',
      name: 'deleteResetListHidden',
      desc: '',
      args: [],
    );
  }

  /// `Trim`
  String get trim {
    return Intl.message('Trim', name: 'trim', desc: '', args: []);
  }

  /// `Send as File`
  String get sendAsFile {
    return Intl.message('Send as File', name: 'sendAsFile', desc: '', args: []);
  }

  /// `Emoticons and stickers`
  String get emoticonsStickers {
    return Intl.message(
      'Emoticons and stickers',
      name: 'emoticonsStickers',
      desc: '',
      args: [],
    );
  }

  /// `Edit Lists`
  String get editLists {
    return Intl.message('Edit Lists', name: 'editLists', desc: '', args: []);
  }

  /// `You can edit lists and filters here, or change how they appear on the "Chats" tab.`
  String get editListsFiltersChangeDisplay {
    return Intl.message(
      'You can edit lists and filters here, or change how they appear on the "Chats" tab.',
      name: 'editListsFiltersChangeDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Editing: Favorites`
  String get editingFavorites {
    return Intl.message(
      'Editing: Favorites',
      name: 'editingFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Use the pencil to change the order of lists on the "Chats" tab.`
  String get usePencilChangeListsChats {
    return Intl.message(
      'Use the pencil to change the order of lists on the "Chats" tab.',
      name: 'usePencilChangeListsChats',
      desc: '',
      args: [],
    );
  }

  /// `You can edit Favorites here, or change the order of Favorites on the "Calls" tab.`
  String get editFavoritesChangeOrderFavorites {
    return Intl.message(
      'You can edit Favorites here, or change the order of Favorites on the "Calls" tab.',
      name: 'editFavoritesChangeOrderFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Only group admins will receive notifications that you have left the group`
  String get groupAdminsReceiveNotify {
    return Intl.message(
      'Only group admins will receive notifications that you have left the group',
      name: 'groupAdminsReceiveNotify',
      desc: '',
      args: [],
    );
  }

  /// `Silent mode?`
  String get silentMode {
    return Intl.message('Silent mode?', name: 'silentMode', desc: '', args: []);
  }

  /// `Permissions`
  String get permissions {
    return Intl.message('Permissions', name: 'permissions', desc: '', args: []);
  }

  /// `Search the Internet`
  String get searchInternet {
    return Intl.message(
      'Search the Internet',
      name: 'searchInternet',
      desc: '',
      args: [],
    );
  }

  /// `Examples: "Work", "Friends"`
  String get examplesWorkFriends {
    return Intl.message(
      'Examples: "Work", "Friends"',
      name: 'examplesWorkFriends',
      desc: '',
      args: [],
    );
  }

  /// `Any list you create becomes a filter at the top of the Chats tab.`
  String get listCreateFilterChats {
    return Intl.message(
      'Any list you create becomes a filter at the top of the Chats tab.',
      name: 'listCreateFilterChats',
      desc: '',
      args: [],
    );
  }

  /// `Avatar`
  String get avatar {
    return Intl.message('Avatar', name: 'avatar', desc: '', args: []);
  }

  /// `Media download quality`
  String get mediaDownloadQuality {
    return Intl.message(
      'Media download quality',
      name: 'mediaDownloadQuality',
      desc: '',
      args: [],
    );
  }

  /// `Standard quality`
  String get standardQuality {
    return Intl.message(
      'Standard quality',
      name: 'standardQuality',
      desc: '',
      args: [],
    );
  }

  /// `Faster sending, smaller file size file`
  String get fasterSendingSmallerFile {
    return Intl.message(
      'Faster sending, smaller file size file',
      name: 'fasterSendingSmallerFile',
      desc: '',
      args: [],
    );
  }

  /// `HD quality`
  String get hdQuality {
    return Intl.message('HD quality', name: 'hdQuality', desc: '', args: []);
  }

  /// `Slower sending, can be up to 6 times larger`
  String get slowerShippingSixTimesBigger {
    return Intl.message(
      'Slower sending, can be up to 6 times larger',
      name: 'slowerShippingSixTimesBigger',
      desc: '',
      args: [],
    );
  }

  /// `Report this group to Chatify?`
  String get reportGroupApp {
    return Intl.message(
      'Report this group to Chatify?',
      name: 'reportGroupApp',
      desc: '',
      args: [],
    );
  }

  /// `The last 5 messages in this group will be forwarded to Chatify. If you leave the group and delete the chat, the messages will only be deleted from this device and your devices with newer versions of Chatify.`
  String get lastFiveMessagesGroup {
    return Intl.message(
      'The last 5 messages in this group will be forwarded to Chatify. If you leave the group and delete the chat, the messages will only be deleted from this device and your devices with newer versions of Chatify.',
      name: 'lastFiveMessagesGroup',
      desc: '',
      args: [],
    );
  }

  /// `Group members will not be notified.`
  String get groupMembersNotified {
    return Intl.message(
      'Group members will not be notified.',
      name: 'groupMembersNotified',
      desc: '',
      args: [],
    );
  }

  /// `Leave the group and delete the chat`
  String get leaveGroupDeleteChat {
    return Intl.message(
      'Leave the group and delete the chat',
      name: 'leaveGroupDeleteChat',
      desc: '',
      args: [],
    );
  }

  /// `Reset all notification settings, including individual notification settings for chats?`
  String get resetAllNotificationSettings {
    return Intl.message(
      'Reset all notification settings, including individual notification settings for chats?',
      name: 'resetAllNotificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select a list`
  String get selectList {
    return Intl.message(
      'Select a list',
      name: 'selectList',
      desc: '',
      args: [],
    );
  }

  /// `Chatify could not find a connected camera.`
  String get appFindConnectedCamera {
    return Intl.message(
      'Chatify could not find a connected camera.',
      name: 'appFindConnectedCamera',
      desc: '',
      args: [],
    );
  }

  /// `Chatify requires a camera to make video calls. Please connect one to your computer.`
  String get videoCallsAppCameraConnectComputer {
    return Intl.message(
      'Chatify requires a camera to make video calls. Please connect one to your computer.',
      name: 'videoCallsAppCameraConnectComputer',
      desc: '',
      args: [],
    );
  }

  /// `Failed to capture video. Another app is using the camera.`
  String get failedCaptureVideoCameraApp {
    return Intl.message(
      'Failed to capture video. Another app is using the camera.',
      name: 'failedCaptureVideoCameraApp',
      desc: '',
      args: [],
    );
  }

  /// `Short`
  String get short {
    return Intl.message('Short', name: 'short', desc: '', args: []);
  }

  /// `Long`
  String get long {
    return Intl.message('Long', name: 'long', desc: '', args: []);
  }

  /// `The file is ready to send.`
  String get fileReadySend {
    return Intl.message(
      'The file is ready to send.',
      name: 'fileReadySend',
      desc: '',
      args: [],
    );
  }

  /// `Image submitted successfully!`
  String get imageSentSuccess {
    return Intl.message(
      'Image submitted successfully!',
      name: 'imageSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `User cancelled submission.`
  String get userCancelSubmission {
    return Intl.message(
      'User cancelled submission.',
      name: 'userCancelSubmission',
      desc: '',
      args: [],
    );
  }

  /// `Group is empty, can't update update`
  String get groupNullCannotUpdateImage {
    return Intl.message(
      'Group is empty, can\'t update update',
      name: 'groupNullCannotUpdateImage',
      desc: '',
      args: [],
    );
  }

  /// `Here is the image!`
  String get herePicture {
    return Intl.message(
      'Here is the image!',
      name: 'herePicture',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update group image in database.`
  String get failedUpdateGroupImageDatabase {
    return Intl.message(
      'Failed to update group image in database.',
      name: 'failedUpdateGroupImageDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Group image successfully deleted from database.`
  String get groupImageClearedSuccessDatabase {
    return Intl.message(
      'Group image successfully deleted from database.',
      name: 'groupImageClearedSuccessDatabase',
      desc: '',
      args: [],
    );
  }

  /// `No image URL to delete`
  String get noImageUrlDelete {
    return Intl.message(
      'No image URL to delete',
      name: 'noImageUrlDelete',
      desc: '',
      args: [],
    );
  }

  /// `Group is empty, can't clear image`
  String get groupNullCannotClearImage {
    return Intl.message(
      'Group is empty, can\'t clear image',
      name: 'groupNullCannotClearImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save group image to database.`
  String get failedCleaGroupImageDatabase {
    return Intl.message(
      'Failed to save group image to database.',
      name: 'failedCleaGroupImageDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Get Media Stream Error`
  String get getMediaStreamError {
    return Intl.message(
      'Get Media Stream Error',
      name: 'getMediaStreamError',
      desc: '',
      args: [],
    );
  }

  /// `Community is empty, can't update update`
  String get communityNullCannotUpdateImage {
    return Intl.message(
      'Community is empty, can\'t update update',
      name: 'communityNullCannotUpdateImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update community image in the database.`
  String get failedUpdateCommunityImageDatabase {
    return Intl.message(
      'Failed to update community image in the database.',
      name: 'failedUpdateCommunityImageDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Community is empty, can't clear image.`
  String get communityNullCannotClearImage {
    return Intl.message(
      'Community is empty, can\'t clear image.',
      name: 'communityNullCannotClearImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save community image to the database.`
  String get failedClearCommunityImageDatabase {
    return Intl.message(
      'Failed to save community image to the database.',
      name: 'failedClearCommunityImageDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Look at this image!`
  String get lookAtPicture {
    return Intl.message(
      'Look at this image!',
      name: 'lookAtPicture',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter image successfully updated in the database`
  String get newsletterImageUpdatedSuccessDatabase {
    return Intl.message(
      'Newsletter image successfully updated in the database',
      name: 'newsletterImageUpdatedSuccessDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter is empty, can't clear image`
  String get newsletterNullCannotUpdateImage {
    return Intl.message(
      'Newsletter is empty, can\'t clear image',
      name: 'newsletterNullCannotUpdateImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update newsletter image in the database.`
  String get failedUpdateNewsletterImageDatabase {
    return Intl.message(
      'Failed to update newsletter image in the database.',
      name: 'failedUpdateNewsletterImageDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Newsletter is empty, can't clear image`
  String get newsletterNullCannotCleaImage {
    return Intl.message(
      'Newsletter is empty, can\'t clear image',
      name: 'newsletterNullCannotCleaImage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to clear newsletter image bulletin from the database.`
  String get failedClearNewsletterImageDatabase {
    return Intl.message(
      'Failed to clear newsletter image bulletin from the database.',
      name: 'failedClearNewsletterImageDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Chat Archive`
  String get chatArchive {
    return Intl.message(
      'Chat Archive',
      name: 'chatArchive',
      desc: '',
      args: [],
    );
  }

  /// `Featured Messages`
  String get featuredMessages {
    return Intl.message(
      'Featured Messages',
      name: 'featuredMessages',
      desc: '',
      args: [],
    );
  }

  /// `Complain and leave`
  String get complainAndLeave {
    return Intl.message(
      'Complain and leave',
      name: 'complainAndLeave',
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
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ru'),
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
