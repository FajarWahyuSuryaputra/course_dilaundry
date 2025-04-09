import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/datasources/shop_datasource.dart';
import 'package:course_dilaundry/models/shop_model.dart';
import 'package:course_dilaundry/pages/detail_page.dart';
import 'package:course_dilaundry/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/failure.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key, required this.query});
  final String query;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final edtSearch = TextEditingController();
  execute() {
    setSearchByCityStatus(ref, 'Loading');
    ShopDatasource.searchByCity(edtSearch.text).then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setSearchByCityStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setSearchByCityStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setSearchByCityStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setSearchByCityStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
                setSearchByCityStatus(ref, 'Unauthorised');
                break;
              default:
                setSearchByCityStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setSearchByCityStatus(ref, 'Success');
            List data = result['data'];
            List<ShopModel> list = data
                .map(
                  (e) => ShopModel.fromJson(e),
                )
                .toList();
            ref.read(searchByCityListProvider.notifier).setData(list);
          },
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.query != '') {
      edtSearch.text = widget.query;
      Future.delayed(Duration.zero, () {
        execute();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Text(
                'City: ',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  height: 1,
                ),
              ),
              Expanded(
                  child: TextField(
                controller: edtSearch,
                decoration: const InputDecoration(
                    border: InputBorder.none, isDense: true),
                style: const TextStyle(
                  height: 1,
                ),
                onSubmitted: (value) => execute(),
              ))
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () => execute(), icon: const Icon(Icons.search))
        ],
      ),
      body: Consumer(
        builder: (_, wiRef, __) {
          String status = wiRef.watch(searchByCityStatusProvider);
          List<ShopModel> list = wiRef.watch(searchByCityListProvider);

          if (status == '') {
            return const SizedBox();
          }

          if (status == 'Loading') {
            return const Center(child: CircularProgressIndicator());
          }

          if (status == 'Success') {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                ShopModel shop = list[index];
                return ListTile(
                  onTap: () {
                    Nav.push(context, DetailPage(shop: shop));
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    radius: 18,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(shop.name),
                  subtitle: Text(shop.city),
                  trailing: const Icon(Icons.navigate_next_rounded),
                );
              },
            );
          }

          return Center(
            child: Text(status),
          );
        },
      ),
    );
  }
}
