import 'package:flutter/foundation.dart';

import 'package:la_red/model/equipo.dart';

import 'package:hive/hive.dart';

import '../constants.dart';

class EquipoData with ChangeNotifier {
  List<Equipo> _equipos = [];
  static bool _read = false;

  List<Equipo> get getEquipos => _equipos;
  Equipo getTeam(index) => _equipos.elementAt(index);
  int get teamLength => _equipos.length;

  void createTeam() async {
    var box = await Hive.openBox(kBoxName);

    Equipo.counter = await box.get('size', defaultValue: 0);
    print(Equipo.counter);
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('Real Madrid', Leagues.libre));
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('Barcelona', Leagues.libre));
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('Bayer Leverkusen', Leagues.libre));
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('Schalke 04', Leagues.femenino));
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('borussia mönchengladbach', Leagues.femenino));
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('Boca Juniors', Leagues.m30));
    await box.put('eq${Equipo.counter}',
        Equipo.autoNameLeague('River Plate', Leagues.m30));

    await box.put('size', Equipo.counter);
    notifyListeners();
  }

  void readTeams() async {
    var box = await Hive.openBox(kBoxName);
    Equipo.counter = await box.get('size', defaultValue: 0);

    print('look at thisss ${Equipo.counter}');
    if (!_read) {
      for (int i = 0; i < Equipo.counter; i++) {
        var aux = await box.get('eq$i');
        _equipos.add(aux);
      }
      _read = true;
    }

    notifyListeners();
  }

  void deleteTeams() async {
    var box = await Hive.openBox(kBoxName);
    box.deleteFromDisk();
    notifyListeners();
  }

  void closeDB() async {
    var box = await Hive.openBox(kBoxName);
    box.put('size', Equipo.counter);
  }
}
