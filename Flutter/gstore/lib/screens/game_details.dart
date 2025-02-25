import 'package:flutter/material.dart';

import '../data/game.dart';
import '../utils/conts.dart';
import '../widgets/button.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class GameDetailsScreen extends StatefulWidget {
  const GameDetailsScreen(this.gameDetails, {super.key});

  final Game gameDetails;

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  int gameQte = 0;

  @override
  void initState() {
    gameQte = widget.gameDetails.qte;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.gameDetails.title),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Image.asset(widget.gameDetails.imagePath,
                  height: 300, width: double.maxFinite),
              Text(
                widget.gameDetails.description,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    Text(
                      "${widget.gameDetails.price} DT",
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      gameQte > 0 ? "Examplaires: $gameQte" : "Hors stock",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.shopping_cart),
                          Text("Acheter"),
                        ],
                      ),
                      onPress: () {
                        setState(() {
                          gameQte--;
                        });
                      }),
                  Button(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.app_registration),
                        Text("S'inscrire"),
                      ],
                    ),
                    onPress: () => Navigator.pushNamed(context, signUpRoute),
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            http.get(Uri.http(baseUrl, "/game")).then((http.Response resp) {
              int count = int.parse(json.decode(resp.body)["count"]);
              if (count != 0) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Achat"),
                          content: const Text("Vous avez déjè acheter ce jeu!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            )
                          ],
                        ));
              } else {
                Navigator.pop(context);
              }
            });
          },
          label: const Text("Acheter"),
          icon: const Icon(Icons.shopping_cart),
        ));
  }
}
