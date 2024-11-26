import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences.dart';
import '../models/dhikr.dart';
import '../data/initial_dhikrs.dart';

class DhikrProvider with ChangeNotifier {
  List<Dhikr> _dhikrs = [];
  List<Dhikr> _archivedDhikrs = [];
  final String _prefsKey = 'dhikrs';
  final String _archivedPrefsKey = 'archived_dhikrs';

  List<Dhikr> get dhikrs => _dhikrs;
  List<Dhikr> get archivedDhikrs => _archivedDhikrs;

  DhikrProvider() {
    _loadDhikrs();
  }

  Future<void> _loadDhikrs() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().split('T')[0];

    String? dhikrsJson = prefs.getString(_prefsKey);
    if (dhikrsJson == null) {
      _dhikrs = initialDhikrs.map((d) => d.copyWith(lastReset: today)).toList();
      _saveDhikrs();
    } else {
      final List<dynamic> decoded = json.decode(dhikrsJson);
      _dhikrs = decoded.map((item) => Dhikr.fromJson(item)).toList();
      
      // Check for daily reset
      bool needsSave = false;
      for (var i = 0; i < _dhikrs.length; i++) {
        if (_dhikrs[i].lastReset != today) {
          _dhikrs[i] = _dhikrs[i].copyWith(
            lastReset: today,
            currentCount: _dhikrs[i].startValue,
          );
          needsSave = true;
        }
      }
      if (needsSave) {
        _saveDhikrs();
      }
    }

    // Load archived dhikrs
    String? archivedJson = prefs.getString(_archivedPrefsKey);
    if (archivedJson != null) {
      final List<dynamic> decoded = json.decode(archivedJson);
      _archivedDhikrs = decoded.map((item) => Dhikr.fromJson(item)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveDhikrs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_dhikrs.map((d) => d.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  Future<void> _saveArchivedDhikrs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_archivedDhikrs.map((d) => d.toJson()).toList());
    await prefs.setString(_archivedPrefsKey, encoded);
  }

  Future<void> addDhikr(Dhikr dhikr) async {
    _dhikrs.add(dhikr);
    await _saveDhikrs();
    notifyListeners();
  }

  Future<void> updateDhikr(Dhikr dhikr) async {
    final index = _dhikrs.indexWhere((d) => d.id == dhikr.id);
    if (index != -1) {
      _dhikrs[index] = dhikr;
      await _saveDhikrs();
      notifyListeners();
    }
  }

  Future<void> archiveDhikr(Dhikr dhikr) async {
    _dhikrs.removeWhere((d) => d.id == dhikr.id);
    _archivedDhikrs.add(dhikr);
    await _saveDhikrs();
    await _saveArchivedDhikrs();
    notifyListeners();
  }

  Future<void> unarchiveDhikr(Dhikr dhikr) async {
    _archivedDhikrs.removeWhere((d) => d.id == dhikr.id);
    _dhikrs.add(dhikr);
    await _saveDhikrs();
    await _saveArchivedDhikrs();
    notifyListeners();
  }

  Future<void> deleteDhikr(Dhikr dhikr) async {
    _dhikrs.removeWhere((d) => d.id == dhikr.id);
    await _saveDhikrs();
    notifyListeners();
  }

  Future<void> reorderDhikrs(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Dhikr item = _dhikrs.removeAt(oldIndex);
    _dhikrs.insert(newIndex, item);
    await _saveDhikrs();
    notifyListeners();
  }
}