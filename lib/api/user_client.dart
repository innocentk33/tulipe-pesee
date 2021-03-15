import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:xml/xml.dart';

class UserClient{
  SoapClient soapClient = SoapClient();

  Future<ApiResponse> authentificate({String login, String password}) async {

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <Exists_User xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <user>$login</user>
            <password>$password</password>
        </Exists_User>
    </Body>
</Envelope>
    ''';

    var response = await soapClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);


    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      String result = document.findAllElements('return_value').first.text;
      
      if(result == "false") {
        response.hasError = true;
        response.message = "Identifiant et/ou mot de passe incorrect(s)";
      }

    }
    
    return response;
  }

}