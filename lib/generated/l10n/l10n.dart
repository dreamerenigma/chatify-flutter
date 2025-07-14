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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
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
    return Intl.message(
      'Create in',
      name: 'createIn',
      desc: '',
      args: [],
    );
  }

  /// `Login with `
  String get loginWith {
    return Intl.message(
      'Login with ',
      name: 'loginWith',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      '  Add User',
      name: 'addUser',
      desc: '',
      args: [],
    );
  }

  /// `Email or Id`
  String get emailOrId {
    return Intl.message(
      'Email or Id',
      name: 'emailOrId',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Hello!',
      name: 'statusText',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Community`
  String get community {
    return Intl.message(
      'Community',
      name: 'community',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Calls',
      name: 'calls',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// ` Settings `
  String get settings {
    return Intl.message(
      ' Settings ',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `New group`
  String get newGroup {
    return Intl.message(
      'New group',
      name: 'newGroup',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Clear list',
      name: 'clearList',
      desc: '',
      args: [],
    );
  }

  /// `Say Hii!👋`
  String get hello {
    return Intl.message(
      'Say Hii!👋',
      name: 'hello',
      desc: '',
      args: [],
    );
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

  /// `Take photo`
  String get takePhoto {
    return Intl.message(
      'Take photo',
      name: 'takePhoto',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Write',
      name: 'write',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `About: `
  String get about {
    return Intl.message(
      'About: ',
      name: 'about',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Joined on: ',
      name: 'joinedOn',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Screen',
      name: 'screen',
      desc: '',
      args: [],
    );
  }

  /// `Themes`
  String get themes {
    return Intl.message(
      'Themes',
      name: 'themes',
      desc: '',
      args: [],
    );
  }

  /// `Wallpapers`
  String get wallpapers {
    return Intl.message(
      'Wallpapers',
      name: 'wallpapers',
      desc: '',
      args: [],
    );
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
  String get pleaseEnterText {
    return Intl.message(
      'Please enter message text',
      name: 'pleaseEnterText',
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
    return Intl.message(
      'Font size',
      name: 'fontSize',
      desc: '',
      args: [],
    );
  }

  /// `Select font`
  String get selectFont {
    return Intl.message(
      'Select font',
      name: 'selectFont',
      desc: '',
      args: [],
    );
  }

  /// `Small`
  String get small {
    return Intl.message(
      'Small',
      name: 'small',
      desc: '',
      args: [],
    );
  }

  /// `Average`
  String get average {
    return Intl.message(
      'Average',
      name: 'average',
      desc: '',
      args: [],
    );
  }

  /// `Big`
  String get big {
    return Intl.message(
      'Big',
      name: 'big',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Chat backup',
      name: 'chatsBackup',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'About me',
      name: 'aboutField',
      desc: '',
      args: [],
    );
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

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logoutAccount {
    return Intl.message(
      'Logout',
      name: 'logoutAccount',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Sure',
      name: 'sure',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Lists',
      name: 'lists',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
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

  /// `Help Center`
  String get helpCenter {
    return Intl.message(
      'Help Center',
      name: 'helpCenter',
      desc: '',
      args: [],
    );
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

  /// `After submitting a complaint to a channel, you can view details about it and the result of its verification here.`
  String get submittingComplaint {
    return Intl.message(
      'After submitting a complaint to a channel, you can view details about it and the result of its verification here.',
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
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Licenses`
  String get licenses {
    return Intl.message(
      'Licenses',
      name: 'licenses',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Arab',
      name: 'arabianLanguage',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Czech',
      name: 'czechLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Danish`
  String get danianLanguage {
    return Intl.message(
      'Danish',
      name: 'danianLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Greek`
  String get greekLanguage {
    return Intl.message(
      'Greek',
      name: 'greekLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russianLanguage {
    return Intl.message(
      'Russian',
      name: 'russianLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get englishLanguage {
    return Intl.message(
      'English',
      name: 'englishLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanishLanguage {
    return Intl.message(
      'Spanish',
      name: 'spanishLanguage',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get deutschLanguage {
    return Intl.message(
      'German',
      name: 'deutschLanguage',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get frenchLanguage {
    return Intl.message(
      'French',
      name: 'frenchLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get italianLanguage {
    return Intl.message(
      'Italian',
      name: 'italianLanguage',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Default',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Copy text',
      name: 'copyText',
      desc: '',
      args: [],
    );
  }

  /// `Save image`
  String get saveImage {
    return Intl.message(
      'Save image',
      name: 'saveImage',
      desc: '',
      args: [],
    );
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

  /// `Save video`
  String get saveVideo {
    return Intl.message(
      'Save video',
      name: 'saveVideo',
      desc: '',
      args: [],
    );
  }

  /// `Video saved!`
  String get videoSaved {
    return Intl.message(
      'Video saved!',
      name: 'videoSaved',
      desc: '',
      args: [],
    );
  }

  /// `Sent at:`
  String get sentAt {
    return Intl.message(
      'Sent at:',
      name: 'sentAt',
      desc: '',
      args: [],
    );
  }

  /// `Read at:`
  String get readAt {
    return Intl.message(
      'Read at:',
      name: 'readAt',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Text copied!',
      name: 'textCopied',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `All media`
  String get allMedia {
    return Intl.message(
      'All media',
      name: 'allMedia',
      desc: '',
      args: [],
    );
  }

  /// `Show in chat`
  String get showInChat {
    return Intl.message(
      'Show in chat',
      name: 'showInChat',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Rotation',
      name: 'rotation',
      desc: '',
      args: [],
    );
  }

  /// `Add contact`
  String get addContact {
    return Intl.message(
      'Add contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Access keys',
      name: 'accessKeys',
      desc: '',
      args: [],
    );
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
  String get two_step_verification {
    return Intl.message(
      'Two-step verification',
      name: 'two_step_verification',
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
    return Intl.message(
      'Add account',
      name: 'addAccount',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'was',
      name: 'prefixDate',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'was in',
      name: 'lastSeenWeek',
      desc: '',
      args: [],
    );
  }

  /// `in `
  String get lastSeenTime {
    return Intl.message(
      'in ',
      name: 'lastSeenTime',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'GIF',
      name: 'gif',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message(
      'Audio',
      name: 'audio',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Save audio',
      name: 'saveAudio',
      desc: '',
      args: [],
    );
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

  /// `Click to add a new status`
  String get addNewStatus {
    return Intl.message(
      'Click to add a new status',
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
  String get encryption {
    return Intl.message(
      'end-to-end encryption',
      name: 'encryption',
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
    return Intl.message(
      'My contacts',
      name: 'myContacts',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Only...',
      name: 'only',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Exc.',
      name: 'exception',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get on {
    return Intl.message(
      'On',
      name: 'on',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Edit image',
      name: 'editImage',
      desc: '',
      args: [],
    );
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

  /// `How can we help you?`
  String get howCanHelpYou {
    return Intl.message(
      'How can we help you?',
      name: 'howCanHelpYou',
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
    return Intl.message(
      'Help Topics',
      name: 'helpTopics',
      desc: '',
      args: [],
    );
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

  /// `Audio and video calls`
  String get audioVideoCalls {
    return Intl.message(
      'Audio and video calls',
      name: 'audioVideoCalls',
      desc: '',
      args: [],
    );
  }

  /// `Communities`
  String get communities {
    return Intl.message(
      'Communities',
      name: 'communities',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Send...`
  String get sendFile {
    return Intl.message(
      'Send...',
      name: 'sendFile',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Jan.',
      name: 'jan',
      desc: '',
      args: [],
    );
  }

  /// `Feb.`
  String get feb {
    return Intl.message(
      'Feb.',
      name: 'feb',
      desc: '',
      args: [],
    );
  }

  /// `Mar.`
  String get mar {
    return Intl.message(
      'Mar.',
      name: 'mar',
      desc: '',
      args: [],
    );
  }

  /// `Apr.`
  String get apr {
    return Intl.message(
      'Apr.',
      name: 'apr',
      desc: '',
      args: [],
    );
  }

  /// `May.`
  String get may {
    return Intl.message(
      'May.',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `Jun.`
  String get jun {
    return Intl.message(
      'Jun.',
      name: 'jun',
      desc: '',
      args: [],
    );
  }

  /// `Jul.`
  String get jul {
    return Intl.message(
      'Jul.',
      name: 'jul',
      desc: '',
      args: [],
    );
  }

  /// `Aug.`
  String get aug {
    return Intl.message(
      'Aug.',
      name: 'aug',
      desc: '',
      args: [],
    );
  }

  /// `Sep.`
  String get sep {
    return Intl.message(
      'Sep.',
      name: 'sep',
      desc: '',
      args: [],
    );
  }

  /// `Oct.`
  String get oct {
    return Intl.message(
      'Oct.',
      name: 'oct',
      desc: '',
      args: [],
    );
  }

  /// `Nov.`
  String get nov {
    return Intl.message(
      'Nov.',
      name: 'nov',
      desc: '',
      args: [],
    );
  }

  /// `Dec.`
  String get dec {
    return Intl.message(
      'Dec.',
      name: 'dec',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Connecting...',
      name: 'connected',
      desc: '',
      args: [],
    );
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

  /// `Add screenshots (optional)`
  String get addScreenshots {
    return Intl.message(
      'Add screenshots (optional)',
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
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Reboot',
      name: 'reboot',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Press ',
      name: 'press',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `on Android or`
  String get onAndroid {
    return Intl.message(
      'on Android or',
      name: 'onAndroid',
      desc: '',
      args: [],
    );
  }

  /// ` on iPhone`
  String get oniPhone {
    return Intl.message(
      ' on iPhone',
      name: 'oniPhone',
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
    return Intl.message(
      ' then ',
      name: 'then',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'By default',
      name: 'byDefault',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Off',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'To ',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `sign out`
  String get signOut {
    return Intl.message(
      'sign out',
      name: 'signOut',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'profile',
      name: 'profileLink',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'recipient',
      name: 'recipient',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
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

  /// `Group photo removed`
  String get failedDeleteGroupPhoto {
    return Intl.message(
      'Group photo removed',
      name: 'failedDeleteGroupPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
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

  /// `My contacts, All`
  String get myContactsAll {
    return Intl.message(
      'My contacts, All',
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
    return Intl.message(
      'Security',
      name: 'security',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Learn more',
      name: 'readMore',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Warning!',
      name: 'warning',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Repeat SMS',
      name: 'repeatSms',
      desc: '',
      args: [],
    );
  }

  /// `Call me`
  String get callMe {
    return Intl.message(
      'Call me',
      name: 'callMe',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Excl. 0',
      name: 'exceptions',
      desc: '',
      args: [],
    );
  }

  /// `On 0`
  String get onZero {
    return Intl.message(
      'On 0',
      name: 'onZero',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get ready {
    return Intl.message(
      'Done',
      name: 'ready',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Pin it`
  String get pinIt {
    return Intl.message(
      'Pin it',
      name: 'pinIt',
      desc: '',
      args: [],
    );
  }

  /// `Complain`
  String get complain {
    return Intl.message(
      'Complain',
      name: 'complain',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Create Poll',
      name: 'createPoll',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `+ add`
  String get addPlus {
    return Intl.message(
      '+ add',
      name: 'addPlus',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'groups',
      name: 'groups',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Admins can:',
      name: 'adminsCan',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'New mailing',
      name: 'newMailing',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
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

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `New contact`
  String get newContact {
    return Intl.message(
      'New contact',
      name: 'newContact',
      desc: '',
      args: [],
    );
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

  /// `Newsletter`
  String get newsletter {
    return Intl.message(
      'Newsletter',
      name: 'newsletter',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'recipients',
      name: 'recipients',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'No members',
      name: 'noMembers',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Wallpaper',
      name: 'wallpaper',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'In archive',
      name: 'inArchive',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Call number',
      name: 'callNumber',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'No results',
      name: 'noResults',
      desc: '',
      args: [],
    );
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

  /// `With end-to-end encryption, your private messages and calls stay between you and the people you chat with. Not even Chatify can access them. These include:`
  String get yourChatsCallsConfidential {
    return Intl.message(
      'With end-to-end encryption, your private messages and calls stay between you and the people you chat with. Not even Chatify can access them. These include:',
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
    return Intl.message(
      'My status',
      name: 'myStatus',
      desc: '',
      args: [],
    );
  }

  /// `No updates`
  String get noUpdates {
    return Intl.message(
      'No updates',
      name: 'noUpdates',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Storage',
      name: 'storage',
      desc: '',
      args: [],
    );
  }

  /// `Hotkeys`
  String get hotKeys {
    return Intl.message(
      'Hotkeys',
      name: 'hotKeys',
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
