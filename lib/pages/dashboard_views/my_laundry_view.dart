import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_format.dart';
import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/datasources/laundry_datasource.dart';
import 'package:course_dilaundry/models/laundry_model.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/widgets/error_background.dart';
import 'package:course_dilaundry/providers/my_laundry_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../config/failure.dart';

class MyLaundryView extends ConsumerStatefulWidget {
  const MyLaundryView({super.key});

  @override
  ConsumerState<MyLaundryView> createState() => _MyLaundryViewState();
}

class _MyLaundryViewState extends ConsumerState<MyLaundryView> {
  late UserModel user;

  getMyLaundry() {
    LaundryDatasource.readByUser(user.id).then(
      (value) {
        value.fold(
          (failure) {
            switch (failure.runtimeType) {
              case ServerFailure:
                setMyLaundryStatus(ref, 'Server Error');
                break;
              case NotFoundFailure:
                setMyLaundryStatus(ref, 'Error Not Found');
                break;
              case ForbiddenFailure:
                setMyLaundryStatus(ref, 'You don\'t have access');
                break;
              case BadRequestFailure:
                setMyLaundryStatus(ref, 'Bad request');
                break;
              case UnauthorizedFailure:
                setMyLaundryStatus(ref, 'Unauthorised');
                break;
              default:
                setMyLaundryStatus(ref, 'Request Error');
                break;
            }
          },
          (result) {
            setMyLaundryStatus(ref, 'Success');
            List data = result['data'];
            List<LaundryModel> laundries = data
                .map(
                  (e) => LaundryModel.fromJson(e),
                )
                .toList();
            ref.read(myLaundryListProvider.notifier).setData(laundries);
          },
        );
      },
    );
  }

  dialogClaim() {
    final edtLaundryID = TextEditingController();
    final edtClaimCode = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) {
        return Form(
            key: formKey,
            child: SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              titlePadding: const EdgeInsets.all(16),
              title: const Text('Claim Code'),
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: edtLaundryID,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary)),
                    labelText: 'Laundry ID',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: edtLaundryID,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary)),
                    labelText: 'Claim Code',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Claim Now',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'))
              ],
            ));
      },
    );
  }

  @override
  void initState() {
    AppSession.getUser().then(
      (value) {
        user = value!;
        getMyLaundry();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [header(), categories(), listLaundries()],
      ),
    );
  }

  Expanded listLaundries() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => getMyLaundry(),
        child: Consumer(
          builder: (_, wiRef, __) {
            String statusList = wiRef.watch(myLaundryStatusProvider);
            String statusCategory = wiRef.watch(myLaundryCategoryProvider);
            List<LaundryModel> listBackup = wiRef.watch(myLaundryListProvider);

            if (statusList == '') {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (statusList != 'Success') {
              return Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
                child: ErrorBackground(ratio: 16 / 9, message: statusList),
              );
            }

            List<LaundryModel> list = [];
            if (statusCategory == 'All') {
              list = List.from(listBackup);
            } else {
              list = listBackup
                  .where(
                    (element) => element.status == statusCategory,
                  )
                  .toList();
            }

            if (list.isEmpty) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 80),
                child: ErrorBackground(ratio: 16 / 9, message: 'Empty'),
              );
            }

            return GroupedListView<LaundryModel, String>(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 80),
              elements: list,
              groupBy: (element) => AppFormat.justDate(element.createdAt),
              order: GroupedListOrder.DESC,
              groupSeparatorBuilder: (value) => Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey[400]!)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Text(AppFormat.shortDate(value))),
              ),
              itemBuilder: (context, element) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              element.shop.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppFormat.longPrice(element.total),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          if (element.withPickup)
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4)),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: const Text(
                                'Pickup',
                                style:
                                    TextStyle(color: Colors.white, height: 1),
                              ),
                            ),
                          if (element.withDelivery)
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4)),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: const Text(
                                'Delivery',
                                style:
                                    TextStyle(color: Colors.white, height: 1),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              '${element.weight}Kg',
                              textAlign: TextAlign.end,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Consumer categories() {
    return Consumer(
      builder: (_, wiRef, __) {
        String categorySelected = wiRef.watch(myLaundryCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.laundryStatusCategory.length,
            itemBuilder: (context, index) {
              String category = AppConstants.laundryStatusCategory[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: index == 0 ? 30 : 8,
                    right:
                        index == AppConstants.laundryStatusCategory.length - 1
                            ? 30
                            : 8),
                child: InkWell(
                  onTap: () {
                    setMyLaundryCategory(ref, category);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: category == categorySelected
                                ? AppColors.primary
                                : Colors.grey[400]!),
                        color: category == categorySelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                          height: 1,
                          color: category == categorySelected
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Laundry',
            style: GoogleFonts.montserrat(
                fontSize: 24, color: Colors.green, fontWeight: FontWeight.w600),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: OutlinedButton.icon(
              style: const ButtonStyle(
                  side: WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
                  padding:
                      WidgetStatePropertyAll(EdgeInsets.fromLTRB(8, 2, 16, 2))),
              onPressed: () => dialogClaim(),
              label: const Text(
                'Claim',
                style: TextStyle(height: 1),
              ),
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
