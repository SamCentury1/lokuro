import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/home_screen/components/campaign_button.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class CampaignDialog extends StatelessWidget {
  final int index;
  const CampaignDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {

    SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);
    AnimationState animationState = Provider.of<AnimationState>(context, listen: false);

    Map<String,dynamic> campaign = settings.campaignData.value[index];  

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width*0.8,
        // height: MediaQuery.of(context).size.height*0.6,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 43, 42, 42),
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              // height: MediaQuery.of(context).size.height*0.6,          
              child: SingleChildScrollView(
                child: Column(
                  children: [
                
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)
                        ),
                        child: Image.network(campaign["campaignPhotoUrl"]),
                      ),
                    ),            
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     campaign["campaignName"],
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 32,
                    //     ),
                    //   ),
                    // ),
                    
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal:  8.0),
                    //   child: Row(
                    //     children: [
                      
                    //     const Text(
                    //       "Difficulty: ",
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18
                    //         ),
                    //       ),
                    //       SizedBox(width: 12.0,),
                    //       Text(
                    //         convertDifficultyCodeToString(campaign["difficulty"]),
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //           fontStyle: FontStyle.italic
                    //         ),                    
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: Row(
                    //     children: [
                      
                    //     const Text(
                    //       "Levels: ",
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18
                    //         ),
                    //       ),
                    //       SizedBox(width: 12.0,),
                    //       Text(
                    //         campaign["levels"].length.toString(),
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold,
                    //           fontStyle: FontStyle.italic
                    //         ),                    
                    //       )
                    //     ],
                    //   ),
                    // ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        children: <TableRow>[
                          campaignTableRow("Mine: ", campaign["campaignName"]),
                          campaignTableRow("Difficulty: ",convertDifficultyCodeToString(campaign["difficulty"])),
                          campaignTableRow("Levels: ",campaign["levels"].length.toString(),),
                          campaignTableRow("Opened: ",campaign["opened"]),
                          campaignTableRow("Stones Mined: ",campaign["stones"]),
                          // campaignTableRow("ownership: ",campaign["ownership"]),
                        ],
                      ),
                    ),

                    Divider(thickness: 1.0, color: const Color.fromARGB(255, 221, 221, 221),),
              
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     campaign["campaignDescription"],
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 16
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 30.0,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap:() => General().navigateToCampaign(context,index,settingsState,gamePlayState,animationState,settings),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 99, 98, 98),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(12.0,4.0,12.0,4.0),
                                  child: Center(
                                    child: Text(
                                      "Start",
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 231, 227, 227),
                                        fontSize: 22,
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )                    
                
                  ],
                ),
              ),
            ),
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   child: campaignCardCampaignName(context, campaign["campaignName"], campaign["location"]),
            // ),            
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width*0.8,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         GestureDetector(
            //           onTap:() => General().navigateToCampaign(context,index,settingsState,gamePlayState,animationState,settings),
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: const Color.fromARGB(255, 99, 98, 98),
            //               borderRadius: BorderRadius.all(Radius.circular(8.0)),
            //             ),
            //             child: Padding(
            //               padding: const EdgeInsets.fromLTRB(12.0,4.0,12.0,4.0),
            //               child: Center(
            //                 child: Text(
            //                   "Start",
            //                   style: TextStyle(
            //                     color: const Color.fromARGB(255, 231, 227, 227),
            //                     fontSize: 22,
            //                   ),
            //                 )
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            // )
          ],
        ),
      ),
    );
  }
}

String convertDifficultyCodeToString(int difficulty) {
  String res = "";
  List<String> difficulties = ["easy","intermediate","advanced","difficult","challenging"];
  res= difficulties[difficulty];
  return res;
}