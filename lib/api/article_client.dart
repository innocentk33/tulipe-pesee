import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class ArticleClient {
  SoapClient<Article> soapClient = SoapClient();

  Future<ApiResponse<Article>> getArticlesAchat(String commandeNo) async {
    List<Article> items = [];

    print("commande $commandeNo");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/articlesachat">
            <filter>
               <Field>Document_No</Field>
                <Criteria>$commandeNo</Criteria>
            </filter>
            <bookmarkKey></bookmarkKey>
            <setSize></setSize>
        </ReadMultiple>
      </Body>
    </Envelope>
    ''';

    var response = await soapClient.post(
        url: "Page/ArticlesAchat",
        action: 'urn:microsoft-dynamics-schemas/page/articlesachat',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('ArticlesAchat');
      elements.forEach((element) {
        items.add(Article.fromXml(element));
      });

      response.items = items;
    }

    return response;
  }

  Future<ApiResponse<Article>> getArticlesVente(String commandeNo) async {
    List<Article> items = List();

    print("commande $commandeNo");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/lignesvente">
            <filter>
               <Field>Document_No</Field>
                <Criteria>$commandeNo</Criteria>
            </filter>
            <bookmarkKey></bookmarkKey>
            <setSize></setSize>
        </ReadMultiple>
      </Body>
    </Envelope>
    ''';

    var response = await soapClient.post(
        url: "Page/lignesvente",
        action: 'urn:microsoft-dynamics-schemas/page/lignesvente',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('lignesvente');
      elements.forEach((element) {
        items.add(Article.fromXml(element));
      });

      response.items = items;
    }

    return response;
  }

  Future<ApiResponse<Article>> getArticleAchatRapide() async {
    List<Article> items = List();

    var body = '''
   <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/feuillearticle">
            <CurrentJnlBatchName>DEFAULT</CurrentJnlBatchName>
            <filter>
                <Field></Field>
                <Criteria></Criteria>
            </filter>
        </ReadMultiple>
    </Body>
</Envelope>
    ''';

    var response = await soapClient.post(
        url: "Page/feuillearticle",
        action: 'urn:microsoft-dynamics-schemas/page/feuillearticle',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('feuillearticle');
      elements.forEach((element) {
        items.add(Article.fromXml(element));
      });

      response.items = items;
    }

    return response;
  }

  Future<ApiResponse<Article>> getArticleVenteByLot(
      {String articleNo, String lot, String locationCode}) async {
    print("getArticleVenteByLot");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <GetSalesLotQty xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <item_Noa46>$articleNo</item_Noa46>
            <lot_Noa46>$lot</lot_Noa46>
            <location_Code>$locationCode</location_Code>
        </GetSalesLotQty>
      </Body>
  </Envelope>
    ''';

    print("body => $body");

    var response = await soapClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      double returnValue =
          double.parse(document.findAllElements('return_value').first.text);

      if (returnValue <= 0) {
        if (returnValue == -3) {
          return ApiResponse(hasError: true, message: "Aucun carton trouvé");
        }

        if (returnValue == -2) {
          return ApiResponse(hasError: true, message: "Le lot est déjà vendu");
        }

        if (returnValue == -1) {
          return ApiResponse(
              hasError: true, message: "Le lot n'est pas disponible");
        }
      }

      return ApiResponse(
          hasError: false, items: [Article(quantity: returnValue)]);
    }
  }

  Future<ApiResponse<Article>> getValeurEffective(
      {Article article, int champs, String sourceType}) async {
    print("getValeurEffective");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <NombreColis xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <item_Noa46>${article.no}</item_Noa46>
            <location_Code>${article.locationCode}</location_Code>
            <source_ID>${article.documentNo}</source_ID>
            <source_Type>$sourceType</source_Type>
            <champs>$champs</champs>
        </NombreColis>
    </Body>
</Envelope>
    ''';

    print("body => $body");

    var response = await soapClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      String result = document.findAllElements('return_value').first.text;

      response.body = result;
    }

    return response;
  }

  Future<ApiResponse<Article>> getNombreColisPeseur(
      {Article article, int champs, String sourceType, String login}) async {
    print("getValeurEffective");

    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <NombreColisPeseur xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <item_Noa46>${article.no}</item_Noa46>
            <location_Code>${article.locationCode}</location_Code>
            <source_ID>${article.documentNo}</source_ID>
            <source_Type>$sourceType</source_Type>
            <champs>$champs</champs>
            <create_By>$login</create_By>
        </NombreColisPeseur>
    </Body>
</Envelope>
    ''';

    print("body => $body");

    var response = await soapClient.post(
        url: "Codeunit/COMMANDESA",
        action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      String result = document.findAllElements('return_value').first.text;

      response.body = result;
    }

    return response;
  }

  Future<ApiResponse<Article>> getFreeLotNo(
      {int number, String quantity, Article article, String userLogin}) async {
    print("getFreeLotNo");

    int nombreTotal = 0;
    var dateFormat = DateFormat("yyyy-MM-dd");
    var currentDate = dateFormat.format(DateTime.now());

    List<Article> articles = List();

    for (int i = 1; i <= number; i++) {
      var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <GetFreeLotNo xmlns="urn:microsoft-dynamics-schemas/codeunit/COMMANDESA">
            <entry_Noa46>0</entry_Noa46>
            <source_ID>${article.documentNo}</source_ID>
            <source_Type>37</source_Type>
            <item_Noa46>${article.no}</item_Noa46>
            <source_Refa46_Noa46>${article.lineNo}</source_Refa46_Noa46>
            <quantity>${double.parse(quantity) * -1}</quantity>
            <location_Code>${article.locationCode}</location_Code>
            <item_Tracking>1</item_Tracking>
            <positive>false</positive>
            <created_By>$userLogin</created_By>
            <expected_Receipt_Date>$currentDate</expected_Receipt_Date>
            <creation_Date>$currentDate</creation_Date>
            <reservation_Status>2</reservation_Status>
            <source_subtype>1</source_subtype>
            <palette></palette>
        </GetFreeLotNo>
    </Body>
</Envelope>
    ''';

      var response = await soapClient.post(
          url: "Codeunit/COMMANDESA",
          action: 'urn:microsoft-dynamics-schemas/codeunit/COMMANDESA',
          body: body);

      if (!response.hasError) {
        final document = XmlDocument.parse(response.body);
        var result = document.findAllElements('return_value').first.text;
        if (result.isNotEmpty) {
          articles.add(Article(no: result));
          nombreTotal++;
        }
      }
    }

    return ApiResponse<Article>(
        hasError: number != nombreTotal,
        message: "$nombreTotal/$number traités",
        items: articles);
  }

  Future<ApiResponse<Article>> getArticlePeseeManuelle(String commandeNo) async {
    List<Article> items = List();


    var body = '''
    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReadMultiple xmlns="urn:microsoft-dynamics-schemas/page/lignecommandepesee">
            <filter>
                <Field>Document_No</Field>
                <Criteria>$commandeNo</Criteria>
            </filter>
            <bookmarkKey></bookmarkKey>
            <setSize></setSize>
        </ReadMultiple>
    </Body>
</Envelope>

    ''';

    var response = await soapClient.post(
        url: "Page/LigneCommandePesee",
        action: 'urn:microsoft-dynamics-schemas/Page/LigneCommandePesee',
        body: body);

    if (!response.hasError) {
      final document = XmlDocument.parse(response.body);

      var elements = document.findAllElements('LigneCommandePesee');
      elements.forEach((element) {
        items.add(Article.fromXml(element));
      });

      response.items = items;
    }

    return response;
  }

}
