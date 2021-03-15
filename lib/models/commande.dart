import 'package:fish_scan/models/article.dart';
import 'package:xml/xml.dart';

class Commande {
  Commande({
    this.key,
    this.no,
    this.buyFromVendorNo,
    this.buyFromVendorName,
    this.situaion,
    this.payToVendorNo,
    this.payToName,
    this.shipToName,
    this.postingDate,
    this.locationCode,
    this.currencyCode,
    this.documentDate,
    this.status,
    this.dueDate,
    this.paymentDiscountPercent,
    this.requestedReceiptDate,
    this.jobQueueStatus,
    this.amountReceivedNotInvoicedExclVatLcy,
    this.amountReceivedNotInvoicedLcy,
    this.amount,
    this.amountIncludingVat,
    this.postingDescription,
    this.traitement,
    this.salePersonCode,
    this.preparateur,
    this.sellToCustomerName,
    this.creationDate,
    this.verificateur,
  });

  String key;
  String no;
  String buyFromVendorNo;
  String buyFromVendorName;
  String situaion;
  String payToVendorNo;
  String payToName;
  String shipToName;
  DateTime postingDate;
  String locationCode;
  String currencyCode;
  DateTime documentDate;
  String status;
  DateTime dueDate;
  String paymentDiscountPercent;
  DateTime requestedReceiptDate;
  String jobQueueStatus;
  String amountReceivedNotInvoicedExclVatLcy;
  String amountReceivedNotInvoicedLcy;
  String amount;
  String amountIncludingVat;
  String postingDescription;
  String traitement;
  String salePersonCode;
  String preparateur;
  String sellToCustomerName;
  String creationDate;
  String verificateur;

  factory Commande.fromXml(XmlElement personNode) {
    var traitementNode = personNode.findAllElements('Traitement');
    var traitementValue =
        traitementNode.isNotEmpty ? traitementNode.first.text : "";

    var salePersonCodeNode = personNode.findAllElements('Salesperson_Code');
    var preparateurNode = personNode.findAllElements('Code_preparateur');
    var sellToCustomerNameNode =
        personNode.findAllElements('Sell_to_Customer_Name');
    var buyFromVendorName = personNode.findAllElements('Buy_from_Vendor_Name');

    var creationDateNode = personNode.findAllElements('Creating_Date');

    var postingDescriptionNode =
        personNode.findAllElements('Posting_Description');

    if(preparateurNode.isEmpty) {
      preparateurNode =
      personNode.findAllElements('Preparateur');
    }

    var verificateurNode =
        personNode.findAllElements('Verificateur');

    return Commande(
      key: personNode.findAllElements('Key').first.text,
      no: personNode.findAllElements('No').first.text,
      postingDescription: postingDescriptionNode.isEmpty
          ? ""
          : postingDescriptionNode.first.text,
      traitement: traitementValue,
      salePersonCode:
          salePersonCodeNode.isEmpty ? "" : salePersonCodeNode.first.text,
      sellToCustomerName: sellToCustomerNameNode.isEmpty
          ? ""
          : sellToCustomerNameNode.first.text,
      buyFromVendorName:
          buyFromVendorName.isEmpty ? "" : buyFromVendorName.first.text,
      creationDate: creationDateNode.isEmpty ? "" : creationDateNode.first.text,
      verificateur: verificateurNode.isEmpty ? null : verificateurNode.first.text,
      preparateur: preparateurNode.isEmpty ? null : preparateurNode.first.text,
    );
  }
}
