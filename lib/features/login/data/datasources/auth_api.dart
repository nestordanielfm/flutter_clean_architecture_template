import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/login/data/models/auth_response.dart';
import 'package:template_app/features/login/data/models/login_request.dart';

part 'auth_api.g.dart';

@RestApi(baseUrl: 'https://dummyjson.com')
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);
}
