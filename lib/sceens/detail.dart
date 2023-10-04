import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/catalogues.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.catalogue});
  final Catalogues catalogue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catalogue.name),
      ),
      body: Center(
        child: Text(
          catalogue.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
