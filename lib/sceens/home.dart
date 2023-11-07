import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/catalogues.dart';
//import 'package:flutter_application_1/providers/user_places.dart';
import 'package:flutter_application_1/qrCode/qr_screen.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/sceens/addcatalog.dart';
import 'package:flutter_application_1/sceens/catalog_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Catalogues> items = [];
  SearchController searchController = SearchController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Iterable<Catalogues> searchCatalogues(
      String query, List<Catalogues> catalogues) {
    final suggestions =
        List.generate(catalogues.length, (index) => catalogues[index])
            .where((element) {
      final titleLower = element.name.toLowerCase();
      final authorLower = element.room.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.startsWith(searchLower) ||
          authorLower.startsWith(searchLower);
    });
    return suggestions;
  }
  //ทดสอบ
  final firebase = FirebaseFirestore.instance.collection('keepData').doc('อุตสาหการ').collection('P-888');
  Stream<List<Catalogues>> readCatalogues() =>
      firebase.snapshots().map((snapshot) =>
          snapshot.docs.map((e) => Catalogues.tofromJson(e.data())).toList());

  @override
  Widget build(BuildContext context) {
    //final userCatalogues = ref.watch(userCtataloguesProvider);

    return SafeArea(
      //ทดสอบ
      child: StreamBuilder<List<Catalogues>>(
        stream: readCatalogues(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: SizedBox(
                    child: Text(
              'บางสิ่งผิดปกติ',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('ไม่มีข้อมูลรายการอุปกรณ์ของห้อง'),
              );
            }
          }
          final userCatalogues = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('home'),
              actions: [
                /*InkWell(
              child: const Row(
                children: [Icon(Icons.qr_code_scanner)],
              ),
              onTap: () {},
            ),
            InkWell(
              child: const Row(
                children: [
                  Icon(Icons.add_box_rounded)
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Addcatalog()));
              },
            ),
            */
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            QRScreen(catalogues: userCatalogues)));
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    //ใช้งานหรือเปล่า
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Addcatalog()));
                  },
                )
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
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
                    leading: const Icon(Icons.message),
                    title: const Text('Messages'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SearchAnchor.bar(
                      searchController: searchController,
                      barLeading: const Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      barTrailing: [
                        IconButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            icon: const Icon(Icons.clear))
                      ],
                      viewTrailing: [
                        IconButton(
                            onPressed: () {
                              searchController.closeView(searchController.text);
                              List<Catalogues> item = searchCatalogues(
                                      searchController.text, userCatalogues)
                                  .toList();
                              setState(() {
                                items.clear();
                                items.addAll(item);
                              });
                            },
                            icon: const Icon(Icons.search)),
                        IconButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                      ],
                      barTextStyle: MaterialStateProperty.all(
                          const TextStyle(color: Colors.black54)),
                      barHintText: 'ค้นหาข้อมูลชื่อของอุปกรณ์',
                      isFullScreen: false,
                      dividerColor: Colors.black38,
                      viewSide: const BorderSide(color: Colors.blue),
                      viewConstraints: const BoxConstraints(maxHeight: 350),
                      suggestionsBuilder: (context, controller) {
                        final keyword = controller.value.text;
                        //ต้องมี Listจากการกรอกข้อมูล
                        return searchCatalogues(keyword, userCatalogues).map(
                          (item) => ListTile(
                            leading: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(item.name),
                            subtitle: Column(
                              children: [
                                Text(item.room),
                                Text('${item.checkDate}')
                              ],
                            ),
                            onTap: () {
                              controller.closeView(keyword);
                              FocusScope.of(context).unfocus();
                              //ใช้งานหรือเปล่า
                              setState(() {
                                items.clear();
                                items.add(item);
                              });
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CataloguesList(
                            items: items,
                            catalogues: userCatalogues,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
