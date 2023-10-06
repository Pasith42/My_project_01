import 'dart:io';

import 'package:flutter_application_1/model/catalogues.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCataloguesNotifier extends StateNotifier<List<Catalogues>> {
  UserCataloguesNotifier() : super(const []);

  void appCatalogue(String name, int number, String room, DateTime startdate,
      DateTime checkdate, File image) {
    final newCatalogue = Catalogues(
        name: name,
        number: number,
        room: room,
        startDate: startdate,
        checkDate: checkdate,
        image: image);
    state = [newCatalogue, ...state];
  }
}

final userCtataloguesProvider =
    StateNotifierProvider<UserCataloguesNotifier, List<Catalogues>>(
  (ref) => UserCataloguesNotifier(),
);
