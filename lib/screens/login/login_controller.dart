import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/repository/user_repository.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController{
  UserRepository repository = UserRepositoryImpl();

  Future<ApiResponse> login({String login , String password}) async {
    var response = await repository.authentificate(login: login, password: password);
    if(!response.hasError) {
      GetStorageService.saveLogin(login);
    }
    return response;
  }
}