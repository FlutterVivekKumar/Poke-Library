import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pokemon_library/extra/colors.dart';
import 'package:pokemon_library/extra/extra_functions.dart';
import 'package:pokemon_library/screens/details_screen/pokemon_details.dart';
import 'package:pokemon_library/screens/home_screen/home_screen.dart';

import '../../models/pokemon_details_model.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeFocus(context: context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            stackBackground(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: Adaptive.h(20),
                    ),
                    verticalSpace(spaceValue: .5),
                    RichText(
                      text: TextSpan(
                          text: 'Poké',
                          style: TextStyle(
                              wordSpacing: 1,
                              letterSpacing: .5,
                              fontSize: Adaptive.sp(
                                48,
                              ),
                              fontFamily: 'Sofia Sans Condensed Regular',
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                          children: [
                            TextSpan(
                              text: ' Library',
                              style: TextStyle(
                                  fontSize: Adaptive.sp(
                                    47,
                                  ),
                                  fontFamily: 'Sofia Sans Condensed Regular',
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      child: Text(
                        mainScreenTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: Adaptive.sp(
                              18,
                            ),
                            fontFamily: 'Sofia Sans Condensed Regular',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    verticalSpace(spaceValue: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        controller: _controller,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) async {
                          showLoadingDialogBox(context: context);
                          if (value.length >= 3) {
                            await returnSearchPokemonDetails(pokemonName: value)
                                .then((pokemon) {
                                  Navigator.pop(context);
                              if (pokemon != 'Not Found') {
                                final pokemonDetails =
                                    PokemonModel.fromJson(jsonDecode(pokemon));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetailsScreen(
                                        pokemonModel: pokemonDetails,
                                        imageUrl:
                                            'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/${pokemonDetails.id}.svg'),
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg:
                                        'Unable to find $value pokemon in the database');
                              }
                            }).onError((error, stackTrace) async {
                              Fluttertoast.showToast(msg: error.toString());
                              return null;
                            });
                          }
                        },
                        style: TextStyle(
                          fontSize: Adaptive.sp(
                            20,
                          ),
                          fontFamily: 'Sofia Sans Condensed Regular',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            hintText: '   Enter pokemon name',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5),
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5),
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 5),
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor, width: 15),
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(18),
                            hintStyle: hintStyle(),
                            suffixIcon: InkWell(
                              onTap: () async {
                                String value = _controller.text;
                                showLoadingDialogBox(context: context);
                                if (value.length >= 3) {
                                  await returnSearchPokemonDetails(pokemonName: value)
                                      .then((pokemon) {
                                    Navigator.pop(context);
                                    if (pokemon != 'Not Found') {
                                      final pokemonDetails =
                                      PokemonModel.fromJson(jsonDecode(pokemon));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PokemonDetailsScreen(
                                              pokemonModel: pokemonDetails,
                                              imageUrl:
                                              'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/${pokemonDetails.id}.svg'),
                                        ),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg:
                                          'Unable to find $value pokemon in the database');
                                    }
                                  }).onError((error, stackTrace) async {
                                    Fluttertoast.showToast(msg: error.toString());
                                    return null;
                                  });
                                }
                              },
                              child: Container(
                                width: Adaptive.w(8),
                                height: Adaptive.w(8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
                                child: const Center(
                                    child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                )),
                              ),
                            )),
                      ),
                    ),
                    verticalSpace(spaceValue: 2),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                            fontSize: Adaptive.sp(
                              16,
                            ),
                            decoration: TextDecoration.underline,
                            fontFamily: 'Sofia Sans Condensed Regular',
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                    verticalSpace(spaceValue: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
