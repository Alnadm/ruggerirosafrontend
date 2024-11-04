import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/controller/info_list_controller.dart';

import 'package:ruggerifrontend/home/info_list_modal.dart';

class BottomModalController extends GetxController {
  PersistentBottomSheetController? _bottomSheetController;
  final InfoListController controller = Get.put(InfoListController());

  Future<void> atualizaLista() async {
    await controller.fetchAllComunicados();
  }

  Future<void> controlaModal(BuildContext context, String token) async {
    _bottomSheetController = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomModal(
          token: token,
          content: Text(
            token,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        );
      },
      constraints: BoxConstraints.expand(
        width: MediaQuery.of(context).size.width * 0.80,
        height: MediaQuery.of(context).size.height * 0.95,
      ),
    );
  }

  void closeBottomSheet() {
    if (_bottomSheetController != null) {
      print("Chamou closeBottomSheet");
      _bottomSheetController!.close();
    }
  }
}

class BottomModal extends StatefulWidget {
  final Widget content;
  final String token;

  const BottomModal({
    Key? key,
    required this.content,
    required this.token,
  }) : super(key: key);

  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: MediaQuery.of(context).size.height * 0.95,
          //width: MediaQuery.of(context).size.width * 0.80,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withOpacity(0.4),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    BottomModalController().atualizaLista();
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // Content of the modal
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lote",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      widget.content,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: InfoListModal(token: widget.token),
        ),
      ],
    );
  }
}
