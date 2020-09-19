import 'package:flutter/material.dart';
import 'package:login_app/model/user.dart';
import 'package:login_app/pages/search.dart';

// import 'countrydetail.dart';

class GSearch extends SearchDelegate {
  final List<User> userList;

  GSearch(this.userList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? userList
        : userList
            .where((element) =>
                element.name.toString().toLowerCase().startsWith(query))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return CustomTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(suggestionList[index].profilePhoto),
          ),
          title: Text(suggestionList[index].name),
          subtitle: Text('hi'),
        );
      },
    );
  }
}

// Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: 150,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: listuser.length,
//                 itemBuilder: (context, index) => CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.black,
//                       // backgroundImage:
//                       //     NetworkImage(listuser[index].profilePhoto),
//                     )),
//           ),
//         )
// var listuser = Provider.of<GroupList>(context).getlist;
//
