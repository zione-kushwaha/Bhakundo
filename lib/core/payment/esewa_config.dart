import 'package:esewa_flutter_sdk/esewa_config.dart';

class AppEsewaConfig {
  AppEsewaConfig._();

  // eSewa Sandbox Credentials
  static const String clientId = "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";
  static const String secretKey = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";

  static EsewaConfig get testConfig {
    return EsewaConfig(
      environment: Environment.test,
      clientId: clientId,
      secretId: secretKey,
    );
  }
}
