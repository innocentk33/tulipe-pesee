import 'package:fish_scan/constants/strings.dart';
import 'package:fish_scan/gen/assets.gen.dart';
import 'package:fish_scan/models/CommandItem.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/screens/home/home_controller.dart';
import 'package:fish_scan/screens/vente/vente_controller.dart';
import 'package:fish_scan/screens/vente/vente_pesee_manuelle_controller.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:fish_scan/widgets/dialogs.dart';
import 'package:fish_scan/widgets/input_text.dart';
import 'package:fish_scan/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VentePeseeManuelleScreen extends StatefulWidget {
  final Article article;

  const VentePeseeManuelleScreen({Key key, this.article}) : super(key: key);

  @override
  _VentePeseeManuelleScreenState createState() =>
      _VentePeseeManuelleScreenState();
}

class _VentePeseeManuelleScreenState extends State<VentePeseeManuelleScreen> {
  final controller = Get.put(VentePeseeManuelleController());
  Article article;
  TextEditingController lotCtrl = TextEditingController();
  TextEditingController poidsCtrl = TextEditingController();
  double poidsMarchandise = 0;
  int nbrCartons=0;
  List<CommandItem> listCarton = [];

  int myIndex = 0;


  @override
  void initState() {
    lotCtrl.text = "1";

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
                    child: GetBuilder<VentePeseeManuelleController>(
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
                                  color: Colors.green)),

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<VentePeseeManuelleController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Poids total: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.poidsTotal.toStringAsFixed(3)} Kg",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<VentePeseeManuelleController>(
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
                    child: GetBuilder<VentePeseeManuelleController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Cartons: ",
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
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<VentePeseeManuelleController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Budget demandé: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.budget}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<VentePeseeManuelleController>(
                      init: controller,
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Montant : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text("${c.montant}",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Expanded(
                      child: Obx(() {
                        if (controller.clearFields) {
                          lotCtrl.text = "1";
                        }

                        return InputText(

                            hint: "Nbr de cartons",
                            inputType: TextInputType.number,

                            controller: lotCtrl);
                      }),
                    ),
                  ),     Expanded(
                    child:
                    Obx(() {
                      if (controller.clearFields) {
                        poidsCtrl.text = "";
                      }

                      return InputText(
                        hint: "Poids",
                        controller: poidsCtrl,
                        inputType: TextInputType.number,
                      );
                    }),
                  ),
                  HSpacer.normal,
                  GestureDetector(
                      onTap: () {
                        if (checkForm()) {
                          saveTracabilite();
                          /*var item = new CommandItem();
                          item.index = ${index + 1};
                          item.nbre = nbrCartons;
                          item.poids = nbrCartons * poidsMarchandise + 1;
                          listCarton.add(item);*/
                        }
                      },
                      child: Icon(Icons.add_circle_outlined,
                          color: Colors.blue, size: 35))
                ],
              ),
              VSpacer.normal,
                /*              Obx(() {
                if (controller.clearFields) {
                  poidsCtrl.text = "";
                }

                return InputText(
                  hint: "Poids",
                  controller: poidsCtrl,
                  inputType: TextInputType.number,
                );
              }),*/
              VSpacer.normal,
              Row(
                children: [
                  GestureDetector(
                    onTap: () => showConfirmationVider(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Vider vente',
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
                child: GetBuilder<VentePeseeManuelleController>(
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
                                nbrCartons = int.parse(pesee.lotNoa46);
                                poidsMarchandise= double.parse(pesee.quantity);
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
                                                'Nombre : ${nbrCartons}\nPoids : ${poidsMarchandise} kg')),
                                        Text("${(nbrCartons*poidsMarchandise)} kg" ,style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                        ),),
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
                          "Enregistrer",
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
              ),

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

  void  saveTracabilite({List<Article> articles} ) async {
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
    //controller.deleteRemotePesee();
    controller.suprimerLesPesees(article);
    Get.back();
    await _deleteLocalPesees();
  }
}
