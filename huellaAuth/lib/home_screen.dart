import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auntentificador con huella dactilar"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_supportState)
              const Text("este dispositivo es compatible")
            else
              const Text("este dispositivo no es compatible"),
            const Divider(
              height: 100,
            ),
            ElevatedButton(
                onPressed: _authenticated, child: const Text("Autentificador"))
          ]),
    );
  }

  Future<void> _authenticated() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "Ingrese su huella dactilar",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      print("Autentificados: $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print("Lista de datos biométricos disponibles : $availableBiometrics");

    if (!mounted) {
      return;
    }
  }
}
