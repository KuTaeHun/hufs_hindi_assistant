import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view.dart';

class hindiCommonVoca extends StatelessWidget {
  @override
  final List<Map> major_icon_images = [
    {
      'id': 0,
      'image': 'pictures/CFLPT_Logo/CFLPT_A0.jpg',
      'title': 'CLFPT A0 '
    },
    {'id': 1, 'image': 'pictures/CFLPT_Logo/CFLPT_A1.jpg', 'title': 'CLFPT A1'},
    {'id': 2, 'image': 'pictures/CFLPT_Logo/CFLPT_A2.jpg', 'title': 'CLFPT A2'},
    {'id': 3, 'image': 'pictures/CFLPT_Logo/CFLPT_B1.jpg', 'title': 'CLFPT B1'},
    {'id': 4, 'image': 'pictures/etc/elementary_hindi_reading.jpg', 'title': '초급문법 단어장'},
    {'id': 5, 'image': 'pictures/etc/middle_hindi_reading.jpg', 'title': '중급문법 단어장'},
    //{'id': 6, 'image': 'pictures/CFLPT_Logo/CFLPT_C2.jpg', 'title': 'CLFPT C2'},
  ];

  //해당 CFL 레벨 클릭시 해당 패이지로 연결되는 리스트
  List<dynamic> moving_link_cfl_list = [
    level_(A0_word_list_page, A0_word_list_scale, 'A0 단어장', 'assets/A0.xlsx'),
    level_(A1_word_list_page, A1_word_list_scale, 'A1 단어장', 'assets/A1.xlsx'),
    level_(A2_word_list_page, A2_word_list_scale, 'A2 단어장', 'assets/A2.xlsx'),
    level_(B1_word_list_page, B1_word_list_scale, "B1 단어장", "assets/B1.xlsx"),
    level_(elementary_grammar_word_list_page, elementary_grammar_word_list_scale, "초급문법 단어장", "assets/elementary_hindi_book.xlsx"),
    level_(middle_grammar_word_list_page, middle_grammar_word_list_scale, "중급문법 단어장", "assets/middle_hindi_book.xlsx"),

  ]; // B2는 아직 안 만들어졌음

  Widget build(BuildContext context) {
    //화면별 넓이 비율 자동 조절 변수
    var horizontal_size = MediaQuery.of(context).size.width-MediaQuery.of(context).padding.left
        -MediaQuery.of(context).padding.right;
    var vertical_size = (MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom);

    return Scaffold(
      backgroundColor:  Colors.grey[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: horizontal_size,
            height: vertical_size * 0.144,
            alignment: Alignment.center,
            decoration:  BoxDecoration(
              border:  Border.all(width: 0.1, color: Colors.black87),
            ),
            child:  Image.asset(
              'pictures/etc/level_banner.jpg',
              fit: BoxFit.fill,
              height: vertical_size * 0.144,
              width: horizontal_size,
            ),
          ),
          Expanded(child: Container(
            
            alignment: Alignment.center,
            child: GridView.builder(
              itemCount:  major_icon_images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.1),
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:  BorderRadius.circular(6),
                  ),
                  child: new GridTile(
                      footer: new Text(
                        major_icon_images[index]['title'],
                        textAlign: TextAlign.center,
                        softWrap: true,
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: true,
                        ),
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'hufsfontMedium',
                            letterSpacing: 1.2),
                      ),
                      child: new InkResponse(
                        enableFeedback: true,
                        onTap: () => {
                           Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                moving_link_cfl_list[index]),
                               (route)=>false,
                          ),
                        },
                        child: Container(
                          width:  250,
                          height:  300,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                          child: new Image.asset(
                            major_icon_images[index]['image'],
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                            width: 200,
                            height: 250,
                          ),
                        ),
                      )),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
