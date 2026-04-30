import '../services/request.dart';

/// Repository for login page APIs. Keeps auth endpoint details out of UI state.
class LoginRepository {
  LoginRepository({RequestManager? requestManager})
      : _requestManager = requestManager ?? RequestManager();

  final RequestManager _requestManager;

  /// Sends the SMS captcha required by the login flow.
  Future<void> sendLoginCaptcha({required String phone}) async {
    await _requestManager.post<dynamic>(
      '/public/captcha/login/${Uri.encodeComponent(phone)}',
    );
  }

  /// Logs in with phone number and SMS code and returns the raw payload.
  Future<Map<String, dynamic>> loginWithSms({
    required String phone,
    required String smsCode, required String password,
  }) async {
    final response = await _requestManager.post<dynamic>(
      '/login/sms',
      data: <String, dynamic>{
        'phone': phone,
        'password': password,
        'smsCode': smsCode,
      },
    );
    return response.raw;
  }
}
