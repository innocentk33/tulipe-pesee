import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:xml/xml.dart';

class CommandeClient {
  SoapClient<Commande> soapClient = SoapClient();

  Future<ApiResponse<Commande>> getCommandesAchat(String statusCommande) async {
    List<Commande> commandes = List();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
          <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/cmdacht">
              <filter>
                  <Field>Depotage</Field>
                  <Criteria>$statusCommande</Criteria>
              </filter>
              <bookmarkKey></bookmarkKey>
              <setSize></setSize>
          </ReadMultiple>
        </Body>
    </Envelope>
    ''';

    var response = await soapClient.post(
        url: "Page/CMDACHT",
        action: 'urn:microsoft-dynamics-schemas/page/cmdacht',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('CMDACHT');
      elements.forEach((element) {
        commandes.add(Commande.fromXml(element));
      });

      response.items = commandes;
    }

    return response;
  }

  Future<ApiResponse<Commande>> getCommandesVente(String statusCommande) async {
    List<Commande> commandes = List();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
          <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/salesorder">
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
        url: "Page/SalesOrder",
        action: 'urn:microsoft-dynamics-schemas/page/salesorder',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('SalesOrder');
      elements.forEach((element) {
        commandes.add(Commande.fromXml(element));
      });

      response.items = commandes;
    }

    return response;
  }

  Future<ApiResponse<Commande>> getNombreCommandeParTraitement(int codeTraitement) async {

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <NbreCommande xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <traitement>$codeTraitement</traitement>
        </NbreCommande>
    </Body>
</Envelope>
    ''';

    var response = await soapClient.post(
        url: "codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      String result = document.findAllElements('return_value').first.text;

      response.body = result;
    }

    return response;
  }



  Future<ApiResponse<Commande>> getMontantTotalCommandePesee(String noCommande) async {

    var body = '''
      <Envelope xmlns=http://schemas.xmlsoap.org/soap/envelope/>
      
          <Body>
      
              <GetMontantTotalComPesee xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
      
                  <order_Noa46>$noCommande</order_Noa46>
      
              </GetMontantTotalComPesee>
      
          </Body>
      
      </Envelope>
    ''';

    var response = await soapClient.post(
        url: "codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      String result = document.findAllElements('return_value').first.text;

      response.body = result;
    }

    return response;
  }

}
