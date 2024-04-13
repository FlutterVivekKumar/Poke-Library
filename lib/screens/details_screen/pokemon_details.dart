import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokemon_library/extra/extra_functions.dart';
import 'package:pokemon_library/models/pokemon_details_model.dart';

import '../../extra/colors.dart';

class PokemonDetailsScreen extends StatefulWidget {
  const PokemonDetailsScreen(
      {super.key, required this.pokemonModel, required this.imageUrl});

  final PokemonModel pokemonModel;
  final String imageUrl;

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    setTitleBarColor();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white.withOpacity(.7), // Status bar color
    ));
    super.dispose();
  }

  void setTitleBarColor() async {
    final color =
        await returnDominantColor(imageUrl: widget.imageUrl, context: context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color.withOpacity(.7), // Status bar color
    ));
  }

  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Column(
        children: [
          FutureBuilder<Color>(
              future: returnDominantColor(
                  imageUrl: widget.imageUrl, context: context),
              builder: (context, snapshot) => snapshot.hasData
                  ? SizedBox(
                      height: Adaptive.h(35),
                      child: Stack(
                        children: [
                          Container(
                            height: Adaptive.h(28),
                            width: Adaptive.w(100),
                            decoration: BoxDecoration(
                                color: snapshot.data!.withOpacity(.7),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                )),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SvgPicture.network(
                                widget.imageUrl,
                                height: Adaptive.h(28),
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: loadingBar(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: 10,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.arrow_back),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: loadingBar(),
                    )),
          verticalSpace(spaceValue: 2),
          Center(
            child: Text(
              capitalize(widget.pokemonModel.forms[0].name),
              style: TextStyle(
                  wordSpacing: 1,
                  letterSpacing: 2,
                  fontSize: Adaptive.sp(
                    42,
                  ),
                  fontFamily: 'Sofia Sans Condensed Regular',
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.pokemonModel.types
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: tagColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Text(
                            getEmojiFromType(
                              e.type.name,
                            ),
                            style: TextStyle(
                                wordSpacing: 1,
                                fontSize: Adaptive.sp(
                                  18,
                                ),
                                fontFamily: 'Sofia Sans Condensed Regular',
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          verticalSpace(spaceValue: 2),
          _activeIndex == 0
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: '#E9E9E9'.toColor(),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),

                            spreadRadius: 1,
                            blurRadius: 1,
                            blurStyle: BlurStyle.normal,
                            offset: const Offset(
                                0, -2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: Adaptive.w(100),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'About',
                                style: TextStyle(
                                    wordSpacing: 1,
                                    letterSpacing: 2,
                                    fontSize: Adaptive.sp(
                                      22,
                                    ),
                                    fontFamily: 'Sofia Sans Condensed Regular',
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Height : ${widget.pokemonModel.height}m',
                            style: TextStyle(
                                wordSpacing: 1,
                                letterSpacing: 2,
                                fontSize: Adaptive.sp(
                                  16,
                                ),
                                fontFamily: 'Sofia Sans Condensed Regular',
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: Adaptive.w(30),
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Weight : ${widget.pokemonModel.weight}kg',
                            style: TextStyle(
                                wordSpacing: 1,
                                letterSpacing: 2,
                                fontSize: Adaptive.sp(
                                  16,
                                ),
                                fontFamily: 'Sofia Sans Condensed Regular',
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: Adaptive.w(30),
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Abilities   ',
                                    style: TextStyle(
                                        wordSpacing: 1,
                                        letterSpacing: 2,
                                        fontSize: Adaptive.sp(
                                          16,
                                        ),
                                        fontFamily:
                                            'Sofia Sans Condensed Regular',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          widget.pokemonModel.abilities.length,
                                          (index) => Text(
                                                ' ~ ${widget.pokemonModel.abilities[index].ability.name}',
                                                style: TextStyle(
                                                    wordSpacing: 1,
                                                    letterSpacing: 2,
                                                    fontSize: Adaptive.sp(
                                                      16,
                                                    ),
                                                    fontFamily:
                                                        'Sofia Sans Condensed Regular',
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black),
                                              ))),
                                ]),
                          ),
                          SizedBox(
                            width: Adaptive.w(50),
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                )
              : _activeIndex == 1
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: '#E9E9E9'.toColor(),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),

                                spreadRadius: 1,
                                blurRadius: 1,
                                blurStyle: BlurStyle.normal,
                                offset: const Offset(
                                    0, -2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: Adaptive.w(100),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Stats',
                                    style: TextStyle(
                                        wordSpacing: 1,
                                        letterSpacing: 2,
                                        fontSize: Adaptive.sp(
                                          22,
                                        ),
                                        fontFamily:
                                            'Sofia Sans Condensed Regular',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              verticalSpace(spaceValue: 2),
                              ...List.generate(
                                  widget.pokemonModel.stats.length,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${capitalize(widget
                                                        .pokemonModel
                                                        .stats[index]
                                                        .stat
                                                        .name)}(${widget
                                                        .pokemonModel
                                                        .stats[index]
                                                        .baseStat})',
                                                    style: TextStyle(
                                                        wordSpacing: 1,
                                                        letterSpacing: 2,
                                                        fontSize: Adaptive.sp(
                                                          14,
                                                        ),
                                                        fontFamily:
                                                            'Sofia Sans Condensed Regular',
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black),
                                                  ),
                                                  Container(
                                                    width: Adaptive.w(46),
                                                    color: Colors.white,
                                                    height: 3,
                                                    child:LinearProgressIndicator(  value: widget
                                                        .pokemonModel
                                                        .stats[index]
                                                        .baseStat * 0.01,
                                                      backgroundColor: Colors.transparent,
                                                      color: returnStatsColor(statsType: widget
                                                          .pokemonModel
                                                          .stats[index]
                                                          .stat
                                                          .name),)
                                                    ,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: Adaptive.w(100),
                                              child: const Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: '#E9E9E9'.toColor(),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),

                                spreadRadius: 1,
                                blurRadius: 1,
                                blurStyle: BlurStyle.normal,
                                offset: const Offset(
                                    0, -2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Adaptive.w(100),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Find Similar Type Pokémon',
                                    style: TextStyle(
                                        wordSpacing: 1,
                                        letterSpacing: 2,
                                        fontSize: Adaptive.sp(
                                          22,
                                        ),
                                        fontFamily:
                                            'Sofia Sans Condensed Regular',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                             
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Species:',
                                  style: TextStyle(
                                      wordSpacing: 1,
                                      letterSpacing: 2,
                                      fontSize: Adaptive.sp(
                                        18,
                                      ),
                                      fontFamily: 'Sofia Sans Condensed Regular',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                child: Text(
                                  '* ${capitalize(widget.pokemonModel.species.name)}',
                                  style: TextStyle(
                                      wordSpacing: 1,
                                      letterSpacing: 2,
                                      fontSize: Adaptive.sp(
                                        16,
                                      ),
                                      fontFamily: 'Sofia Sans Condensed Regular',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: Adaptive.w(100),
                                child: const Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Stats:',
                                  style: TextStyle(
                                      wordSpacing: 1,
                                      letterSpacing: 2,
                                      fontSize: Adaptive.sp(
                                        18,
                                      ),
                                      fontFamily: 'Sofia Sans Condensed Regular',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Wrap(children: List.generate(widget.pokemonModel.stats.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                child: Text(
                                  '* ${capitalize(widget.pokemonModel.stats[index].stat.name)}',
                                  style: TextStyle(
                                      wordSpacing: 1,
                                      letterSpacing: 2,
                                      fontSize: Adaptive.sp(
                                        14,
                                      ),
                                      fontFamily: 'Sofia Sans Condensed Regular',
                                      fontWeight: FontWeight.w800,

                                      color: Colors.black),
                                ),
                              ),),)
,
                              SizedBox(
                                width: Adaptive.w(100),
                                child: const Divider(
                                  color: Colors.grey,
                                ),
                              ),
                             const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Types:',
                                  style: TextStyle(
                                      wordSpacing: 1,
                                      letterSpacing: 2,
                                      fontSize: Adaptive.sp(
                                        18,
                                      ),
                                      fontFamily: 'Sofia Sans Condensed Regular',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Wrap(children: List.generate(widget.pokemonModel.types.length, (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                child: Text(
                                  '* ${capitalize(widget.pokemonModel.types[index].type.name)}',
                                  style: TextStyle(
                                      wordSpacing: 1,
                                      letterSpacing: 2,
                                      fontSize: Adaptive.sp(
                                        16,
                                      ),
                                      fontFamily: 'Sofia Sans Condensed Regular',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                              ),),)

                            ],
                          ),
                        ),
                      ),
                    ),
          NeumorphicTabBar(
            onTapEvent: (int value) {
              setState(() {
                _activeIndex = value;
              });
            },
          )
        ],
      ),
    );
  }
}

class NeumorphicTabBar extends StatefulWidget {
  const NeumorphicTabBar({super.key, required this.onTapEvent});

  final ValueChanged<int> onTapEvent;

  @override
  State<NeumorphicTabBar> createState() => _NeumorphicTabBarState();
}

class _NeumorphicTabBarState extends State<NeumorphicTabBar> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: Adaptive.w(100),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: '#E9E9E9'.toColor(),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  _activeIndex = index;
                  widget.onTapEvent(_activeIndex);
                });
              },
              child: Card(
                elevation: _activeIndex == index ? 4 : 0,
                color:
                    _activeIndex == index ? Colors.white : '#E9E9E9'.toColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  child: Text(
                    index == 0
                        ? 'About'
                        : index == 1
                            ? "Stats"
                            : "Similar",
                    style: TextStyle(
                        wordSpacing: 1,
                        letterSpacing: 2,
                        fontSize: Adaptive.sp(
                          16,
                        ),
                        fontFamily: 'Sofia Sans Condensed Regular',
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
