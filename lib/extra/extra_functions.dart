import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokemon_library/extra/colors.dart';
import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_library/models/pokemon_details_model.dart';
import 'package:xml/xml.dart';
/*----------------Constants----------------*/
const mainScreenTitle =
    'Largest Pokémon index with information about every Pokemon you can think of.';
const double backgroundImageOpacity = .05;

/*----------------Extensions----------------*/
extension HexColor on String {
  Color toColor() {
    // Remove the '#' character if present
    final hexCode = this.replaceAll('#', '');
    // Parse the hex code and convert it to a Color object
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
Future<String> returnSvgString({required String imageUrl}) async{
  final response  = await get(Uri.parse(imageUrl));
  return response.body;
}

Future<Uint8List> svgToPng(BuildContext context, String svgString, {int ?svgWidth, int? svgHeight}) async {
  final pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
  final ui.Image image = await pictureInfo.picture.toImage(svgWidth??200, svgHeight??200);
  final ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

Future<File> returnPngFile({required BuildContext context, required String svgString}) async {
  final pngBytes = await svgToPng(context, svgString);

  // Get the path to the application's documents directory.
  final directory = await getApplicationDocumentsDirectory();

  // Create a file in the documents directory.
  final file = File('${directory.path}/test${DateTime.now().toString()}.png');

  // Write the PNG bytes to the file and return it.
  return await file.writeAsBytes(pngBytes);
}
Future<Color>returnDominantColor ({required BuildContext context,required String imageUrl})async
{
  final svgString = await returnSvgString(imageUrl: imageUrl);

  final file  = await returnPngFile(context: context, svgString: svgString);
  final palateGenerator =  await PaletteGenerator.fromImageProvider(
    Image.file(file).image,
  );
  print( palateGenerator.dominantColor!.color.toString());
  return palateGenerator.dominantColor!.color;
}
Color returnStatsColor({required String statsType}){

  switch(statsType){
    case  'hp':
      return Colors.green;
    case 'attack':
      return primaryColor;
    case 'defence':
      return Colors.purpleAccent;
    case 'special-attack':
      return Colors.blueAccent;
    default:
      return Colors.deepPurple;
  }
}



/*----------------Widgets----------------*/
Widget verticalSpace({required double spaceValue}) => SizedBox(
      height: Adaptive.h(spaceValue),
    );

SliverAppBar homeScreenAppBar() => SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      expandedHeight: Adaptive.h(8),
      leading: const SizedBox(),
      flexibleSpace: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/appBar_logo.png',
                  height: 40,
                  width: 40,
                ),
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: 'Poké',
                      style: TextStyle(
                          wordSpacing: 1,
                          letterSpacing: .5,
                          fontSize: Adaptive.sp(
                            22,
                          ),
                          fontFamily: 'Sofia Sans Condensed Regular',
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                      children: [
                        TextSpan(
                          text: ' Library',
                          style: TextStyle(
                              fontSize: Adaptive.sp(
                                22,
                              ),
                              fontFamily: 'Sofia Sans Condensed Regular',
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Container stackBackground() => Container(
      width: Adaptive.w(100),
      height: Adaptive.h(100),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/background.jpeg',
              ),
              opacity: backgroundImageOpacity,
              fit: BoxFit.cover)),
    );

LottieBuilder loadingBar({double? width, double? height}) =>
    Lottie.asset('assets/loading.json',
        width: width ?? Adaptive.w(20), height: height ?? Adaptive.w(20));

/*----------------Extra Functions----------------*/
void removeFocus({required BuildContext context}) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  currentFocus.unfocus();
}

String getEmojiFromType(String pokemonType) {
  switch (pokemonType.toLowerCase()) {
    case 'fire':
      return '🔥 Fire';
    case 'water':
      return '💧 Water';
    case 'grass':
      return '🌿 Grass';
    case 'electric':
      return '⚡ Electric';
    case 'flying':
      return '🌪️ Flying';
    case 'rock':
      return '🗿 Rock';
    case 'ground':
      return '🏔️ Ground';
    case 'ice':
      return '❄️ Ice';
    case 'poison':
      return '🦠 Poison';
    case 'bug':
      return '🦋 Bug';
    case 'fighting':
      return '🥊 Fighting';
    case 'steel':
      return '🛡️ Steel';
    case 'psychic':
      return '🌟 Psychic';
    case 'ghost':
      return '🧪 Ghost';
    case 'dark':
      return '🌙 Dark';
    case 'dragon':
      return '☄️ Dragon';
    case 'fairy':
      return '🦷 Fairy';
    case 'shadow':
      return '⚫ Shadow';case 'normal':
      return '⚖ Normal';
    default:
      return '❓ Unknown'; // If the Pokémon type doesn't match any emoji
  }
}



String capitalize(String text) {
  return text.split(' ').map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1);
    }
    return '';
  }).join(' ');
}

/*---------------Text Styles----------------------*/
TextStyle hintStyle() => TextStyle(
    fontSize: Adaptive.sp(
      20,
    ),
    fontFamily: 'Sofia Sans Condensed Regular',
    fontWeight: FontWeight.normal,
    color: hintColor);
/*---------------APIS----------------------------*/
Future<String> returnSearchPokemonDetails({required String pokemonName}) async {
  final url =
  Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName');

  final response = await get(url);

  return response.body;
}

/*--------------Loading Dialog Box---------------*/
Future<void> showLoadingDialogBox({required BuildContext context}) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: loadingBar(),
          ),
        );
      }
  );
}