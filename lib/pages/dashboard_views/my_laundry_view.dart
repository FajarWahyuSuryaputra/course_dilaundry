import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/datasources/laundry_datasource.dart';
import 'package:course_dilaundry/models/laundry_model.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/providers/my_laundry_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return const Placeholder();
  }
}
