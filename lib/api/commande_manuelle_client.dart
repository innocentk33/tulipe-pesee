import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:xml/xml.dart';

import '../utils/get_storage_service.dart';
import 'commande_client.dart';

class CommandeManuelleClient {
  SoapClient<Commande> soapClient = SoapClient();

  Future<ApiResponse<Commande>> getCommandes(String statusCommande) async {
    List<Commande> commandes = [];

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
          <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/commandepesee">
              <filter>
                  <Field>Traitement</Field>
                  <Criteria>$statusCommande</Criteria>
              </filter>
              <bookmarkKey></bookmarkKey>
              <setSize></setSize>
          </ReadMultiple>
        </Body>
    </Envelope>
    ''';

    var response = await soapClient.post(
        url: "Page/CommandePesee",
        action: 'urn:microsoft-dynamics-schemas/page/commandepesee',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('CommandePesee');
      elements.forEach((element) {
        commandes.add(Commande.fromXml(element));
      });

      response.items = commandes;
    }

    return response;
  }

  Future<ApiResponse<Commande>> updateNomPeseur(String noCommande) async {
    String nom = await GetStorageService.getLogin();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <setPeseurComPesee xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>$noCommande</order_Noa46>
            <user_app_name>$nom</user_app_name>
        </setPeseurComPesee>
    </Body>
</Envelope>
    ''';

    var response = await soapClient.post(
        url: "codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
      xmlDocument.findAllElements("setPeseurComPesee_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      }
    }
    return response;
  }
  Future<ApiResponse<Commande>> setComLinPeseeActeur(String noCommande ,String article) async {
    String nom = await GetStorageService.getLogin();

    var body = '''
          <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
          
           <Body>
          
           <setComLinPeseeActeur xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
          
           <order_Noa46>$noCommande</order_Noa46>
          
           <article>$article</article>
          
           <user_app_name>$nom</user_app_name>
          
           </setComLinPeseeActeur>
          
           </Body>
          
           </Envelope>
    ''';

    var response = await soapClient.post(
        url: "codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
      xmlDocument.findAllElements("setPeseurComPesee_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      }
    }
    return response;
  }

  Future<ApiResponse<Commande>> updateNomVerificateur(String noCommande) async {
    String nom = await GetStorageService.getLogin();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <setVerifComPesee xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>$noCommande</order_Noa46>
            <user_app_name>$nom</user_app_name>
        </setVerifComPesee>
    </Body>
</Envelope>
    ''';

    var response = await soapClient.post(
        url: "codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
      xmlDocument.findAllElements("setVerifComPesee_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      }
    }
    return response;
  }

  Future<ApiResponse<Commande>> validerPesee(String noCommande) async {

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ValiderComPesee xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>$noCommande</order_Noa46>
        </ValiderComPesee>
    </Body>
</Envelope>
    ''';

    var response = await soapClient.post(
        url: "codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
      xmlDocument.findAllElements("return_value");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      }
      else{
        response.message = faultCodeNode.first.text;
      }
    }
    return response;
  }
}
