import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:workshop_6_json/models/Youtubes.dart';

class Detail extends StatelessWidget {
  Youtube youtube;

  Detail(this.youtube);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: ListView(children: [
        _headerImageSection(), // header youtube detail
        _bodySection(),
      ]),
    );
  }

  Widget _headerImageSection() => FadeInImage.memoryNetwork(
        //transparent_image flutter รูป header จะค่อยๆกระพริบขึ้นมา
        height: 180,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: kTransparentImage,
        image: youtube.youtubeImage, //รูปจาก youtube
      );

  Widget _bodySection() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              youtube.title, // ชื่อ title
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            Divider(),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 12),
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
                Expanded(     //ขยายเต็มพื้นที่
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail",
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Text(
                        "Published on May 24 2022 ",
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Subscript 200K".toUpperCase(),
                  ),
                )
              ],
            )
          ],
        ),
      );
}
