import 'package:course_dilaundry/pages/dashboard_views/account_view.dart';
import 'package:course_dilaundry/pages/dashboard_views/home_view.dart';
import 'package:course_dilaundry/pages/dashboard_views/my_laundry_view.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const appName = 'Di Laundry';

  static const _host = 'http://192.168.1.8:8000';

  /// ``` baseURL = '192.168.1.5:8000/api' ```
  static const baseURL = '$_host/api';

  /// ``` baseImageURL = '192.168.1.5:8000/storage' ```
  static const baseImageURL = '$_host/storage';
  // http://192.168.1.5:8000/storage

  static const laundryStatusCategory = [
    'All',
    'Pickup',
    'Queue',
    'Process',
    'Washing',
    'Dried',
    'Ironed',
    'Done',
    'Delivery',
  ];

  static List<Map> navMenuDashboard = [
    {
      'view': const HomeView(),
      'icon': Icons.home_filled,
      'label': 'Home',
    },
    {
      'view': const MyLaundryView(),
      'icon': Icons.local_laundry_service,
      'label': 'My Laundry',
    },
    {
      'view': const AccountView(),
      'icon': Icons.account_circle,
      'label': 'Account',
    },
  ];

  static const homeCategories = [
    'All',
    'Regular',
    'Express',
    'Economical',
    'Exlusive'
  ];
}
