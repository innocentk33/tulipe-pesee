import 'package:fish_scan/api/user_client.dart';
import 'package:fish_scan/models/api_response.dart';

abstract class UserRepository{
  Future<ApiResponse> authentificate({String login, String password});
}

class UserRepositoryImpl extends UserRepository{
  UserClient userClient = UserClient();
  @override
  Future<ApiResponse> authentificate({String login, String password}) => userClient.authentificate(login: login, password: password);

}