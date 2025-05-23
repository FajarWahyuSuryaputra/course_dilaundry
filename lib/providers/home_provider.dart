import 'package:course_dilaundry/models/promo_model.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeCategoryProvider = StateProvider.autoDispose(
  (ref) => 'All',
);
final homePromoStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);
final homeRecommendationStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);

setHomeCategory(WidgetRef ref, String newCategory) {
  ref.read(homeCategoryProvider.notifier).state = newCategory;
}

setHomePromoStatus(WidgetRef ref, String newStatus) {
  ref.read(homePromoStatusProvider.notifier).state = newStatus;
}

setHomeRecommendationStatus(WidgetRef ref, String newStatus) {
  ref.read(homeRecommendationStatusProvider.notifier).state = newStatus;
}

final homePromoListProvider =
    StateNotifierProvider.autoDispose<HomePromoList, List<PromoModel>>(
  (ref) => HomePromoList([]),
);
final homeRecommendationListProvider =
    StateNotifierProvider.autoDispose<HomeRecommendationList, List<ShopModel>>(
  (ref) => HomeRecommendationList([]),
);

class HomePromoList extends StateNotifier<List<PromoModel>> {
  HomePromoList(super.state);

  setData(List<PromoModel> newData) {
    state = newData;
  }
}

class HomeRecommendationList extends StateNotifier<List<ShopModel>> {
  HomeRecommendationList(super.state);

  setData(List<ShopModel> newData) {
    state = newData;
  }
}
