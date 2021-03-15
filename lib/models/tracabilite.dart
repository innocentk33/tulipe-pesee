import 'package:xml/xml.dart';

class Tracabilite {
  final String fsourceId = 'sourceId';
  final String fitemNoa46 = 'itemNoa46';
  final String fsourceRefa46Noa46 = 'sourceRefa46Noa46';
  final String flotNoa46 = 'lotNoa46';
  final String fquantity = 'quantity';
  final String flocationCode = 'locationCode';
  final String fcreatedBy = 'createdBy';
  final String fsourceType = 'sourceType';
  final String fidTracabilite = 'idTracabilite';
  final String fnumPalette = 'numPalette';

  int id;
  String xmlns;
  String entryNoa46;
  String sourceID;
  String sourceType;
  String itemNoa46;
  String sourceRefa46Noa46;
  String lotNoa46;
  String quantity;
  String locationCode;
  String itemTracking;
  String positive;
  String createdBy;
  String expectedReceiptDate;
  String creationDate;
  String reservationStatus;
  String sourceSubtype;
  String idTracabilite;
  String numPalette;
  bool canBeDelete;

  Tracabilite(
      {this.xmlns,
      this.entryNoa46,
      this.sourceID,
      this.sourceType,
      this.itemNoa46,
      this.sourceRefa46Noa46,
      this.lotNoa46,
      this.quantity,
      this.locationCode,
      this.itemTracking,
      this.positive,
      this.createdBy,
      this.expectedReceiptDate,
      this.creationDate,
      this.reservationStatus,
      this.sourceSubtype,
      this.id,
      this.idTracabilite,
      this.numPalette,
      this.canBeDelete = false});

  @override
  String toString() {
    return 'Tracabilite{entryNoa46: $entryNoa46, sourceID: $sourceID, sourceType: $sourceType, itemNoa46: $itemNoa46, sourceRefa46Noa46: $sourceRefa46Noa46, lotNoa46: $lotNoa46, quantity: $quantity, locationCode: $locationCode, itemTracking: $itemTracking, positive: $positive, createdBy: $createdBy, expectedReceiptDate: $expectedReceiptDate, creationDate: $creationDate, reservationStatus: $reservationStatus, sourceSubtype: $sourceSubtype}';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      '$fsourceId': this.sourceID,
      '$fitemNoa46': this.itemNoa46,
      '$fsourceRefa46Noa46': this.sourceRefa46Noa46,
      '$flotNoa46': this.lotNoa46,
      '$fquantity': this.quantity,
      '$flocationCode': this.locationCode,
      '$fcreatedBy': this.createdBy,
      '$fidTracabilite': this.idTracabilite,
      '$fnumPalette': this.numPalette,
    };
    if (id != null) {
      map['id'] = this.id;
    }
    return map;
  }

  Tracabilite.fromMap(Map map) {
    this.sourceID = map['$fsourceId'];
    this.sourceType = map['$fsourceType'];
    this.itemNoa46 = map['$fitemNoa46'];
    this.sourceRefa46Noa46 = map['$fsourceRefa46Noa46'];
    this.lotNoa46 = map['$flotNoa46'];
    this.quantity = map['$fquantity'];
    this.locationCode = map['$flocationCode'];
    this.idTracabilite = map['$fidTracabilite'];
    this.numPalette = map['$fnumPalette'];
    this.createdBy = map['$fcreatedBy'];
    this.id = map['id'];
  }

  factory Tracabilite.fromXml(XmlElement element) {
    String articleNo = element.findAllElements('Item_No').first.text;
    String lotNo = element.findAllElements('Lot_No').first.text;
    var createByNode = element.findAllElements('Created_By');

    return Tracabilite(
      idTracabilite: "${lotNo}_${articleNo}",
      lotNoa46: lotNo,
      quantity: "${double.parse(element.findAllElements('qty').first.text)}",
      locationCode: element.findAllElements('Location_Code').first.text,
      sourceID: element.findAllElements('Source_ID').first.text,
      itemNoa46: articleNo,
      sourceRefa46Noa46: element.findAllElements('Source_Ref_No').first.text,
      createdBy: createByNode.isEmpty ? "" : createByNode.first.text,
    );
  }
}
