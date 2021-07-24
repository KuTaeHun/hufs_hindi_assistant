import 'package:HUFSHindiAssistant/function/pageroute.dart';
import 'package:HUFSHindiAssistant/word_list_page/list_voca_grammar.dart';
import 'package:HUFSHindiAssistant/word_list_page/word_one_by_one_grammar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:HUFSHindiAssistant/word_list_page/Test_voca.dart';
import 'package:HUFSHindiAssistant/word_list_page/list_voca.dart';
import 'package:HUFSHindiAssistant/word_list_page/word_one_by_one_view.dart';
import 'package:HUFSHindiAssistant/function/unmemory_list.dart';
import '../main.dart';

//단어 외우는 방식 정할 때 나오는 사진, 문자
final List<Map> select_icon_for_word = [
  {'id': 0, 'image': 'pictures/Choice_Voca/List_Voca.jpg', 'title': '단어장'},
  {
    'id': 1,
    'image': 'pictures/Choice_Voca/One_by_one_voca.jpg',
    'title': '하나씩'
  },
  {'id': 2, 'image': 'pictures/Choice_Voca/Test_voca.jpg', 'title': '테스트'},
];

class level_ extends StatefulWidget {
  List<String> wordlist;
  String chapter_list;
  List<List> start_end_num;
  String file_name;

  level_(List<String> wordlist, List<List> start_end_num, String chapter_list,
      String file_name) {
    this.wordlist = wordlist;
    this.chapter_list = chapter_list;
    this.start_end_num = start_end_num;
    this.file_name = file_name;
  }

  @override
  level_State createState() => level_State(
      this.wordlist, this.start_end_num, this.chapter_list, this.file_name);
}

class level_State extends State<level_> {
  String chapter_list;
  List<String> wordlist;
  List<List> start_end_num;
  String file_name;

  //챕터 목록에서 학습한 부분은 체크 아이콘으로 변경되는 함수.
  Future<List<bool>> identical_check_icon;

  level_State(List<String> wordlist, List<List> start_end_num,
      String chapter_list, String file_name)  {
    this.chapter_list = chapter_list;
    this.wordlist = wordlist;
    this.start_end_num = start_end_num;
    this.file_name = file_name;




  }



  //해당 챕터를 진행했는지 아니면 아직 진행하지 않았는지 구분하는 함수. 1이면 해당 챕터 공부했음, null이면 아직 안 함.
  _completed_chapter_word_distinguish(String chapter) async {
    SharedPreferences completed_words_chapter =
        await SharedPreferences.getInstance();
    setState(() {
      completed_words_chapter.setInt(chapter, 1);
    });
  }

  Future<List<bool>>_check_learned_chapter(List<String> chapter) async{

    Future<List<bool>> num;

    SharedPreferences completed_words_chapter =
    await SharedPreferences.getInstance();
    setState(() {
      num= Future((){
        List<bool> temp=[];

        for(int i=0; i<chapter.length; i++){
          if(completed_words_chapter.getInt(chapter[i])==null || completed_words_chapter.getInt(chapter[i])!=1)
          {
            temp.add(false);
          }
          else{
            temp.add(true);
          }

        }
        return temp;
      });
    });

    return num;

    }




  //해당 챕터를 저장한 부분을 불러오고 없으면 저장하는 함수
  _loading(String chapter) async {
    SharedPreferences wordlist = await SharedPreferences.getInstance();
    setState(() {
      if ((wordlist.getString('current_word_chapter')) == null) {
        (wordlist.setString('current_word_chapter', '학습 미완료'));
      } else
        (wordlist.setString('current_word_chapter', chapter));
    });
  }

  void alert(BuildContext context, int start, int end, String page_title,
      String file_name) {
    AlertDialog alert = AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      title: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.indigo,
        child: Container(
          width: horizontal_size * 0.8,
          height: vertical_size * 0.04,
          child: const Text(
            '암기 방법 선택',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'hunfsfontBold',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
      content: Builder(
        builder: (context) {
          loading = false;


          return WillPopScope(
              child: Container(
                margin: const EdgeInsets.all(10),
                color:  Colors.red.withOpacity(0),
                width: horizontal_size * 0.8,
                height: vertical_size * 0.2,
                padding:  EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        child: Container(
                          width: horizontal_size * 0.23,
                          height: vertical_size * 0.19,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                select_icon_for_word[0]['image'],
                                width: horizontal_size * 0.2,
                                height: vertical_size * 0.13,
                              ),
                               Text(
                                select_icon_for_word[0]['title'],
                                style:const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          if (this.file_name.compareTo(
                              'assets/elementary_hindi_book.xlsx') ==
                              0 ||
                              this.file_name.compareTo(
                                  'assets/middle_hindi_book.xlsx') ==
                                  0) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                new word_list_voca_grammar(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                                (route)=> false,
                            );
                          } else
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new word_list_voca(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                                (route)=> false,
                            );
                        }),
                    InkWell(
                        child: Container(
                          width: horizontal_size * 0.23,
                          height: vertical_size * 0.19,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                select_icon_for_word[1]['image'],
                                width: horizontal_size * 0.2,
                                height: vertical_size * 0.13,
                              ),
                              Text(
                                select_icon_for_word[1]['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          if (this.file_name.compareTo(
                              'assets/elementary_hindi_book.xlsx') ==
                              0 ||
                              this.file_name.compareTo(
                                  'assets/middle_hindi_book.xlsx') ==
                                  0) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                new word_one_by_one_view_grammar(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                                (route)=> false,
                            );
                          } else
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                new word_one_by_one_view(
                                  start_word_num: start,
                                  finish_word_num: end,
                                  page_name: page_title,
                                  file_name: file_name,
                                ),
                              ),
                                (route)=> false,
                            );
                        }),
                    InkWell(
                        child: Container(
                          width: horizontal_size * 0.23,
                          height: vertical_size * 0.19,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                select_icon_for_word[2]['image'],
                                width: horizontal_size * 0.2,
                                height: vertical_size * 0.13,
                              ),
                              Text(
                                select_icon_for_word[2]['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new TestVoca(
                                start_word_num: start,
                                finish_word_num: end,
                                page_name: page_title,
                                file_name: file_name,
                              ),
                            ),
                              (route)=> false,
                          );
                        }),
                  ],
                ),
              ),
              onWillPop: () async {
                Navigator.pop(context);
              });
        },
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  void initState() {

    // TODO: implement initState
    loading = false;
    identical_check_icon = _check_learned_chapter(this.wordlist);

  }

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

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: ()async{
        listtoMain(context: context);
      },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading:Builder(


                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp(),),
                          (route)=>false,
                      );
                    },
                  );
                },
              ),
              shadowColor: Colors.white,
              centerTitle: true,
              backgroundColor: Color.fromARGB(240, 10, 15, 64),
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
            ),
            body: FutureBuilder(
              future: this.identical_check_icon,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data==null){
                  return CircularProgressIndicator();
                }
                else{
                  return Column(
                    children: [
                      Container(
                        width: horizontal_size,
                        height: vertical_size * 0.08,
                        alignment: Alignment.centerLeft,
                        padding:const EdgeInsets.only(left: 25),
                        child: Text(
                          chapter_list,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            fontFamily: 'hufsfontMedium',
                            height: 3,
                            textBaseline: TextBaseline.ideographic,
                          ),
                        ),
                      ),
                      loadingAnimation(
                          loading, vertical_size * 0.01, horizontal_size),
                      Expanded(
                        child: ListView.builder(

                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          itemCount: wordlist.length,
                          itemBuilder: (BuildContext context, int index) {


                            int this_page_start_num = start_end_num[index][0];
                            int this_page_end_num = start_end_num[index][1];

                            return ListTile(

                                title: Text(wordlist[index]),
                                trailing: snapshot.data[index]==false? const Icon(Icons.keyboard_arrow_right):const Icon(Icons.done_outline,color: Colors.green,),
                                onTap: () {
                                  setState(() {
                                    //챕터 클릭하면 완료한 챕터로 표시
                                    _completed_chapter_word_distinguish(
                                        wordlist[index]);
                                    _loading(wordlist[index]);
                                  });
                                  alert(context, this_page_start_num,
                                      this_page_end_num, wordlist[index], file_name);
                                });
                          },
                        ),
                      ),
                    ],
                  );
                }


              },
            ),
          ),
        ),
       );
  }
}




Widget loadingAnimation(
    bool loading, double vertical_size, double horizontal_size) {
  if (loading) {
    return const LinearProgressIndicator();
  } else {
    return  Divider(
      color: Colors.white,
      height: vertical_size,
    );
  }
}
