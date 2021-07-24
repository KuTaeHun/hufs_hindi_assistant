import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HUFSHindiAssistant/main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:HUFSHindiAssistant/introductionScreen.dart';

class setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          const ListTile(
            leading: Text('일반'),
          ),
          ListTile(
              leading: const Icon(Icons.photo_filter),
              title: const Text('튜토리얼'),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (BuildContext context) => onboardingpage()),
                );
              }
              //Share.share(text:'한국외국어대학교 힌디어 단어장', subject:'학과 중간 기말, 졸업 시험, 인증 시험 모두 여기서!'),
              ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈페이지'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              var url = 'http://cfl.ac.kr/index.do';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('정보'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '앱 정보',
                '▶ 앱 기획 및 제작자\n한국외국어대학교 인도학과 15학번 구태훈\n\n▶ 아이콘 및 배너 디자인 총괄 담당\n Park SoJiung, 구태훈\n\n▶ 앱 검수 및 수정\n 신윤수, 이주연, 정유진, 최영우\n\n▶ 앱 소유권\n 한국외국어대학교 특수외국어진흥원(CFL)  ',
                15),
          ),
          ListTile(
            leading: const Text('문의하기'),
          ),
          ListTile(
            leading: const Icon(Icons.add_comment),
            title: const Text('업데이트 관련 문의하기'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => alert(
                context,
                '앱 건의사항',
                '이 앱을 사용해주셔서 감사합니다. 어플 발전에 있어 좋은 아이디어가 있으시면 ku28411@daum.net으로 보내주시면 감사하겠습니다.',
                16),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('수업 관련 문의하기'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              var url =
                  'http://cfl.ac.kr/cop/bbs/selectBoardList.do?bbsId=BBSMSTR_000000000003&menuId=MNU_0000000000000030';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer_sharp),
            title: const Text('FAQ'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => faqList()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 설정부분 알림창 관련 함수
void alert(BuildContext context, String info_title, String info_text,
    double font_size) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(info_title),
          content: Text(
            info_text,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'hufsfontLight',
              fontSize: font_size,
              wordSpacing: 1.1,
              height: 1.5,
              fontWeight: FontWeight.normal,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("확인")),
          ],
        );
      });
}

//FAQ 질문들
class faqList extends StatelessWidget {
  ListTile makefaq(BuildContext context, int index) {
    List<ListTile> faqlist = [
      ListTile(
        title: Text('나의 단어 복습은 무엇인가요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '나의 단어 복습',
            '이 기능은 단어 학습에서 저장한 단어 혹은 테스트에서 틀린 단어를 모아둔 단어입니다. 암기가 완료된 단어는 삭제할 수 있습니다.',
            14),
      ),
      ListTile(
        title: Text('나의 문장 복습은 무엇인가요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '나의 문장 복습',
            '이 기능은 문장 학습에서 저장한 문장을 모아둔 기능입니다. 문장 학습과 같이 특정 문장을 퀴즈를 볼 수 있습니다.',
            14),
      ),
      ListTile(
        title: Text('학과 단어는 언제 출시되나요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '학과 단어',
            '학과 단어는 한국외국어대학교 인도학과, 인도어과에서 사용한 교재에 있는 단어들을 참조하여 다른 앱으로 만들 예정입니다. 책에 나온 단어들을 외워 학교 시험에 도움을 주는 것에 초점을 맞추어 제작 예정입니다.',
            14),
      ),
      ListTile(
        title: Text('문장 학습에서 문제는 어떤 근거로 만들었나요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '문장 학습',
            '문장 학습에서 틀린 문장은 CFLPT 단어 부분을 참고했습니다. 해당 문장은 CFLPT 단어장에 있는 예시 문장을 근거로 제작되었습니다',
            14),
      ),
      ListTile(
        title: Text('메인 화면 단어, 문장 등급은 어떤 기준인가요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '등급 기준',
            '등급의 기준은 시험 단어 중 테스트 기능, 문장 학습을 완료하면 맞은 단어와 지금까지 학습한 단어 수를 계산합니다. 이를 근거로 30점 미만이면 F이고 10점 단위마다 등급이 올라갑니다.',
            14),
      ),
      ListTile(
        title: Text('단어, 문장 테스트를 하다가 도중에 나와도 기록이 되나요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '기록의 기준',
            '테스트를 보는 도중 나오면 나의 단어는 기록이 되지만 나의 문장에는 기록되지 않습니다. 나의 문장은 해당 챕터를 끝까지 시험을 쳐야 나의 문장에 기록됩니다. 또한 도중에 나오면 성적에는 기록되지 않습니다.',
            14),
      ),
      ListTile(
        title: Text('한 단원당 단어의 갯수를 정한 기준이 있었나요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '단원당 단어 수',
            '한 파트당 단어 40개를 기준으로 하고 있습니다. 이 앱의 목적 중 하나가 출퇴근 시간등 남는 시간을 이용하여 단어 암기를 하는 것을 목표로 두고 있습니다. 따라서 10~15분 동안 한 단원을 볼 수 있게 만들었습니다.',
            14),
      ),
      ListTile(
        title: Text('단어장 보는 방식을 도중에 바꾸었는데 나만의 단어장에 저장될까요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(context, '임시 저장',
            '도중에 단어 암기 혹은 테스트를 정지해도 나만의 단어, 문장에 저장이 됩니다.', 14),
      ),
      ListTile(
        title: Text('단어장 글자 폰트는 무엇으로 작성되었나요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '글자 폰트',
            '한국어 폰트는 한국 외대 폰트를 사용하였습니다. 또한 힌디어는 가장 대중적으로 사용되는 폰트를 사용하였습니다.',
            14),
      ),
      ListTile(
        title: Text('앱을 사용하는데 버그가 있어요. 어디에 말하면 될까요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '앱 오류 보고',
            '앱 오류 신고는 ku28411@daum.net으로 전달해주시면 감사하겠습니다. 검토 후 다음 업데이트에 반영하도록 하겠습니다.',
            14),
      ),
      ListTile(
        title: Text('업데이트는 어떻게 진행되나요?'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () => alert(
            context,
            '수정 사항',
            '업데이트는 앱에 문제가 있을 시, 새로운 단어 리스트가 추가될 시, CFL에서 진행하는 행사 및 공지사항 변경이 있을 때 업데이트가 이루어집니다. 주로 CFL 공지사항 수정을 위해 업데이트가 이루어집니다.',
            14),
      )
    ];

    return faqlist[index];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyApp(),
                            ),
                            (route) => false,
                          );
                        },
                      );
                    },
                  ),
                  shadowColor: Colors.black26,
                  centerTitle: true,
                  backgroundColor: const Color.fromARGB(240, 10, 15, 64),
                  title: Text(
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
                body: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                    itemCount: 11,
                    itemBuilder: (BuildContext context, int index) {
                      return makefaq(context, index);
                    }))),
        onWillPop: ()  {
          Navigator.of(context).pop();
        });
  }
}
