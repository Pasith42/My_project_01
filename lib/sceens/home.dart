import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/user_places.dart';
import 'package:flutter_application_1/qrCode/qr_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:flutter_application_1/model/catalogues.dart';
import 'package:flutter_application_1/sceens/addcatalog.dart';
import 'package:flutter_application_1/sceens/catalog_list.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final userCatalogues = ref.watch(userCtataloguesProvider);
    final SearchController searchController = SearchController();

    return SafeArea(
      child: Scaffold(
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const QRScreen()));
              },
              icon: const Icon(Icons.qr_code_scanner),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //แถบค้นหาข้อมูล
              SearchAnchor.bar(
                searchController: searchController,
                barLeading: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                barTextStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.black54)),
                barHintText: 'ค้นหาข้อมูล',
                isFullScreen: false,
                dividerColor: Colors.black38,
                viewSide: const BorderSide(color: Colors.blue),
                viewConstraints: const BoxConstraints(maxHeight: 350),
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
                              style: const TextStyle(color: Colors.black),
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
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CataloguesList(catalogues: userCatalogues)),
            ],
          ),
        ),
      ),
    );
  }
}
