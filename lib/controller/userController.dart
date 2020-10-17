import 'dart:convert';

import 'package:ehrlichtest/model/auth0Const.dart';
import 'package:ehrlichtest/model/userModel.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserController extends GetxController {
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final user = UserModel().obs;
  var isBusy = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initAction();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    isBusy.value = true;

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response.idToken);
      final profile = await getUserDetails(response.accessToken);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      isBusy.value = false;

      user.update((value) {
        value.isLoggedIn = true;
        value.userName = idToken['nickname'];
        value.userPicture = profile['picture'];
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    isBusy.value = true;
    errorMessage.value = '';

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
            issuer: 'https://$AUTH0_DOMAIN',
            scopes: ['openid', 'profile', 'offline_access'],
            promptValues: ['login']),
      );

      final idToken = parseIdToken(result.idToken);
      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      isBusy.value = false;
      user.update((value) {
        value.isLoggedIn = true;
        value.userName = idToken['nickname'];
        value.userPicture = profile['picture'];
      });
    } catch (e, s) {
      print('login error: $e - stack: $s');

      isBusy.value = false;
      user.update((value) {
        value.isLoggedIn = false;
      });
      errorMessage.value = e.toString();
    }
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    user.update((value) {
      value.isLoggedIn = false;
    });
    isBusy.value = false;
  }
}
