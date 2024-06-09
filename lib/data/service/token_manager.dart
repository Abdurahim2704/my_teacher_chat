import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  final dio = Dio(BaseOptions(
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 2)));
  String? accessToken;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> setUp() async {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] = "Bearer $accessToken";
        options.headers["Content-Type"] = "application/json";
        options.headers["Accept"] = "application/json";
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          if (await _storage.containsKey(key: "refreshToken")) {
            await getAccess();
          } else {
            await getToken(username: "+998990000001", password: "user");
          }
          return handler.resolve(await retry(error.requestOptions));
          // return handler.next(error);
        }
      },
    ));
  }

  Future<void> getAccess() async {
    final refreshToken = await _storage.read(key: "refreshToken");

    final access = await Dio(
        BaseOptions(headers: {"Authorization": "Bearer $refreshToken"})).post(
      Apis.baseUrl + Apis.refreshToken,
    );

    if (access.statusCode == 200) {
      accessToken = access.data["accessToken"];
      _storage.write(key: "refreshToken", value: refreshToken);
    } else {
      //refresh token xato yoki expired
      accessToken = null;
      await _storage.deleteAll();
    }
  }

  Future<Response<dynamic>> retry(RequestOptions options) async {
    final myOptions = Options(
        method: options.method,
        headers: options.headers,
        validateStatus: (status) => (status == 200 || status == 201),
        responseType: ResponseType.json);
    final response = await dio.request<dynamic>(options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: myOptions);
    return response;
  }

  Future<void> getToken(
      {required String username, required String password}) async {
    final response = await dio.post(Apis.baseUrl + Apis.loginApi,
        data: {"login": username, "password": password});

    if (response.statusCode == 200) {
      accessToken = response.data["accessToken"];
      await _storage.write(
          key: "refreshToken", value: response.data["refreshToken"]);
    }
  }
}

class Apis {
  static const baseUrl = "http://192.168.2.132:3680";
  static const loginApi = "/api/auth/login";
  // static const credForLogin = {"login": "+998990000001", "password": "user"};
  static const refreshToken = "/api/auth/refresh";
}
