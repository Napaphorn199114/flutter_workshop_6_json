import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_6_json/detail.dart';
import 'package:workshop_6_json/models/Youtubes.dart';
import 'package:workshop_6_json/services/AuthService.dart';
import 'package:workshop_6_json/services/Network.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService authService = AuthService();
  final typeArray = const ['superhero', 'foods', 'songs', 'training'];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController =
      ScrollController(); // เวลา refresh เสร็จให้มันเด้งกับมาหน้าจอด้านบนสุดเหมือนเดิม
  String type = "";
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    type = typeArray[index];
  }
  //List<String> _dummy =List<String>.generate(20, (index) => "Row:${index}"); //ทดสอบ generate ข้อมูล 20

  @override
  Widget build(BuildContext context) {
    //Network.fetchYoutube();    // ติดต่อ network
    //Network.fetchJsonTest();     // ตัวอย่างติดต่อ network web อื่นๆ

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutAlertDialog();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Youtube>>(
          future: Network.fetchYoutube(type: type), //ติดต่อ network
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
                ),
                child: RefreshIndicator(
                  // ทำการ Refresh หน้าจอ
                  key: _refresh,
                  child: _listSection(youtubes: snapshot.data),
                  onRefresh: _handleRefresh, // ทำการ Refresh หน้าจอ
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator(); //โหลด วงกลมหมุนๆ
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (index >= typeArray.length - 1) {
            //คลิกแล้วจะ refresh ทุกหมวดหมู่ typeArray[index]; ['superhero','foods','songs','training'];
            index = 0;
          } else {
            index++;
          }
          type = typeArray[index];
          _refresh.currentState?.show(); // เมื่อ show แล้วจะทำการ stop
          _scrollController.animateTo(
              0, //กดปุ่มแล้วให้ refresh ไปที่ตำแหน่ง offset 0 คือบนสุด
              duration: Duration(seconds: 1),
              curve: Curves.easeOut);
          _handleRefresh();
        },
        backgroundColor: Colors.pink,
        tooltip: "reload",
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    // refresh loading
    await Future.delayed(
      // ทำการ delay 2 วิ ก่อนโหลดข้อมูลใหม่
      Duration(seconds: 2),
    );
    setState(() {});
    return null;
  }

  Widget _listSection({List<Youtube>? youtubes}) => ListView.builder(
      controller:
          _scrollController, // เวลา refresh ให้มัน scroll listview กลับขึ้นไปด้านบนสุด
      //scroll เลื่อนได้ เยอะ
      //itemCount: _dummy.length,
      itemCount: youtubes?.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _headerImageSection(); // แสดง logo
        }
        var item = youtubes![index];
        bool last = youtubes.length ==
            (index +
                1); // ถ้าเลื่อนมาถึง ยูทูปบรรทัดสุดท้าย  จะไม่ทำให้ ปุ่ม refresh ทับ ปุ่ม share

        return Card(
          margin: last
              ? EdgeInsets.only(bottom: 90, left: 20, right: 20)
              : EdgeInsets.only(
                  bottom: 10,
                  left: 20,
                  right: 20), //ถ้าเลื่อนมาถึงตัวสุดท้ายให้ padding ลอย
          child: Column(children: [
            _headerSectionCard(youtube: item),
            _bodySectionCard(youtube: item),
            _footerSectionCard(youtube: item),
          ]),
        );
      });

  Widget _headerImageSection() => Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Image.asset(
          "assets/header_home.png",
          height: 100,
        ),
      );

  Widget _headerSectionCard({required Youtube youtube}) => ListTile(
        leading: GestureDetector(
          //คลิกตรง header วงกลม เพื่อส่งไปยังอีกหน้า detail
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(youtube),
              ),
            );
          },
          child: Container(
            height: 50,
            width: 50,
            child: ClipOval(
              // รูป กลม
              child: FadeInImage.memoryNetwork(
                //transparent_image flutter รูป header จะค่อยๆกระพริบขึ้นมา
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: youtube.avatarImage,
              ),
            ),
          ),
        ),
        title: Text(
          youtube.title, //หัวข้อ
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
        ),
        subtitle: Text(
          youtube.subtitle, //รายละเอียด
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );

  Widget _bodySectionCard({required Youtube youtube}) => GestureDetector(
        //ทำให้รูป กดได้
        onTap: () {
          _launchURL(youtubeId: youtube.id);
        }, //สามารถกด รูปได้
        child: FadeInImage.memoryNetwork(
          //transparent_image flutter รูป header จะค่อยๆกระพริบขึ้นมา
          height: 180,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: kTransparentImage,
          image: youtube.youtubeImage, //รูปจาก youtube
        ),
      );

  Widget _footerSectionCard({required Youtube youtube}) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _customButton(
              icon: Icons.thumb_up, label: "Like", text: youtube.title),
          _customButton(icon: Icons.share, label: "Share", text: youtube.title),
          SizedBox(
            width: 12,
          ),
        ],
      );

  Widget _customButton(
          {required IconData icon,
          required String label,
          required String text}) =>
      TextButton(
          onPressed: () {
            print(text); // print title การคลิกปุ่ม  Like Share
          },
          child: Row(
            children: [
              Icon(icon),
              SizedBox(
                width: 8,
              ),
              Text(label),
            ],
          ));

  _launchURL({required String youtubeId}) async {
    String url = 'https://www.youtube.com/watch?v=${youtubeId}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showLogoutAlertDialog() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    showDialog(
        context: context,
        barrierDismissible:true, // ถ้ามี alert มา สามารถกดพื้นที่ข้างนอกได้นอกจากปุ่ม OK
        builder: (context) {
          return AlertDialog(
            title: Text("${_prefs.getString(AuthService.USERNAME)} to logout"),
            content: Text("Are you sure?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  authService.logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (Route<dynamic> route) =>
                          false); // กลับไปหน้า login ลบทุกอย่าง
                },
                child: Text("Yes"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // pop ทำการปิด
                },
                child: Text("No"),
              ),
            ],
          );
        });
  }
}
