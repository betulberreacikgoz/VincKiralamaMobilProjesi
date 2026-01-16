import 'package:vinc_kiralama/domain/entities/offer.dart';

abstract class OfferRepository {
  Future<List<Offer>> getIncomingOffers();
  Future<void> acceptOffer(int id);
  Future<void> rejectOffer(int id);
}
