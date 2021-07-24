import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HUFSHindiAssistant/function/pageroute.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:HUFSHindiAssistant/main.dart';

//시험 후 틀린 단어 한 번 보고 시험 점수도 알 수 있는 페이지

class test_result extends StatefulWidget {
  //해당 단원 이름
  String _page_name;

  //해당 단원 단어 총 갯수
  int _total_itemcount;

  //맞은 단어
  int _correct_count;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  test_result(String _page_name, int _total_itemcount, int _correct_count,
      List<String> wrong_hindi_words, List<String> wrong_korean_words) {
    this._page_name = _page_name;
    this._total_itemcount = _total_itemcount;
    this._correct_count = _correct_count;
    this.wrong_hindi_words = wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;
  }

  @override
  _test_resultState createState() => _test_resultState(
      this._page_name,
      this._total_itemcount,
      this._correct_count,
      this.wrong_hindi_words,
      this.wrong_korean_words);
}

class _test_resultState extends State<test_result> {
  //해당 단원 이름
  String _page_name;

  //해당 단원 단어 총 갯수
  int _total_itemcount;

  //맞은 단어
  int _correct_count;

  // 틀린 단어 리스트 형식
  var _incorrect_word_list;

  //총 점수(100점 만점)
  int _total_score;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  _test_resultState(String _page_name, int _total_itemcount, int _correct_count,
      List<String> wrong_hindi_words, List<String> wrong_korean_words) {
    this._page_name = _page_name;
    this._total_itemcount = _total_itemcount;
    this._correct_count = _correct_count;
    this._incorrect_word_list = _incorrect_word_list;
    this.wrong_hindi_words = wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;

    _total_score =
        ((this._correct_count / this._total_itemcount) * 100).round();
    _fixCorrect(this._correct_count);
    _fixTotalCount(this._total_itemcount);
    _fixGrade();

  }

  //지금까지 맞은 갯수를 수정하여 다시 기록하는 함수
  _fixCorrect(int this_page_correct) async{
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    int current_correct =0;
    setState(() {
      if ((wordlist.getInt('total_word_correct')) == null) {
        (wordlist.setInt('total_word_correct', this_page_correct));


      }
      else{
        current_correct = wordlist.getInt('total_word_correct');
        current_correct += this_page_correct;
        wordlist.setInt('total_word_correct', current_correct);
      }

    });
  }

  //지금까지 총 푼 갯수를 수정하여 다시 기록하는 함수
  _fixTotalCount(int this_page_total) async{
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    int current_total =0;
    setState(() {
      if ((wordlist.getInt('total_word')) == null) {
        (wordlist.setInt('total_word', this_page_total));


      }
      else{
        current_total = wordlist.getInt('total_word');
        current_total = current_total+ this_page_total;
        wordlist.setInt('total_word', current_total);
      }

    });
  }

  _fixGrade() async{
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    var total_record_score;
    String total_record_grade = ' ';
    var total_word_num;
    var correct_word_num;

    setState(() {
      if((wordlist.getInt('total_word'))==null || (wordlist.getInt('total_word_correct'))==null)
      {
        total_record_grade = '시험 미실시';
        total_record_score = 0;
        wordlist.setString('word_grade', total_record_grade);
      }
      else{
        total_word_num = wordlist.getInt('total_word');
        correct_word_num = wordlist.getInt('total_word_correct');
        total_record_score = ((correct_word_num/total_word_num)*100).round();

        if(total_record_score>=0 && total_record_score<30)
          total_record_grade = 'F';
        else if(total_record_score>=30 && total_record_score<50)
          total_record_grade = 'D';
        else if(total_record_score>=50 && total_record_score<60)
          total_record_grade = 'C';
        else if(total_record_score>=60 && total_record_score<70)
          total_record_grade='B';
        else if(total_record_score>70 && total_record_score<80)
          total_record_grade = 'B+';
        else if(total_record_score>=80 && total_record_score<90)
          total_record_grade = 'A';
        else
          total_record_grade = 'A+';

        wordlist.setString('word_grade', total_record_grade);
      }

    });
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


    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width:  AppBar().preferredSize.width * 0.2,
                    height: AppBar().preferredSize.height * 0.95,
                    child: IconButton(
                      icon: const  Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () async {
                        return listtoMain(context: context);
                      },
                    ),
                  );
                },
              ),
              shadowColor:  Colors.black26,
              centerTitle: true,
              backgroundColor: const Color.fromARGB(240, 10, 15, 64),
              title: const Text(
                "단어 시험 결과",
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
                    height: vertical_size * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:  horizontal_size * 0.4,
                          height:  vertical_size * 0.08,
                          alignment:  Alignment.center,
                          margin: const EdgeInsets.only(left: 0.5),
                          child:  Text(
                            _page_name,
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
                          height: vertical_size * 0.08,
                          alignment:  Alignment.center,
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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                    width: horizontal_size * 0.95,
                    height: vertical_size * 0.8,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                           BoxShadow(
                              color: Colors.black12,
                              offset:  const  Offset(3.0, 3.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0)
                        ]),
                    child: Column(
                      children: [
                        //점수판
                        Container(
                          width: horizontal_size * 0.9,
                          height: vertical_size * 0.25,
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Column(
                            children: [
                              Container(
                                width: horizontal_size * 0.3,
                                height: vertical_size * 0.1,
                                alignment: Alignment.center,
                                child: Text(
                                  (_total_score.toString() + " 점"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 3,
                              ),
                               Container(
                                width: horizontal_size * 0.3,
                                height: vertical_size * 0.1,
                                alignment: Alignment.center,
                                child: Text(
                                  (_correct_count.toString() +
                                      "/" +
                                      _total_itemcount.toString()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: horizontal_size * 0.85,
                          height: vertical_size * 0.08,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          alignment: Alignment.center,
                          child: const Text(
                            "틀린 단어",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child:  Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  //margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 0.8),
                                      child: AutoSizeText(
                                        wrong_hindi_words[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        minFontSize: 15,
                                        maxLines: 3,
                                      ),
                                    ),
                                    subtitle: AutoSizeText(
                                      wrong_korean_words[index],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black,
                                      ),
                                      maxLines: 3,
                                      minFontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            },
                            scrollDirection:  Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.black26,
                            ),
                            itemCount: wrong_hindi_words.length,
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
        onWillPop: () async {
          listtoMain(context: context);
        });
  }
}

class mySentence_result extends StatefulWidget {
  //해당 단원 이름
  String _page_name;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  mySentence_result(String _page_name, List<String> wrong_hindi_words,
      List<String> wrong_korean_words) {
    this._page_name = _page_name;

    this.wrong_hindi_words = wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;
  }

  @override
  _mySentence_resultState createState() => _mySentence_resultState(
      this._page_name, this.wrong_hindi_words, this.wrong_korean_words);
}

class _mySentence_resultState extends State<mySentence_result> {
  //해당 단원 이름
  String _page_name;

  //이번 해당 장에 틀린 힌디어 단어 리스트
  List<String> wrong_hindi_words = new List<String>();
  List<String> wrong_korean_words = new List<String>();

  _mySentence_resultState(String _page_name, List<String> wrong_hindi_words,
      List<String> wrong_korean_words) {
    this._page_name = _page_name;

    this.wrong_hindi_words = wrong_hindi_words;
    this.wrong_korean_words = wrong_korean_words;
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
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: AppBar().preferredSize.width * 0.2,
                    height: AppBar().preferredSize.height * 0.95,
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => MyApp(),
                          ),
                            (route)=>false,
                        );
                      },
                    ),
                  );
                },
              ),
              shadowColor: Colors.black26,
              centerTitle: true,
              backgroundColor: const Color.fromARGB(240, 10, 15, 64),
              title: const Text(
                "HUFS 힌디 단어장",
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
                    height: vertical_size * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: horizontal_size * 0.4,
                          height: vertical_size * 0.08,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 0.5),
                          child: Text(
                            _page_name,
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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                    width: horizontal_size * 0.95,
                    height: vertical_size * 0.8,
                    decoration:  BoxDecoration(
                        color: const Color.fromARGB(240, 242, 242, 242),
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          const BoxShadow(
                              color: Colors.black12,
                              offset:  Offset(3.0, 3.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0)
                        ]),
                    child: Column(
                      children: [
                        //점수판

                        Container(
                          width: horizontal_size * 0.85,
                          height: vertical_size * 0.08,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          alignment: Alignment.center,
                          child: const Text(
                            "틀린 단어",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: wrong_hindi_words.length,


                              itemBuilder: (BuildContext context, int index){
                                return Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  //margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 0.8),
                                      child: AutoSizeText(
                                        wrong_hindi_words[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        minFontSize: 15,
                                        maxLines: 3,
                                      ),
                                    ),
                                    subtitle: AutoSizeText(
                                      wrong_korean_words[index],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black,
                                      ),
                                      maxLines: 3,
                                      minFontSize: 10,
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async{
          return listtoMain(context: context);
        });
  }
}
