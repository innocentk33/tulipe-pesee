import 'package:xml/xml.dart';

class Article {
  String key;
  String type;
  String no;
  String iCPartnerRefType;
  String nonstock;
  String vATProdPostingGroup;
  String description;
  String dropShipment;
  String locationCode;
  int nombreDeCartons;
  double quantity;
  String reservedQuantity;
  String jobRemainingQty;
  String unitOfMeasureCode;
  String unitOfMeasure;
  double directUnitCost;
  String indirectCostPercent;
  String unitCostLCY;
  String unitPriceLCY;
  String taxLiable;
  String useTax;
  String lineDiscountPercent;
  String lineAmount;
  String lineDiscountAmount;
  String prepaymentPercent;
  String prepmtLineAmount;
  String prepmtAmtInv;
  String allowInvoiceDisc;
  String invDiscountAmount;
  String invDiscAmountToInvoice;
  String qtyToReceive;
  String quantityReceived;
  String qtyToInvoice;
  String quantityInvoiced;
  String prepmtAmtToDeduct;
  String prepmtAmtDeducted;
  String allowItemChargeAssignment;
  String qtyToAssign;
  String qtyAssigned;
  String jobPlanningLineNo;
  String jobLineType;
  String jobUnitPrice;
  String jobLineAmount;
  String jobLineDiscountAmount;
  String jobLineDiscountPercent;
  String jobTotalPrice;
  String jobUnitPriceLCY;
  String jobTotalPriceLCY;
  String jobLineAmountLCY;
  String jobLineDiscAmountLCY;
  String requestedReceiptDate;
  String promisedReceiptDate;
  String plannedReceiptDate;
  String expectedReceiptDate;
  String orderDate;
  String planningFlexibility;
  String prodOrderLineNo;
  String finished;
  String whseOutstandingQtyBase;
  String blanketOrderLineNo;
  String applToItemEntry;
  String documentNo;
  String lineNo;
  String overReceiptQuantity;
  String amountBeforeDiscount;
  String invoiceDiscountAmount;
  String invoiceDiscPct;
  String totalAmountExclVAT;
  String totalVATAmount;
  double totalAmountInclVAT;
  double quantityBase;
  double unitPrice;
  String preparateur;
  String verificateur;
  bool controle;
  String poids1;
  String cartonPeseur;
  double quantity_base;
  double budget;

  Article({
    this.key,
    this.type,
    this.no,
    this.iCPartnerRefType,
    this.nonstock,
    this.vATProdPostingGroup,
    this.description,
    this.dropShipment,
    this.locationCode,
    this.nombreDeCartons,
    this.quantity,
    this.reservedQuantity,
    this.jobRemainingQty,
    this.unitOfMeasureCode,
    this.unitOfMeasure,
    this.directUnitCost,
    this.indirectCostPercent,
    this.unitCostLCY,
    this.unitPriceLCY,
    this.taxLiable,
    this.useTax,
    this.lineDiscountPercent,
    this.lineAmount,
    this.lineDiscountAmount,
    this.prepaymentPercent,
    this.prepmtLineAmount,
    this.prepmtAmtInv,
    this.allowInvoiceDisc,
    this.invDiscountAmount,
    this.invDiscAmountToInvoice,
    this.qtyToReceive,
    this.quantityReceived,
    this.qtyToInvoice,
    this.quantityInvoiced,
    this.prepmtAmtToDeduct,
    this.prepmtAmtDeducted,
    this.allowItemChargeAssignment,
    this.qtyToAssign,
    this.qtyAssigned,
    this.jobPlanningLineNo,
    this.jobLineType,
    this.jobUnitPrice,
    this.jobLineAmount,
    this.jobLineDiscountAmount,
    this.jobLineDiscountPercent,
    this.jobTotalPrice,
    this.jobUnitPriceLCY,
    this.jobTotalPriceLCY,
    this.jobLineAmountLCY,
    this.jobLineDiscAmountLCY,
    this.requestedReceiptDate,
    this.promisedReceiptDate,
    this.plannedReceiptDate,
    this.expectedReceiptDate,
    this.orderDate,
    this.planningFlexibility,
    this.prodOrderLineNo,
    this.finished,
    this.whseOutstandingQtyBase,
    this.blanketOrderLineNo,
    this.applToItemEntry,
    this.documentNo,
    this.lineNo,
    this.overReceiptQuantity,
    this.amountBeforeDiscount,
    this.invoiceDiscountAmount,
    this.invoiceDiscPct,
    this.totalAmountExclVAT,
    this.totalVATAmount,
    this.totalAmountInclVAT,
    this.quantityBase,
    this.unitPrice,
    this.preparateur,
    this.verificateur,
    this.controle,
    this.poids1,
    this.cartonPeseur,
    this.budget,
    this.quantity_base,
  });

  factory Article.fromXml(XmlElement personNode) {
    var directUnitCostNode = personNode.findAllElements('Direct_Unit_Cost');
    double directUnitCost = directUnitCostNode.isEmpty
        ? 0
        : double.parse(directUnitCostNode.first.text);

    var qtyBaseNode = personNode.findAllElements('Quantity_base');
    double qtyBase =
        qtyBaseNode.isEmpty ? 0 : double.parse(qtyBaseNode.first.text);

    var unitPriceNode = personNode.findAllElements('Unit_Price');
    double unitPrice =
        unitPriceNode.isEmpty ? 0 : double.parse(unitPriceNode.first.text);

    var totalAmoutIclVATNode =
        personNode.findAllElements('Total_Amount_Incl_VAT');
    double totalAmountInclVAT = totalAmoutIclVATNode.isEmpty
        ? 0
        : double.parse(totalAmoutIclVATNode.first.text);

    var keyNode = personNode.findAllElements('Key');
    var keyValue = keyNode.isEmpty ? "" : keyNode.first.text;

    var noNode = personNode.findAllElements('No');
    var noValue = noNode.isEmpty ? "" : noNode.first.text;

    if (noValue.isEmpty) {
      var itemNoNode = personNode.findAllElements('Item_No');
      noValue = itemNoNode.isEmpty ? "" : itemNoNode.first.text;
    }

    var documentNoNode = personNode.findAllElements('Document_No');
    var documentNoValue =
        documentNoNode.isEmpty ? "" : documentNoNode.first.text;

    var nombreCartonsNode = personNode.findAllElements('Nombre_de_carton');
    var nombreCartonsValue =
        nombreCartonsNode.isEmpty ? "0" : nombreCartonsNode.first.text;
    var budget = personNode.findAllElements("Budget");
    var budgetValue = budget.isEmpty?0:budget.first.text;
    var quantityBase = qtyBaseNode.isEmpty ? 0 : double.parse(qtyBaseNode.first.text);
    var quantityNode = personNode.findAllElements('Quantity');
    var quantityNodeValue = quantityNode.isEmpty ? "0" : quantityNode.first.text;

    var descriptionNode = personNode.findAllElements('Description');
    var descriptionValue =
        descriptionNode.isEmpty ? "" : descriptionNode.first.text;

    var locationCodeNode = personNode.findAllElements('Location_Code');
    var locationCodeValue =
        locationCodeNode.isEmpty ? "" : locationCodeNode.first.text;

    var lineNoNode = personNode.findAllElements('Line_No');
    var lineNoValue = lineNoNode.isEmpty ? "" : lineNoNode.first.text;

    var preparateurNode = personNode.findAllElements('Preparateur');

    var verificateurNode = personNode.findAllElements('Verificateur');

    var controleNode = personNode.findAllElements('Controle');

    var poids1Node = personNode.findAllElements('Total_1');
    var cartonPeseur = personNode.findAllElements("Cartons_peseur");

    return Article(
      key: keyValue,
      no: noValue,
      documentNo: documentNoValue,
      nombreDeCartons: int.parse(nombreCartonsValue),
      directUnitCost: directUnitCost,
      quantity: double.parse(quantityNodeValue),
      budget: double.parse(budgetValue),
      quantity_base: quantityBase,
      description: descriptionValue,
      locationCode: locationCodeValue,
      lineNo: lineNoValue,
      quantityBase: qtyBase,
      unitPrice: unitPrice,
      totalAmountInclVAT: totalAmountInclVAT,
      verificateur:
          verificateurNode.isEmpty ? null : verificateurNode.first.text,
      preparateur: preparateurNode.isEmpty ? null : preparateurNode.first.text,
      controle: controleNode.isEmpty ? false : (controleNode.first.text == "true"),
      poids1: poids1Node.isEmpty ? "0" : (poids1Node.first.text),
      cartonPeseur: cartonPeseur.isEmpty ? "0" : (cartonPeseur.first.text),
    );
  }
}
