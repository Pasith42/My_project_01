import 'package:flutter/material.dart';

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
  State<SearchBarApp> createState() => //_SearchBarAppState();
      SearchBarAppState();
}

class SearchBarAppState extends State<SearchBarApp> {
  final SearchController controller = SearchController();
  final leading = const Icon(Icons.search);
  final trailing = [
    IconButton(
      icon: const Icon(Icons.keyboard_voice),
      onPressed: () {
        print('Use voice command');
      },
    ),
    IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () {
        print('Use image search');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Search Anchor Sample')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SearchAnchor(
              searchController: controller,
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  leading: leading,
                  trailing: trailing,
                  onTap: () {
                    controller.openView();
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                final keyword = controller.value.text;
                return List.generate(5, (index) => 'Item $index')
                    .where((element) =>
                        element.toLowerCase().startsWith(keyword.toLowerCase()))
                    .map((item) => ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ));
              },
            ),
            Expanded(
              child: Center(
                child: controller.text.isEmpty
                    ? const Text('No keyword')
                    : Text('Keyword: ${controller.value.text}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAnchorBarExampleState extends State<SearchBarApp> {
  final SearchController _searchController = SearchController();
  final ThemeData themeData = ThemeData(useMaterial3: true);

  final leading = const Icon(Icons.search, color: Colors.white);
  final trailing = [
    IconButton(
      icon: const Icon(Icons.keyboard_voice, color: Colors.white),
      onPressed: () {
        print('Use voice command');
      },
    ),
    IconButton(
      icon: const Icon(Icons.camera_alt, color: Colors.white),
      onPressed: () {
        print('Use image search');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Search Anchor Sample')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchAnchor.bar(
              searchController: _searchController,
              barTrailing: trailing,
              barLeading: leading,
              barBackgroundColor: MaterialStateProperty.all(Colors.teal),
              barTextStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white)),
              barHintText: 'Tap to search',
              barHintStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white)),
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              viewLeading: leading,
              viewTrailing: trailing,
              viewBackgroundColor: Colors.pink,
              viewHeaderTextStyle: const TextStyle(color: Colors.white),
              viewHintText: 'Enter keyword here',
              viewHeaderHintStyle: const TextStyle(color: Colors.white),
              viewConstraints: const BoxConstraints(
                maxWidth: 300,
                maxHeight: 300,
              ),
              viewElevation: 100,
              dividerColor: Colors.teal,
              isFullScreen: false,
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                final keyword = controller.value.text;
                var catalogues = List.generate(5, (index) => 'Item $index')
                    .where((element) =>
                        element.toLowerCase().startsWith(keyword.toLowerCase()))
                    .map((item) => GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                          child: ListTile(
                            title: Text(item,
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              setState(() {
                                controller.closeView(item);
                                FocusScope.of(context).unfocus();
                              });
                            },
                          ),
                        ));
                return catalogues;
              },
            ),
            Expanded(
              child: Center(
                child: _searchController.text.isEmpty
                    ? const Text('No keyword')
                    : Text('Keyword: ${_searchController.value.text}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
