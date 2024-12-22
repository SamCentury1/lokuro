import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/models/campaign_model.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/resources/storage_methods.dart';
import 'package:lokuro/screens/home_screen/components/campaign_button.dart';
import 'package:lokuro/screens/home_screen/components/level_button.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late SettingsState _settingsState;
  late SettingsController _settings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _settings = Provider.of<SettingsController>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      // getting the dimentions of the screen and setting the play area height 
      // final AppBar appBar = AppBar();
      final double paddingTop = MediaQuery.of(context).padding.top;
      const double controlBarHeight = 60.0;
      final double screenHeight = MediaQuery.of(context).size.height - paddingTop;
      final double screenWidth = MediaQuery.of(context).size.width;
      final Size screenSize = Size(screenWidth,screenHeight);

      final double playAreaHeight = screenHeight - controlBarHeight;
      final double playAreaWidth = screenWidth;
      final Size playAreaSize = Size(playAreaWidth,playAreaHeight);

      _settingsState = Provider.of<SettingsState>(context, listen: false);
      _settingsState.setPlayAreaSize(playAreaSize);
      _settingsState.setScreenSize(screenSize);
      _settingsState.setBackgroundAlignments([
        [Offset.zero, Offset(playAreaSize.width,playAreaSize.height)],
        [Offset(playAreaSize.width,playAreaSize.height), Offset.zero, ],
        [Offset(0.0, playAreaSize.height), Offset(playAreaSize.width,0.0)],
        [Offset(playAreaSize.width,0.0), Offset(0.0, playAreaSize.height)],
      ]);

      // await StorageMethods().getLevelsFromJson();
      // getLevelData(_settings);
    });
  }
  @override
  Widget build(BuildContext context) {
    SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    return FutureBuilder(
      future: getCampaignData(_settings),
      builder: (context, AsyncSnapshot<void> futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (futureSnapshot.hasError) {
          return const SizedBox(
            child: Text("error"),
          );
        } else {
          return Consumer<SettingsController>(
            builder: (context,settings,child) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: const Color.fromARGB(255, 65, 65, 65),
                  body: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // width: ,
                            // height: settingsState.playAreaSize.height*0.2,
                            height: MediaQuery.of(context).size.height*0.15,
                            child: const Center(
                              child: Text(
                                "Lokuro",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: const Color.fromARGB(255, 230, 228, 228)
                                ),
                              ),
                            ),
                            
                          ),


                          Column(
                            children: displayCampaigns(settings, settingsState),
                          )


                          // Text("campaigns: ${settings.campaignData.value.length}")


              
                          // const Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Novice",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: displayLevels(settings.levelData.value)
                          //   // children: displayLevels(_settings),
                          // ),
                       
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Novice",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: const Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: getLevelButtons(settingsState,"novice")
                          //   // children: displayLevels(_settings),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Divider(thickness:2.0, color: Colors.grey,),
                          // ),
              
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Easy",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: const Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: getLevelButtons(settingsState,"easy")
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Divider(thickness:2.0, color: Colors.grey,),
                          // ),
              
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Intermediate",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: const Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: getLevelButtons(settingsState,"intermediate")
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Divider(thickness:2.0, color: Colors.grey,),
                          // ),
              
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Advanced",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: const Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: getLevelButtons(settingsState,"advanced")
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Divider(thickness:2.0, color: Colors.grey,),
                          // ),
              
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Hard",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: const Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: getLevelButtons(settingsState,"hard")
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Divider(thickness:2.0, color: Colors.grey,),
                          // ), 
              
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Align(
                          //     alignment:Alignment.centerLeft,
                          //     child: Text(
                          //       "Diabolical",
                          //       style: TextStyle(
                          //         fontSize: 28,
                          //         color: const Color.fromARGB(255, 230, 228, 228)
                          //       ),
                          //     )
                          //   ),
                          // ),
                          // Wrap(
                          //   children: getLevelButtons(settingsState,"diabolical")
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: Divider(thickness:2.0, color: Colors.grey,),
                          // ),                                                                                
                        ],
                      ),
                    )
                  ),
                ),
              );
            }
          );          
        }
      }
    );
  }
}

// List<Widget> getLevelButtons(SettingsState settingsState, String difficulty) {

//   List<Widget> levelButtons = [];
  
//   for (int i = 1; i< settingsState.levelData.length; i++) {
//     if (settingsState.levelData[i]["difficulty"]==difficulty) {
//       Widget levelButton = LevelButton(index: i);
//       levelButtons.add(levelButton);
//     }
//   }
//   return levelButtons;
// }

// List<Widget> displayLevels(List<dynamic> levelData,) {

//   List<Widget> levelButtons = [];
  
//   for (int i = 0; i< levelData.length; i++) {
//     // if (levelData[i]["difficulty"]==difficulty) {
//       Widget levelButton = LevelButton(index: i,);
//       levelButtons.add(levelButton);
//     // }
//   }
//   return levelButtons;
// }


Future<void> getCampaignData(SettingsController settings) async {
  // List<dynamic> levelData = settings.levelData.value;

  // if local storage is empty - get the level data as json payload and set it
  if (settings.levelData.value.isEmpty) {
    print("data is empty - load it");
    await StorageMethods().saveCampaignDataFromJsonFileToLocalStorage(settings);
  } else {
    print("level data is not empty: ${settings.levelData.value}");
    await StorageMethods().saveCampaignDataFromJsonFileToLocalStorage(settings);
  }
  // print("level data: $levelData");
  // List<dynamic> levelData = 
}

Future<List<dynamic>> getLevelDataFromLocalStorage(SettingsController settings) async {

  final List<dynamic> levelData = await StorageMethods().getLevelDataFromJsonFile(settings);  

  return levelData;
}


List<Widget> displayCampaigns(SettingsController settings, SettingsState settingsState) {
  List<Widget> res = [];
  for (int i=0; i<settings.campaignData.value.length; i++) {
    // Map<String,dynamic> campaign = settings.campaignData.value[i];
    Widget widget = CampaignButton(index: i);
    // Widget widget = GestureDetector(
    //   onTap:() => General().navigateToLevel(context,index,settingsState,gamePlayState,animationState,settings),
    //   child: Padding(
    //     padding: EdgeInsets.all(8.0),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: const Color.fromARGB(255, 220, 141, 236),
    //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
    //         boxShadow: [
    //           BoxShadow(color: const Color.fromARGB(134, 58, 57, 57), offset: Offset.zero, blurRadius: 20.0, spreadRadius: 5.0),
    //           BoxShadow(color: const Color.fromARGB(62, 223, 221, 221), offset: Offset.zero, blurRadius: 10.0, spreadRadius: 3.0),
    //         ]
    //       ),
    //       width: settingsState.playAreaSize.width*0.6,
    //       child: Padding(
    //         padding: EdgeInsets.all(5.0),
    //         child: Text(
    //           campaign["campaignName"],
    //           style: TextStyle(
    //             color: Colors.black,
    //             fontSize: 22
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    res.add(widget);
  }
  return res;
}