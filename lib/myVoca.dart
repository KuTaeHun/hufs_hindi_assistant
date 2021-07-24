import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:HUFSHindiAssistant/function/pageroute.dart';

import 'package:shared_preferences/shared_preferences.dart';

class myVoca extends StatefulWidget {
  @override
  _myVocaState createState() => _myVocaState();
}

class _myVocaState extends State<myVoca> {
  //힌디어 단어 가리기

  int alpha_hindi = 255;

  int red_hindi = 0;

  int green_hindi = 0;

  int blue_hindi = 0;

  //한국어 뜻 가리기

  int alpha_korean = 255;

  int red_korean = 0;

  int green_korean = 0;

  int blue_korean = 0;

  //폰트 사이즈 조절

  double font_size_hindi = 22;

  double font_size_korean = 13;

  SharedPreferences wordlist;

  var data = {
    'key': [],
    'hindi': [],
    'case': [],
    'korean': [],
    'hindi_example': [],
    'korean_example': []
  };

  var uniquekey;

  List<UniqueKey> makeUniqueKey(int count) {
    List<UniqueKey> keys = [];

    for (int i = 0; i < count; i++) {
      keys.add(UniqueKey());
    }

    return keys;
  }

  int count_num;

  initState() {
    super.initState();

    count_num = 0;
  }

  var keys;

  _myVocaState() {
    firstoperate();
  }

  firstoperate() async {
    this.count_num = await _loading();

    await _extractString();

    keys = makeUniqueKey(this.count_num);
  }

  Future<int> _loading() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();

    var count_num;

    setState(() {
      count_num = Future(() {
        if ((wordlist.getInt('total_count_num')) == null) {
          wordlist.setInt('total_count_num', 0);

          return wordlist.getInt('total_count_num');
        } else
          return (wordlist.getInt('total_count_num') ?? 0);
      });
    });

    return count_num;
  }

  _extractString() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();

    int index;

    int count = 0;

    setState(() {
      index = wordlist.getInt('count_num');

      if (index != 0 && index != null) {
        for (int i = 1; i < index + 1; i++) {
          String temp;

          temp = wordlist.getString("w_word" + (i.toString()));

          if (temp != null) {
            count++;
          }
        }

        wordlist.setInt("total_count_num", count);

        for (int i = 1; i < index + 1; i++) {
          String hindiword = wordlist.getString("w_word" + (i.toString()));

          String wordcase = wordlist.getString('w_word_class' + (i.toString()));

          String mean = wordlist.getString('w_mean' + (i.toString()));

          String hindi_example =
              wordlist.getString("w_example_hindi" + (i.toString()));

          String korean_example =
              wordlist.getString("w_example_korean" + (i.toString()));

          if (hindiword != null && wordcase != null && mean != null) {
            this.data['key'].add(UniqueKey());

            this.data['hindi'].add(hindiword);

            this.data['case'].add(wordcase);

            this.data['korean'].add(mean);

            if (hindi_example == null && korean_example == null) {
              this.data['hindi_example'].add('');

              this.data['korean_example'].add('학과 단어는 예제가 없습니다.');
            } else {
              this.data['hindi_example'].add(hindi_example);

              this.data['korean_example'].add(korean_example);
            }
          }
        }
      } else {
        wordlist.setInt('count_num', 0);
      }
    });
  }

  _removeString(int find_index, var data, var total_count_num) async {
    _find_right_word(
        SharedPreferences wordlist, var find_index, var count, var data) async {
      for (int i = 1; i < count + 1; i++) {
        if (wordlist.getString('w_word' + (i.toString())) != null &&
            wordlist.getString('w_word_class' + (i.toString())) != null &&
            wordlist.getString('w_mean' + (i.toString())) != null &&
            wordlist.getString('w_example_hindi' + (i.toString())) != null &&
            wordlist.getString('w_example_korean' + (i.toString())) != null) {
          if (data['hindi'][find_index]
                  .compareTo(wordlist.getString('w_word' + (i.toString()))) ==
              0) {
            wordlist.remove('w_word' + (i.toString()));

            wordlist.remove('w_word_class' + (i.toString()));

            wordlist.remove('w_mean' + (i.toString()));

            wordlist.remove('w_example_hindi' + (i.toString()));

            wordlist.remove('w_example_korean' + (i.toString()));
          }
        }
      }
    }

    var total_count;

    SharedPreferences wordlist = await SharedPreferences.getInstance();

    setState(() {
      wordlist.setInt('total_count_num', total_count_num);
    });

    if (find_index >= 0) {
      total_count = wordlist.getInt('count_num');

      await _find_right_word(wordlist, find_index, total_count, data);

      this.data['hindi'].removeAt(find_index);

      this.data['case'].removeAt(find_index);

      this.data['korean'].removeAt(find_index);

      this.data['korean_example'].removeAt(find_index);

      this.data['hindi_example'].removeAt(find_index);
    }
  }

  //BottomNavigationBar

  int _selectedIndex = 0;

  bool _selectedcheck_hindi = false;

  bool _selectedcheck_korean = false;

  //모든 예시 보기, 보지 않기

  bool zoom_in_example = false;

  bool isPlaying = false;

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
    return WillPopScope(child: Builder(builder: (BuildContext context) {
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
          // height: vertical_size * 0.07,

          // width: horizontal_size,

          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            backgroundColor: Colors.white,
            selectedFontSize: 15,
            iconSize: 20,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.black.withOpacity(.50),
            selectedItemColor: Colors.black,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;

                if (_selectedIndex == 0)
                  _selectedcheck_hindi = !_selectedcheck_hindi;

                if (_selectedIndex == 1)
                  _selectedcheck_korean = !_selectedcheck_korean;

                if (_selectedcheck_hindi == true && index == 0) {
                  alpha_hindi = 255;

                  blue_hindi = 0;

                  red_hindi = 0;

                  green_hindi = 0;

                  alpha_korean = 255;

                  blue_korean = 0;

                  red_korean = 0;

                  green_korean = 0;
                } else if (_selectedcheck_hindi == false && index == 0) {
                  alpha_hindi = 0;

                  blue_hindi = 255;

                  red_hindi = 255;

                  green_hindi = 255;

                  alpha_korean = 255;

                  blue_korean = 0;

                  red_korean = 0;

                  green_korean = 0;
                } else if (_selectedcheck_korean == true && index == 1) {
                  alpha_hindi = 255;

                  blue_hindi = 0;

                  red_hindi = 0;

                  green_hindi = 0;

                  alpha_korean = 255;

                  blue_korean = 0;

                  red_korean = 0;

                  green_korean = 0;
                } else if (_selectedcheck_korean == false && index == 1) {
                  alpha_hindi = 255;

                  blue_hindi = 0;

                  red_hindi = 0;

                  green_hindi = 0;

                  alpha_korean = 0;

                  blue_korean = 255;

                  red_korean = 255;

                  green_korean = 255;
                } else if (index == 2) {
                  if (font_size_hindi <= 25) {
                    font_size_hindi += 0.5;
                  } else if (font_size_korean <= 20) font_size_korean += 0.5;
                } else if (index == 3) {
                  if (font_size_korean > 10)
                    font_size_korean -= 0.5;
                  else if (font_size_hindi > 15) font_size_hindi -= 0.5;
                }
              });
            },
            items: [
              const BottomNavigationBarItem(
                  label: '단어 가림',
                  icon: Icon(
                    Icons.format_clear,
                  )),
              const BottomNavigationBarItem(
                  label: '의미 가림', icon: Icon(Icons.format_strikethrough)),
              const BottomNavigationBarItem(
                  label: "단어 크게", icon: Icon(Icons.format_size)),
              const BottomNavigationBarItem(
                  label: "단어 작게", icon: Icon(Icons.text_fields))
            ],
          ),
        ),
        body: this.count_num > 0
            ? Container(
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
                            child: const Text(
                              '미암기 단어',
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
                              "단어 수: " + this.count_num.toString() + "개",
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
                    Expanded(
                      child: ListView.builder(
                          itemCount: this.count_num,
                          itemBuilder: (context, index) {
                            {
                              final item = keys[index];

                              return Slidable(
                                key: item,
                                child: Container(
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,

                                    //margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),

                                    child: ExpansionTile(
                                      expandedAlignment: Alignment.centerLeft,
                                      expandedCrossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      initiallyExpanded: false,
                                      maintainState: false,
                                      backgroundColor: Colors.white54,
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 0.8),
                                        child: AutoSizeText(
                                          this.data['hindi'][index],
                                          style: TextStyle(
                                            fontSize: font_size_hindi,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                alpha_hindi,
                                                red_hindi,
                                                green_hindi,
                                                blue_hindi),
                                          ),
                                          minFontSize: 15,
                                          maxLines: 3,
                                        ),
                                      ),
                                      subtitle: AutoSizeText(
                                        this.data['korean'][index],
                                        style: TextStyle(
                                          fontSize: font_size_korean,
                                          fontWeight: FontWeight.w100,
                                          color: Color.fromARGB(
                                              alpha_korean,
                                              red_korean,
                                              green_korean,
                                              blue_korean),
                                        ),
                                        maxLines: 3,
                                        minFontSize: 10,
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 16),
                                          child: AutoSizeText(
                                            this.data['case'][index],
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300),
                                            maxLines: 1,
                                            minFontSize: 8,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          child: AutoSizeText(
                                            this.data['hindi_example'][index],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 3,
                                            minFontSize: 15,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 5, 16, 10),
                                          child: AutoSizeText(
                                            this.data['korean_example'][index],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w100),
                                            maxLines: 3,
                                            minFontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actionPane: const SlidableDrawerActionPane(),
                                actionExtentRatio: 0.2,
                                actions: <Widget>[
                                  IconSlideAction(
                                    caption: "삭제",
                                    color: Colors.redAccent,
                                    icon: Icons.delete,
                                    onTap: () {
                                      setState(() {
                                        this.count_num--;

                                        _removeString(
                                            index, this.data, this.count_num);

                                        keys.removeAt(index);
                                      });
                                    },
                                  )
                                ],
                              );
                            }

                            ;
                          }),
                    ),
                  ],
                ),
              )
            : Container(
                width: horizontal_size,
                height: vertical_size,
                alignment: Alignment.center,
                color: Colors.white70,
                child: const Text(
                  "저장된 복습 단어가 없습니다.\n단어 학습 후 나의 단어장을 확인하세요.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                      fontSize: 20),
                )),
      ));
    // ignore: missing_return
    }), onWillPop: () async {
       return listtoMain(context: context);
    });
  }
}
