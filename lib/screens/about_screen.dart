import 'package:driverid01/widgets/side_tabbed_title.dart';
import 'package:driverid01/widgets/tap_to_action.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  static const routeName = '/about';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            SideTabbedTitle('Boomer Driver App'),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                  'An Uber-like application for Drivers made using Flutter.',
                  style: Theme.of(context).textTheme.displayLarge),
            ),
            SizedBox(height: 40),
            SideTabbedTitle('External Services that app uses'),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps SDK for Android',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps SDK for iOS',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Firebase for authentication and database',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Provider',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Google Maps Flutter',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Geolocator',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Animated Text Kit',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(color: Color(0xff6D5D54)),
            ListTile(
              leading: Icon(
                Icons.circle,
                color: Color(0xff6D5D54),
              ),
              title: Text(
                'Flutter Geofire',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'This application is only for showcasing purposes.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              tileColor: Theme.of(context).primaryColorDark,
              contentPadding: const EdgeInsets.all(10),
              title: TapToActionText(
                label: 'Created By ',
                tapLabel: 'DuduMoon21111',
                padding: const EdgeInsets.all(0),
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
