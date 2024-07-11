import 'package:flutter/material.dart';
import 'package:flutter_application_99/models/menu_model.dart';
import 'package:flutter_application_99/pages/accounts.dart';
import 'package:flutter_application_99/pages/dashboard.dart';
import 'package:flutter_application_99/pages/notifications.dart';
import 'package:flutter_application_99/pages/reports.dart';
import 'package:flutter_application_99/pages/settings.dart';

class MenuItems {
  List<MenuModel> items = [
    MenuModel(
        title: 'Dashboard', icon: Icons.dashboard, page: const Dashboard()),
    MenuModel(title: 'Accounts', icon: Icons.person, page: const Accounts()),
    MenuModel(
        title: 'Notifications',
        icon: Icons.notifications,
        page: const Notifications()),
    MenuModel(
        title: 'Reports', icon: Icons.document_scanner, page: const Reports()),
    MenuModel(title: 'Settings', icon: Icons.settings, page: const Settings())
  ];
}
