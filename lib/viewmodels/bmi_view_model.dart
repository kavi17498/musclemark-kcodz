import 'package:riverpod/riverpod.dart';
import '../models/bmi.dart';
import '../services/bmi_hive_services.dart';

class BmiViewModel extends Notifier<List<Bmi>> {
  final BmiHiveServices _service = BmiHiveServices();

  @override
  List<Bmi> build() {
    return _service.getAllBmis();
  }

  void refresh() {
    state = _service.getAllBmis();
  }

  Future<void> addBmi(Bmi bmi) async {
    await _service.addBmi(bmi);
    refresh();
  }

  Future<void> deleteBmi(int id) async {
    // Update the state immediately for real-time UI update
    final currentBmis = List<Bmi>.from(state);
    currentBmis.removeWhere((bmi) => bmi.id == id);
    state = currentBmis;

    // Also delete from Hive storage
    await _service.deleteBmi(id);
  }

  Future<void> updateBmi(Bmi bmi) async {
    // Update the state immediately for real-time UI update
    final currentBmis = List<Bmi>.from(state);
    final index = currentBmis.indexWhere((b) => b.id == bmi.id);

    if (index != -1) {
      currentBmis[index] = bmi;
      state = currentBmis;
    }

    // Also update in Hive storage
    await _service.updateBmi(bmi.id, bmi);
  }
}
