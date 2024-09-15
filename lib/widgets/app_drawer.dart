import 'package:flutter/material.dart';
import 'package:tasks_manager_forcen/widgets/drawer_items.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Drawer(
        width: 270,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(
                    'assets/images/profile_image.jpg'
                ),
              ),
              accountName: Text('CISSE410'),
              accountEmail: Text('formation@forcen.sn'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.zero,
              ),
            ),
            /*DrawerItems(
              title: 'Home',
              icon: Icons.home_outlined,
              onTap: (){
                Navigator.pushNamed(context, '/home');
              },
            ),*/
            DrawerItems(
              title: 'Dashboard',
              icon: Icons.dashboard_outlined,
              onTap: (){
                Navigator.pushNamed(context, '/main');
              },
            ),
            DrawerItems(
              title: 'Completed tasks',
              icon: Icons.list_alt_sharp,
              onTap: (){
                Navigator.pushNamed(context, '/completed-tasks');
              },
            ),
            DrawerItems(
              title: 'Uncompleted tasks',
              icon: Icons.incomplete_circle_outlined,
              onTap: (){
                Navigator.pushNamed(context, '/uncompleted-tasks');
              },
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
