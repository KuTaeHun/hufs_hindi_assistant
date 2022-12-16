import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:HUFSHindiAssistant/clfpt_wordlist/CFLPT_chapter_list.dart';

import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view.dart';

import 'package:HUFSHindiAssistant/clfpt_wordlist/word_list_view_sentence.dart';

import 'package:HUFSHindiAssistant/hindiCommonVoca_Sentence.dart';

import '../main.dart';

//시험,리스트, 카드 형식에서 학습 도중 해당 레벨 챕터로 돌아갈때 쓰는 함수

Future<bool> backtoChapterList(
    {@required BuildContext context, @required var file_name}) async {
  if (file_name.compareTo('assets/A0.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            A0_word_list_page, A0_word_list_scale, 'A0 단어장', 'assets/A0.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/A1.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            A1_word_list_page, A1_word_list_scale, 'A1 단어장', 'assets/A1.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/A2.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            A2_word_list_page, A2_word_list_scale, 'A2 단어장', 'assets/A2.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/B1.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            B1_word_list_page, B1_word_list_scale, 'B1 단어장', 'assets/B1.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/B2.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            B1_word_list_page, B1_word_list_scale, 'B1 단어장', 'assets/B1.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/middle_hindi_book.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            middle_grammar_word_list_page,
            middle_grammar_word_list_scale,
            '중급문법 단어장',
            'assets/middle_hindi_book.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name == 'assets/elementary_hindi_book.xlsx') {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_(
            elementary_grammar_word_list_page,
            elementary_grammar_word_list_scale,
            '초급문법 단어장',
            'assets/elementary_hindi_book.xlsx'),
      ),
      (route) => false,
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => MyApp()),
      (route) => false,
    );
  }
  return true;
}

//문장 학습에서 학습 도중 해당 레벨 챕터로 돌아갈때 쓰는 함수

Future<bool> Sentence_backtoChapterList (
    {@required BuildContext context, @required var file_name}) async {
  if (file_name.compareTo('assets/A0.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_Sentence(
            A0_word_list_page, A0_word_list_scale, 'A0 단어장', 'assets/A0.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/A1.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_Sentence(
            A1_word_list_page, A1_word_list_scale, 'A1 단어장', 'assets/A1.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/A2.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_Sentence(
            A2_word_list_page, A2_word_list_scale, 'A2 단어장', 'assets/A2.xlsx'),
      ),
      (route) => false,
    );
  } else if (file_name.compareTo('assets/B1.xlsx') == 0) {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(
        builder: (context) => level_Sentence(
            B1_word_list_page, B1_word_list_scale, 'B1 단어장', 'assets/B1.xlsx'),
      ),
      (route) => false,
    );
  } else {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => MyApp()),
      (route) => false,
    );
  }
  return true;
}

//해당 레벨의 챕터에서 뒤로가기 버튼을 눌렀을 때 메인 화면으로 이동하는 함수.

Future<bool> listtoMain({@required BuildContext context}) async{
  Navigator.pushAndRemoveUntil(
    context,
    CupertinoPageRoute(builder: (context) => MyApp()),
    (route) => false,
  );
  return true;
}

//문장 학습을 하는 도중 나갈때 나갈지 묻는 함수

void sen_show_quit_dialog(BuildContext context, String file_name) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text('아직 학습이 진행중입니다. 해당 챕터 목차로 이동할까요?'),
              actions: <Widget>[
                ElevatedButton(
                    child: Text('아니오'),
                    onPressed: () => Navigator.of(context).pop(false)),
                ElevatedButton(
                    child: Text('예'),
                    onPressed: () {
                      Sentence_backtoChapterList(
                          context: context, file_name: file_name);
                    }),
              ]));
}

//단어 테스트를 보는 도중에 나갈때 해당 챕터로 이동하는 함수

void show_quit_dialog(BuildContext context, String file_name) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: Text('아직 시험이 진행중입니다. 해당 챕터 목차로 이동할까요?'),
              actions: <Widget>[
                ElevatedButton(
                    child: Text('아니오'),
                    onPressed: () => Navigator.of(context).pop(false)),
                ElevatedButton(
                    child: Text('예'),
                    onPressed: () {
                      backtoChapterList(context: context, file_name: file_name);
                    }),
              ]));
}
