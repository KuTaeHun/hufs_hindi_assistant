import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HUFSHindiAssistant/word_list_page/make_infinite_save.dart';
import 'package:percent_indicator/percent_indicator.dart';

class home extends StatefulWidget {
  @override
  _mainfunction createState() => _mainfunction();
}

class _mainfunction extends State<home> {
  //메인 화면 팜플렛, 책 주소 및 파일

  //총 단어 수
  int total_word;

  //총 문장 수
  int total_sentence;

  //미암기 단어 수
  int rememorize_word;

  //미암기 문장 수
  int rememorize_sentence;

  //현재 학습 중인 문장 파트
  String this_part_word = '';
  String this_part_sentence = '';

  final List<Map> images = [
    {
      'id': 0,
      'image': 'pictures/informed_pictures/hindi_songfestival_first.jpg',
    },
    {
      'id': 1,
      'image': 'pictures/informed_pictures/hindi_songfestival_second.jpg',
    },
    {
      'id': 2,
      'image': 'pictures/informed_pictures/hindi_songfestival_third.jpg',
    },
    {
      'id': 3,
      'image': 'pictures/informed_pictures/hindi_verb_book_picture.png',
    },
  ];

  PageController pageController;
  int currentPage = 0;

  //평균 단어 등급
  String current_word_Grade = '';

  //평균 문장 등급
  String current_sentence_Grade = '';

  //현재 진행 완료된 단어, 문장 퍼센트
  double current_word_Percentage = 0.0;
  double current_sentence_Percentage = 0.0;

  _mainfunction()
  {
    _count_wrong_words();
    //단어 진행 완료된 퍼센트 불러오는 함수
    calculate_progress_word();
    //문장 진행 완료된 퍼센트 불러오는 함수
    calculate_progress_sentence();
    _downloading_current_word_chapter();
    _downloading_current_sentence_chapter();
  }
  @override
  void initState() {
    super.initState();
    pageController = PageController();

  }

//단어, 문장 퍼센트 불러오기
  _downloading_current_word_chapter() async {
    SharedPreferences completed_words_chapter =
        await SharedPreferences.getInstance();

    this.current_word_Percentage = completed_words_chapter
        .getDouble('total_completed_word_chapter_percent');
  }

  _downloading_current_sentence_chapter() async {
    SharedPreferences completed_sentences_chapter =
        await SharedPreferences.getInstance();
    this.current_sentence_Percentage = completed_sentences_chapter
        .getDouble('total_completed_sentence_chapter_percent');
  }

//틀린 단어 및 틀린 문장 갯수를 알려주는 함수
  _count_wrong_words() async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    setState(() {
      if ((wordlist.getInt('total_count_num')) == null) {
        (wordlist.setInt('total_count_num', 0));

        this.rememorize_word = (wordlist.getInt('total_count_num'));
      } else {
        this.rememorize_word = (wordlist.getInt('total_count_num') ?? 0);
      }
      if ((wordlist.getInt('total_count_sen')) == null) {
        (wordlist.setInt('total_count_sen', 0));

        this.rememorize_sentence = (wordlist.getInt('total_count_sen'));
      } else {
        this.rememorize_sentence = (wordlist.getInt('total_count_sen') ?? 0);
      }
      if (wordlist.getString('word_grade') == null) {
        this.current_word_Grade = '시험 미실시';
      } else {
        this.current_word_Grade = wordlist.getString('word_grade');
      }
      if (wordlist.getString('sentence_grade') == null) {
        this.current_sentence_Grade = '시험 미실시';
      } else {
        this.current_sentence_Grade = wordlist.getString('sentence_grade');
      }
      if (wordlist.getString('current_word_chapter') == null) {
        this.this_part_word = '학습 미완료';
      } else {
        this.this_part_word = wordlist.getString('current_word_chapter');
      }
      if (wordlist.getString('current_sentence_chapter') == null) {
        this.this_part_sentence = '학습 미완료';
      } else {
        this.this_part_sentence =
            wordlist.getString('current_sentence_chapter');
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  //공지사항 문장 글자 스타일
  var announcement_text_style = const TextStyle(
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    fontFamily: 'hufsfontLight',
    fontSize: 12.0,
    color: Colors.black,
  );

  var horizontal_size;
  var vertical_size;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //화면별 넓이 비율 자동 조절 변수
     horizontal_size = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
     vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);


  }

  Widget homepage(BuildContext context,int index){
    List<Widget> homepage = [




      Container(
        width: horizontal_size,
        height: vertical_size * 0.22,
        child:  Card(
          clipBehavior: Clip.antiAlias,
          child: Column(

            children: [
              Container(
                width: horizontal_size,
                height: vertical_size * 0.08,

                child: const ListTile(
                  title: AutoSizeText(
                    "최근 단어 학습 및 평균 성적",
                    maxFontSize: 18,
                    minFontSize: 14,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: AutoSizeText(
                    "저번 시간까지 학습을 진행했던 단어 챕터를 보여줍니다.\n",
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(
                width: horizontal_size,
                height: vertical_size * 0.02,
              ),
              Container(
                width: horizontal_size,
                height: vertical_size * 0.105,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            // width: horizontal_size * 0.6,
                            // height: vertical_size * 0.1,
                            child: const AutoSizeText(
                              "단어 챕터",
                              minFontSize: 12,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            // width: horizontal_size * 0.6,
                            // height: vertical_size * 0.2,
                            child: AutoSizeText(
                              this.this_part_word,
                              minFontSize: 9,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      // width: horizontal_size * 0.6,
                      // height: vertical_size * 0.2,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            // width: horizontal_size * 0.4,
                            // height: vertical_size * 0.07,
                            child: const AutoSizeText(
                              "평균 등급",
                              minFontSize: 12,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            // width: horizontal_size * 0.4,
                            // height: vertical_size * 0.13,
                            child: AutoSizeText(
                              this.current_word_Grade,
                              minFontSize: 9,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      // width: horizontal_size * 0.4,
                      // height: vertical_size * 0.2,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        width: horizontal_size,
        height: vertical_size * 0.22,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                width: horizontal_size,
                height: vertical_size * 0.08,
                child: ListTile(
                  title: const AutoSizeText(
                    "최근 문장 학습 및 평균 성적",
                    maxFontSize: 18,
                    minFontSize: 14,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle:const AutoSizeText(
                    "저번 시간까지 학습을 진행했던 문장 챕터를 보여줍니다.",
                    style:  TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(
                width: horizontal_size,
                height: vertical_size * 0.02,
              ),
              Container(
                width: horizontal_size,
                height: vertical_size * 0.105,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: const AutoSizeText(
                              "문장 챕터",
                              minFontSize: 12,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: AutoSizeText(
                              this.this_part_sentence,
                              minFontSize: 9,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: const AutoSizeText(
                              "평균 등급",
                              minFontSize: 12,
                              style:const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: AutoSizeText(
                              this.current_sentence_Grade,
                              minFontSize: 9,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        width: horizontal_size,
        height: vertical_size * 0.23,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                width: horizontal_size,
                height: vertical_size*0.08,
                child: ListTile(
                  title: const AutoSizeText(
                    "복습이 필요한 단어",
                    maxFontSize: 18,
                    minFontSize: 14,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const AutoSizeText(
                    "나의 단어 복습 파트에서 내가 틀린 단어를 볼 수 있습니다.\n완전 암기된 단어들은 옆으로 슬라이드해 삭제 해보세요.",
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(
                height: vertical_size*0.035,
                width: horizontal_size,
              ),
              Container(
                width: horizontal_size,
                height: vertical_size*0.095,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          const AutoSizeText(
                            "복습 단어 수",
                            minFontSize: 12,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            (this.rememorize_word.toString() + "개"),
                            minFontSize: 9,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          const AutoSizeText(
                            "복습 문장 수",
                            minFontSize: 12,
                            style:const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            (this.rememorize_sentence.toString() + "개"),
                            minFontSize: 9,
                            style:const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        width: horizontal_size,
        height: vertical_size * 0.37,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                height: vertical_size*0.08,
                width: horizontal_size,
                child: ListTile(
                  title: const AutoSizeText(
                    "학습 진도율",
                    maxFontSize: 18,
                    minFontSize: 14,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const AutoSizeText(
                    "총 단어 중에서 한 번이상 본 챕터를 기록합니다.\n학습량을 늘려 100%의 진도율을 완성해 보세요.",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: horizontal_size,
                height: vertical_size*0.05,
              ),
              Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: new CircularPercentIndicator(
                        radius: horizontal_size * 0.27,
                        lineWidth: horizontal_size * 0.035,
                        animation: true,
                        percent: this.current_word_Percentage,
                        center: new Text(
                          ((this.current_word_Percentage) * 100)
                              .toStringAsFixed(2)
                              .toString() +
                              "%",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        footer: const Text(
                          "단어 진행률",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      ),
                    ),
                    Container(
                      child: new CircularPercentIndicator(
                        radius: horizontal_size * 0.27,
                        lineWidth: horizontal_size * 0.035,
                        animation: true,
                        percent: this.current_sentence_Percentage,
                        center:  Text(
                          ((this.current_sentence_Percentage) * 100)
                              .toStringAsFixed(2)
                              .toString() +
                              "%",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        footer: const Text(
                          "문장 진행률",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ];
    return homepage[index];
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Container(
      width: horizontal_size,
      height: vertical_size,
      child: ListView.builder(itemCount:4, itemBuilder: (context,index){
        return homepage(context,index);
      },),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(240, 10, 15, 64),
            Color.fromARGB(240, 108, 121, 240)
          ])),
    ));
  }
}
