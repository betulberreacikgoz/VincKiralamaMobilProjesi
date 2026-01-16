import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/datasources/crane_remote_data_source.dart';
import 'package:vinc_kiralama/domain/entities/crane.dart';
import 'package:vinc_kiralama/domain/entities/category.dart';

final craneRepositoryProvider = Provider<CraneRepository>((ref) {
  final dataSource = ref.watch(craneRemoteDataSourceProvider);
  return CraneRepositoryImpl(dataSource);
});

abstract class CraneRepository {
  Future<List<Crane>> getAllCranes();
  Future<List<Crane>> getMyCranes();
  Future<void> addCrane(Crane crane);
  Future<void> updateCrane(Crane crane);
  Future<void> deleteCrane(int id);
  Future<List<Category>> getCategories();
}

class CraneRepositoryImpl implements CraneRepository {
  final CraneRemoteDataSource _dataSource;
  CraneRepositoryImpl(this._dataSource);

  @override
  Future<List<Crane>> getAllCranes() => _dataSource.getAllCranes();

  @override
  Future<List<Crane>> getMyCranes() => _dataSource.getMyCranes();

  @override
  Future<void> addCrane(Crane crane) => _dataSource.addCrane(crane);

  @override
  Future<void> updateCrane(Crane crane) => _dataSource.updateCrane(crane);

  @override
  Future<void> deleteCrane(int id) => _dataSource.deleteCrane(id);

  @override
  Future<List<Category>> getCategories() => _dataSource.getCategories();
}
