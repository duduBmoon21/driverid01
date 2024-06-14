import 'package:driverid01/models/driver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/maps_provider.dart';
import '../providers/driver_provider.dart';

import 'about_screen.dart';
import 'all_cars_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    final driverData = Provider.of<DriverProvider>(context, listen: false);
    final driver = driverData.driver;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileTile(context, driver),
              const SizedBox(height: 40),
              _buildListTile(
                context,
                icon: Icons.directions_car,
                text: 'View Cars',
                onTap: () {
                  Navigator.of(context).pushNamed(AllCarsScreen.routeName);
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.payment,
                text: 'Payment Methods',
                onTap: () {
                  // Navigator.of(context).pushNamed(PaymentMethodsScreen.routeName);
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.history,
                text: 'History',
                onTap: () {
                  // Navigator.of(context).pushNamed(HistoryScreen.routeName);
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.info,
                text: 'About',
                onTap: () {
                  Navigator.of(context).pushNamed(AboutScreen.routeName);
                },
              ),
              _buildDivider(),
              const Expanded(child: SizedBox()),
              _buildListTile(
                context,
                icon: Icons.logout,
                text: 'Logout',
                onTap: () async {
                  await _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context, Driver driver) {
    return ListTile(
      onTap: () {
        print('View Profile');
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Theme.of(context).primaryColorDark.withOpacity(0.6),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      leading: Image.asset('assets/images/user_icon.png'),
      title: Text(
        driver.name ?? 'No name',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      // subtitle: Text(
      // //  driver.mobile?? 'No Mobile',
      //   // style: Theme.of(context).textTheme.bodyMedium,
      // ),
      trailing: const Icon(
        Icons.edit,
        color: Color(0xffB8AAA3),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Icon(
        icon,
        color: const Color(0xff6D5D54),
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0xff6D5D54));
  }

  Future<void> _logout(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).logout();
    await Provider.of<MapsProvider>(context, listen: false).goOffline();
  }
}
