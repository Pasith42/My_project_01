import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/catalogues.dart';
import 'package:flutter_application_1/sceens/detail.dart';

class CataloguesList extends StatelessWidget {
  const CataloguesList({
    super.key,
    required this.items,
    required this.catalogues,
  });
  final List<Catalogues> catalogues;
  final List<Catalogues> items;

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
      itemCount: items.isEmpty ? catalogues.length : items.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final item = items.isEmpty ? catalogues[index] : items[index];

        return ListTile(
          leading: Image.file(
            item.image,
            fit: BoxFit.fill,
            width: 50,
            height: 50,
          ),
          //CircleAvatar(radius: 26,backgroundImage: FileImage(catalogues[index].image),),
          title: Text(
            item.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          subtitle: Column(
            children: [
              Text(item.number.toString()),
              Text(item.checkDate.toString()),
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
    );
  }
}
