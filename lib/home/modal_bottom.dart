import 'package:flutter/material.dart';

class BottomModal extends StatefulWidget {
  final Widget content;

  const BottomModal({Key? key, required this.content}) : super(key: key);

  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  bool isModalOpen = false;

  void toggleModal() {
    setState(() {
      isModalOpen = !isModalOpen;
    });
  }

  void openModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const BottomModal(
            content: Text(
          'This is the modal content',
          style: TextStyle(fontSize: 24.0),
        ));
      },
      constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.95),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Your main content goes here

        // Modal
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
                  icon: Icon(Icons.close),
                  onPressed: toggleModal,
                ),
              ),

              // Content of the modal
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: widget.content,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
