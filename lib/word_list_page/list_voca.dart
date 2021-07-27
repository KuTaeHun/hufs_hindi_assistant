import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HUFSHindiAssistant/function/pageroute.dart';
import 'package:HUFSHindiAssistant/word_list_page/words.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:HUFSHindiAssistant/function/unmemory_list.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:HUFSHindiAssistant/main.dart';

class word_list_voca extends StatefulWidget {
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
  word_list_voca(
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
  _word_list_vocaState createState() => _word_list_vocaState(
      start_word_num, finish_word_num, page_name, file_name);
}

class _word_list_vocaState extends State<word_list_voca> {
  //단어 레벨 타이틀
  String page_name;
  String file_name;

  //단계별로 총 단어 수를 원하는 부분 별로 자르기 위한 변수
  int _start_word_num;
  int _finish_word_num;
  int _total_itemcount;

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

  //엑셀 파일 word list는 비동기 리스트라서 word_mean으로 강제 형 변환시킴
  Future<List<dynamic>> word_list;

  _word_list_vocaState(int start_word_num, int finish_word_num,
      String page_name, String file_name) {
    this._start_word_num = start_word_num;
    this._finish_word_num = finish_word_num;
    this.word_list = make_word_list(start_index:start_word_num,finish_index:finish_word_num, words_level:file_name,file_name: page_name);
    this.page_name = page_name;
    this.file_name = file_name;
    this._total_itemcount = finish_word_num - start_word_num + 1;
  }

  //BottomNavigationBar
  int _selectedIndex = 0;
  bool _selectedcheck_hindi = false;
  bool _selectedcheck_korean = false;

  //모든 예시 보기, 보지 않기

  bool zoom_in_example = false;
  bool isPlaying = false;


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

    // TODO: implement build
    return WillPopScope(
        child: new FutureBuilder(
            future:
                make_word_list(start_index:_start_word_num,finish_index:_finish_word_num, words_level:file_name,file_name: page_name),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
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
                          //목차로 이동하기
                          onPressed: () {
                          backtoChapterList(context: context, file_name: file_name);
                          },
                        );
                      },
                    ),
                    shadowColor: Colors.black26,
                    centerTitle: true,
                    backgroundColor: const Color.fromARGB(240, 10, 15, 64),
                    title:const  Text(
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
                    child:  BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _selectedIndex,
                      backgroundColor: Colors.white,
                      selectedFontSize: 13,
                      iconSize: 18,
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
                          } else if (_selectedcheck_hindi == false &&
                              index == 0) {
                            alpha_hindi = 0;
                            blue_hindi = 255;
                            red_hindi = 255;
                            green_hindi = 255;
                            alpha_korean = 255;
                            blue_korean = 0;
                            red_korean = 0;
                            green_korean = 0;
                          } else if (_selectedcheck_korean == true &&
                              index == 1) {
                            alpha_hindi = 255;
                            blue_hindi = 0;
                            red_hindi = 0;
                            green_hindi = 0;
                            alpha_korean = 255;
                            blue_korean = 0;
                            red_korean = 0;
                            green_korean = 0;
                          } else if (_selectedcheck_korean == false &&
                              index == 1) {
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
                            } else if (font_size_korean <= 20)
                              font_size_korean += 0.5;
                          } else if (index == 3) {
                            if (font_size_korean > 10)
                              font_size_korean -= 0.5;
                            else if (font_size_hindi > 15)
                              font_size_hindi -= 0.5;
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
                            label: '의미 가림',
                            icon: Icon(Icons.format_strikethrough)),
                        const BottomNavigationBarItem(
                            label: "단어 크게", icon: Icon(Icons.format_size)),
                        const BottomNavigationBarItem(
                            label: "단어 작게", icon: Icon(Icons.text_fields))
                      ],
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
                                  "단어 수: " + _total_itemcount.toString() + "개",
                                  style:const TextStyle(
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.1, horizontal: 0.8),
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index){
                                return Slidable(
                                  actionPane: const SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.17,
                                  actions: <Widget>[
                                    IconSlideAction(
                                      caption: '저장',
                                      color: const Color.fromARGB(200, 0, 0, 139),
                                      icon:  Icons.archive,
                                      onTap: () => setState(() {
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

                                        var snackbar = SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: const Text(
                                              "미암기 단어장에 해당 단어가 추가되었습니다."),
                                          action:  SnackBarAction(
                                            label: "확인",
                                            onPressed: () {},
                                          ),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackbar);
                                      }),
                                    ),
                                  ],
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
                                          snapshot.data[index][0],
                                          style:  TextStyle(
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
                                        snapshot.data[index][2],
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
                                            snapshot.data[index][1],
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
                                            snapshot.data[index][3],
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
                                            snapshot.data[index][4],
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
                                );

                          })
                        ),
                      ],
                    ),
                  ),
                ));
              } else {
                return const Text('Data 로딩 실패');
              }
            }),
        onWillPop: () async {
          backtoChapterList(context: context, file_name: file_name);
        });
  }
}
