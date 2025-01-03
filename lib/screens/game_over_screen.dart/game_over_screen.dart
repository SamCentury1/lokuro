import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lokuro/components/coin_painter.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_over_screen.dart/components/game_summary_row.dart';
import 'package:provider/provider.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  

  late GamePlayState _gamePlayState;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gamePlayState = Provider.of<GamePlayState>(context,listen: false);

    // startCoinCount();
  }

  late int coinsCollected = 0;

  void startCoinCount() async {
    int target = _gamePlayState.coinsCollected.last;

    int desiredDuration = 2000;
    const int step = 10;
    int stops = (desiredDuration/step).floor();
    int increment = (target/stops).floor();

    Timer.periodic(const Duration(milliseconds: 5), (Timer timer) {
      if (coinsCollected >= target) {
        timer.cancel();
        setState(() {
          coinsCollected = target;
        });        
      } else {
        setState(() {
          coinsCollected = coinsCollected + increment;
        });
      }
    });
  }


  
  
  @override
  Widget build(BuildContext context) {

    final GamePlayState gamePlayState = Provider.of<GamePlayState>(context,listen:false);
    final SettingsState settingsState = Provider.of<SettingsState>(context,listen:false);

    final String campaignName = gamePlayState.currentCampaignState.campaignName;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 65, 65, 65),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 14, 14, 14),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),             
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2.0, color: Colors.white))
                          ),
                          child: const Text(
                            "Game Summary",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: Text(
                          "Congratulations! You completed the ${campaignName} campaign in record time!",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 243, 243, 243),
                            fontSize: 18,
                            fontWeight: FontWeight.w200
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: settingsState.screenSize.width*0.6,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 14, 14, 14),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CustomPaint(
                            painter: CoinPainter(),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            coinsCollected.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 14, 14, 14),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))
                ),                
                child: Column(
                  children: getSummaryTable(gamePlayState,getGemSummaryTableData(gamePlayState)),
                  // children: [                 
                  //   Table(
                  //     border: const TableBorder(horizontalInside: BorderSide(width: 1.0, color: const Color.fromARGB(148, 235, 235, 235))),
                  //     columnWidths: const {
                  //       // 0: FlexColumnWidth(2),
                  //       0: FlexColumnWidth(10),
                  //       1: FlexColumnWidth(5),
                  //       2: FlexColumnWidth(10),
                  //     },
                  //     children: getGemSummaryTableRows(gamePlayState),
                  //   ),
                  // ],
                ),
              ),
            )

            
                      
          ],
        ),
      ),
    );
  }
}

List<Widget> getSummaryTable(GamePlayState gamePlayState, List<Map<String,dynamic>> gemSummaryTableData) {
  List<Widget> table = [
    Table(
      border: const TableBorder(horizontalInside: BorderSide(width: 1.0, color: const Color.fromARGB(148, 235, 235, 235))),
      columnWidths: const {
        // 0: FlexColumnWidth(2),
        0: FlexColumnWidth(10),
        1: FlexColumnWidth(5),
        2: FlexColumnWidth(10),
      },
      children: [getGemSummaryTableHeader()],
    ),
  ];

  for (int i=0; i<gemSummaryTableData.length; i++) {
    Widget row = GameSummaryRow(gemData: gemSummaryTableData[i],);
    table.add(row);
  }

  return table;


}

TableRow getGemSummaryTableHeader() {
  return const TableRow(

    children: [
      TableCell(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Stone",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),                          
            ),
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            "Count",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),                          
          ),
        ),
      ),
      TableCell(
        child: Center(
          child: Text(
            "Value",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),                          
          ),
        ),                        
      ),
    ] 
  );
}

List<Map<String,dynamic>> getGemSummaryTableData(GamePlayState gamePlayState) {
  Map<int,dynamic> gemSummary = {};
  Map<int,dynamic> gemCounts = {};
  for (int i=0; i<gamePlayState.levelSummary.length; i++) {
    for (int j=0; j<gamePlayState.levelSummary[i]["jewels"].length; j++) {
      int key = gamePlayState.levelSummary[i]["jewels"][j]["key"];
      double value = gamePlayState.levelSummary[i]["jewels"][j]["value"];
      gemSummary[key] = (gemSummary[key] ?? 0) + value;
      gemCounts[key] = (gemCounts[key] ?? 0) + 1;
    }
  }

  List<Map<String,dynamic>> gemSummaryTableData = [];
  gemSummary.forEach((key,value) {
    String gemName = gamePlayState.gemstoneData[key]["name"];
    Color color = gamePlayState.gemstoneData[key]["color"];
    int count = gemCounts[key];
    Map<String,dynamic> gemObject = {"key":key, "name": gemName, "count": count, "value": value, "color": color};
    gemSummaryTableData.add(gemObject);
  });

  return gemSummaryTableData;
}


List<TableRow> getGemSummaryTableRows(GamePlayState gamePlayState) {
  
  List<TableRow> rows = [
    getGemSummaryTableHeader()
  ];

  Map<int,dynamic> gemSummary = {};
  Map<int,dynamic> gemCounts = {};
  for (int i=0; i<gamePlayState.levelSummary.length; i++) {
    for (int j=0; j<gamePlayState.levelSummary[i]["jewels"].length; j++) {
      int key = gamePlayState.levelSummary[i]["jewels"][j]["key"];
      double value = gamePlayState.levelSummary[i]["jewels"][j]["value"];
      gemSummary[key] = (gemSummary[key] ?? 0) + value;
      gemCounts[key] = (gemCounts[key] ?? 0) + 1;
    }
  }

  List<Map<String,dynamic>> gemSummaryTableData = [];
  gemSummary.forEach((key,value) {
    String gemName = gamePlayState.gemstoneData[key]["name"];
    Color color = gamePlayState.gemstoneData[key]["color"];
    int count = gemCounts[key];
    Map<String,dynamic> gemObject = {"key":key, "name": gemName, "count": count, "value": value, "color": color};
    gemSummaryTableData.add(gemObject);
  });





  print("----------------table summary data--------------------");
  print(gemSummaryTableData);
  print("--------------------------------------------------");  
  
  gemSummaryTableData.sort((a, b) => b["value"].compareTo(a["value"]));

  
  // double maxValue = gemSummaryTableData.first["value"];

  for (int i=0; i<gemSummaryTableData.length; i++) {
    Map<String,dynamic> gemData = gemSummaryTableData[i];
    TableRow row = GameSummaryRow(gemData: gemData) as TableRow;
    // final Color color = gemData["color"];
    // final String name = gemData["name"];
    // final int count = gemData["count"];
    // final double value = gemData["value"];
    // TableRow row = TableRow(
    //   children: [
    //     TableCell(
    //       child: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Row(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 3.0),
    //               child: SizedBox(
    //                 width: 25,
    //                 height: 25,
    //                 child: CustomPaint(
    //                   painter: GemPainter1(color: color),
    //                 )
    //               ),
    //             ),
                
    //             Text(
    //               name,
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 18
    //               )
    //             ),
    //           ],
    //         ),
    //       )
    //     ),
    //     TableCell(
    //       child: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Center(
    //           child: Text(
    //             count.toString(),
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 18
    //             )
    //           ),
    //         ),
    //       )
    //     ),  

    //     TableCell(
    //       child: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Center(
    //           child: Text(
    //             Helpers().formatDigits(value),
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 18
    //             )
    //           ),              
    //         ),
    //       )
    //     ),                
    //   ]
    // );
    rows.add(row);
  };
  return rows;
}


List<Widget> getDashedLine(int dashCount, double dashWidth, double dashHeight) {
  return List.generate(dashCount, (_) {            
    return SizedBox(
      width: dashWidth,
      height: dashHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  });  
}

Widget formattedGemValue(double value) {

  Widget dollarSign = Text(
  "\$",
    style: TextStyle(
      color: Colors.white,
      fontSize: 18
    )
  ); 

  Widget formattedValue = Text(
  Helpers().formatDigits(value),
    style: TextStyle(
      color: Colors.white,
      fontSize: 18
    )
  );      
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final double boxWidth = constraints.constrainWidth();
      const double dashWidth = 4.0;
      final double dashHeight = 2.0;
      final int dashCount = (boxWidth / (2 * dashWidth)).floor();

        final List<Widget> dashedLine = getDashedLine(dashCount,dashWidth,dashHeight);
        dashedLine.insert(0, dollarSign);
        dashedLine.insert(dashedLine.length,formattedValue);

      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,          
        children: dashedLine,
      );
    }
  );
}


Widget formatGemValue(double value) {

  final String stringValue = Helpers().formatDigits(value);

  Widget widget = Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
      "\$",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        )
      ),      
      Text(
      stringValue,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18
        )
      ),
    ]
  );

  return widget;


}