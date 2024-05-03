import 'package:conversor_de_moedas/repositories/counter_repository.dart';
import 'package:flutter/material.dart';
import '../widgets/text_field_item.dart';
import 'package:conversor_de_moedas/theme/pallete.dart';


class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final CounterRepository counterRepository = CounterRepository();
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double? dolar;
  double? euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        


        title: const Text(
          'Conversor de moedas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          
          ),
        ),


        backgroundColor: Pallete.secondaryColor,
        leading: Image.asset(
          'assets/img/logo.png',
        ),

        centerTitle: true,
        
      ),
      body: FutureBuilder<Map>(
        future: counterRepository.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Carregando dados...',
                  style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontSize: 25,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Erro ao carregar dados :(',
                    style: TextStyle(
                      color:  Pallete.secondaryColor,
                      fontSize: 25,
                    ),
                  ),
                );
              } else {
                dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                euro = snapshot.data!['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 145,
                        color: Pallete.secondaryColor,
                      ),
                      const Divider(),
                      TextFieldItem(
                        label: 'Reais',
                        prefix: 'R\$ ',
                        controller: realController,
                        onChanged: _realChanged,
                      ),
                      const Divider(),
                      TextFieldItem(
                        label: 'Dólares',
                        prefix: 'US\$ ',
                        controller: dolarController,
                        onChanged: _dolarChanged,
                      ),
                      const Divider(),
                      TextFieldItem(
                        label: 'Euros',
                        prefix: '€ ',
                        controller: euroController,
                        onChanged: _euroChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  void _clearAll() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar! / euro!).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = (euro * this.euro! / dolar!).toStringAsFixed(2);
  }
}