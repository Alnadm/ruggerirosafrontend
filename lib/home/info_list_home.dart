import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ruggerifrontend/home/info_card.dart';
import 'package:ruggerifrontend/home/modal_bottom.dart';

class InfoListHome extends StatelessWidget {
  final InfoListController controller = Get.put(InfoListController());
  ScrollController _scrollController = ScrollController();

  Widget build(BuildContext context) {
    return Obx(
      () {
        print('InfoListHome rebuilt');
        print("ListTokens Length: ${controller.listTokens.length}");

        if (controller.listTokens.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(300, 200, 50, 0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          width: MediaQuery.of(context).size.width * 0.38,
          height: MediaQuery.of(context).size.height * 0.38,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !controller.isFetching.value) {
                // User reached the bottom of the list
                controller.fetchAllComunicados(); // Fetch next page
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: List.generate(controller.listTokens.length, (index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(30, 8, 10, 5),
                    child: InfoCardHome(
                      data: controller.listTokens[index].first['dataInsercao'],
                      token: controller.listTokens[index].first['token'],
                      quantidadeArquivos: controller.comunicadosPorLote(
                          controller.listTokens[index].first['token']),
                      falhas: controller.comunicadosPorLoteComErro(
                          controller.listTokens[index].first['token']),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InfoCardHome extends StatefulWidget {
  final String data;
  final String token;
  final int quantidadeArquivos;
  final int falhas;

  const InfoCardHome({
    required this.data,
    required this.token,
    required this.quantidadeArquivos,
    required this.falhas,
  });

  @override
  _InfoCardHomeState createState() => _InfoCardHomeState();
}

class _InfoCardHomeState extends State<InfoCardHome>
    with TickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _colorAnimationController;
  final InfoListController controller = Get.put(InfoListController());
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
      onTap: () {
        // Handle onTap if needed
        controller.getListForToken(widget.token);
        BottomModalController().controlaModal(context, widget.token);
      },
      child: Card(
        elevation: 0,
        //shadowColor: Colors.transparent,
        //surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: ColorTween(
                        begin: Theme.of(context).cardTheme.color,
                        end: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.3))
                    .animate(_colorAnimationController)
                    .value,
              ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Arquivos no Lote:"),
                      Text(
                        '${widget.quantidadeArquivos}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Falhas"),
                      Text(
                        '${widget.falhas}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
