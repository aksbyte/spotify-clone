import 'package:client/core/constant/app_export.dart';
import 'package:flutter/material.dart';
import '../../core/constant/app_constant.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            // Add your back button functionality here
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundImage: AssetImage(AppVector.logo)),
            title: Text(
              'Spotify clone music app',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              'Version ${AppConstant.version}',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Developer',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,

            leading: Container(
              height: 40,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle
              ),
              child: Image.network(
                  "https://avatars.githubusercontent.com/u/54511621?v=4", fit: BoxFit.cover,),
            ),
            title: Text(
              'AksByte',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              'The explorer of hidden features.',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person, color: colorScheme.onSurface),
            title: Text(
              'Akshay Nishad',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              'Software Engineer - Flutter Developer',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Support',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.privacy_tip, color: colorScheme.onSurface),
            title: Text(
              'Privacy policy',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            onTap: () {
              // Add navigation to Privacy Policy
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.star, color: colorScheme.onSurface),
            title: Text(
              'Rate app',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            onTap: () {
              // Add navigation to Rate App
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.apps, color: colorScheme.onSurface),
            title: Text(
              'More apps',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            onTap: () {
              // Add navigation to More Apps
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.facebook, color: colorScheme.onSurface),
            title: Text(
              'Follow on Facebook',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            onTap: () {
              // Add navigation to Facebook Page
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Copyright Notice ©',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface),
          ),
          Text(
            "Created this app thought learning purpose ",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
