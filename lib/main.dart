import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SearchController _searchController = SearchController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            InkWell(
              child: Row(
                children: [Icon(Icons.qr_code_scanner), Text(' Scan')],
              ),
              onTap: () {},
            ),
            InkWell(
              child: Row(
                children: [Icon(Icons.qr_code_scanner), Text(' Scan')],
              ),
              onTap: () {},
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchAnchor.bar(
                searchController: _searchController,
                barLeading: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                barTextStyle:
                    MaterialStateProperty.all(TextStyle(color: Colors.black54)),
                barHintText: 'ค้นหาข้อมูล',
                isFullScreen: false,
                dividerColor: Colors.black38,
                viewSide: BorderSide(color: Colors.blue),
                viewConstraints: BoxConstraints(maxHeight: 350),
                suggestionsBuilder: (context, controller) {
                  final keyword = controller.value.text;
                  //ต้องมี Listจากการกรอกข้อมูล
                  return List.generate(5, (index) => 'Item $index')
                      .where((element) => element
                          .toLowerCase()
                          .startsWith(keyword.toLowerCase()))
                      .map(
                        (item) => GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                          child: ListTile(
                            title: Text(
                              item,
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              controller.closeView(item);
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext, index) {
                    return ListTile(
                      //leading: CircleAvatar(backgroundImage: AssetImage(images[index]),),
                      title: Text("This is title"),
                      subtitle: Text("This is subtitle"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      tileColor: Colors.black54,
                      contentPadding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1, color: Colors.orangeAccent),
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () {},
                    );
                  },
                  itemCount: 1,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
