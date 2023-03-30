import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider_one.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => ProviderOne(),
        child: const MyHomePage(),
      ),
    );
  }
}

final GlobalKey<FormState> _formKey = GlobalKey();

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderOne>(
      builder: (_, state, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Calculo IMC'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset('assets/images/perfil.jpg'),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Digite suas medidas para\n calcular o IMC',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              width: 150,
                              child: TextFormField(
                                controller: state.pesoController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Peso em kg',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim() == '') {
                                    return 'Peso Vazio';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              width: 150,
                              child: TextFormField(
                                controller: state.alturaController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Altura em Metros',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim() == '') {
                                    return 'Altura Vazia';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          final state =
                              Provider.of<ProviderOne>(context, listen: false);
                          if (_formKey.currentState!.validate()) {
                            final peso =
                                double.parse(state.pesoController.text);
                            final altura =
                                double.parse(state.alturaController.text);

                            final imc = peso / (altura * altura);

                            state.imc = imc;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                  value: state,
                                  child: const Resultado(),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Calcular'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Resultado extends StatelessWidget {
  const Resultado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ProviderOne>(context);
    String? massa;
    String? asset;
    final imcFormatado = state.imc!.toStringAsFixed(2);

    if (state.imc! <= 18.5) {
      massa = ("SEU IMC É $imcFormatado/Kg.\n ABAIXO DO PESO");
      asset = ('assets/images/abaixopeso.png');
    } else if (state.imc! >= 18.5 && state.imc! <= 24.9) {
      massa = ("SEU IMC É $imcFormatado/Kg.\n PESO NORMAL");
      asset = ('assets/images/normal.png');
    } else if (state.imc! >= 25 && state.imc! <= 29.9) {
      massa = ("SEU IMC É $imcFormatado/Kg.\n SOBREPESO");
      asset = ('assets/images/sobrepeso.png');
    } else if (state.imc! >= 30 && state.imc! <= 34.9) {
      massa = ("SEU IMC É $imcFormatado/Kg.\n OBESIDADE GRAU 1");
      asset = ('assets/images/obesidade1.png');
    } else if (state.imc! >= 35 && state.imc! <= 39.9) {
      massa = ("SEU IMC É $imcFormatado/Kg.\n OBESIDADE GRAU 2");
      asset = ('assets/images/obesidade2.png');
    } else if (state.imc! >= 40) {
      massa = ("SEU IMC É $imcFormatado/Kg.\n OBESIDADE GRAU 3");
      asset = ('assets/images/obesidade3.png');
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Resultado'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
            width: 200,
            height: 500,
            child: Image.asset(asset ?? ''),
          ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  massa ?? 'ERRO!!',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
