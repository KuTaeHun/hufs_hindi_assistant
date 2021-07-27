import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view.dart';
import 'package:HUFSHindiAssistant/hindiCommonVoca_Sentence.dart';
import 'package:HUFSHindiAssistant/hindiCommonVoca.dart';
import 'package:HUFSHindiAssistant/setting.dart';

import 'package:HUFSHindiAssistant/home.dart';
import 'package:HUFSHindiAssistant/myVoca.dart';
import 'package:HUFSHindiAssistant/mySentence.dart';

import 'package:HUFSHindiAssistant/introductionScreen.dart';
import 'dart:ui';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String current_word = '';
  String current_sentence = '';
  int current_score_word =0;
  int current_score_sentence=0;
  //instancememory는 초기 시작 때 튜토리얼을 확인했는지 확인하기 위한 변수이다.
  SharedPreferences _instancememory;
  //show one time은 만약 튜토리얼 확인을 했으면 안 보이게 결정할 수 있는 변수이다.
  bool show_one_time =false;


  //_makeInstance는 튜토리얼 관련 인스턴스 생성 및 default면 show one time을 true로 놓아 처음 이 앱을 쓴다는 것을 확인
  makeInstance() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    this._instancememory = await SharedPreferences.getInstance();
    setState(() {
      this.show_one_time = (_instancememory.getBool('first_experience')??false);
    });



  }
  keep_remember() async{
    //기존 학습 했던 단어, 문장 부분, 평균 단어 정답률, 평균 문장 정답률
    this._instancememory = await SharedPreferences.getInstance();
    setState(() {
      this.current_word = (_instancememory.getBool('current_w')??'학습 데이터가 없습니다.');

    });
  }


  @override
  Widget build(BuildContext context) {

    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    makeInstance();
    if(this.show_one_time==false)
    {

      return onboardingpage();
    }


    else
      return WillPopScope(

        onWillPop: (){},
        child: MaterialApp(
          title: "HUFS 힌디 학습 도우미",
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
          home:  DefaultTabController(
            length: 4,
            child: Main_AppBar(),
          ),
        ),);
  }
}

class Main_AppBar extends StatefulWidget {


  @override
  _Main_AppBarState createState() => _Main_AppBarState();
}

class _Main_AppBarState extends State<Main_AppBar> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {


    return
      SafeArea(
        key:_scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {


                return  IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                  MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            shadowColor: Colors.white,
            centerTitle: true,
            backgroundColor: const Color.fromARGB(240, 10, 15, 64),
            title: const Text(
              'HUFS 힌디어 학습 도우미',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'hufsfontMedium',
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.white,

              labelColor: Colors.white,
              isScrollable: false,
              indicatorWeight: 1,
              tabs: [
                Tab(text: '홈'),
                Tab(text: '문장 시험'),
                Tab(text: '시험 단어'),
                Tab(text: '설정')
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: home()),
              Center(child: hindiCommonVocaSentence()),
              Center(child: hindiCommonVoca()),
              Center(child: setting())
            ],
          ),

          //Drawer Function in left side
          drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SafeArea(
                    child: Container(
                      height: 100.0,
                      child: DrawerHeader(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "특수외국어 진흥원",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      fontFamily: 'hufsfontLight',
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "한국외국어대학교",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      fontFamily: 'hufsfontLight',
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: const CircleAvatar(
                                  radius: 22,
                                  backgroundImage: AssetImage(
                                    'pictures/indiaflag.jpg',
                                  )),
                            )
                          ],
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(240, 10, 15, 64),
                        ),
                      ),
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      '나의 단어 복습',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'hufsfontLight',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: const Icon(
                      Icons.spellcheck,
                      size: 20,
                    ),
                    selectedTileColor: Colors.white54,
                    onTap: () {

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (BuildContext context) => myVoca()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.sort_by_alpha,
                      size: 20,
                    ),
                    title: const Text(
                      '나의 문장 복습',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'hufsfontLight',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selectedTileColor: Colors.white70,
                    onTap: () {

                      Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (BuildContext context) => mySentence()),
                      );
                    },
                  ),
                ],
              )),
        ),

      );
  }
}
