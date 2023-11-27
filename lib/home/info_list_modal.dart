import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/home/info_card.dart';

class InfoListModal extends StatelessWidget {
  final String token;
  final InfoListController controller = Get.put(InfoListController());

  InfoListModal({super.key, required this.token});

  Widget build(BuildContext context) {
    return Obx(
      () {
        print('InfoListModal rebuilt');
        print("ListTokens Length: ${controller.listTokens.length}");
        if (controller.selectedTokenLote.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          width: MediaQuery.of(context).size.width * 0.78,
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var tokenGroup in controller.selectedTokenLote)
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                    child: InfoCardModal(
                      token: tokenGroup['token'],
                      data: tokenGroup['data'],
                      hora: tokenGroup['hora'],
                      idNomeCond: tokenGroup['nomeCondominio'],
                      processo: tokenGroup['numeroProcesso'],
                      status: tokenGroup['status'],
                      statusDescricao: tokenGroup['statusDescricao'],
                      idDraft: tokenGroup['draftId'],
                      quantidadeArquivos:
                          controller.comunicadosPorLote(tokenGroup['token']),
                      falhas: controller
                          .comunicadosPorLoteComErro(tokenGroup['token']),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class InfoCardModal extends StatefulWidget {
  final String token;
  final String data;
  final String hora;
  final String idNomeCond;
  final String processo;
  final String status;
  final String statusDescricao;
  final String idDraft;
  final int quantidadeArquivos;
  final int falhas;

  const InfoCardModal({
    required this.token,
    required this.data,
    required this.hora,
    required this.idNomeCond,
    required this.processo,
    required this.status,
    required this.statusDescricao,
    required this.idDraft,
    required this.quantidadeArquivos,
    required this.falhas,
  });

  @override
  _InfoCardModalState createState() => _InfoCardModalState();
}

class _InfoCardModalState extends State<InfoCardModal>
    with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _colorAnimationController;

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovering) {
        setState(() {
          isHovered = hovering;
          if (isHovered) {
            _colorAnimationController.forward();
          } else {
            _colorAnimationController.reverse();
          }
        });
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          color: widget.status == "ERRO"
              ? Theme.of(context).errorColor
              : Theme.of(context).cardTheme.color,
          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Data"),
                  Text(
                    widget.data,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(width: 30.0),
              if (widget.status != "ERRO")
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Condominio"),
                      Text(
                        widget.idNomeCond,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Processo"),
                  Text(
                    widget.processo,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(width: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email"),
                  Text(
                    widget.idDraft,
                  ),
                ],
              ),
              SizedBox(width: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status"),
                  if (widget.status == "ERRO")
                    Text(
                      latin1.decode(latin1.encode(widget.statusDescricao)),
                    )
                  else
                    Text(
                      widget.status,
                    ),
                ],
              ),
              SizedBox(width: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
