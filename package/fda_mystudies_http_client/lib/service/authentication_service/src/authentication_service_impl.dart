import 'package:fda_mystudies_http_client/service/authentication_service/authentication_service.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(as: AuthenticationService)
class AuthenticationServiceImpl implements AuthenticationService {
  final http.Client client;

  AuthenticationServiceImpl(this.client);

  @override
  Future<Object> changePassword(String currentPassword, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Object> grantVerifiedUser() {
    // TODO: implement grantVerifiedUser
    throw UnimplementedError();
  }

  @override
  Future<Object> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Object> refreshTokenForUser() {
    // TODO: implement refreshTokenForUser
    throw UnimplementedError();
  }

  @override
  Future<Object> resetPassword(String emailId) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
