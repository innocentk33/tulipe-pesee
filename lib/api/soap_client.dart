import 'dart:io';

import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:http/http.dart' as http;

class SoapClient<T> {

  Future<ApiResponse<T>> post({String url, String action, String body}) async {
    var baseUrl = await GetStorageService.getUrl();
    var completeUrl = "$baseUrl/$url";

    print("url => $completeUrl");
    print("body => $body");

    try {
      var response = await http.post(
        completeUrl,
        headers: {
          'Content-Type': 'text/xml',
          'SOAPAction': action,
          'Authorization': 'Basic VFVMSVBFOiUlVHVsaXBlMTMy'
        },
        body: body,
      );
      print("response => ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>(hasError: false, body: response.body);
      } else {
        return ApiResponse<T>(hasError: true, message: response.reasonPhrase);
      }
    } on SocketException {
      return ApiResponse<T>(
          hasError: true,
          message: "Impossible de se connecter!\nVeuillez réessayer");
    }
  }
}
