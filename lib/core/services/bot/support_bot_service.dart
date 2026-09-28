import '../../../api/apis.dart';

class SupportBotService {
  static Future<void> processMessage({required String supportChatId, required String userMessage}) async {
    final text = userMessage.trim().toLowerCase();

    String? response;

    if (text.contains('привет') || text.contains('здравствуй') || text.contains('добрый день')) {
      response = 'Здравствуйте! 🤝 Чем мы можем помочь?';
    } else if (text.contains('удалить аккаунт')) {
      response = 'Чтобы удалить аккаунт, откройте настройки профиля и выберите пункт «Удалить аккаунт».';
    } else if (text.contains('не работает')) {
      response = 'Понимаем. Расскажите, пожалуйста, подробнее, что именно не работает.';
    } else if (text.contains('оператор')) {
      response = 'Хорошо. Передаю ваше обращение специалисту поддержки.';
    } else if (text.contains('спасибо')) {
      response = 'Пожалуйста! 😊 Если появятся ещё вопросы, мы готовы помочь.';
    }

    response ??= 'Я пока не совсем понял ваш вопрос. ' 'Попробуйте описать проблему подробнее.';

    await APIs.sendSupportBotMessage(supportChatId: supportChatId, message: response);
  }
}
