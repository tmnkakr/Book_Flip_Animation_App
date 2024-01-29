import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class FlipFlipPage extends StatefulWidget {
  const FlipFlipPage({super.key});

  @override
  State<FlipFlipPage> createState() => _FlipFlipPageState();
}

class _FlipFlipPageState extends State<FlipFlipPage>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> artikelData = [];
  late PageController pageController;
  double dragPositionTopFront = 0;
  double dragPositionBottomFront = 270;
  double dragPositionTopBack = 0;
  double dragPositionBottomBack = 0;
  bool isFront = true;
  bool isNext = true;
  late AnimationController flipController;
  int currentPageFront = 1;
  int currentPageBack = 1;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    String jsonData =
        await DefaultAssetBundle.of(context).loadString('assets/data.json');
    List<dynamic> dataList = json.decode(jsonData);

    setState(() {
      artikelData = List<Map<String, dynamic>>.from(dataList);
    });
  }

  @override
  Widget build(BuildContext context) {
    double layarTinggi = MediaQuery.of(context).size.height;
    double layarLebar = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) => setState(() {
          if (dragPositionTopFront >= 0 &&
              dragPositionTopFront < 90 &&
              isFront == true) {
            dragPositionTopFront =
                (dragPositionTopFront + details.delta.dy).clamp(0, 90);
            if (dragPositionTopFront == 0 && isNext == false) {
              isNext = true;
            }
          } else if (dragPositionTopFront == 90 && isFront == true) {
            dragPositionBottomFront =
                (dragPositionBottomFront + details.delta.dy).clamp(270, 360);

            isFront = false;
          } else if (dragPositionBottomFront > 270 &&
              dragPositionBottomFront <= 360) {
            dragPositionBottomFront =
                (dragPositionBottomFront + details.delta.dy).clamp(270, 360);
            if (dragPositionBottomFront == 360 && isNext == true) {
              // print('Next Page');

              isNext = false;
            }
          } else if (dragPositionBottomFront == 270) {
            dragPositionTopFront =
                (dragPositionTopFront + details.delta.dy).clamp(0, 90);
            if (isFront == false) {
              isFront = true;
            }
          }
        }),
        onVerticalDragEnd: (details) {
          if (isNext == false &&
              pageController.page! < artikelData.length - 2) {
            dragPositionTopFront = 0;
            dragPositionBottomFront = 270;
            dragPositionTopBack = 0;
            dragPositionBottomBack = 0;
            pageController.jumpToPage(pageController.page!.toInt() + 1);
          } else if (isNext == true && pageController.page! > 0) {
            dragPositionTopFront = 90;
            dragPositionBottomFront = 360;
            dragPositionTopBack = 0;
            dragPositionBottomBack = 0;
            pageController.jumpToPage(pageController.page!.toInt() - 1);
          }
        },
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: pageController,
          itemCount: artikelData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                // top
                Stack(
                  children: [
                    // back page
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(dragPositionTopBack / 180 * pi),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: layarLebar,
                        height: layarTinggi / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const NetworkImage(
                                'https://cf.bstatic.com/xdata/images/hotel/max1024x768/200332548.jpg?k=81c26152eed74143cfb59626b17a177124efa259ee0138673ffdc50b1d66c498&o=&hp=1'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: SizedBox(
                                width: layarLebar - 20.0,
                                child: RichText(
                                  text: TextSpan(
                                    text: artikelData[(index + currentPageBack)
                                                .clamp(
                                                    0, artikelData.length - 1)]
                                            ['title'] ??
                                        '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // front page
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(dragPositionTopFront / 180 * pi),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: layarLebar,
                        height: layarTinggi / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const NetworkImage(
                                'https://cf.bstatic.com/xdata/images/hotel/max1024x768/200332548.jpg?k=81c26152eed74143cfb59626b17a177124efa259ee0138673ffdc50b1d66c498&o=&hp=1'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: SizedBox(
                                width: layarLebar - 20.0,
                                child: RichText(
                                  text: TextSpan(
                                    text: artikelData[index +
                                            currentPageFront -
                                            1]['title'] ??
                                        '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // bottom
                Stack(
                  children: [
                    // back page
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(dragPositionBottomBack / 180 * pi),
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          artikelData[index + currentPageBack - 1]
                                  ['description'] ??
                              '',
                          textAlign: TextAlign.justify,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // front page
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(dragPositionBottomFront / 180 * pi),
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          artikelData[(index + currentPageFront).clamp(
                                  0, artikelData.length - 1)]['description'] ??
                              '',
                          textAlign: TextAlign.justify,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
