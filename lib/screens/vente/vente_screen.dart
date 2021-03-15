import 'package:fish_scan/constants/strings.dart';
import 'package:fish_scan/gen/assets.gen.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/screens/vente/vente_controller.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/input_text.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VenteScreen extends StatefulWidget {
  final Article article;

  const VenteScreen({Key key, this.article}) : super(key: key);

  @override
  _VenteScreenState createState() => _VenteScreenState();
}

class _VenteScreenState extends State<VenteScreen> {
  final controller = Get.put(VenteController());
  Article article;
  TextEditingController lotCtrl = TextEditingController();
  TextEditingController poidsCtrl = TextEditingController();

  @override
  void initState() {
    article = widget.article;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.setArticle(article);
      _getPesees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDeletePeseeConfirmation();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(article.description),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              showDeletePeseeConfirmation();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<VenteController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Poids demandé: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.poidsDemandes} Kg",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<VenteController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Poids effectif: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.poidsTotal} Kg",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<VenteController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cartons demandés: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.nombreCartonsDemandes}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<VenteController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Cartons effectifs: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.nombreCartons}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              VSpacer.normal,
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (controller.clearFields) {
                        lotCtrl.text = "";
                      }

                      if (controller.barCode.isNotEmpty) {
                        lotCtrl.text = controller.barCode;
                      }

                      return InputText(
                          hint: controller.isPoidsUnique
                              ? "Nombre de cartons"
                              : "N° Lot",
                          inputType: controller.isPoidsUnique
                              ? TextInputType.numberWithOptions()
                              : null,
                          controller: lotCtrl);
                    }),
                  ),
                  HSpacer.normal,
                  GestureDetector(
                    onTap: () {
                      if (lotCtrl.text.isEmpty) {
                        showInfoDialog(context,
                            message: "Le lot est obligatoire");
                        return;
                      }

                      if (controller.isPoidsUnique) {
                        if (poidsCtrl.text.isEmpty ||
                            double.parse(poidsCtrl.text) <= 0) {
                          showInfoDialog(context,
                              message: "Le poids est obligatoire");
                          return;
                        }
                      }
                      searchArticle();
                    },
                    child: Icon(Icons.search),
                  ),
                  HSpacer.normal,
                  Obx(
                    () => Visibility(
                      visible: !controller.isPoidsUnique,
                      child: GestureDetector(
                        onTap: () => getBarCode(),
                        child:
                            Assets.images.barcode.image(width: 50, height: 50),
                      ),
                    ),
                  ),
                  HSpacer.normal,
                  GestureDetector(
                      onTap: () {
                        if (checkForm()) {
                          saveTracabilite();
                        }
                      },
                      child: Icon(Icons.add_circle_outlined,
                          color: Colors.blue, size: 35))
                ],
              ),
              VSpacer.normal,
              Obx(() {
                if (controller.clearFields) {
                  poidsCtrl.text = "";
                }

                if (controller.quantity.isNotEmpty) {
                  poidsCtrl.text = controller.quantity;
                }

                return InputText(
                  hint: "Poids",
                  controller: poidsCtrl,
                  inputType: TextInputType.number,
                  enabled: controller.isPoidsUnique ? true : false,
                );
              }),
              VSpacer.normal,
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.isPoidsUnique,
                      onChanged: (value) => controller.updatePoidsUnique(value),
                    ),
                  ),
                  Text('Poids unique'),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () => showConfirmationVider(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Vider',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              VSpacer.normal,
              Expanded(
                child: GetBuilder<VenteController>(
                  init: controller,
                  builder: (c) {
                    if (c.pesees.isEmpty) {
                      return Center(
                        child: Text('Aucune pesée'),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: c.pesees.length,
                              itemBuilder: (context, index) {
                                var pesee = c.pesees[index];
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${index + 1}"),
                                        HSpacer.normal,
                                        Expanded(
                                            child: Text(
                                                'Lot : ${pesee.lotNoa46}\nPoids : ${pesee.quantity} kg')),
                                        GestureDetector(
                                            onTap: () => c
                                                .deletePeseeToDatabase([pesee]),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                    VSpacer.normal,
                                    Divider(
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    VSpacer.large,
                                  ],
                                );
                              }),
                        ),
                        VSpacer.normal,
                        Button(
                          "Enregister",
                          onPressed: () => showInfoDialog(
                            context,
                            message:
                                "Etes-vous sur de vouloir valider le(s) pesée(s) ?",
                            positiveLabel: "OUI",
                            positiveAction: () => submitPesee(),
                            negativeLabel: "NON",
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDeletePeseeConfirmation() {
    if (controller.pesees.isNotEmpty) {
      showInfoDialog(context,
          message:
              "Vos données ne sont pas enregistrées !\nVoulez-vous continuer ?",
          negativeLabel: "NON",
          positiveLabel: "OUI",
          positiveAction: () => _deleteLocalPesees());
      return;
    }
    Get.back();
  }

  getBarCode() async {
    bool isScanned = await controller.getBarCode();
    if (isScanned) searchArticle();
  }

  submitPesee() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");

    var response = await controller.submitPesee();

    Get.back();

    showInfoDialog(context, message: response.message);
  }

  bool checkForm() {
    if (lotCtrl.text.isEmpty) {
      showInfoDialog(context, message: "Le lot est obligatoire");
      return false;
    }

    if (poidsCtrl.text.isEmpty) {
      showInfoDialog(context, message: "Le poids est obligatoire");
      return false;
    }

    if (double.parse(poidsCtrl.text) <= 0) {
      showInfoDialog(context, message: "Le poids doit être positif");
      return false;
    }

    return true;
  }

  void saveTracabilite({List<Article> articles}) async {
    bool isSaved = true;

    if (articles == null) {
      isSaved = await controller.savePeseeToDatabase(
        lot: lotCtrl.text.trim(),
        quantity: poidsCtrl.text.trim(),
      );
    } else {
      for (int i = 0; i < articles.length; i++) {
        await controller.savePeseeToDatabase(
          lot: articles[i].no,
          quantity: poidsCtrl.text.trim(),
        );
      }
    }

    if (!isSaved) {
      showInfoDialog(context, message: Strings.LOT_ENREGISTRE);
      return;
    }

    //_loadBarCodeScreen();
  }

  searchArticle() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");

    Future.delayed(Duration(seconds: 1), () async {
      var response = await controller.searchArticle(
          lot: lotCtrl.text.trim(), quantity: poidsCtrl.text);

      Get.back();
      if (response.hasError) {
        showInfoDialog(context, message: response.message, positiveLabel: "OK",
            positiveAction: () {
          controller.resetFields();
          if (controller.isPoidsUnique) {
            if (response.items != null && response.items.isNotEmpty) {
              saveTracabilite(
                articles: response.items,
              );
            }
          }
        });
        return;
      }

      Future.delayed(
        Duration(seconds: 1),
        () => saveTracabilite(
          articles: controller.isPoidsUnique ? response.items : null,
        ),
      );
    });
  }

  _getPesees() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    var response = await controller.getPesees();
    Get.back();
    //_loadBarCodeScreen();
  }

  _deleteLocalPesees() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    await controller.deleteAllPesees();
    Get.back();
    Get.back();
  }

  void _loadBarCodeScreen() {
    Future.delayed(Duration(milliseconds: 500), () => getBarCode());
  }

  showConfirmationVider() {
    showInfoDialog(context,
        message:
            "Vous allez vider toutes les pesées !\nVoulez vous continuer ?",
        positiveLabel: "OUI",
        negativeLabel: "NON",
        positiveAction: () => _deleteRemotePesees());
  }

  _deleteRemotePesees() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    var response = await controller.deleteRemotePesee();
    if (!response.hasError) {
      Get.back();
      await _deleteLocalPesees();
      return;
    }
    showInfoDialog(context, message: response.message ?? "");
  }
}
