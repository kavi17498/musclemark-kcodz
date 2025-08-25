import 'package:hive/hive.dart';
import '../models//bmi.dart';

class BmiHiveServices {
  final Box<Bmi> _box = Hive.box<Bmi>('bmi');

  //get all bmis
  List<Bmi> getAllBmis() => _box.values.toList();

  //add bmi
  Future<void> addBmi(Bmi bmi) async {
    _box.add(bmi);
  }

  //delete bmi
  Future<void> deleteBmi(int index) async {
    await _box.deleteAt(index);
  }

  //update bmi
  Future<void> updateBmi(int index, Bmi bmi) async {
    await _box.putAt(index, bmi);
  }
}
