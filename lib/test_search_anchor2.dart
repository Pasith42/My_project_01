import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchBarApp(),
    );
  }
}

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  var allItems = List.generate(5, (index) => 'item $index');
  var items = [];
  var searHistory = [];
  final TextEditingController searchController = TextEditingController();
  final SearchController controller = SearchController();

  @override
  void initState() {
    controller.addListener(searchListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller.removeListener(searchListener);
    super.dispose();
  }

  void search(String qurery) {
    if (qurery.isEmpty) {
      setState(() {
        items = allItems;
      });
    } else {
      setState(() {
        items = allItems.where((catalogue) {
          final titleLower = catalogue.toLowerCase();
          final searchLower = qurery.toLowerCase();
          return titleLower.contains(searchLower);
        }).toList();
      });
    }
  }

  void searchListener() {
    search(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ทดลอง searchAnchor2'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SearchAnchor(
            searchController: controller,
            viewHintText: 'ค้นหาข้อมูล',
            viewTrailing: [
              IconButton(
                onPressed: () {
                  searHistory.add(controller.text);
                  searHistory = searHistory.reversed.toSet().toList();
                  controller.closeView(controller.text);
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: Icon(Icons.clear),
              ),
            ],
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                hintText: 'Search...',
                leading: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {},
                  ),
                ],
                onTap: () => controller.openView(),
              );
            },
            suggestionsBuilder: (context, controller) {
              return [
                Wrap(
                  children: List.generate(searHistory.length, (index) {
                    final item = searHistory[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: ChoiceChip(
                        label: Text(item),
                        selected: item == controller.text,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24.0),
                          ),
                        ),
                        onSelected: (value) {
                          search(item);
                          controller.clear();
                        },
                      ),
                    );
                  }),
                ),
                ...[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Card(
                        child: Column(
                          children: [
                            Text('Name : $item'),
                            const SizedBox(height: 8.0),
                            Text(item),
                          ],
                        ),
                      );
                    },
                  ),
                ]
              ];
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.isEmpty ? allItems.length : items.length,
              itemBuilder: (context, index) {
                final item = items.isEmpty ? allItems[index] : items[index];

                return Card(
                  child: Column(
                    children: [
                      Text('Name : $item'),
                      const SizedBox(height: 8.0),
                      Text(item),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
