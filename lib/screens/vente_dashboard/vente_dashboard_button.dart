import 'package:fish_scan/screens/vente_dashboard/vente_dashboard_controller.dart';
import 'package:fish_scan/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenteDashboardButton extends StatefulWidget {
  final Function onPressed;
  final String text;
  final int codeTraitement;

  const VenteDashboardButton(
      {Key key, this.onPressed, this.text, this.codeTraitement})
      : super(key: key);

  @override
  _VenteDashboardButtonState createState() => _VenteDashboardButtonState();
}

class _VenteDashboardButtonState extends State<VenteDashboardButton> {
  VenteDashboardController controller = VenteDashboardController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getNombreCommandes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Button(
        widget.text,
        color: Colors.white,
        textColor: Colors.black,
        onPressed: widget.onPressed,
        suffix: controller.isLoading
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  controller.nombre.toString(),
                  style: TextStyle(color: Colors.white),
                )),
      );
    });
  }

  void _getNombreCommandes() async {
    controller.getNombreCommandeParTraitement(widget.codeTraitement);
  }
}
