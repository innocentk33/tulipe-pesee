import 'package:xml/xml.dart';

class Pesee {
  final String flotNoa46 = 'lotNoa46';
  final String fquantity = 'quantity';
  final String farticleNo = 'articleNo';
  final String flocationCode = 'locationCode';
  final String fsourceId = 'sourceId';
  final String fitemNoa46 = 'itemNoa46';
  final String fsourceRefa46Noa46 = 'sourceRefa46Noa46';
  final String fcreatedBy = 'createdBy';
  final String fidPesee = 'idPesee';
  final String fpreparateur = 'fpreparateur';
  final String fverificateur = 'fverificateur';



  int id;
  String idPesee;
  String lotNoa46;
  String quantity;
  String poidArticle;
  String nombreArticle;
  String articleNo;
  String locationCode;
  String entryNoa46;
  String sourceID;
  String sourceType;
  String itemNoa46;
  String sourceRefa46Noa46;
  String itemTracking;
  String positive;
  String createdBy;
  String expectedReceiptDate;
  String creationDate;
  String reservationStatus;
  String sourceSubtype;
  String idTracabilite;
  bool canBeDelete;
  bool isPreparateur;
  bool isVerificateur;
  String noLigne;


  Pesee({
    this.quantity,
    this.articleNo,
    this.idPesee,
    this.locationCode,
    this.id,
    this.entryNoa46,
    this.sourceID,
    this.sourceType,
    this.itemNoa46,
    this.sourceRefa46Noa46,
    this.lotNoa46,
    this.itemTracking,
    this.positive,
    this.createdBy,
    this.expectedReceiptDate,
    this.creationDate,
    this.reservationStatus,
    this.sourceSubtype,
    this.idTracabilite,
    this.canBeDelete = false,
    this.isPreparateur = false,
    this.isVerificateur = false,
    this.noLigne,
    this.poidArticle,
    this.nombreArticle,

  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      '$flotNoa46': this.lotNoa46,
      '$fquantity': this.quantity,
      '$farticleNo': this.articleNo,
      '$flocationCode': this.locationCode,
      '$fsourceId': this.sourceID,
      '$fitemNoa46': this.itemNoa46,
      '$fsourceRefa46Noa46': this.sourceRefa46Noa46,
      '$fcreatedBy': this.createdBy,

      '$fverificateur': this.isVerificateur ? 1 : 0,
      '$fpreparateur': this.isPreparateur ? 1 : 0,
    };
    if (idPesee != null) {
      map['$fidPesee'] = idPesee;
    }
    return map;
  }

  Pesee.fromMap(Map map) {
    this.lotNoa46 = map['$flotNoa46'];
    this.quantity = map['$fquantity'];
    this.articleNo = map['$farticleNo'];
    this.idPesee = map['$fidPesee'];
    this.locationCode = map['$flocationCode'];
    this.sourceID = map['$fsourceId'];
    this.itemNoa46 = map['$fitemNoa46'];
    this.sourceRefa46Noa46 = map['$fsourceRefa46Noa46'];
    this.createdBy = map['$fcreatedBy'];
    this.quantity = map['$fquantity'];
    this.isPreparateur = map['$fpreparateur'] == 0 ? false : true;
    this.isVerificateur = map['$fverificateur'] == 0 ? false : true;
  }

  @override
  String toString() {
    return 'Pesee{id: $id, idPesee: $idPesee, lotNoa46: $lotNoa46, quantity: $quantity, articleNo: $articleNo, locationCode: $locationCode, entryNoa46: $entryNoa46, sourceID: $sourceID, sourceType: $sourceType, itemNoa46: $itemNoa46, sourceRefa46Noa46: $sourceRefa46Noa46, itemTracking: $itemTracking, positive: $positive, createdBy: $createdBy, expectedReceiptDate: $expectedReceiptDate, creationDate: $creationDate, reservationStatus: $reservationStatus, sourceSubtype: $sourceSubtype, idTracabilite: $idTracabilite}';
  }

  factory Pesee.fromXml(XmlElement element) {
    var articleNo = element.findAllElements('Item_No');
    var lotNo = element.findAllElements('Lot_No');
    var createByNode = element.findAllElements('Created_By');
    var unitPriceNode = element.findAllElements('Unit_Price');
    double unitPrice =  unitPriceNode.isEmpty ? 0 : double.parse(unitPriceNode.first.text);

    var quantity = 0.0;

    var quantityNode = element.findAllElements('qty');
    if(quantityNode.isEmpty){
      quantityNode = element.findAllElements('Poids');
      quantity = double.parse(quantityNode.first.text) * -1;
    }

    if(lotNo.isEmpty){
      lotNo = element.findAllElements('nombre');
    }

    return Pesee(
      idPesee: "${lotNo}_${articleNo}",
      lotNoa46: lotNo.isEmpty ? "": lotNo.first.text,

      quantity:
      quantityNode.isEmpty ? "0" : "${quantity * -1}",
      articleNo: articleNo.isEmpty ? "" : articleNo.first.text,
      locationCode: element.findAllElements('Location_Code').isEmpty ? "" : element.findAllElements('Location_Code').first.text,
      sourceID: element.findAllElements('Source_ID').isEmpty ? "" : element.findAllElements('Source_ID').first.text,
      itemNoa46: articleNo.isEmpty ? "" : articleNo.first.text,
      sourceRefa46Noa46: element.findAllElements('Source_Ref_No').isEmpty ? "" : element.findAllElements('Source_Ref_No').first.text,
      createdBy: createByNode.isEmpty ? "" : createByNode.first.text,
    );
  }
}
