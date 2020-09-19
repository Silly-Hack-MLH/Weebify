import 'package:flutter/material.dart';
import 'package:login_app/pages/search.dart';

class ChatListContainer extends StatefulWidget {
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  static final Color onlineDotColor = Color(0xff46dc64);
  static final Color blackColor = Color(0xff19191b);
  static final Color greyColor = Color(0xff8f8f8f);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) => SearchScreen())))
        ],
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: 2,
          itemBuilder: (context, index) {
            return CustomTile(
              mini: false,
              onTap: () {},
              title: Text(
                "The CS Guy",
                style: TextStyle(
                    color: Colors.black, fontFamily: "Arial", fontSize: 19),
              ),
              subtitle: Text(
                "Hello",
                style: TextStyle(
                  color: greyColor,
                  fontSize: 14,
                ),
              ),
              leading: Container(
                constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: onlineDotColor,
                            border: Border.all(color: blackColor, width: 2)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;

  static final Color separatorColor = Color(0xff272c35);

  CustomTile({
    @required this.leading,
    @required this.title,
    this.icon,
    @required this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.mini = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: separatorColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            icon ?? Container(),
                            subtitle,
                          ],
                        )
                      ],
                    ),
                    trailing ?? Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
