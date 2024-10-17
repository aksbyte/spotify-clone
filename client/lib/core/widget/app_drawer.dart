import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../features/about_us/about_us_page.dart';
import '../constant/app_constant.dart';


class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {


  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      AppConstant.appName = info.appName;
      AppConstant.packageName = info.packageName;
      AppConstant.version = info.version;
      AppConstant.buildNumber = info.buildNumber;

      /* appName = info.appName;
      packageName = info.packageName;
      version = info.version;
      buildNumber = info.buildNumber;*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              /* image: DecorationImage(
                  image: AssetImage(
                    'asset/app_logo.png',
                  ),
                  fit: BoxFit.cover),*/
              //  color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppConstant.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Developer Information'),
            onTap: () {
              // Navigate to developer information page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AboutScreen(),
                  ));
              //Navigator.of(context).pop();
              // Navigate to about page
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to help and support page
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Version: ${AppConstant.version}',
                ),
                Text(
                  'Build: ${AppConstant.buildNumber}',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
