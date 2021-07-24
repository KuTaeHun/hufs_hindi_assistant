import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HUFSHindiAssistant/clfpt_wordlist/CFLPT_chapter_list.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

Future<List<dynamic>> make_word_list(
    {@ required int start_index,
      @required int finish_index,
      @ required String words_level,
      @required String file_name}) async {
  int start, end;
  ByteData data;


  if (words_level.compareTo('assets/A0.xlsx') == 0) {
    if (start_index >= 1 && finish_index <= 30) {

      start = 0;
      end = 30;
    } else if (start_index >= 31 && finish_index <= 60) {
      start = 30;
      end = 60;
    } else {
      start = 60;
      end = 97;
    }
    data = await rootBundle.load('assets/A0.xlsx');

  }
  if (words_level.compareTo('assets/A1.xlsx') == 0) {
    if (start_index >= 1 && finish_index <= 90) {
      if (start_index >= 1 && finish_index <= 30) {
        start = 0;
        end = 30;

      } else if (start_index >= 31 && finish_index <= 60) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_1.xlsx');
    }
    else if (start_index >= 91 && finish_index <= 180) {
      if (start_index >= 91 && finish_index <= 120) {
        start = 0;
        end = 30;
      } else if (start_index >= 121 && finish_index <= 150) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_2.xlsx');
    }
    else if (start_index >= 181 && finish_index <= 270) {
      if (start_index >= 181 && finish_index <= 210) {
        start = 0;
        end = 30;
      } else if (start_index >= 211 && finish_index <= 240) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_3.xlsx');
    }
    else if (start_index >= 271 && finish_index <= 360) {
      if (start_index >= 271 && finish_index <= 300) {
        start = 0;
        end = 30;
      } else if (start_index >= 301 && finish_index <= 330) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_4.xlsx');
    }
    else if (start_index >= 361 && finish_index <= 450) {
      if (start_index >= 361 && finish_index <= 390) {
        start = 0;
        end = 30;
      } else if (start_index >= 391 && finish_index <= 420) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_5.xlsx');
    }
    else if (start_index >= 451 && finish_index <= 540) {
      if (start_index >= 451 && finish_index <= 480) {
        start = 0;
        end = 30;
      } else if (start_index >= 481 && finish_index <= 510) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_6.xlsx');
    }
    else if (start_index >= 541 && finish_index <= 630) {
      if (start_index >= 541 && finish_index <= 570) {
        start = 0;
        end = 30;
      }
      else if (start_index >= 571 && finish_index <= 600) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A1_7.xlsx');
    }
    else {
      if (start_index >= 631 && finish_index <= 660) {
        start = 0;
        end = 30;
      } else if (start_index >= 661 && finish_index <= 690) {
        start = 30;
        end = 60;
      } else if (start_index >= 691 && finish_index <= 720) {
        start = 60;
        end = 90;
      } else {
        start = 91;
        end = 114;
      }

      data = await rootBundle.load('assets/A1_8.xlsx');
    }
  }
  if (words_level.compareTo('assets/A2.xlsx') == 0) {
    if (start_index >= 1 && finish_index <= 90) {
      if (start_index >= 1 && finish_index <= 30) {
        start = 0;
        end = 30;
      } else if (start_index >= 31 && finish_index <= 60) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_1.xlsx');
    } else if (start_index >= 91 && finish_index <= 180) {
      if (start_index >= 91 && finish_index <= 120) {
        start = 0;
        end = 30;
      } else if (start_index >= 121 && finish_index <= 150) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_2.xlsx');
    } else if (start_index >= 181 && finish_index <= 270) {
      if (start_index >= 181 && finish_index <= 210) {
        start = 0;
        end = 30;
      } else if (start_index >= 211 && finish_index <= 240) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_3.xlsx');
    } else if (start_index >= 271 && finish_index <= 360) {
      if (start_index >= 271 && finish_index <= 300) {
        start = 0;
        end = 30;
      } else if (start_index >= 301 && finish_index <= 330) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_4.xlsx');
    } else if (start_index >= 361 && finish_index <= 450) {
      if (start_index >= 361 && finish_index <= 390) {
        start = 0;
        end = 30;
      } else if (start_index >= 391 && finish_index <= 420) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_5.xlsx');
    } else if (start_index >= 451 && finish_index <= 540) {
      if (start_index >= 451 && finish_index <= 480) {
        start = 0;
        end = 30;
      } else if (start_index >= 481 && finish_index <= 510) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_6.xlsx');
    } else if (start_index >= 541 && finish_index <= 630) {
      if (start_index >= 541 && finish_index <= 570) {
        start = 0;
        end = 30;
      } else if (start_index >= 571 && finish_index <= 600) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_7.xlsx');
    } else if (start_index >= 631 && finish_index <= 720) {
      if (start_index >= 631 && finish_index <= 660) {
        start = 0;
        end = 30;
      } else if (start_index >= 661 && finish_index <= 690) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_8.xlsx');
    } else if (start_index >= 721 && finish_index <= 810) {
      if (start_index >= 721 && finish_index <= 750) {
        start = 0;
        end = 30;
      } else if (start_index >= 751 && finish_index <= 780) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/A2_9.xlsx');
    } else {
      if (start_index >= 811 && finish_index <= 840) {
        start = 0;
        end = 30;
      } else if (start_index >= 841 && finish_index <= 870) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 80;
      }
      data = await rootBundle.load('assets/A2_10.xlsx');
    }
  }
   if (words_level.compareTo('assets/B1.xlsx') == 0) {
    if (start_index >= 1 && finish_index <= 90) {
      if (start_index >= 1 && finish_index <= 30) {
        start = 0;
        end = 30;
      } else if (start_index >= 31 && finish_index <= 60) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_1.xlsx');
    } else if (start_index >= 91 && finish_index <= 180) {
      if (start_index >= 91 && finish_index <= 120) {
        start = 0;
        end = 30;
      } else if (start_index >= 121 && finish_index <= 150) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_2.xlsx');
    } else if (start_index >= 181 && finish_index <= 270) {
      if (start_index >= 181 && finish_index <= 210) {
        start = 0;
        end = 30;
      } else if (start_index >= 211 && finish_index <= 240) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_3.xlsx');
    } else if (start_index >= 271 && finish_index <= 360) {
      if (start_index >= 271 && finish_index <= 300) {
        start = 0;
        end = 30;
      } else if (start_index >= 301 && finish_index <= 330) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_4.xlsx');
    } else if (start_index >= 361 && finish_index <= 450) {
      if (start_index >= 361 && finish_index <= 390) {
        start = 0;
        end = 30;
      } else if (start_index >= 391 && finish_index <= 420) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_5.xlsx');
    } else if (start_index >= 451 && finish_index <= 540) {
      if (start_index >= 451 && finish_index <= 480) {
        start = 0;
        end = 30;
      } else if (start_index >= 481 && finish_index <= 510) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_6.xlsx');
    } else if (start_index >= 541 && finish_index <= 630) {
      if (start_index >= 541 && finish_index <= 570) {
        start = 0;
        end = 30;
      } else if (start_index >= 571 && finish_index <= 600) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_7.xlsx');
    } else if (start_index >= 631 && finish_index <= 720) {
      if (start_index >= 631 && finish_index <= 660) {
        start = 0;
        end = 30;
      } else if (start_index >= 661 && finish_index <= 690) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_8.xlsx');
    } else if (start_index >= 721 && finish_index <= 810) {
      if (start_index >= 721 && finish_index <= 750) {
        start = 0;
        end = 30;
      } else if (start_index >= 751 && finish_index <= 780) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_9.xlsx');
    } else if (start_index >= 811 && finish_index <= 900) {
      if (start_index >= 811 && finish_index <= 840) {
        start = 0;
        end = 30;
      } else if (start_index >= 841 && finish_index <= 870) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_10.xlsx');
    } else if (start_index >= 901 && finish_index <= 990) {
      if (start_index >= 901 && finish_index <= 930) {
        start = 0;
        end = 30;
      } else if (start_index >= 931 && finish_index <= 960) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_11.xlsx');
    } else if (start_index >= 991 && finish_index <= 1080) {
      if (start_index >= 991 && finish_index <= 1020) {
        start = 0;
        end = 30;
      } else if (start_index >= 1021 && finish_index <= 1050) {
        start = 30;
        end = 60;
      } else {
        start = 60;
        end = 90;
      }
      data = await rootBundle.load('assets/B1_12.xlsx');
    } else {
      if (start_index >= 1081 && finish_index <= 1110) {
        start = 0;
        end = 30;
      } else if (start_index >= 1111 && finish_index <= 1140) {
        start = 30;
        end = 60;
      } else if (start_index >= 1141 && finish_index <= 1172) {
        start = 60;
        end = 92;
      }

      data = await rootBundle.load('assets/B1_13.xlsx');
    }
  }
   if (words_level.compareTo('assets/elementary_hindi_book.xlsx') == 0) {
    if (file_name.compareTo('초급 문법 1,2과') == 0) {
      start = 0;
      end = 32;
      data = await rootBundle.load('assets/elementary_hindi_book(1~3).xlsx');
    }
    else if (file_name.compareTo('초급 문법 3과-1') == 0) {
      start = 32;
      end = 62;
      data = await rootBundle.load('assets/elementary_hindi_book(1~3).xlsx');
    }
    else if (file_name.compareTo('초급 문법 3과-2') == 0) {
      start = 62;
      end = 95;
      data = await rootBundle.load('assets/elementary_hindi_book(1~3).xlsx');
    }
    else if (file_name.compareTo('초급 문법 4과') == 0) {
      start = 1;
      end = 53;
      data = await rootBundle.load('assets/elementary_hindi_book(4~5).xlsx');
    }
    else if (file_name.compareTo('초급 문법 5과') == 0) {
      start = 53;
      end = 104;
      data = await rootBundle.load('assets/elementary_hindi_book(4~5).xlsx');
    }
    else if (file_name.compareTo('초급 문법 6과') == 0) {
      start = 1;
      end = 22;
      data = await rootBundle.load('assets/elementary_hindi_book(6~8).xlsx');
    }
    else if (file_name.compareTo('초급 문법 7과') == 0) {
      start = 22;
      end = 56;
      data = await rootBundle.load('assets/elementary_hindi_book(6~8).xlsx');
    }
    else if (file_name.compareTo('초급 문법 8과') == 0) {
      start = 56;
      end = 98;
      data = await rootBundle.load('assets/elementary_hindi_book(6~8).xlsx');
    }
    else if (file_name.compareTo('초급 문법 9과') == 0) {
      start = 1;
      end = 46;
      data = await rootBundle.load('assets/elementary_hindi_book(9~10).xlsx');
    }
    else if (file_name.compareTo('초급 문법 10과') == 0) {
      start = 46;
      end = 80;
      data = await rootBundle.load('assets/elementary_hindi_book(9~10).xlsx');
    }

    else if (file_name.compareTo('초급 문법 11과') == 0) {
      start = 1;
      end = 24;
      data = await rootBundle.load('assets/elementary_hindi_book(11~14).xlsx');
    }
    else if (file_name.compareTo('초급 문법 12과') == 0) {
      start = 24;
      end = 53;
      data = await rootBundle.load('assets/elementary_hindi_book(11~14).xlsx');
    }
    else if (file_name.compareTo('초급 문법 13과') == 0) {
      start = 53;
      end = 71;
      data = await rootBundle.load('assets/elementary_hindi_book(11~14).xlsx');
    }
    else if (file_name.compareTo('초급 문법 14과') == 0) {
      start = 71;
      end = 94;
      data = await rootBundle.load('assets/elementary_hindi_book(11~14).xlsx');
    }

    else if (file_name.compareTo('초급 문법 15과') == 0) {
      start = 1;
      end = 16;
      data = await rootBundle.load('assets/elementary_hindi_book(15~19).xlsx');
    }
    else if (file_name.compareTo('초급 문법 16과') == 0) {
      start = 16;
      end = 43;
      data = await rootBundle.load('assets/elementary_hindi_book(15~19).xlsx');
    }
    else if (file_name.compareTo('초급 문법 17과') == 0) {
      start = 43;
      end = 59;
      data = await rootBundle.load('assets/elementary_hindi_book(15~19).xlsx');
    }

    else if (file_name.compareTo('초급 문법 18과') == 0) {
      start = 59;
      end = 85;
      data = await rootBundle.load('assets/elementary_hindi_book(15~19).xlsx');
    }
    else if (file_name.compareTo('초급 문법 19과') == 0) {
      start = 85;
      end = 125;
      data = await rootBundle.load('assets/elementary_hindi_book(15~19).xlsx');
    }
    else if (file_name.compareTo('초급 문법 20과') == 0) {
      start = 1;
      end = 40;
      data = await rootBundle.load('assets/elementary_hindi_book(20~21).xlsx');
    }
    else if (file_name.compareTo('초급 문법 21과') == 0) {
      start = 40;
      end = 93;
      data = await rootBundle.load('assets/elementary_hindi_book(20~21).xlsx');
    }
    else if (file_name.compareTo('초급 문법 22과') == 0) {
      start = 1;
      end = 42;
      data = await rootBundle.load('assets/elementary_hindi_book(22~24).xlsx');
    }
    else if (file_name.compareTo('초급 문법 23과') == 0) {
      start = 42;
      end = 85;
      data = await rootBundle.load('assets/elementary_hindi_book(22~24).xlsx');
    }
    else if (file_name.compareTo('초급 문법 24과') == 0) {
      start = 85;
      end = 111;
      data = await rootBundle.load('assets/elementary_hindi_book(22~24).xlsx');
    }
  }
   if (words_level.compareTo('assets/middle_hindi_book.xlsx') == 0) {
    if (file_name.compareTo('중급 문법 1과') == 0) {
      start = 1;
      end = 47;
      data = await rootBundle.load('assets/middle_hindi_book(1~4).xlsx');
    }
    else if (file_name.compareTo('중급 문법 2과') == 0) {
      start = 47;
      end = 68;
      data = await rootBundle.load('assets/middle_hindi_book(1~4).xlsx');
    }
    else if (file_name.compareTo('중급 문법 3과') == 0) {
      start = 68;
      end = 81;
      data = await rootBundle.load('assets/middle_hindi_book(1~4).xlsx');
    }
    else if (file_name.compareTo('중급 문법 4과') == 0) {
      start = 81;
      end = 95;
      data = await rootBundle.load('assets/middle_hindi_book(1~4).xlsx');
    }

    else if (file_name.compareTo('중급 문법 5~7과') == 0) {
      start = 1;
      end = 19;
      data = await rootBundle.load('assets/middle_hindi_book(5~15).xlsx');
    }
    else if (file_name.compareTo('중급 문법 8과') == 0) {
      start = 19;
      end = 48;
      data = await rootBundle.load('assets/middle_hindi_book(5~15).xlsx');
    }
    else if (file_name.compareTo('중급 문법 9~11과') == 0) {
      start = 48;
      end = 62;
      data = await rootBundle.load('assets/middle_hindi_book(5~15).xlsx');
    }
    else if (file_name.compareTo('중급 문법 12과') == 0) {
      start = 62;
      end = 88;
      data = await rootBundle.load('assets/middle_hindi_book(5~15).xlsx');
    }
    else if (file_name.compareTo('중급 문법 13~15과') == 0) {
      start = 88;
      end = 107;
      data = await rootBundle.load('assets/middle_hindi_book(5~15).xlsx');
    }

    else if (file_name.compareTo('중급 문법 16~17과') == 0) {
      start = 1;
      end = 29;
      data = await rootBundle.load('assets/middle_hindi_book(16~24).xlsx');
    }
    else if (file_name.compareTo('중급 문법 18~21과') == 0) {
      start = 29;
      end = 51;
      data = await rootBundle.load('assets/middle_hindi_book(16~24).xlsx');
    }
    else if (file_name.compareTo('중급 문법 22~23과') == 0) {
      start = 51;
      end = 69;
      data = await rootBundle.load('assets/middle_hindi_book(16~24).xlsx');
    }
    else if (file_name.compareTo('중급 문법 24과') == 0) {
      start = 69;
      end = 102;
      data = await rootBundle.load('assets/middle_hindi_book(16~24).xlsx');
    }

    else if (file_name.compareTo('중급 문법 25과') == 0) {
      start = 1;
      end = 39;
      data = await rootBundle.load('assets/middle_hindi_book(25~33).xlsx');
    }
    else if (file_name.compareTo('중급 문법 26~29과') == 0) {
      start = 39;
      end = 64;
      data = await rootBundle.load('assets/middle_hindi_book(25~33).xlsx');
    }
    else if (file_name.compareTo('중급 문법 30~33과') == 0) {
      start = 64;
      end = 106;
      data = await rootBundle.load('assets/middle_hindi_book(25~33).xlsx');
    }
    else if (file_name.compareTo('중급 문법 34~36과') == 0) {
      start = 1;
      end = 34;
      data = await rootBundle.load('assets/middle_hindi_book(34~43).xlsx');
    }
    else if (file_name.compareTo('중급 문법 37~40과') == 0) {
      start = 34;
      end = 61;
      data = await rootBundle.load('assets/middle_hindi_book(34~43).xlsx');
    }
    else if (file_name.compareTo('중급 문법 41~43과') == 0) {
      start = 61;
      end = 102;
      data = await rootBundle.load('assets/middle_hindi_book(34~43).xlsx');
    }

    else if (file_name.compareTo('중급 문법 44과') == 0) {
      start = 1;
      end = 24;
      data = await rootBundle.load('assets/middle_hindi_book(44~49).xlsx');
    }
    else if (file_name.compareTo('중급 문법 45~46과') == 0) {
      start = 24;
      end = 43;
      data = await rootBundle.load('assets/middle_hindi_book(44~49).xlsx');
    }
    else if (file_name.compareTo('중급 문법 47과') == 0) {
      start = 43;
      end = 76;
      data = await rootBundle.load('assets/middle_hindi_book(44~49).xlsx');
    }
    else if (file_name.compareTo('중급 문법 48~49과') == 0) {
      start = 76;
      end = 91;
      data = await rootBundle.load('assets/middle_hindi_book(44~49).xlsx');
    }
  }

  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  List<dynamic> word_list = [];
  //List<dynamic>.generate(finish_index - start_index + 1, (int index) => []);

  List<dynamic> all_row = excel.tables['Sheet1'].rows;

  int index=start;
  for (int i = 0; i < end - index; i++) {

    word_list.add(all_row[start]);
    start++;
  }

  return word_list;
}