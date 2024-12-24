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
      print("padding top: $paddingTop");
      const double controlBarHeight = 100.0;
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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (futureSnapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error")));
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




Future<void> getCampaignData(SettingsController settings) async {
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
    Widget widget = CampaignButton(index: i);
    res.add(widget);
  }
  return res;
}