import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/constants/strings.dart';
import 'package:fish_scan/gen/assets.gen.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/screens/depotage/depotage_controller.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/input_text.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DepotageScreen extends StatefulWidget {
  final Article article;
  final NavigationMenu menu;

  const DepotageScreen({Key key, this.article, this.menu}) : super(key: key);

  @override
  _DepotageScreenState createState() => _DepotageScreenState();
}

class _DepotageScreenState extends State<DepotageScreen> {
  final controller = Get.put(DepotageController());
  Article article;
  TextEditingController lotCtrl = TextEditingController();
  TextEditingController poidsCtrl = TextEditingController();
  TextEditingController paletteCtrl = TextEditingController();

  @override
  void initState() {
    article = widget.article;
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      controller.setArticle(article);
      controller.setMenu(widget.menu);
      _getTracabilites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDeleteTracabiliteConfirmation();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text(article.description),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                showDeleteTracabiliteConfirmation();
              },
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<DepotageController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                  Expanded(
                    child: GetBuilder<DepotageController>(
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
                  HSpacer.large,
                  GestureDetector(
                      onTap: () {
                        if (checkForm()) {
                          saveTracabilite();
                        }
                      },
                      child: Icon(
                        Icons.add_circle,
                        size: 30,
                        color: Colors.blue,
                      ))
                ],
              ),
              VSpacer.normal,
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Obx(() {
                      if (controller.clearFields) {
                        poidsCtrl.text = "";
                      }
                      return InputText(
                        hint: "Poids (Kg)",
                        controller: poidsCtrl,
                        inputType: TextInputType.number,
                      );
                    }),
                  ),
                  HSpacer.small,
                  Expanded(
                    child: InputText(
                      hint: "NP",
                      controller: paletteCtrl,
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
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
                  HSpacer.large,
                  GestureDetector(
                    onTap: () => _getUserCartonsInfo(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              VSpacer.normal,
              Expanded(
                child: GetBuilder<DepotageController>(
                  init: controller,
                  builder: (c) {
                    if (c.tracabilites.isEmpty) {
                      return Center(
                        child: Text('Aucune tracabilité'),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: c.tracabilites.length,
                              itemBuilder: (context, index) {
                                var tracabilite = c.tracabilites[index];
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
                                                'Lot : ${tracabilite.lotNoa46}\nPoids : ${tracabilite.quantity} kg\nPalette: ${tracabilite.numPalette}')),
                                        GestureDetector(
                                            onTap: () => c
                                                .deleteTracabiliteToDatabase(
                                                    [tracabilite]),
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
                          "Valider",
                          onPressed: () => showInfoDialog(
                            context,
                            message:
                                "Etes-vous sur de vouloir valider le(s) traçabilité(s) ?",
                            positiveLabel: "OUI",
                            positiveAction: () => submitTracabilite(),
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

  submitTracabilite() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");

    var response = await controller.submitTracabilite(widget.menu);

    Get.back();

    showInfoDialog(context, message: response.message);
  }

  bool checkForm() {
    if (lotCtrl.text.isEmpty) {
      showInfoDialog(context,
          message:
              "Le ${controller.isPoidsUnique ? 'nombre de cartons' : 'lot'} est obligatoire");
      return false;
    }

    if (controller.isPoidsUnique) {
      if (int.parse(lotCtrl.text) <= 0) {
        showInfoDialog(context,
            message: "Le nombre de carton doit être positif");
        return false;
      }
    }
    if (poidsCtrl.text.isEmpty) {
      showInfoDialog(context, message: "Le poids est obligatoire");
      return false;
    }

    if (double.parse(poidsCtrl.text) <= 0) {
      showInfoDialog(context, message: "Le poids doit être positif");
      return false;
    }

    if (paletteCtrl.text.isEmpty) {
      showInfoDialog(context, message: "Le numéro de palette est obligatoire");
      return false;
    }

    return true;
  }

  void saveTracabilite() async {
    if (controller.isPoidsUnique) {
      await controller.saveTracabilites(
          number: int.parse(lotCtrl.text.trim()),
          palette: paletteCtrl.text,
          quantity: poidsCtrl.text);
    } else {
      bool isSaved = await controller.saveTracabilite(
          lot: lotCtrl.text.trim(),
          quantity: poidsCtrl.text.trim(),
          palette: paletteCtrl.text.trim());
      if (!isSaved) {
        showInfoDialog(context, message: Strings.LOT_ENREGISTRE);
        return;
      }
    }
    //_loadBarCodeScreen();
  }

  void _getTracabilites() async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    var response = await controller.getTracabilites();
    Get.back();
    //_loadBarCodeScreen();
  }

  void showDeleteTracabiliteConfirmation() {
    if (controller.tracabilites.isNotEmpty) {
      showInfoDialog(context,
          message:
              "Vos données ne sont pas enregistrées !\nVoulez-vous continuer ?",
          negativeLabel: "NON",
          positiveLabel: "OUI",
          positiveAction: () => _deleteTracabilites());
      return;
    }
    Get.back();
  }

  _deleteTracabilites({bool fromVider = false}) async {
    showLoadingDialog(context, message: "Veuillez patienter ...");
    await controller.deleAllTracabilites();
    Get.back();
    if (!fromVider) Get.back();
  }

  getBarCode() async {
    await controller.getBarCode();
  }

  void _loadBarCodeScreen() {
    Future.delayed(Duration(milliseconds: 500), () => getBarCode());
  }

  showConfirmationVider() {
    showInfoDialog(context,
        message:
            "Vous allez vider toutes les traçabilités !\nVoulez vous continuer ?",
        positiveLabel: "OUI",
        negativeLabel: "NON",
        positiveAction: () => _deleteTracabilites(fromVider: true));
  }

  _getUserCartonsInfo() async {
    showLoadingDialog(context, message: "Veuillez patienter...");
    var response =
        await controller.getNombreColisPeseur(champs: 0, sourceType: "39");
    Get.back();
    if (!response.hasError) {
      showInfoDialog(context,
          message: "Nombre de cartons envoyés : ${response.body}");
    }
  }
}
