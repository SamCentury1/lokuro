import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/helpers.dart';

class GameSummaryRow extends StatefulWidget {
  final int index;
  final Map<String,dynamic> gemData;
  const GameSummaryRow({
    super.key,
    required this.index,
    required this.gemData
  });

  @override
  State<GameSummaryRow> createState() => _GameSummaryRowState();
}

class _GameSummaryRowState extends State<GameSummaryRow> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startAnimation();

  }

  late double valueCount = 0.0;

  void startAnimation() {
    const int duration = 1000;
    const int step = 10;
    final int stops = (duration/step).floor();
    final double target = widget.gemData["value"];
    // calculate the increment that permits the count to complete in exactly 1000 ms
    final int increment = (target/stops).floor();
    Future.delayed(Duration(milliseconds: (widget.index*duration)), () {
      Timer.periodic(const Duration(milliseconds: step), (Timer timer) {
        if (valueCount >= target) {
          timer.cancel();
          setState(() {
            valueCount == target;
          });
        } else {
          setState(() {
            valueCount = valueCount+increment;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.gemData["color"];
    final String name = widget.gemData["name"];
    final int count = widget.gemData["count"];
    // final double value = widget.gemData["value"];

    return Table(
      border: const TableBorder(horizontalInside: BorderSide(width: 1.0, color: Color.fromARGB(148, 235, 235, 235))),
      columnWidths: const {
        // 0: FlexColumnWidth(2),
        0: FlexColumnWidth(10),
        1: FlexColumnWidth(5),
        2: FlexColumnWidth(10),
      },      
      children: <TableRow>[
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CustomPaint(
                          painter: GemPainter1(color: color),
                        )
                      ),
                    ),
                    
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      )
                    ),
                  ],
                ),
              )
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    )
                  ),
                ),
              )
            ),  

            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  // child: formatGemValue(valueCount),
                  child: Text(
                    "${Helpers().formatDigits(valueCount,)} \$",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    )
                  ),
                ),
              )
            ),                
          ]
        )
      ]
    );
  }
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