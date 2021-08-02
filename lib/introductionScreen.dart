import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:HUFSHindiAssistant/main.dart';

class onboardingpage extends StatefulWidget {
  @override
  _onboardingpageState createState() => _onboardingpageState();
}

class _onboardingpageState extends State<onboardingpage> {
  SharedPreferences _preference;
  @override
  initState() {
    // 부모의 initState호출
    super.initState();
  }

  // var horizontal_size;
  // var vertical_size;
  //
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   horizontal_size = MediaQuery.of(context).size.width;
  //   vertical_size = (MediaQuery.of(context).size.height -
  //       AppBar().preferredSize.height -
  //       MediaQuery.of(context).padding.top -
  //       MediaQuery.of(context).padding.bottom);
  // }

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

     //가로 화면 변경 방지
     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return WillPopScope(
      child: MaterialApp(
        title: 'Introduction screen',
        debugShowCheckedModeBanner: false,
        theme:  ThemeData(primarySwatch: Colors.blue),
        home: OnBoardingPage(),
      ),
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) =>
               AlertDialog(title: Text('단어장을 종료할까요?'), actions: <Widget>[
                RaisedButton(
                    child: Text('아니오'),
                    onPressed: () => Navigator.of(context).pop(false)),
                RaisedButton(child: Text('예'), onPressed: () => exit(0)),
              ])),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  //instancememory는 초기 시작 때 튜토리얼을 확인했는지 확인하기 위한 변수이다.
  SharedPreferences _instance;

  changeIntroDecision() async {
    // SharedPreferences의 인스턴스를 필드에 저장
    this._instance = await SharedPreferences.getInstance();
    setState(() {
      this._instance.setBool('first_experience', true);
    });
  }

  _onIntroEnd(context) {
    changeIntroDecision();

    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (BuildContext context) => MyApp()),(route)=>false,
    );
  }

  Widget _buildImage(String assetName, var horizontal_size, var vertical_size) {
    return Align(
      child: Image.asset(
        'pictures/$assetName.jpg',
        height: vertical_size * 0.45,
        width: horizontal_size,
      ),
      alignment: Alignment.bottomCenter,
    );
  }


  var horizontal_size ;
  var vertical_size;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);
  }

  @override
  Widget build(BuildContext context) {


    const bodyStyle = TextStyle(fontSize: 18.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
        child: IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "시작하기",
          body:
              "CFLPT 단어장은 4가지 방식으로 학습할 수 있습니다. 단어장 형식, 카드 형식, 객관식 형식으로 단어 학습이 가능합니다. 또한 문장을 퀴즈 형식으로 학습할 수 있습니다.",
          image:
              _buildImage('introduction/main', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),

        PageViewModel(
          title: "나의 단어, 문장 복습",
          body:
              "단어 학습 후 잘 안 외워진 단어를 여기서 복습할 수 있습니다. 메인 메뉴에서 오른쪽으로 스와이프하면 나만의 단어장, 문장 기능을 확인할 수 있습니다.",
          image: _buildImage('introduction/myword',
              horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "단어장 방식 암기하기",
          body:
          "기존 단어장 형식으로 단어를 암기할 수 있습니다.\n 해당 단어를 클릭하면 관련 예제 문장을 볼 수 있습니다.",
          image: _buildImage(
              'introduction/listvoca', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "나의 단어 저장하기",
          body: "오른쪽으로 스와이프하면 단어 저장 버튼이 등장합니다.\n복습 후 암기된 단어를 저장합니다.",
          image: _buildImage(
              'introduction/listvoca_save', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),


        PageViewModel(
          title: "카드 형식 단어장",
          body: "해당 카드를 터치하면 뜻과 예시 문장이 등장합니다.\n 문장 학습은 카드 암기 방식이 존재하지 않습니다.",
          image: _buildImage(
              'introduction/card', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "카드 형식 단어장 저장",
          body:
          "카드를 아래에서 위로 스와이프하면 해당 단어를 저장합니다.\n 카드 뒷면(한국어 의미, 예제)에서는 단어가 저장되지 않습니다.",
          image: _buildImage(
              'introduction/card_save', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "문장 학습",
          body:
              "O,X 퀴즈 형식입니다. 해석이 맞으면 O를 선택하세요!\n틀린 문장은 자동으로 나의 문장 학습에 저장됩니다. 힌트는 문제의 핵심 단어를 보여줍니다.",
          image: _buildImage(
              'introduction/sentencetest', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "단어 테스트",
          body:
              "정답을 선택하세요!\n틀린 단어는 자동으로 나의 단어 학습에 저장됩니다. 한국어 문제 버튼을 누르면 문제와 예시가 바뀝니다.",
          image: _buildImage(
              'introduction/wordtest', horizontal_size, vertical_size),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "시험 결과",
          body: "해당 단원 단어 테스트, 문장 학습이 완료되면 점수와 틀린 단어를 볼 수 있습니다.",
          image: _buildImage('introduction/resultpage', horizontal_size,
              vertical_size),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      isProgress: false,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: const Size(8.0, 8.0),
        color: const Color(0xFFBDBDBD),
        activeSize: const Size(15.0, 8.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    ));
  }
}
