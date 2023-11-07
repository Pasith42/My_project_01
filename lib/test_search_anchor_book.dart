import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/books_data.dart';

import 'model/books.dart';

void main() => runApp(
      const MyApp(),
    );

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
  SearchController searchController = SearchController();
  List<Book> items = [];
  List<Book> books = allBooks;

  @override
  void initState() {
    //searchController.addListener(searchListener);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    //searchController.removeListener(searchListener);
    super.dispose();
  }

  /*void search(String qurery) {
    if (qurery.isEmpty) {
      setState(() {
        List<Book> items = books;
      });
    } else {
      setState(() {
        items = books.where((catalogue) {
          final titleLower = catalogue.title.toLowerCase();
          final searchLower = qurery.toLowerCase();
          return titleLower.contains(searchLower);
        }).toList();
      });
    }
  }

  void searchListener() {
    search(searchController.text);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ทดลอง ค้นหารายการข้อมูล')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    List<Book> item =
                        List.generate(books.length, (index) => books[index])
                            .where((element) =>
                                element.title.toLowerCase().startsWith(
                                    searchController.text.toLowerCase()) ||
                                element.author.toLowerCase().startsWith(
                                    searchController.text.toLowerCase()))
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
                const TextStyle(color: Colors.black45)),
            barHintText: 'ค้นหาข้อมูลชื่อของอุปกรณ์',
            isFullScreen: false,
            dividerColor: Colors.black54,
            viewSide: const BorderSide(color: Colors.blue),
            viewConstraints: const BoxConstraints(maxHeight: 350),
            suggestionsBuilder: (context, controller) {
              final keyword = controller.value.text;

              return
                  /*[
                ...[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return ListTile(
                        leading: Image.network(
                          item.urlImage,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.author),
                        onTap: () {
                          controller.closeView(item);
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  )
                ]
              ];
              */
                  List.generate(books.length, (index) => books[index])
                      .where((element) =>
                          element.title
                              .toLowerCase()
                              .startsWith(keyword.toLowerCase()) ||
                          element.author
                              .toLowerCase()
                              .startsWith(keyword.toLowerCase()))
                      .map(
                        (item) => ListTile(
                          leading: Image.network(
                            item.urlImage,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          title: Text(item.title),
                          subtitle: Text(item.author),
                          onTap: () {
                            controller.closeView(keyword);
                            FocusScope.of(context).unfocus();
                            setState(() {
                              items.clear();
                              items.add(item);
                              //items.isEmpty
                              //    ?items.add(item)
                              //    : items.replaceRange(0, items.length, [item]);
                            });
                          },
                        ),
                      );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.isEmpty ? books.length : items.length,
              itemBuilder: (context, index) {
                final book = items.isEmpty ? books[index] : items[index];
                return ListTile(
                  leading: Image.network(
                    book.urlImage,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
