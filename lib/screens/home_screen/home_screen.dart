import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:pokemon_library/extra/colors.dart';
import 'package:pokemon_library/extra/extra_functions.dart';
import 'package:pokemon_library/models/pokemon_details_model.dart';
import 'package:pokemon_library/screens/details_screen/pokemon_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _totalPokemon = 1302;
  int _itemsPerPage = 10;

  List<int> items = [];

  int get totalPages => (_totalPokemon / _itemsPerPage).ceil();
  bool _loading = false;

  Future<List<int>> getPageItems(int index) async {
    int startIndex = index * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    endIndex = endIndex > _totalPokemon ? _totalPokemon : endIndex;

    List<int> newItems = [];
    // Simulating asynchronous delay
    await Future.delayed(Duration(seconds: 1));
    for (int i = startIndex; i < endIndex; i++) {
      newItems.add(i);
    }
    return newItems;
  }

// Example usage:
  void loadPage() async {
    setState(() {
      _loading = true;
    });
    List<int> loadedItems = await getPageItems(_currentIndex);
    setState(() {
      items = loadedItems;
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadPage();
    super.initState();
  }

  void goToNextPage() {
    if (_currentIndex < totalPages - 1) {
      setState(() {
        _currentIndex++;
        loadPage();
      });
    }
  }

  void goToPreviousPage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        loadPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          removeFocus(context: context);
        },
        child: Scaffold(
          extendBodyBehindAppBar: false,
          body: CustomScrollView(
            slivers: <Widget>[
              homeScreenAppBar(),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: MyHeaderDelegate(
                    goToNextPage: goToNextPage,
                    goToPreviousPage: goToPreviousPage,
                    currentIndex: _currentIndex),
              ),
              SliverAnimatedList(
                initialItemCount: 1,
                itemBuilder: (BuildContext context, int index,
                    Animation<double> animation) {
                  return Stack(
                    children: [
                      stackBackground(),
                      _loading == true
                          ? SizedBox(
                              height: Adaptive.h(50),
                              child: Center(
                                child: loadingBar(),
                              ))
                          : Column(
                              children: List.generate(
                                items.length,
                                (index) => PokemonItem(
                                  index: items[index],
                                ),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PokemonItem extends StatefulWidget {
  const PokemonItem({super.key, required this.index});

  final int index;

  @override
  State<PokemonItem> createState() => _PokemonItemState();
}

class _PokemonItemState extends State<PokemonItem> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonModel>(
        future: returnPokemonDetaail(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailsScreen(
                          pokemonModel: snapshot.data!,
                          imageUrl:
                              'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/${widget.index + 1}.svg',
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          verticalSpace(spaceValue: 5),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      width: Adaptive.w(100),
                                      height: Adaptive.h(22),
                                      decoration: BoxDecoration(
                                          color: tagColor,
                                          borderRadius:
                                              BorderRadius.circular(27)),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.forms[0].name,
                                    style: TextStyle(
                                        wordSpacing: 1,
                                        letterSpacing: 2,
                                        fontSize: Adaptive.sp(
                                          32,
                                        ),
                                        fontFamily:
                                            'Sofia Sans Condensed Regular',
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: snapshot.data!.types
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: tagColor,
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                                  child: Text(
                                                    getEmojiFromType(
                                                      e.type.name,
                                                    ),
                                                    style: TextStyle(
                                                        wordSpacing: 1,
                                                        fontSize: Adaptive.sp(
                                                          18,
                                                        ),
                                                        fontFamily:
                                                            'Sofia Sans Condensed Regular',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.network(
                            'https://unpkg.com/pokeapi-sprites@2.0.2/sprites/pokemon/other/dream-world/${widget.index + 1}.svg',
                            height: Adaptive.h(27),
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: loadingBar(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : snapshot.hasError
                  ? SizedBox(
                      height: Adaptive.h(20),
                      child: Center(
                        child: Text(snapshot.error.toString()),
                      ),
                    )
                  : SizedBox(
                      height: Adaptive.h(20),
                      child: Center(
                        child: loadingBar(),
                      ),
                    );
        });
  }

  Future<PokemonModel> returnPokemonDetaail() async {
    final url =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${widget.index + 1}');

    final response = await get(url);

    return PokemonModel.fromJson(jsonDecode(response.body));
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback goToNextPage, goToPreviousPage;
  final int currentIndex;

  const MyHeaderDelegate(
      {required this.goToNextPage,
      required this.goToPreviousPage,
      required this.currentIndex});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 5,
              color: textFieldColor,
              surfaceTintColor: textFieldColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.grey,
                    hintText: 'Enter pokemon name',
                    hintStyle: hintStyle(),
                    fillColor: Colors.white60,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith<Size>(
                        (states) => Size(Adaptive.w(30), 40)),
                    maximumSize: MaterialStateProperty.resolveWith<Size>(
                        (states) => Size(Adaptive.w(30), 50)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return currentIndex == 0
                            ? Colors.grey
                            : '#d90310'.toColor();
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () => goToPreviousPage(),
                  child: Text(
                    'Previous ($currentIndex)',
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white, fontSize: Adaptive.sp(12)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith<Size>(
                        (states) => Size(Adaptive.w(30), 40)),
                    maximumSize: MaterialStateProperty.resolveWith<Size>(
                        (states) => Size(Adaptive.w(30), 50)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return '#d90310'.toColor();
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () => goToNextPage(),
                  child: Text(
                    'Next(${currentIndex + 1})',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 130;

  @override
  double get minExtent => 130;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
