import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruggerifrontend/home/home.dart';
import 'package:ruggerifrontend/theme/theme.dart';

class Login extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.70,
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius:
                BorderRadius.circular(20.0), // Adjust the radius as needed
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.350,
                //height: MediaQuery.of(context).size.height * 0.65,
                decoration: const BoxDecoration(
                  //color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(20.0), // Adjust the radius as needed
                    bottomLeft:
                        Radius.circular(20.0), // Adjust the radius as needed
                  ),
                ),
                child: Stack(children: [
                  Center(
                    child: Image.asset(
                      'assets/images/backgroundlogin.png', // Adjust the path to your image
                      //width: 100, // Set your desired width
                      // Set your desired height

                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/LogoRuggeri.png', // Adjust the path to your image
                      width: MediaQuery.of(context).size.width *
                          0.1, // Set your desired width
                      // Set your desired height
                      //fit: BoxFit.cover,
                    ),
                  ),
                ]),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.350,
                height: MediaQuery.of(context).size.height * 0.90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight:
                        Radius.circular(20.0), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(20.0), // Adjust the radius as needed
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(widht * 0.05, height * 0.2, 0, 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seja bem vindo\nde volta!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 70, 10),
                          child: Center(
                            child: TextFormField(
                              maxLines: 1,
                              //controller: userController,
                              //maxLength: 200,

                              decoration: const InputDecoration(
                                labelText: "Usuário",
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                                fillColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                  // borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                  bottom: 10.0,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  //borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                              validator: (value) =>
                                  value == null ? "Vazio hein" : null,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 70, 20),
                          child: TextFormField(
                            maxLines: 1,
                            //controller: userController,
                            //maxLength: 200,
                            decoration: const InputDecoration(
                              labelText: "Senha",
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              fillColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                // borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                            //style: AppStyle.defaultFormFieldText,
                            validator: (value) =>
                                value == null ? "Vazio hein" : null,
                          ),
                        ),
                      ),
                      RememberMeCheckbox(),
                      Container(
                        padding: EdgeInsets.only(right: 50, top: 20),
                        width: 380,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B420C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => Home(),
                              transition: Transition.fade,
                              opaque:
                                  false, // Set to true if you want to hide the previous screen during the transition
                            );
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RememberMeCheckbox extends StatelessWidget {
  final RxBool rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => Checkbox(
              value: rememberMe.value,
              onChanged: (bool? value) {
                rememberMe.value = value ?? false;
              },
              checkColor: Colors.white,
              activeColor: Colors.grey.shade800,
              fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.grey.shade800; // Set your selected color
                } else {
                  return Colors.grey
                      .shade300; // Set to transparent for an outlined appearance
                }
              }),
              //fillColor: ,
            )),
        const Text(
          'Lembre de mim',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
