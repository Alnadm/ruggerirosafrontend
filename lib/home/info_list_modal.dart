import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/controller/info_list_controller.dart';

class InfoListModal extends StatelessWidget {
  final String token;
  final InfoListController controller = Get.put(InfoListController());

  InfoListModal({super.key, required this.token});

  Widget build(BuildContext context) {
    return Obx(
      () {
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
                      id: tokenGroup['id'],
                      token: tokenGroup['token'],
                      data: tokenGroup['data'],
                      hora: tokenGroup['hora'],
                      idNomeCond: tokenGroup['nomeCondominio'],
                      processo: tokenGroup['numeroProcesso'],
                      status: tokenGroup['status'],
                      statusDescricao: tokenGroup['statusDescricao'],
                      idDraft: tokenGroup['draftId'],
                      parteAdversa: tokenGroup['parteAdversa'],
                      nomeSindico: tokenGroup['nomeSindico'],
                      emailSindico: tokenGroup['emailSindico'],
                      tipoDeAcao: tokenGroup['tipoDeAcao'],
                      tipoDeFase: tokenGroup['tipoDeFase'],
                      link: tokenGroup['link'],
                      advogadoResponsavel: tokenGroup['advogadoResponsavel'],
                      descricao: tokenGroup['descricao'],
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
  final int id;
  final String token;
  final String data;
  final String hora;
  final String idNomeCond;
  final String processo;
  final String status;
  final String statusDescricao;
  final String idDraft;
  final String parteAdversa;
  final String nomeSindico;
  final String emailSindico;
  final String tipoDeAcao;
  final String tipoDeFase;
  final String link;
  final String advogadoResponsavel;
  final String descricao;
  final int quantidadeArquivos;
  final int falhas;

  const InfoCardModal(
      {required this.id,
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
      required this.nomeSindico,
      required this.emailSindico,
      required this.tipoDeAcao,
      required this.tipoDeFase,
      required this.link,
      required this.advogadoResponsavel,
      required this.descricao,
      required this.parteAdversa});

  @override
  _InfoCardModalState createState() => _InfoCardModalState();
}

class _InfoCardModalState extends State<InfoCardModal>
    with TickerProviderStateMixin {
  bool isHovered = false;
  bool isExpanded = false;
  late AnimationController _colorAnimationController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

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
        setState(() {
          isExpanded = !isExpanded; // Toggle expansion state
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
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Sindico"),
                                    Text(
                                      widget.nomeSindico,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email Sindico"),
                                    Text(
                                      widget.emailSindico,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Parte Adversa"),
                                    Text(
                                      widget.parteAdversa,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tipo"),
                                    Text(
                                      widget.link,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Descrição"),
                                    Text(
                                      widget.descricao,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 30.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Fase"),
                                    Text(
                                      widget.tipoDeFase,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (widget.status == "ERRO")
                              Column(
                                children: [
                                  SizedBox(height: 30),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("E-mail para envio"),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller: emailController,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors
                                                      .black), // Adjust input text size
                                              decoration: InputDecoration(
                                                  isDense:
                                                      true, // Reduce vertical height
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 12.0),
                                                  border: OutlineInputBorder(),
                                                  hintText:
                                                      'Digite o e-mail do síndico',
                                                  hintStyle: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black),
                                                  fillColor: Colors
                                                      .white // Adjust hint text size
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Nome do Sindico"),
                                            SizedBox(height: 5),
                                            TextFormField(
                                              controller: nameController,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors
                                                      .black), // Adjust input text size
                                              decoration: InputDecoration(
                                                  isDense:
                                                      true, // Reduce vertical height
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 12.0),
                                                  border: OutlineInputBorder(),
                                                  hintText:
                                                      'Digite o nome do síndico',
                                                  hintStyle: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black),
                                                  fillColor: Colors
                                                      .white // Adjust hint text size
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 22),
                                          ElevatedButton(
                                            onPressed: _submitData,
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.black, // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            child: Text(
                                              'Enviar',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                          ],
                        ),
                      )
                    : SizedBox(), // Empty widget when not expanded
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || name.isEmpty) {
      Get.snackbar('Erro', 'Por favor, preencha todos os campos.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Erro', 'Por favor, insira um e-mail válido.');
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            'Fazendo o Upload...',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          children: const [
            SizedBox(height: 20),
            Center(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );

    // Call the controller method to send data
    final controller = Get.find<InfoListController>();
    int statusCode;

    try {
      statusCode = await controller.updateAndSendMail(
        email: email,
        name: name,
        token: widget.token,
        comunicadoId: widget.id,
      );
    } catch (e) {
      // Handle exception if needed
      statusCode = 0; // Assign a default value in case of error
    }

    // Close the loading dialog
    Navigator.pop(context);

    if (statusCode == 200) {
      await controller.fetchLatestData();
    }
    // Show success or failure dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            statusCode == 200
                ? 'Email enviado com sucesso.'
                : 'Falha ao enviar os dados.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          children: [
            SizedBox(height: 20),
            Center(
              child: statusCode == 200
                  ? SuccessAnimation() // Display success animation
                  : FailureAnimation(), // Display failure animation
            ),
            SizedBox(height: 20),
            // Optional: Add an OK button to close the dialog
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class SuccessAnimation extends StatefulWidget {
  @override
  _SuccessAnimationState createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 80,
      ),
    );
  }
}

class FailureAnimation extends StatefulWidget {
  @override
  _FailureAnimationState createState() => _FailureAnimationState();
}

class _FailureAnimationState extends State<FailureAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticIn);
    _colorAnimation = ColorTween(begin: Colors.redAccent, end: Colors.red)
        .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Icon(
        Icons.error,
        color: _colorAnimation.value,
        size: 80,
      ),
    );
  }
}
