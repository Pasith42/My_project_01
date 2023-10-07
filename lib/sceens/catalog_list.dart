import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/catalogues.dart';
import 'package:flutter_application_1/sceens/detail.dart';

class CataloguesList extends StatelessWidget {
  const CataloguesList({super.key, required this.catalogues});
  final List<Catalogues> catalogues;

  @override
  Widget build(BuildContext context) {
    if (catalogues.isEmpty) {
      return Center(
        child: Container(
          height: 300,
          child: Text(
            'ไม่มีรายการที่มีอยู่',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(catalogues[index].image),
          ),
          title: Text(
            catalogues[index].name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          subtitle: const Column(
            children: [
              Text("This is subtitle"),
              Text("This is subtitle 2"),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_sharp),
          tileColor: Colors.black54,
          contentPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Colors.orangeAccent),
              borderRadius: BorderRadius.circular(10)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Detail(catalogue: catalogues[index]),
            ));
          },
        );
      },
      itemCount: catalogues.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }
}
