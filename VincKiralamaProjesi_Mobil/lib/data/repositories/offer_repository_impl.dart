import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/datasources/offer_remote_data_source.dart';
import 'package:vinc_kiralama/domain/entities/offer.dart';
import 'package:vinc_kiralama/domain/repositories/offer_repository.dart';

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final dataSource = ref.watch(offerRemoteDataSourceProvider);
  return OfferRepositoryImpl(dataSource);
});

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource _dataSource;

  OfferRepositoryImpl(this._dataSource);

  @override
  Future<List<Offer>> getIncomingOffers() => _dataSource.getIncomingOffers();

  @override
  Future<void> acceptOffer(int id) => _dataSource.acceptOffer(id);

  @override
  Future<void> rejectOffer(int id) => _dataSource.rejectOffer(id);
}
