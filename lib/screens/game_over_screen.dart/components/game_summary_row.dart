import 'package:flutter/material.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/helpers.dart';

class GameSummaryRow extends StatelessWidget {
  final Map<String,dynamic> gemData;
  const GameSummaryRow({
    super.key,
    required this.gemData
  });

  @override
  Widget build(BuildContext context) {
    final Color color = gemData["color"];
    final String name = gemData["name"];
    final int count = gemData["count"];
    final double value = gemData["value"];

    return Table(
      border: const TableBorder(horizontalInside: BorderSide(width: 1.0, color: const Color.fromARGB(148, 235, 235, 235))),
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
                child: Center(
                  child: Text(
                    Helpers().formatDigits(value),
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