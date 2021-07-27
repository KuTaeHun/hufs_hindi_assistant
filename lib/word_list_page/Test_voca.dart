import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'package:HUFSHindiAssistant/function/test_result_page.dart';

import 'package:HUFSHindiAssistant/word_list_page/words.dart';

import 'dart:async';

import 'dart:math';

import 'package:HUFSHindiAssistant/function/pageroute.dart';

import 'package:HUFSHindiAssistant/function/unmemory_list.dart';
import 'package:flutter/services.dart';

class TestVoca extends StatefulWidget {
  //단어 레벨 타이틀

  String page_name;

  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수

  int start_word_num;

  int finish_word_num;

  int _total_itemcount;

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴

  Future<List<dynamic>> word_list;

  TestVoca({
    Key key,
    @required this.start_word_num,
    @required this.finish_word_num,
    @required this.page_name,
    @required this.file_name,
  }) {
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
  _TestVocaState createState() => _TestVocaState(this.start_word_num,
      this.finish_word_num, this.page_name, this.file_name);
}

class _TestVocaState extends State<TestVoca>
    with SingleTickerProviderStateMixin {
  //정답일때 체크표시가 나오는 에니메이션을 위한 변수.

  AnimationController _animationController;

  Animation<double> _animation;

  //단어 레벨 타이틀

  String page_name;

  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수

  int _start_word_num;

  int _finish_word_num;

  int _total_itemcount;

  int count = 1;

  int correct = 0;

  int incorrect = 0;

  List<String> hindi_wrong_word = [];

  List<String> korean_wrong_word = [];

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴

  Future<List<dynamic>> word_list;

  _TestVocaState(int start_word_num, int finish_word_num, String page_name,
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

  var hindi_word = '';

  var korean_word = '';

  //BottomNavigationBar

  int _selectedIndex = 0;

  int global_index = 0;

  //엑셀을 챕터별로 분류할때 한 챕터에 저장된 최소 단어

  int minimum_index_num;

  //힌디 단어 시험인지, 한국어 의미 단어 시험인지 설정

  bool _choice_language = true;

  //이번 해당 장에 틀린 힌디어 단어 리스트

  List<String> wrong_hindi_words = new List<String>();

  List<String> wrong_korean_words = new List<String>();

  //단어당 4지 선다형 과 정답을 뽑을 때 쓰는 변수

  Map<String, dynamic> question;

  //build가 주기적으로 일어나며 makequestion 함수에 랜덤 기능이 있으므로

  //한 번만 진행하기 위해 만든 bool 변수

  bool only_one_time_makequestion = true;

  //한 번만 결과 페이지 나타내기 위해 만든 bool qustn

  bool only_one_time_show_result = true;

  Map<String, dynamic> make_question(
      bool choice_num,
      String hindi_correct_word,
      String korean_correct_word,
      List<String> hindi_wrong_words,
      List<String> korean_wrong_words) {
    only_one_time_makequestion = false;

    Map<String, dynamic> result = {
      'correct_number': 1,
      'main_word': '',
      'wrong_word': []
    };

    //일시적으로 순서 정렬하지 않은 힌디 문제 리스트

    List<String> temp_hindi_randomword = [];

    //일시적으로 순서 정렬하지 않은 한국어 문제 리스트

    List<String> temp_korean_randomword = [];

    //정답,오답을 포함한 문제 리스트

    List<String> randomword = [];

    //문제를 정렬하기 위한 인덱스 리스트

    List<int> randomnumber = [0, 0, 0, 0];

    //정답을 누르면 초록색으로 Tap 색깔이 바뀜 그리고 오답이면 빨간색으로 색깔이 바뀜.

    Color highlight_color;

    Color splash_color;

    //랜덤 시드와 범위를 넣고 변경하는 랜덤 함수

    int generateRandom(int range, int seed) {
      Random random = new Random(seed);

      int randomIndex = random.nextInt(range);

      return randomIndex;
    }

    //랜덤 시드를 뽑는 함수

    int generateRandomseed() {
      Random random = new Random();

      int randomIndex = random.nextInt(1000);

      return randomIndex;
    }

    int right_num;

    int randomIndex;

    if (choice_num) {
      //처음에는 정답을 저장한 리스트 생성

      temp_hindi_randomword.add(hindi_correct_word);

      //답을 제외한 파트 별 단어 수에서 랜덤으로 3개 인덱스 뽑음

      for (int i = 0; i < 3; i++) {
        randomIndex = generateRandom(minimum_index_num, generateRandomseed());

        if (temp_hindi_randomword[0]
                .compareTo(hindi_wrong_words[randomIndex]) !=
            0) {
          temp_hindi_randomword.add(hindi_wrong_words[randomIndex]);
        } else {
          Loop1:
          while (true) {
            randomIndex =
                generateRandom(minimum_index_num, generateRandomseed());

            //3개의 랜덤 단어를 저장

            if (temp_hindi_randomword[0]
                    .compareTo(hindi_wrong_words[randomIndex]) !=
                0) {
              temp_hindi_randomword.add(hindi_wrong_words[randomIndex]);

              break Loop1;
            }
          }
        }
      }

      //뽑는 4개중 중복된 인덱스를 걸러내는 반복문

      for (int i = 0; i < 4; i++) {
        randomIndex = generateRandom(4, generateRandomseed());

        randomnumber[i] = randomIndex;

        for (int j = 0; j < i; j++) {
          if (randomnumber[i] == randomnumber[j]) i--;
        }
      }

      //뽑은 4개의 단어를 섞는 반복문

      for (int i = 0; i < 4; i++) {
        randomword.add(temp_hindi_randomword[randomnumber[i]]);
      }

      for (int i = 0; i < randomword.length; i++) {
        if (hindi_correct_word.compareTo(randomword[i]) == 0) {
          right_num = i;
        }
      }

      result['correct_number'] = right_num;

      result['main_word'] = korean_correct_word;

      result['wrong_word'] = randomword;

      return result;
    } else {
      //처음에는 정답을 저장한 리스트 생성

      temp_korean_randomword.add(korean_correct_word);

      //답을 제외한 파트 별 단어 수에서 랜덤으로 3개 인덱스 뽑음

      for (int i = 0; i < 3; i++) {
        randomIndex = generateRandom(25, generateRandomseed());

        if (temp_korean_randomword.first
                .compareTo(korean_wrong_words[randomIndex]) !=
            0) {
          temp_korean_randomword.add(korean_wrong_words[randomIndex]);
        } else {
          Loop1:
          while (true) {
            randomIndex = generateRandom(25, generateRandomseed());

            //3개의 랜덤 단어를 저장

            if (temp_korean_randomword[0]
                    .compareTo(korean_wrong_words[randomIndex]) !=
                0) {
              temp_korean_randomword.add(korean_wrong_words[randomIndex]);

              break Loop1;
            }
          }
        }
      }

      //뽑는 4개중 중복된 인덱스를 걸러내는 반복문

      for (int i = 0; i < 4; i++) {
        randomIndex = generateRandom(4, generateRandomseed());

        randomnumber[i] = randomIndex;

        for (int j = 0; j < i; j++) {
          if (randomnumber[i] == randomnumber[j]) i--;
        }
      }

      //뽑은 4개의 단어를 섞는 반복문

      for (int i = 0; i < 4; i++) {
        randomword.add(temp_korean_randomword[randomnumber[i]]);
      }

      for (int i = 0; i < randomword.length; i++) {
        if (korean_correct_word.compareTo(randomword[i]) == 0) {
          right_num = i;
        }
      }

      result['correct_number'] = right_num;

      result['main_word'] = hindi_correct_word;

      result['wrong_word'] = randomword;

      return result;
    }
  }

  var horizontal_size;

  var vertical_size;

  Color highlight_color;

  Color splash_color;

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

  void quiz_operation_func(AsyncSnapshot snapshot) async {
    int hindi_index, korean_index;

    //초급 문법, 중급 문법과 CFLPT 단어 엑셀 파일의 모양이 달라 조건문으로 구분하였다.

    //초문, 중문은 엑셀 B,D 줄에 힌디어, 한국어 단어가 있고 CFLPT는 A,C에 있다.

    if (this.file_name.compareTo('assets/elementary_hindi_book.xlsx') == 0 ||
        this.file_name.compareTo('assets/middle_hindi_book.xlsx') == 0) {
      hindi_index = 1;

      korean_index = 3;

      minimum_index_num = 13;
    } else {
      hindi_index = 0;

      korean_index = 2;

      minimum_index_num = 30;
    }

    for (int i = 0; i < minimum_index_num; i++) {
      this.hindi_wrong_word.add(snapshot.data[i][hindi_index].toString());
    }

    for (int i = 0; i < minimum_index_num; i++) {
      this.korean_wrong_word.add(snapshot.data[i][korean_index].toString());
    }

    //global_index는 엑셀 파일에 셀 인덱스, count는 이번 챕터의 총 단어 갯수

    if (global_index == 0 && count == 1) {
      this.hindi_word = snapshot.data[global_index][hindi_index].toString();

      this.korean_word = snapshot.data[global_index][korean_index].toString();
    } else {
      try {
        if (global_index < _total_itemcount && count <= _total_itemcount) {
          this.hindi_word = snapshot.data[global_index][hindi_index].toString();

          this.korean_word =
              snapshot.data[global_index][korean_index].toString();
        } else {
          if (only_one_time_show_result) {
            move_page(context, this.page_name, this._total_itemcount,
                this.correct, wrong_hindi_words, wrong_korean_words);
          }

          only_one_time_show_result = false;
        }
      } on Exception catch (_) {
        if (only_one_time_show_result) {
          move_page(context, this.page_name, this._total_itemcount,
              this.correct, wrong_hindi_words, wrong_korean_words);
        }

        only_one_time_show_result = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    //가로 화면 변경 방지
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return WillPopScope(
        child: new FutureBuilder(
            future: make_word_list(
                start_index: _start_word_num,
                finish_index: _finish_word_num,
                words_level: file_name,
                file_name: page_name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                //오답 단어 예제를 모으고 챕터에서 모든 단어 학습시 결과창으로 나갈 수 있는 함수

                quiz_operation_func(snapshot);

                if (only_one_time_makequestion) {
                  question = make_question(_choice_language, this.hindi_word,
                      this.korean_word, hindi_wrong_word, korean_wrong_word);
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
                            show_quit_dialog(context, file_name);
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
                  bottomNavigationBar: Container(
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _selectedIndex,
                      backgroundColor: const Color.fromARGB(240, 105, 118, 236),
                      selectedFontSize: 13,
                      iconSize: 18,
                      unselectedFontSize: 12,
                      unselectedItemColor: Colors.white.withOpacity(.50),
                      selectedItemColor: Colors.white,
                      onTap: (choice_num) {
                        setState(() {
                          _selectedIndex = choice_num;

                          if (_selectedIndex == 0)
                            _choice_language = true;
                          else
                            _choice_language = false;
                        });
                      },
                      items: [
                        const BottomNavigationBarItem(
                            label: '힌디어 문제',
                            icon: Icon(
                              Icons.format_clear,
                            )),
                        const BottomNavigationBarItem(
                            label: '한국어 문제',
                            icon: Icon(Icons.format_strikethrough)),
                      ],
                    ),
                  ),
                  body: Container(
                    width: horizontal_size,
                    height: vertical_size,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color.fromARGB(240, 10, 15, 64),
                          Color.fromARGB(240, 108, 121, 240)
                        ])),
                    child: Column(
                      children: [
                        //파트 이름, 번호, 단어 수

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          width: horizontal_size,
                          height: vertical_size * 0.07,
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
                                    color: Colors.white,
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
                                  style: const TextStyle(
                                    color: Colors.white,
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

                        //정답, 오답 수, 제한 시간

                        Container(
                          alignment: Alignment.centerLeft,
                          height: 80,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
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
                                    SizedBox(
                                      height: vertical_size * 0.002,
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
                                    count.toString() +
                                        "/" +
                                        _total_itemcount.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
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

                        //단어 보이기 카드 형식

                        Expanded(
                          child: Container(
                            width: horizontal_size * 0.9,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(240, 242, 242, 242),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: horizontal_size * 0.84,
                                  height: vertical_size * 0.23,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(3.0, 3.0),
                                            blurRadius: 10.0,
                                            spreadRadius: 0.0)
                                      ]),
                                  child: AutoSizeText(
                                    question['main_word'],
                                    maxFontSize: 28,
                                    minFontSize: 13,
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 23),
                                  ),
                                ),
                                SizedBox(
                                  height: vertical_size * 0.025,
                                ),
                                InkWell(
                                    splashColor: splash_color,
                                    highlightColor: highlight_color,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: horizontal_size * 0.84,
                                      height: vertical_size * 0.065,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 0.0)
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: AutoSizeText(
                                          "1.   " + question['wrong_word'][0],
                                          maxFontSize: 30,
                                          minFontSize: 10,
                                          softWrap: true,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      only_one_time_makequestion = true;

                                      setState(() {
                                        if (question['correct_number'] == 0) {
                                          highlight_color =
                                              Colors.green.withOpacity(0.4);

                                          splash_color = Colors.amberAccent
                                              .withOpacity(0.4);

                                          correct++;

                                          count++;

                                          global_index++;
                                        } else {
                                          highlight_color =
                                              Colors.red.withOpacity(0.4);

                                          splash_color =
                                              Colors.black.withOpacity(0.4);

                                          if (this.file_name.compareTo(
                                                      'assets/elementary_hindi_book.xlsx') ==
                                                  0 ||
                                              this.file_name.compareTo(
                                                      'assets/middle_hindi_book.xlsx') ==
                                                  0) {
                                            unMemory_words(
                                                words: snapshot
                                                    .data[global_index][1]
                                                    .toString(),
                                                word_class: snapshot
                                                    .data[global_index][2]
                                                    .toString(),
                                                mean: snapshot
                                                    .data[global_index][3]
                                                    .toString());

                                            wrong_hindi_words.add(snapshot
                                                .data[global_index][1]
                                                .toString());

                                            wrong_korean_words.add(snapshot
                                                .data[global_index][3]
                                                .toString());
                                          } else {
                                            unMemory_words(
                                                words: snapshot
                                                    .data[global_index][0],
                                                word_class: snapshot
                                                    .data[global_index][1],
                                                mean: snapshot
                                                    .data[global_index][2],
                                                example_hindi: snapshot
                                                    .data[global_index][3],
                                                example_korean: snapshot
                                                    .data[global_index][4]);

                                            wrong_hindi_words.add(
                                                snapshot.data[global_index][0]);

                                            wrong_korean_words.add(
                                                snapshot.data[global_index][2]);
                                          }

                                          incorrect++;

                                          count++;

                                          global_index++;
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                InkWell(
                                    splashColor: splash_color,
                                    highlightColor: highlight_color,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: horizontal_size * 0.84,
                                      height: vertical_size * 0.065,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 0.0)
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: AutoSizeText(
                                          "2.   " + question['wrong_word'][1],
                                          maxFontSize: 30,
                                          minFontSize: 10,
                                          softWrap: true,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        only_one_time_makequestion = true;

                                        if (question['correct_number'] == 1) {
                                          highlight_color =
                                              Colors.green.withOpacity(0.4);

                                          splash_color = Colors.amberAccent
                                              .withOpacity(0.4);

                                          correct++;

                                          count++;

                                          global_index++;
                                        } else {
                                          highlight_color =
                                              Colors.red.withOpacity(0.4);

                                          splash_color =
                                              Colors.black.withOpacity(0.4);

                                          if (this.file_name.compareTo(
                                                      'assets/elementary_hindi_book.xlsx') ==
                                                  0 ||
                                              this.file_name.compareTo(
                                                      'assets/middle_hindi_book.xlsx') ==
                                                  0) {
                                            unMemory_words(
                                                words: snapshot
                                                    .data[global_index][1],
                                                word_class: snapshot
                                                    .data[global_index][2],
                                                mean: snapshot
                                                    .data[global_index][3]);

                                            wrong_hindi_words.add(
                                                snapshot.data[global_index][1]);

                                            wrong_korean_words.add(
                                                snapshot.data[global_index][3]);
                                          } else {
                                            unMemory_words(
                                                words: snapshot
                                                    .data[global_index][0],
                                                word_class: snapshot
                                                    .data[global_index][1],
                                                mean: snapshot
                                                    .data[global_index][2],
                                                example_hindi: snapshot
                                                    .data[global_index][3],
                                                example_korean: snapshot
                                                    .data[global_index][4]);

                                            wrong_hindi_words.add(
                                                snapshot.data[global_index][0]);

                                            wrong_korean_words.add(
                                                snapshot.data[global_index][2]);
                                          }

                                          incorrect++;

                                          count++;

                                          global_index++;
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                InkWell(
                                    splashColor: splash_color,
                                    highlightColor: highlight_color,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: horizontal_size * 0.84,
                                      height: vertical_size * 0.065,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(3.0, 3.0),
                                                blurRadius: 10.0,
                                                spreadRadius: 0.0)
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13),
                                        child: AutoSizeText(
                                          "3.   " + question['wrong_word'][2],
                                          maxFontSize: 30,
                                          minFontSize: 10,
                                          softWrap: true,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        only_one_time_makequestion = true;

                                        if (question['correct_number'] == 2) {
                                          highlight_color =
                                              Colors.green.withOpacity(0.4);

                                          splash_color = Colors.amberAccent
                                              .withOpacity(0.4);

                                          correct++;

                                          count++;

                                          global_index++;
                                        } else {
                                          highlight_color =
                                              Colors.red.withOpacity(0.4);

                                          splash_color =
                                              Colors.black.withOpacity(0.4);

                                          if (this.file_name.compareTo(
                                                      'assets/elementary_hindi_book.xlsx') ==
                                                  0 ||
                                              this.file_name.compareTo(
                                                      'assets/middle_hindi_book.xlsx') ==
                                                  0) {
                                            unMemory_words(
                                                words: snapshot
                                                    .data[global_index][1],
                                                word_class: snapshot
                                                    .data[global_index][2],
                                                mean: snapshot
                                                    .data[global_index][3]);

                                            wrong_hindi_words.add(
                                                snapshot.data[global_index][1]);

                                            wrong_korean_words.add(
                                                snapshot.data[global_index][3]);
                                          } else {
                                            unMemory_words(
                                                words: snapshot
                                                    .data[global_index][0],
                                                word_class: snapshot
                                                    .data[global_index][1],
                                                mean: snapshot
                                                    .data[global_index][2],
                                                example_hindi: snapshot
                                                    .data[global_index][3],
                                                example_korean: snapshot
                                                    .data[global_index][4]);

                                            wrong_hindi_words.add(
                                                snapshot.data[global_index][0]);

                                            wrong_korean_words.add(
                                                snapshot.data[global_index][2]);
                                          }

                                          incorrect++;

                                          count++;

                                          global_index++;
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: vertical_size * 0.015,
                                ),
                                InkWell(
                                  splashColor: splash_color,
                                  highlightColor: highlight_color,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: horizontal_size * 0.84,
                                    height: vertical_size * 0.065,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(3.0, 3.0),
                                              blurRadius: 10.0,
                                              spreadRadius: 0.0)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13),
                                      child: AutoSizeText(
                                        "4.   " + question['wrong_word'][3],
                                        maxFontSize: 30,
                                        minFontSize: 10,
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      only_one_time_makequestion = true;

                                      if (question['correct_number'] == 3) {
                                        highlight_color =
                                            Colors.green.withOpacity(0.4);

                                        splash_color =
                                            Colors.amberAccent.withOpacity(0.4);

                                        correct++;

                                        count++;

                                        global_index++;
                                      } else {
                                        highlight_color =
                                            Colors.red.withOpacity(0.4);

                                        splash_color =
                                            Colors.black.withOpacity(0.4);

                                        if (this.file_name.compareTo(
                                                    'assets/elementary_hindi_book.xlsx') ==
                                                0 ||
                                            this.file_name.compareTo(
                                                    'assets/middle_hindi_book.xlsx') ==
                                                0) {
                                          unMemory_words(
                                              words: snapshot.data[global_index]
                                                  [1],
                                              word_class: snapshot
                                                  .data[global_index][2],
                                              mean: snapshot.data[global_index]
                                                  [3]);

                                          wrong_hindi_words.add(
                                              snapshot.data[global_index][1]);

                                          wrong_korean_words.add(
                                              snapshot.data[global_index][3]);
                                        } else {
                                          unMemory_words(
                                              words: snapshot.data[global_index]
                                                  [0],
                                              word_class: snapshot
                                                  .data[global_index][1],
                                              mean: snapshot.data[global_index]
                                                  [2],
                                              example_hindi: snapshot
                                                  .data[global_index][3],
                                              example_korean: snapshot
                                                  .data[global_index][4]);

                                          wrong_hindi_words.add(
                                              snapshot.data[global_index][0]);

                                          wrong_korean_words.add(
                                              snapshot.data[global_index][2]);
                                        }

                                        incorrect++;

                                        count++;

                                        global_index++;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
              } else {
                return Container(
                  child: Center(
                    child: const Text("로딩이 실패하였습니다. 앱 종료후 다시 실행시켜주세요."),
                  ),
                );
              }
            }),
        onWillPop: () async {
          show_quit_dialog(context, file_name);
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
  List<String> wrong_korean_words,
) {
  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => test_result(
                page_name,
                _total_itemcount,
                correct,
                wrong_hindi_words,
                wrong_korean_words)),(route)=>false);
  });
}
