import 'base_config.dart';

class AuthService {
  static String send_code = "${config.authServiceBaseUrl}send-code/";
  static String signup = "${config.authServiceBaseUrl}signup/";
  static String login = "${config.authServiceBaseUrl}login";
}
