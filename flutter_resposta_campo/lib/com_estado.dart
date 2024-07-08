import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_resposta_campo/dados.dart';
import 'package:flutter_resposta_campo/item.dart';

class ComEstado extends StatefulWidget {
  const ComEstado({super.key});

  @override
  State<ComEstado> createState() => _ComEstadoState();
}

class _ComEstadoState extends State<ComEstado> {
  final TextEditingController _controlador = TextEditingController();
  int atual = 0;

  Dados resultado = Dados();

  Future<String> carregaMapa() async {
    // https://65ed39a1-637e-4157-b2a6-71792c21959e-00-kia4m2vmkv45.kirk.replit.dev/?x=7

    final resposta = await (http.get(Uri.parse('https://65ed39a1-637e-4157-b2a6-71792c21959e-00-kia4m2vmkv45.kirk.replit.dev/?x=${atual}')));

    if(resposta.statusCode == 200) {
      return resposta.body;
    } else {
      print(resposta.statusCode);
      throw Exception('Resposta inválida');
    }
  }

  Future<Item> buscaMapa() async {
    String mapaCarregado = await carregaMapa();
    final mapaDecodificado = jsonDecode(mapaCarregado);
    Item elemento = Item.fromJson(mapaDecodificado);
    return elemento;
  }

  late Future<Item> elemento;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    elemento = buscaMapa();
    _controlador.text = '$atual';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {
                      setState(() {
                      atual = int.parse(_controlador.text) - 1;
                      elemento = buscaMapa();
                      _controlador.text = '${atual}';
                      }); 
                    }, icon: const Icon(Icons.arrow_downward),),
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _controlador,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {
                      setState(() {
                        atual = int.parse(_controlador.text) + 1;
                        elemento = buscaMapa();
                        _controlador.text = '${atual}';
                      });
                    }, icon: const Icon(Icons.arrow_upward),),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: elemento,
                    builder: (context, registro) {
                      if (registro.hasData) {
                        return Text(
                          'Resposta: ${registro.data!.x}',
                          style: const TextStyle(fontSize: 32),
                        );
                      } else if(registro.hasError) {
                        return Text(
                          'Erro: ${registro.error}',
                          style: const TextStyle(fontSize: 32),
                        );
                      }
                      return const CircularProgressIndicator();
                    }),
              ],
            )),
      ),
    );
    ;
  }
}
