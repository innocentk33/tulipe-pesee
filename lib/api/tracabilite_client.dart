import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/models/pesee.dart';
import 'package:fish_scan/models/tracabilite.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:xml/xml.dart';

class TracabiliteClient {
  SoapClient<Pesee> soapPeseeClient = SoapClient();
  SoapClient<Tracabilite> soapTracabiliteClient = SoapClient();
  SoapClient<Article> soapArticle = SoapClient();

  Future<ApiResponse<Tracabilite>> submitTracabilite(
      Tracabilite tracabilite, int sourceType, int sourceSubType) async {
    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <UpdateItemTracking xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <entry_Noa46>0</entry_Noa46>
            <source_ID>${tracabilite.sourceID}</source_ID>
            <source_Type>$sourceType</source_Type>
            <item_Noa46>${tracabilite.itemNoa46}</item_Noa46>
            <source_Refa46_Noa46>${tracabilite.sourceRefa46Noa46}</source_Refa46_Noa46>
            <lot_Noa46>${tracabilite.lotNoa46.replaceAll("\n", "").trim()}</lot_Noa46>
            <quantity>${tracabilite.quantity.replaceAll("\n", "").trim()}</quantity>
            <location_Code>${tracabilite.locationCode}</location_Code>
            <item_Tracking>1</item_Tracking>
            <positive>true</positive>
            <created_By>${tracabilite.createdBy}</created_By>
            <expected_Receipt_Date>${tracabilite.creationDate}</expected_Receipt_Date>
            <creation_Date>${tracabilite.creationDate}</creation_Date>
            <palette>${tracabilite.numPalette}</palette>
            <reservation_Status>2</reservation_Status>
            <source_subtype>$sourceSubType</source_subtype>
        </UpdateItemTracking>
    </Body>
</Envelope>
    ''';

    var response = await soapTracabiliteClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
          xmlDocument.findAllElements("UpdateItemTracking_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      } else {
        response.items = [tracabilite];
      }
    }

    return response;
  }

  Future<ApiResponse<Pesee>> submitPesee(Pesee pesee) async {
    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <UpdateItemTracking xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <entry_Noa46>0</entry_Noa46>
            <source_ID>${pesee.sourceID}</source_ID>
            <source_Type>37</source_Type>
            <item_Noa46>${pesee.itemNoa46}</item_Noa46>
            <source_Refa46_Noa46>${pesee.sourceRefa46Noa46}</source_Refa46_Noa46>
            <lot_Noa46>${pesee.lotNoa46}</lot_Noa46>
            <quantity>${double.parse(pesee.quantity) * -1}</quantity>
            <location_Code>${pesee.locationCode}</location_Code>
            <item_Tracking>1</item_Tracking>
            <positive>false</positive>
            <created_By>${pesee.createdBy}</created_By>
            <expected_Receipt_Date>${pesee.creationDate}</expected_Receipt_Date>
            <creation_Date>${pesee.creationDate}</creation_Date>
            <palette></palette>
            <reservation_Status>2</reservation_Status>
            <source_subtype>1</source_subtype>
        </UpdateItemTracking>
    </Body>
</Envelope>
    ''';

    var response = await soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
          xmlDocument.findAllElements("UpdateItemTracking_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      } else {
        response.items = [pesee];
      }
    }

    return response;
  }

  Future<ApiResponse<Pesee>> submitPeseeManuelle(Pesee pesee) async {
    var username = await GetStorageService.getLogin();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <EnregisterPesee xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>${pesee.sourceID}</order_Noa46>
            <username>$username</username>
            <noArticle>${pesee.articleNo}</noArticle>
            <num>${pesee.idPesee}</num>
            <nombre>${pesee.lotNoa46}</nombre>
            <poids>${pesee.quantity}</poids>
            <total>${double.parse(pesee.quantity) * double.parse(pesee.lotNoa46)}</total>
            <peseur>${pesee.isPreparateur}</peseur>
            <vericateur>${pesee.isVerificateur}</vericateur>
        </EnregisterPesee>
    </Body>
</Envelope>
    ''';

    var response = await soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode = xmlDocument.findAllElements("EnregisterPesee_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      } else {
        response.items = [pesee];
      }
    }

    return response;
  }

  Future<ApiResponse> updateCommandeQuantity(
      Article article, double quantity, int nombreCartons) async {
    print("submit tracabilite");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <UpdateOrderLineTotalQty xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>${article.documentNo}</order_Noa46>
            <line_Noa46>${article.lineNo}</line_Noa46>
            <item_Noa46>${article.no}</item_Noa46>
            <qté>$quantity</qté>
            <carton>$nombreCartons</carton>
        </UpdateOrderLineTotalQty>
    </Body>
</Envelope>
    ''';

    return soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);
  }

  Future<ApiResponse> updateCommandeStatus(
      {Commande commande, String login, int status}) async {
    print("updateCommandeStatus");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <setStatus xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>${commande.no}</order_Noa46>
            <user_app_name>$login</user_app_name>
            <traitement>$status</traitement>
        </setStatus>
    </Body>
</Envelope>
    ''';

    return soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);
  }

  Future<ApiResponse<Pesee>> getPesee(Article article) async {
    print("getPesee");
    List<Pesee> pesees = List();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/lignestracking">
            <filter>
                <Field>Source_ID</Field>
                <Criteria>${article.documentNo}</Criteria>
            </filter>
            <filter>
                <Field>Source_Type</Field>
                <Criteria>37</Criteria>
            </filter>
            <filter>
                <Field>Item_No</Field>
                <Criteria>${article.no}</Criteria>
            </filter>
        </ReadMultiple>
    </Body>
</Envelope>
    ''';

    var response = await soapPeseeClient.post(
        url: "Page/lignestracking",
        action: 'urn:microsoft-dynamics-schemas/page/lignestracking',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('lignestracking');
      elements.forEach((element) {
        pesees.add(Pesee.fromXml(element));
      });

      response.items = pesees;
    }

    return response;
  }

  Future<ApiResponse<Pesee>> getPeseeManuelle(Article article) async {
    print("getPesee");
    List<Pesee> pesees = List();
    String username = await GetStorageService.getLogin();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/pesee">
            <filter>
                <Field>Document_No</Field>
                <Criteria>${article.documentNo}</Criteria>
            </filter>
            <filter>
                <Field>No</Field>
                <Criteria>${article.no}</Criteria>
            </filter>   
            <filter>
                <Field>Peseur</Field>
                <Criteria>$username</Criteria>
            </filter>
        </ReadMultiple>
    </Body>
</Envelope>
    ''';

    var response = await soapPeseeClient.post(
        url: "Page/Pesee",
        action: 'urn:microsoft-dynamics-schemas/page/pesee',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('Pesee');
      elements.forEach((element) {
        pesees.add(Pesee.fromXml(element));
      });

      response.items = pesees;
    }

    return response;
  }

  Future<ApiResponse<Tracabilite>> getTracabilite(Article article) async {
    print("getTracabilite");
    List<Tracabilite> tracabilites = List();

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/lignestracking">
            <filter>
                <Field>Source_ID</Field>
                <Criteria>${article.documentNo}</Criteria>
            </filter>
            <filter>
                <Field>Source_Type</Field>
                <Criteria>39</Criteria>
            </filter>
            <filter>
                <Field>Item_No</Field>
                <Criteria>${article.no}</Criteria>
            </filter>
        </ReadMultiple>
    </Body>
</Envelope>
    ''';

    var response = await soapTracabiliteClient.post(
        url: "Page/lignestracking",
        action: 'urn:microsoft-dynamics-schemas/page/lignestracking',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('lignestracking');
      elements.forEach((element) {
        tracabilites.add(Tracabilite.fromXml(element));
      });

      response.items = tracabilites;
    }

    return response;
  }

  Future<ApiResponse> deleteTracabilite(
      {String articleNo, String commandeNo, String sourceType}) async {
    print("deletePesee");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ResetItemTracking xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <item_Noa46>$articleNo</item_Noa46>
            <source_ID>$commandeNo</source_ID>
            <source_Type>$sourceType</source_Type>
        </ResetItemTracking>
    </Body>
</Envelope>
    ''';

    return soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);
  }

  Future<ApiResponse<Pesee>> deletePesee(Pesee pesee) async {
    var body = '''
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ResetItemTracking xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <item_Noa46>${pesee.itemNoa46}</item_Noa46>
            <source_ID>${pesee.sourceID}</source_ID>
            <source_Type>37</source_Type>
        </ResetItemTracking>
    </Body>
</Envelope>
    ''';

    var response = await soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
          xmlDocument.findAllElements("ResetItemTracking_Result");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      } else {
        response.items = [pesee];
      }
    }

    return response;
  }

  Future<ApiResponse<Pesee>> deletePeseesManuelle(Pesee pesee) async {
    String username = await GetStorageService.getLogin();

    var body = '''
 <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
 
        
          <Body>
        <SuprimerUnePesee xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>${pesee.sourceID}</order_Noa46>
            <username>$username</username>
            <noArticle>${pesee.articleNo}</noArticle>
            <nombre>${pesee.lotNoa46}</nombre>
            <poids>${pesee.quantity}</poids>
            <total>${double.parse(pesee.quantity) * double.parse(pesee.lotNoa46)}</total>
        </SuprimerUnePesee>
    </Body>
        
  
</Envelope>
    ''';

    var response = await soapPeseeClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
          xmlDocument.findAllElements("SuprimerUnePesee");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      } else {
        response.items = [pesee];
      }
    }

    return response;
  }
  Future<ApiResponse<Article>> suprimerLesPesees (Article article ) async {
    String username = await GetStorageService.getLogin();

    var body = '''
        <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <SuprimerLesPesees xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <order_Noa46>${article.documentNo}</order_Noa46>
            <noArticle>${article.no}</noArticle>
            <username>$username</username>
        </SuprimerLesPesees>
    </Body>
</Envelope>
    ''';

    var response = await soapArticle.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);


    if (!response.hasError) {
      XmlDocument xmlDocument = XmlDocument.parse(response.body);
      var faultCodeNode =
          xmlDocument.findAllElements("SuprimerLesPesees");
      if (faultCodeNode.isEmpty) {
        response.hasError = true;
      }
    } else{
      print(response.body);
    }
    return response;
  }



}
