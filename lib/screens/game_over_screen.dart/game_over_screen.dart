import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lokuro/components/coin_painter.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:provider/provider.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
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
                            "+1231",
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
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(10),
                    2: FlexColumnWidth(5),
                    3: FlexColumnWidth(10),
                  },
                  children: getGemSummaryTableRows(gamePlayState),
                  // children: <TableRow>[
                    // TableRow(
                    //   children: [
                    //     TableCell(
                    //       child: Text(
                    //         "",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20
                    //         ),
                    //       ),
                    //     ),
                    //     TableCell(
                    //       child: Text(
                    //         "Stone",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20
                    //         ),                          
                    //       ),
                    //     ),
                    //     TableCell(
                    //       child: Text(
                    //         "Count",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20
                    //         ),                          
                    //       ),
                    //     ),
                    //     TableCell(
                    //       child: Text(
                    //         "Value",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 20
                    //         ),                          
                    //       ),                        
                    //     ),
                    //   ] 
                    // )
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

TableRow getGemSummaryTableHeader() {
  return const TableRow(
    children: [
      TableCell(
        child: Text(
          "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
      ),
      TableCell(
        child: Text(
          "Stone",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),                          
        ),
      ),
      TableCell(
        child: Text(
          "Count",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),                          
        ),
      ),
      TableCell(
        child: Text(
          "Value",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),                          
        ),                        
      ),
    ] 
  );
}

List<TableRow> getGemSummaryTableRows(GamePlayState gamePlayState) {
  
  Random random = Random();
  List<TableRow> rows = [
    getGemSummaryTableHeader()
  ];
  Map<int,int> collectedGems = Helpers().getMapOfCollectedGems(gamePlayState);

  List<String> stoneNames = [
    "Ruby",
    "Amethyst",
    "Emerald",
    "Amber",
    "Topax",
    "Aquamarine"
  ];
  


  collectedGems.forEach((key,value) {
    final int gemValuePiece1 = random.nextInt(89)+10;
    final int gemValuePiece2 = random.nextInt(100)+800;
    final Color color = gamePlayState.colors[key];    
    TableRow row = TableRow(
      children: [
        TableCell(
          child: Container(

                width: 25,
                height: 25,
            child: CustomPaint(
              painter: GemPainter1(color: color),
            )
          ),
        ),
        TableCell(
          child: Text(
            stoneNames[key],
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            )
          )
        ),
        TableCell(
          child: Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            )
          )
        ),  

        TableCell(
          child: Text(
          "\$ ${gemValuePiece1},${gemValuePiece2}.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18
            )
          )
        ),                
      ]
    );
    rows.add(row);
  });
  return rows;
}