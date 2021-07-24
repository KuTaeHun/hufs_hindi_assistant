/*현재 단어, 문장 학습 진도률 체크해주는 함수와 퍼센트 위젯으로 해당 부분이 얼만큼 진행했는지 알려주는 위젯*/

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/CFLPT_chapter_list.dart';

//단어 진도률을 계산하는 함수
calculate_progress_word() async{
  int current_percentage =0;
  int total_length = A0_word_list_page.length+ A1_word_list_page.length+A2_word_list_page.length+B1_word_list_page.length;
  List<String> total_page = A0_word_list_page+ A1_word_list_page+A2_word_list_page+B1_word_list_page;
  SharedPreferences completed_words_chapter = await SharedPreferences.getInstance();
  for (int i =0; i<total_length; i++){
    if(completed_words_chapter.getInt(total_page[i])==1){
      current_percentage+=1;
    }
  }
  double percentage;
  percentage = ((current_percentage/total_length));

  completed_words_chapter.setDouble('total_completed_word_chapter_percent', percentage);
}
//문장 진도률을 계산하는 함수
calculate_progress_sentence() async{
  int current_percentage =0;
  int total_length = A0_word_list_page.length+ A1_word_list_page.length+A2_word_list_page.length+B1_word_list_page.length;
  List<String> total_page = A0_word_list_page+ A1_word_list_page+A2_word_list_page+B1_word_list_page;
  SharedPreferences completed_sentences_chapter = await SharedPreferences.getInstance();
  for (int i =0; i<total_length; i++){
    if(completed_sentences_chapter.getInt("sen"+total_page[i])==2){
      current_percentage+=1;
    }
  }

  double percentage;
  percentage = ((current_percentage/total_length));

  completed_sentences_chapter.setDouble('total_completed_sentence_chapter_percent', percentage);
}

