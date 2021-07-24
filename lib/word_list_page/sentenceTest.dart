import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/scheduler.dart';

import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view_sentence.dart';

import 'package:HUFSHindiAssistant/function/pageroute.dart';

import 'package:HUFSHindiAssistant/function/unmemory_list.dart';

import 'package:HUFSHindiAssistant/word_list_page/words.dart';

import 'package:flutter/material.dart';

import 'package:dotted_line/dotted_line.dart';

import 'package:HUFSHindiAssistant/function/test_result_sentence_page.dart';

class sentenceTest extends StatefulWidget {
  //단어 레벨 타이틀

  String page_name;

  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수

  int _start_word_num;

  int _finish_word_num;

  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴

  Future<List<dynamic>> word_list;

  sentenceTest(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    Key:
    key;

    this._start_word_num = start_word_num;

    this._finish_word_num = finish_word_num;

    this.word_list = make_word_list(
        start_index: start_word_num,
        finish_index: finish_word_num,
        words_level: file_name,
        file_name: page_name);

    this.page_name = page_name;

    this.file_name = file_name;

    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _sentenceTestState createState() => _sentenceTestState(
      _start_word_num, _finish_word_num, page_name, file_name);
}

class _sentenceTestState extends State<sentenceTest> {
  //단어 레벨 타이틀

  String page_name;

  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수

  int _start_word_num;

  int _finish_word_num;

  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴

  Future<List<dynamic>> word_list;

  _sentenceTestState(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;

    this._finish_word_num = finish_word_num;

    this.word_list = make_word_list(
        start_index: start_word_num,
        finish_index: finish_word_num,
        words_level: file_name,
        file_name: page_name);

    this.page_name = page_name;

    this.file_name = file_name;

    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  Widget build(BuildContext context) {
    return sentence(this._start_word_num, this._finish_word_num, this.page_name,
        this.file_name);
  }
}

/// This is the stateful widget that the main application instantiates.

class sentence extends StatefulWidget {
  //sentence({Key key}) : super(key: key);

  //단어 레벨 타이틀

  String page_name;

  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수

  int _start_word_num;

  int _finish_word_num;

  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴

  Future<List<dynamic>> word_list;

  sentence(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    Key:
    key;

    this._start_word_num = start_word_num;

    this._finish_word_num = finish_word_num;

    this.word_list = make_word_list(
        start_index: start_word_num,
        finish_index: finish_word_num,
        words_level: file_name,
        file_name: page_name);

    this.page_name = page_name;

    this.file_name = file_name;

    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  @override
  _sentenceState createState() =>
      _sentenceState(_start_word_num, _finish_word_num, page_name, file_name);
}

/// This is the private State class that goes with MyStatefulWidget.

class _sentenceState extends State<sentence> {
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

  var korean_wrong_example = '';

  //정답 번호

  var right_num = '';

  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수

  int index = 0;

  int count = 1;

  //맞은 갯수, 틀린 갯수

  int correct = 0;

  int incorrect = 0;

  Color hint_color;

  //결과 페이지 한 번만 보여주게 만드는 변수

  bool result_page_one_time = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //이번 해당 장에 틀린 힌디어 단어 리스트

  List<String> wrong_hindi_words = new List<String>();

  List<String> wrong_korean_words = new List<String>();

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴

  Future<List<dynamic>> word_list;

  _sentenceState(int start_word_num, int finish_word_num, String page_name,
      String file_name) {
    this._start_word_num = start_word_num;

    this._finish_word_num = finish_word_num;

    this.word_list = make_word_list(
        start_index: start_word_num,
        finish_index: finish_word_num,
        words_level: file_name,
        file_name: page_name);


    this.page_name = page_name;

    this.file_name = file_name;


    this._total_itemcount = finish_word_num - start_word_num + 1;

    this.hint_color = Colors.white;
  }

  var horizontal_size;

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
    return WillPopScope(
        child: new FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (index == 0 && count == 1) {
                this.hindi_word = snapshot.data[index][0].toString();

                this.word_case = snapshot.data[index][1].toString();

                this.korean_word = snapshot.data[index][2].toString();

                this.hindi_example = snapshot.data[index][3].toString();

                this.korean_example = snapshot.data[index][4].toString();

                this.korean_wrong_example = snapshot.data[index][5].toString();

                this.right_num = snapshot.data[index][6].toString();
              } else {
                try {
                  if (index < _total_itemcount && count <= _total_itemcount) {
                    this.hindi_word = snapshot.data[index][0].toString();

                    this.word_case = snapshot.data[index][1].toString();

                    this.korean_word = snapshot.data[index][2].toString();

                    this.hindi_example = snapshot.data[index][3].toString();

                    this.korean_example = snapshot.data[index][4].toString();

                    this.korean_wrong_example =
                        snapshot.data[index][5].toString();

                    this.right_num = snapshot.data[index][6].toString();
                  } else {
                    if (result_page_one_time) {
                      move_page(context, this.page_name, this._total_itemcount,
                          this.correct, wrong_hindi_words, wrong_korean_words);
                    }

                    result_page_one_time = false;
                  }
                } on Exception catch (_) {
                  if (result_page_one_time) {
                    move_page(context, this.page_name, this._total_itemcount,
                        this.correct, wrong_hindi_words, wrong_korean_words);
                  }

                  result_page_one_time = false;
                }
              }

              return SafeArea(
                child: Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    leading: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 30,
                          ),

                          //목차로 이동하기

                          onPressed: () {
                            sen_show_quit_dialog(context, file_name);
                          },
                        );
                      },
                    ),
                    shadowColor: Colors.black26,
                    centerTitle: true,
                    backgroundColor: Color.fromARGB(240, 10, 15, 64),
                    title: Text(
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
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color.fromARGB(240, 10, 15, 64),
                          Color.fromARGB(240, 108, 121, 240)
                        ])),
                    width: horizontal_size,
                    height: vertical_size,
                    child: Column(
                      children: [
                        //단원 이름, 문제

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          width: horizontal_size,
                          height: vertical_size * 0.06,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
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
                                margin: EdgeInsets.only(left: 0.5),
                                child: Text(
                                  page_name,
                                  style: TextStyle(
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
                                  "단어 수: " + _total_itemcount.toString() + "개",
                                  style: TextStyle(
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

                        SizedBox(height: vertical_size * 0.02),

                        //틀린 문제, 맞은 문제

                        Container(
                          alignment: Alignment.centerLeft,
                          height: 80,
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          width: horizontal_size,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: vertical_size * 0.15,
                                width: horizontal_size * 0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: horizontal_size * 0.4,
                                      margin: EdgeInsets.only(left: 0.5),
                                      child: Text(
                                        "O: " + correct.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 3,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      width: horizontal_size * 0.4,
                                      margin: EdgeInsets.only(left: 0.5),
                                      child: Text(
                                        "X: " + incorrect.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 3,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: vertical_size * 0.15,
                                width: horizontal_size * 0.32,
                                child: Container(
                                  child: Text(
                                    "진행: " +
                                        count.toString() +
                                        "/" +
                                        _total_itemcount.toString(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //문제 카드

                        Container(
                          alignment: Alignment.center,
                          height: vertical_size * 0.7,
                          width: horizontal_size * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black26,
                                    offset: new Offset(10.0, 10.0),
                                    blurRadius: 20.0,
                                    spreadRadius: 10.0)
                              ]),
                          child: Column(
                            children: [
                              //질문 번호

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontal_size * 0.02),
                                alignment: Alignment.centerLeft,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.1,
                                child: AutoSizeText(
                                  "Question" +
                                      count.toString() +
                                      ".\n아래 문장은 올바른 문장입니까?",
                                  minFontSize: 10,
                                  maxFontSize: 20,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontal_size * 0.01),
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.15,
                                child: AutoSizeText(hindi_example,
                                    minFontSize: 20,
                                    maxFontSize: 30,
                                    style: TextStyle(fontSize: 25)),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: horizontal_size * 0.01),
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.15,
                                child: AutoSizeText(korean_wrong_example,
                                    minFontSize: 15,
                                    maxFontSize: 25,
                                    style: TextStyle(fontSize: 20)),
                              ),

                              DottedLine(
                                lineLength: horizontal_size * 0.895,
                                direction: Axis.horizontal,
                                dashColor: Colors.indigo,
                              ),

                              SizedBox(
                                height: vertical_size * 0.02,
                              ),

                              Container(
                                alignment: Alignment.center,
                                width: horizontal_size * 0.9,
                                height: vertical_size * 0.1,
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      width: horizontal_size * 0.2,
                                      height: vertical_size * 0.1,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: horizontal_size * 0.02),
                                      child: OutlineButton(
                                        onPressed: () {
                                          setState(() {
                                            hint_color = Colors.black;
                                          });

                                          //HintDialog(context,hindi_word,korean_word);
                                        },
                                        hoverColor: Colors.black12,
                                        child: AutoSizeText(
                                          "힌트",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: horizontal_size * 0.5,
                                      height: vertical_size * 0.1,
                                      alignment: Alignment.topCenter,
                                      child: AutoSizeText(
                                        hindi_word +
                                            "의 뜻은 " +
                                            korean_word +
                                            " 입니다.",
                                        minFontSize: 10,
                                        maxFontSize: 20,
                                        style: TextStyle(
                                            fontSize: 15, color: hint_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        height: vertical_size * 0.15,
                                        child: Icon(
                                          Icons.panorama_fish_eye,
                                          size: 50,
                                        ),
                                      ),
                                      onTap: () {
                                        // if (_total_itemcount == count) {

                                        //   move_page(

                                        //       context,

                                        //       this.page_name,

                                        //       this._total_itemcount,

                                        //       this.correct,

                                        //       wrong_hindi_words,

                                        //       wrong_korean_words);

                                        // }

                                        setState(() {
                                          count++;

                                          index++;

                                          hint_color = Colors.white;

                                          if (right_num.compareTo('1') == 0)
                                            correct++;
                                          else {
                                            unMemory_sentence(
                                              snapshot.data[index][0]
                                                  .toString(),
                                              snapshot.data[index][1]
                                                  .toString(),
                                              snapshot.data[index][2]
                                                  .toString(),
                                              snapshot.data[index][3]
                                                  .toString(),
                                              snapshot.data[index][4]
                                                  .toString(),
                                              snapshot.data[index][5]
                                                  .toString(),
                                              snapshot.data[index][6]
                                                  .toString(),
                                            );

                                            incorrect++;

                                            wrong_hindi_words.add(snapshot
                                                .data[index][0]
                                                .toString());

                                            wrong_korean_words.add(snapshot
                                                .data[index][2]
                                                .toString());
                                          }
                                        });
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        height: vertical_size * 0.15,
                                        child: Icon(
                                          Icons.clear,
                                          size: 50,
                                        ),
                                      ),
                                      onTap: () {
                                        // if (_total_itemcount == count) {

                                        //   move_page(

                                        //       context,

                                        //       this.page_name,

                                        //       this._total_itemcount,

                                        //       this.correct,

                                        //       wrong_hindi_words,

                                        //       wrong_korean_words);

                                        // }

                                        setState(() {
                                          hint_color = Colors.white;

                                          count++;

                                          index++;

                                          if (right_num.compareTo('0') == 0)
                                            correct++;
                                          else {
                                            unMemory_sentence(
                                              snapshot.data[index][0]
                                                  .toString(),
                                              snapshot.data[index][1]
                                                  .toString(),
                                              snapshot.data[index][2]
                                                  .toString(),
                                              snapshot.data[index][3]
                                                  .toString(),
                                              snapshot.data[index][4]
                                                  .toString(),
                                              snapshot.data[index][5]
                                                  .toString(),
                                              snapshot.data[index][6]
                                                  .toString(),
                                            );

                                            incorrect++;

                                            wrong_hindi_words.add(snapshot
                                                .data[index][0]
                                                .toString());

                                            wrong_korean_words.add(snapshot
                                                .data[index][2]
                                                .toString());
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Text("로딩 실패");
            }
          },
          future: make_word_list(
              start_index: _start_word_num,
              finish_index: _finish_word_num,
              words_level: file_name,
              file_name: page_name),
        ),
        onWillPop: () async {
          sen_show_quit_dialog(context, file_name);
        });
  }

  HintDialog(BuildContext context, String hindi_word, String korea_word) {
    // set up the button

    Widget okButton = FlatButton(
      child: Text("확인"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog

    AlertDialog alert = AlertDialog(
      title: Text("단어 힌트"),
      content: Text(hindi_word + "의 뜻은 " + korean_word + "입니다."),
      actions: [
        okButton,
      ],
    );

    // show the dialog

    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } //페이지 이동

  void move_page(
      BuildContext context,
      String page_name,
      int _total_itemcount,
      int correct,
      List<String> wrong_hindi_words,
      List<String> wrong_korean_words) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => test_sentence_result(
                  page_name,
                  _total_itemcount,
                  correct,
                  wrong_hindi_words,
                  wrong_korean_words)),
          (route) => false);
    });
  }
}
