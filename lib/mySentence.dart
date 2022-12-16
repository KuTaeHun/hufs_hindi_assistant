import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/scheduler.dart';

import 'package:flutter/material.dart';

import 'package:dotted_line/dotted_line.dart';

import 'package:HUFSHindiAssistant/function/pageroute.dart';

import 'package:HUFSHindiAssistant/function/test_result_page.dart';

import 'package:HUFSHindiAssistant/word_list_page/Test_voca.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class mySentence extends StatefulWidget {
  mySentence() {
    Key:
    key;
  }

  @override
  _mySentenceState createState() => _mySentenceState();
}

class _mySentenceState extends State<mySentence> {
  _mySentenceState() {}

  @override
  Widget build(BuildContext context) {

    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return sentence();
  }
}

/// This is the stateful widget that the main application instantiates.

class sentence extends StatefulWidget {
  sentence() {
    Key:
    key;
  }

  @override
  _sentenceState createState() => _sentenceState();
}

/// This is the private State class that goes with MyStatefulWidget.

class _sentenceState extends State<sentence> {
  //단어 리스트에 있는 인덱스와 한 번 만 초기화하기 위한 count 변수

  int index = 0;

  int count = 0;

  //맞은 갯수, 틀린 갯수

  int correct = 0;

  int incorrect = 0;

  Color hint_color = Colors.white;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences wordlist;

  _sentenceState() {
    firstoperate();
  }

  //이번 해당 장에 틀린 힌디어 단어 리스트

  List<String> wrong_hindi_words = [];

  List<String> wrong_korean_words = [];

  //이번 해당 장에 맞은 힌디어 단어 리스트

  //맞은 단어는 로컬 스토리지에서 제거하기 위해서 필요한 변수.

  List<String> right_hindi_words = [];

  List<String> right_korean_words = [];

  Future<Map> data;

  firstoperate() async {
    this.count = await _loading_total_words();

    int temp = await _loading();

    this.data = _extractString(temp);
  }

  //문장 시험 후 틀린 단어 중 null이 아닌 유효한 값을 가져오는 함수.

  Future<int> _loading_total_words() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();

    Future<int> count_num;

    setState(() {
      count_num = Future(() {
        if ((wordlist.getInt('total_count_sen')) == null) {
          wordlist.setInt('total_count_sen', 0);

          return wordlist.getInt('total_count_sen');
        } else
          return (wordlist.getInt('total_count_sen') ?? 0);
      });
    });

    return count_num;
  }

  //문장 시험 후 저장된 단어 중 null을 포함하여 저장된 단어 갯수를 가져오는 함수.

  Future<int> _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();

    var count_num;

    setState(() {
      count_num = Future(() {
        if ((wordlist.getInt('count_num_sen')) == null) {
          wordlist.setInt('count_num_sen', 0);

          return wordlist.getInt('count_num_sen');
        } else
          return (wordlist.getInt('count_num_sen') ?? 0);
      });
    });

    return count_num;
  }

  //결과 페이지 한 번만 보여주게 만드는 변수

  bool result_page_one_time = true;

  Future<Map> _extractString(int index) async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();

    Map data = {
      'hindi': [],
      'case': [],
      'korean': [],
      'hindi_example': [],
      'korean_example': [],
      'korean_wrong_example': [],
      'right': []
    };

    int count = 0;


    if (index != 0) {
      count = wordlist.getInt("total_count_sen");


      setState(() {
        for (int i = 1; i < index + (1); i++) {
          String temp = wordlist.getString("s_word" + (i.toString()));



          if (temp != null) {
            data['hindi'].add(wordlist.getString("s_word" + (i.toString())));

            data['case']
                .add(wordlist.getString("s_word_class" + (i.toString())));

            data['korean'].add(wordlist.getString("s_mean" + (i.toString())));

            data['hindi_example']
                .add(wordlist.getString("s_example_hindi" + (i.toString())));

            data['korean_example']
                .add(wordlist.getString("s_example_korean" + (i.toString())));

            data['korean_wrong_example'].add(
                wordlist.getString('s_example_wrong_korean' + (i.toString())));

            data['right'].add(wordlist.getString('s_right' + (i.toString())));
          }
        }
      });
    }

    return data;
  }

  removesentence(List<String> right_hindi, List<String> wrong_hindi) async {
    var wrong_words_count, right_words_count, total_count;

    SharedPreferences wordlist = await SharedPreferences.getInstance();

    total_count = wordlist.getInt('count_num_sen');

    wrong_words_count = wrong_hindi.length;

    right_words_count = right_hindi.length;

    wordlist.setInt('total_count_sen', wrong_words_count);

    setState(() {
      for (int i = 0; i < right_words_count; i++)
        for (int j = 1; j < total_count + 1; j++) {
          if (wordlist.getString('s_word' + (j.toString())) != null) {
            if (right_hindi[i].compareTo('s_word' + (j.toString())) == 0) {
              wordlist.remove('s_word' + (j.toString()));

              wordlist.remove('s_word_class' + (j.toString()));

              wordlist.remove('s_mean' + (j.toString()));

              wordlist.remove('s_example_hindi' + (j.toString()));

              wordlist.remove('s_example_korean' + (j.toString()));

              wordlist.remove('s_example_wrong_korean' + (j.toString()));

              wordlist.remove('s_right' + (j.toString()));
            }
          }
        }
    });
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
        child: FutureBuilder(
          future: this.data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                height: vertical_size,
                width: horizontal_size,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (this.count == 0)
                return noitem(context);
              else {
                if (index == count) {
                  return Container(
                    width: horizontal_size,
                    height: vertical_size,
                    child: test_result('복습 단어 추천', count, correct,
                        wrong_hindi_words, wrong_korean_words),
                  );
                } else {
                  return yesitem(context, snapshot);
                }
              }
            }
          },
        ),
        onWillPop: () async {
          listtoMain(context: context);
        });
  }

  Widget noitem(BuildContext context) {
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
                listtoMain(context: context);
              },
            );
          },
        ),
        shadowColor: Colors.black26,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(240, 10, 15, 64),
        title: const Text(
          "HUFS 힌디어 학습 도우미",
          style: const TextStyle(
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
          alignment: Alignment.center,
          color: Colors.white70,
          child: const Text(
            "저장된 복습 문장이 없습니다.\n문장 학습 후 복습 문장을 확인하세요.",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black26,
                fontSize: 20),
          )),
    ));
  }

  Widget yesitem(BuildContext context, AsyncSnapshot snapshot) {
    if (result_page_one_time) {
      if (count == index) {
        move_page(context, '복습 단어 추천', count, correct, wrong_hindi_words,
            wrong_korean_words);

        result_page_one_time = false;
      }
    }

    return WillPopScope(
        child: SafeArea(
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
                      listtoMain(context: context);
                    },
                  );
                },
              ),
              shadowColor: Colors.black26,
              centerTitle: true,
              backgroundColor: const Color.fromARGB(240, 10, 15, 64),
              title: const Text(
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
              decoration: const BoxDecoration(
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
                  SizedBox(height: vertical_size * 0.02),

                  //틀린 문제, 맞은 문제

                  Container(
                    alignment: Alignment.centerLeft,
                    height: 80,
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                margin: const EdgeInsets.only(left: 0.5),
                                child: Text(
                                  "O: " + correct.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 3,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: horizontal_size * 0.4,
                                margin: const EdgeInsets.only(left: 0.5),
                                child: Text(
                                  "X: " + incorrect.toString(),
                                  style: const TextStyle(
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
                                  index.toString() +
                                  "/" +
                                  this.count.toString(),
                              style: const TextStyle(
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

                  SizedBox(
                    height: vertical_size * 0.03,
                  ),

                  Container(
                    alignment: Alignment.center,
                    height: vertical_size * 0.7,
                    width: horizontal_size * 0.9,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(10.0, 10.0),
                              blurRadius: 20.0,
                              spreadRadius: 10.0)
                        ]),
                    child: Column(
                      children: [
                        //질문 번호

                        Container(
                          alignment: Alignment.center,
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontal_size * 0.02),
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              "Question" +
                                  (index + 1).toString() +
                                  ".\n아래 문장은 올바른 문장입니까?",
                              minFontSize: 10,
                              maxFontSize: 20,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontal_size * 0.01),
                          alignment: Alignment.center,
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.15,
                          child: AutoSizeText(
                              snapshot.data['hindi_example'][index],
                              minFontSize: 20,
                              maxFontSize: 30,
                              style: const TextStyle(fontSize: 25)),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontal_size * 0.01),
                          alignment: Alignment.center,
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.15,
                          child: AutoSizeText(
                              snapshot.data['korean_wrong_example'][index],
                              minFontSize: 15,
                              maxFontSize: 25,
                              style: const TextStyle(fontSize: 20)),
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
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      hint_color = Colors.black;
                                    });

                                    //HintDialog(context,hindi_word,korean_word);
                                  },

                                  child: const AutoSizeText(
                                    "힌트",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                width: horizontal_size * 0.5,
                                height: vertical_size * 0.1,
                                alignment: Alignment.topCenter,
                                child: AutoSizeText(
                                  snapshot.data['hindi'][index] +
                                      "의 뜻은 " +
                                      snapshot.data['korean'][index] +
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                child: Container(
                                  height: vertical_size * 0.15,
                                  child: const Icon(
                                    Icons.panorama_fish_eye,
                                    size: 50,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    hint_color = Colors.white;

                                    if (snapshot.data['right'][index]
                                            .compareTo('1') ==
                                        0) {
                                      right_hindi_words
                                          .add(snapshot.data['hindi'][index]);

                                      right_korean_words
                                          .add(snapshot.data['korean'][index]);

                                      index++;

                                      correct++;
                                    } else {
                                      wrong_hindi_words
                                          .add(snapshot.data['hindi'][index]);

                                      wrong_korean_words
                                          .add(snapshot.data['korean'][index]);

                                      index++;

                                      incorrect++;
                                    }
                                  });

                                  if (count == index) {
                                    removesentence(
                                        right_hindi_words, wrong_hindi_words);

                                    //move_page(context,"복습 추천 단어", count, correct, wrong_hindi_words, wrong_korean_words);

                                  }
                                },
                              ),
                              InkWell(
                                child: Container(
                                  height: vertical_size * 0.15,
                                  child: const Icon(
                                    Icons.clear,
                                    size: 50,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    hint_color = Colors.white;

                                    if (snapshot.data['right'][index]
                                            .compareTo('0') ==
                                        0) {
                                      right_hindi_words
                                          .add(snapshot.data['hindi'][index]);

                                      right_korean_words
                                          .add(snapshot.data['korean'][index]);

                                      index++;

                                      correct++;
                                    } else {
                                      wrong_hindi_words
                                          .add(snapshot.data['hindi'][index]);

                                      wrong_korean_words
                                          .add(snapshot.data['korean'][index]);

                                      index++;

                                      incorrect++;
                                    }
                                  });

                                  if (count == index) {
                                    removesentence(
                                        right_hindi_words, wrong_hindi_words);

                                    //move_page(context,'복습 추천 단어', count, correct, wrong_hindi_words, wrong_korean_words);

                                  }
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
        ),
        onWillPop: () {
          // ignore: missing_return
         return listtoMain(context: context);
        });
  }
}

//페이지 이동

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
            builder: (BuildContext context) => test_result(
                page_name,
                _total_itemcount,
                correct,
                wrong_hindi_words,
                wrong_korean_words)),
        (route) => false);
  });
}
