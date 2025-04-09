import 'package:course_dilaundry/models/shop_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchByCityStatusProvider = StateProvider.autoDispose(
  (ref) => '',
);

setSearchByCityStatus(WidgetRef ref, String newStatus) {
  ref.read(searchByCityStatusProvider.notifier).state = newStatus;
}

final searchByCityListProvider =
    StateNotifierProvider.autoDispose<searchByCityList, List<ShopModel>>(
  (ref) => searchByCityList([]),
);

class searchByCityList extends StateNotifier<List<ShopModel>> {
  searchByCityList(super.state);

  setData(newList) {
    state = newList;
  }
}
