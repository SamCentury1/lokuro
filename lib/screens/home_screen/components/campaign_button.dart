import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/home_screen/components/campaign_dialog.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class CampaignButton extends StatefulWidget {
  final int index;
  const CampaignButton({super.key, required this.index});

  @override
  State<CampaignButton> createState() => _CampaignButtonState();
}

class _CampaignButtonState extends State<CampaignButton> {


  late bool isCardOpen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    
    // GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    
    Map<String,dynamic> campaign = settings.campaignData.value[widget.index];

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 20, 20, 20),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(134, 58, 57, 57), offset: Offset.zero, blurRadius: 20.0, spreadRadius: 5.0),
                BoxShadow(color: Color.fromARGB(62, 223, 221, 221), offset: Offset.zero, blurRadius: 10.0, spreadRadius: 3.0),
              ],
            ),
            width: settingsState.playAreaSize.width * 0.9,
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      campaign["campaignPhotoUrl"],
                      fit: BoxFit.cover,
                      width: settingsState.playAreaSize.width * 0.9,
                      height: 100, // Maintain fixed height here
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
                    campaignCardCampaignName(context, campaign["campaignName"],campaign["location"]),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
              
                      Flexible(
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          children: <TableRow>[
                            campaignTableRow("Difficulty: ",convertDifficultyCodeToString(campaign["difficulty"])),
                            campaignTableRow("Levels: ",campaign["levels"].length.toString(),),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                          showDialog(
                            context: context, 
                            builder: (context) {
                              return CampaignDialog(index: widget.index);
                            }
                          );
                          // setState(() {
                          //   isCardOpen = !isCardOpen;
                          // });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 49, 48, 48),
                            borderRadius: BorderRadius.all(Radius.circular(6.0))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18.0, 4.0, 18.0, 4.0,),
                            child: Text(
                              "Launch",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              
              
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}



TableRow campaignTableRow(String label, String body) {
  return TableRow(
    children: <Widget>[
      TableCell(
        child: Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 226, 225, 225),
            fontSize: 14
          ),
        )
      ),
      TableCell(
        child: Text(
          body,
          style: const TextStyle(
            color: Color.fromARGB(255, 226, 225, 225),
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold
          ),                                  
        )
      )
    ]
  );
}


Widget campaignCardCampaignName(BuildContext context, String campaignName,  String campaignLocation) {
  return SizedBox(
    child: Padding(
      padding: EdgeInsets.all(5.0),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            campaignName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),                        
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            campaignLocation,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}