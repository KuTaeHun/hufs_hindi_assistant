import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view.dart';
import 'package:HUFSHindiAssistant/function/pageroute.dart';
import 'package:HUFSHindiAssistant/hindiCommonVoca.dart';
import 'package:HUFSHindiAssistant/main.dart';
import 'package:HUFSHindiAssistant/word_list_page/words.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:HUFSHindiAssistant/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:HUFSHindiAssistant/function/finish_alert_function.dart';
import 'package:HUFSHindiAssistant/function/unmemory_list.dart';
import 'package:flutter/services.dart';

class word_one_by_one_view extends StatelessWidget {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int start_word_num;
  int finish_word_num;
  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  //생성자 , 첫 번째 범위, 두 번째, 세 번째 단원을 나누는 범위
  word_one_by_one_view(
      {Key key,
      @required this.start_word_num,
      @required this.finish_word_num,
      @required this.page_name,
      @required this.file_name}) {
    this.word_list = make_word_list(start_index:start_word_num,finish_index:finish_word_num, words_level:file_name,file_name: page_name);

    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  Widget build(BuildContext context) {

    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
        child: AnimatedFlipCard(
            start_word_num, finish_word_num, page_name, file_name),
      ),
    );
  }
}

class AnimatedFlipCard extends StatefulWidget {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  AnimatedFlipCard(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_index:start_word_num,finish_index:finish_word_num, words_level:file_name,file_name: page_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _AnimatedFlipCardState createState() => _AnimatedFlipCardState(
      _start_word_num, _finish_word_num, page_name, file_name);
}

class _AnimatedFlipCardState extends State<AnimatedFlipCard>
    with TickerProviderStateMixin {
  AnimationController _flipCardController;
  Animation<double> _frontAnimation;
  Animation<double> _backAnimation;

  //해당 단어 파트 이름
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
  int _total_itemcount;

  //카드별 단어 내용
  var hindi_word = '';
  var korean_word = '';
  var word_case = '';
  var korean_example = '';
  var hindi_example = '';

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  _AnimatedFlipCardState(int start_word_num, int finish_word_num,
      String page_name, String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_index:start_word_num,finish_index:finish_word_num, words_level:file_name,file_name: page_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수
  int index = 0;
  int count = 1;

  @override
  void initState() {
    super.initState();

    _flipCardController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    // play from 0  to 0.5s
    _frontAnimation = Tween<double>(begin: 0.0, end: 0.5 * pi).animate(
        CurvedAnimation(parent: _flipCardController, curve: Interval(0, 0.5)));

    // delay in 0.5s(wait for the front flip completed) and then play
    _backAnimation = Tween<double>(begin: 1.5 * pi, end: 2 * pi).animate(
        CurvedAnimation(parent: _flipCardController, curve: Interval(0.5, 1)));
  }

  @override
  void dispose() {
    _flipCardController.dispose();
    super.dispose();
  }

  void flipCard() {
    if (_flipCardController.isDismissed) {
      _flipCardController.forward();
    } else {
      _flipCardController.reverse();
    }
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


    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
        child: new FutureBuilder(
            future:
                make_word_list(start_index:_start_word_num,finish_index:_finish_word_num, words_level:file_name,file_name: page_name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (index == 0 && count == 1) {
                  this.hindi_word = snapshot.data[index][0].toString();
                  this.word_case = snapshot.data[index][1].toString();
                  this.korean_word = snapshot.data[index][2].toString();
                  this.hindi_example = snapshot.data[index][3].toString();
                  this.korean_example = snapshot.data[index][4].toString();
                }

                //양 옆으로 밀었을 때 swipe 하는 기능
                void _onHorizontalDragStartHandler(DragStartDetails details) {
                  setState(() {
                    if (details.globalPosition.dx.floorToDouble() <
                        horizontal_size * 0.5) {
                      if (this.index > 0) {
                        this.index--;
                        count--;
                      }
                    } else {
                      if (this.index == _total_itemcount - 1) {
                        alert_backto_lobi(context, this.file_name);
                      }
                      if (this.index < _total_itemcount - 1) {
                        this.index++;
                        count++;
                      }
                    }
                    this.hindi_word = snapshot.data[index][0].toString();
                    this.word_case = snapshot.data[index][1].toString();
                    this.korean_word = snapshot.data[index][2].toString();
                    this.hindi_example = snapshot.data[index][3].toString();
                    this.korean_example = snapshot.data[index][4].toString();
                    this.count = count;
                  });
                }

                void _onVerticalDragStartHandler(DragStartDetails details) {
                  setState(() {
                    if (details.globalPosition.dy.floorToDouble() >
                        vertical_size * 0.3) {
                      setState(() {
                        unMemory_words(words:snapshot.data[index][0]
                            .toString(),
                            word_class:snapshot.data[index][1]
                                .toString(),
                            mean:snapshot.data[index][2]
                                .toString(),
                            example_hindi:snapshot.data[index][3]
                                .toString(),
                            example_korean:snapshot.data[index][4]
                                .toString());
                      });

                      var snackbar = SnackBar(
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                        content: const Text(
                          "미암기 단어장에 해당 단어가 추가되었습니다.",
                          style: TextStyle(color: Colors.black),
                        ),
                        action: SnackBarAction(
                          label: "확인",
                          onPressed: () {},
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackbar);
                    }
                  });
                }

                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      leading: Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                             backtoChapterList(context: context, file_name: file_name);
                            },
                          );
                        },
                      ),
                      shadowColor: Colors.black26,
                      centerTitle: true,
                      backgroundColor: const Color.fromARGB(240, 10, 15, 64),
                      title:const Text(
                        "HUFS 힌디어 학습 도우미",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'hufsfontMedium',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    body: Container(
                      width: horizontal_size,
                      height: vertical_size,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            width: horizontal_size,
                            height: vertical_size * 0.06,
                            decoration:
                            const BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(1.5, 0),
                              )
                            ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: horizontal_size * 0.4,
                                  height: vertical_size * 0.05,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left: 0.5),
                                  child: Text(
                                    page_name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'hufsfontMedium',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: horizontal_size * 0.32,
                                  height: vertical_size * 0.05,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "단어 수: " +
                                        _total_itemcount.toString() +
                                        "개",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'hufsfontMedium',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: vertical_size * 0.81,
                            width: horizontal_size,
                            alignment: Alignment.center,
                            child: Center(
                              // ignore: missing_return
                              child: Stack(
                                children: <Widget>[
                                  AnimatedBuilder(
                                      child: GestureDetector(
                                        child: CustomCard_Behind(
                                            this.korean_word,
                                            this.word_case,
                                            this.hindi_example,
                                            this.korean_example,
                                            this.count,
                                            this._total_itemcount,
                                            const Color.fromARGB(240, 150, 131, 60)),
                                        onTap: flipCard,
                                        onHorizontalDragStart:
                                            _onHorizontalDragStartHandler,
                                      ),
                                      animation: _backAnimation,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Transform(
                                          alignment: FractionalOffset.center,
                                          child: child,
                                          transform: Matrix4.identity()
                                            ..rotateY(_backAnimation.value),
                                        );
                                      }),
                                  AnimatedBuilder(
                                      child: GestureDetector(
                                        child: CustomCard_Front(
                                            this.hindi_word,
                                            this.count,
                                            this._total_itemcount,
                                            Color.fromARGB(240, 112, 126, 250)),
                                        onTap: flipCard,
                                        onHorizontalDragStart:
                                            _onHorizontalDragStartHandler,
                                        onVerticalDragStart:
                                            _onVerticalDragStartHandler,
                                      ),
                                      animation: _frontAnimation,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Transform(
                                          alignment: FractionalOffset.center,
                                          child: child,
                                          transform: Matrix4.identity()
                                            ..rotateY(_frontAnimation.value),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else
                return const Text("한 개당 보여주는 단어장 로딩 Failed");
            }),
        onWillPop: () async {
          backtoChapterList(context: context, file_name: file_name);
        });
  }
}

class CustomCard_Front extends StatelessWidget {
  String _hindi_word;
  Color color;
  int count;
  String total_count;

  CustomCard_Front(
      String _hindi_word, int count, int total_count, Color color) {
    this._hindi_word = _hindi_word;
    this.color = color;
    this.count = count;
    this.total_count = total_count.toString();
  }

  @override
  Widget build(BuildContext context) {

    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    var horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);

    return Container(
        decoration: BoxDecoration(
            color: this.color,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10.0, 10.0),
                  blurRadius: 20.0,
                  spreadRadius: 0.0)
            ]),
        width: horizontal_size * 0.8,
        height: vertical_size * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: horizontal_size * 0.75,
              height: vertical_size * 0.08,
              child: Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  this.count.toString() + "/" + this.total_count,
                  style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: horizontal_size * 0.5,
              height: vertical_size * 0.4,
              child: Container(
                alignment: Alignment.center,
                child: AutoSizeText(
                  this._hindi_word,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                  maxLines: 2,
                  minFontSize: 35,
                ),
              ),
            )
          ],
        ));
  }
}

class CustomCard_Behind extends StatelessWidget {
  String _korean_word;
  String _word_class;
  String _hindi_example;
  String _korean_example;
  int count;
  int total_count;
  Color color;

  CustomCard_Behind(
      String _korean_word,
      String _word_class,
      String _hindi_example,
      String _korean_example,
      int count,
      int total_count,
      Color color) {
    this._korean_word = _korean_word;
    this._word_class = _word_class;
    this._hindi_example = _hindi_example;
    this._korean_example = _korean_example;
    this.count = count;
    this.total_count = total_count;
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {

    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);

    return Container(
        decoration: BoxDecoration(
            color: this.color,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10.0, 10.0),
                  blurRadius: 20.0,
                  spreadRadius: 0.0)
            ]),
        width: horizontal_size * 0.8,
        height: vertical_size * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.05,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: AutoSizeText(
                    this.count.toString() + "/" + total_count.toString(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                    maxLines: 1,
                    minFontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(height: vertical_size * 0.03),
            Container(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.15,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: AutoSizeText(
                  this._korean_word,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'hufsfontMedium'),
                  maxLines: 3,
                  presetFontSizes: [35, 25, 21],
                ),
              ),
            ),
            Container(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.05,
              alignment: Alignment.center,
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: AutoSizeText(
                  this._word_class,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  maxLines: 3,
                  minFontSize: 10,
                ),
              ),
            ),
            SizedBox(height: vertical_size * 0.023),
            Container(
              width: horizontal_size * 0.7,
              height: vertical_size * 0.28,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset:  Offset(5.0, 5.0),
                        blurRadius: 5.0,
                        spreadRadius: 0.0)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: horizontal_size * 0.7,
                    height: vertical_size * 0.07,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: horizontal_size * 0.64,
                        height: vertical_size * 0.05,
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child:const  AutoSizeText(
                          "예제",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3),
                          maxLines: 1,
                          minFontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: vertical_size * 0.01),
                  Container(
                    width: horizontal_size * 0.7,
                    height: vertical_size * 0.11,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                      child: AutoSizeText(
                        this._hindi_example,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                        maxLines: 3,
                        presetFontSizes: [25, 18, 15],
                        minFontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: vertical_size * 0.005),
                  Container(
                    height: vertical_size * 0.07,
                    width: horizontal_size * 0.7,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: AutoSizeText(
                        this._korean_example,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                        maxLines: 3,
                        minFontSize: 8,
                        presetFontSizes: [16, 12, 8],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
