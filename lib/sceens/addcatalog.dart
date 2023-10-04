import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Addcatalog extends ConsumerStatefulWidget {
  Addcatalog({super.key});

  @override
  ConsumerState<Addcatalog> createState() => _AddcatalogState();
}

class _AddcatalogState extends ConsumerState<Addcatalog> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _roomController = TextEditingController();

  void _saveCatalogue() {
    final enterName = _nameController.text;
    final enterNumber = int.parse(_nameController.text);
    final enterRoom = _nameController.text;

    if (enterName.isEmpty || enterNumber.isNegative || enterRoom.isEmpty) {
      return;
    }

    ref.read(userCtataloguesProvider.notifier).appCatalogue(
          enterName,
          enterNumber,
          enterRoom,
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'เพิ่มรายการใหม่',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _nameController,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'ชื่ออุปกรณ์'),
                  controller: _roomController,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton.icon(
                    onPressed: _saveCatalogue,
                    icon: Icon(Icons.add),
                    label: Text('Add Catalogue')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
