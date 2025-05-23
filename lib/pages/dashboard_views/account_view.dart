import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_session.dart';
import 'package:course_dilaundry/config/nav.dart';
import 'package:course_dilaundry/models/user_model.dart';
import 'package:course_dilaundry/pages/auth/login_page.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  logout(BuildContext context) {
    DInfo.dialogConfirmation(context, 'Logout', 'You sure want to logout?',
            textNo: 'Cancel')
        .then(
      (yes) {
        if (yes ?? false) {
          AppSession.removeUser();
          AppSession.removeBearerToken();
          Nav.replace(context, const LoginPage());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        UserModel user = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: Text(
                'Account',
                style: GoogleFonts.montserrat(
                    fontSize: 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AppAssets.profile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          user.username,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          user.email,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.image),
              title: const Text('Change Profile'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: OutlinedButton(
                onPressed: () => logout(context),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Settings',
                style: TextStyle(
                    height: 1, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.dark_mode),
              title: const Text('Edit Profile'),
              trailing: Switch(
                value: false,
                thumbColor: const WidgetStatePropertyAll(Colors.black54),
                trackOutlineColor: const WidgetStatePropertyAll(Colors.black54),
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.translate),
              title: const Text('Language'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.support_agent),
              title: const Text('Support'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            ListTile(
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationIcon: const Icon(
                      Icons.local_laundry_service,
                      size: 50,
                      color: AppColors.primary,
                    ),
                    applicationName: 'Di Laundry',
                    applicationVersion: 'v1.0.0',
                    children: [
                      const Text(
                          'Laundry Market App to monitor you laundry status')
                    ]);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              dense: true,
              horizontalTitleGap: 14,
              iconColor: Colors.black54,
              textColor: Colors.black54,
              leading: const Icon(Icons.info),
              title: const Text('About'),
              trailing: const Icon(Icons.navigate_next_rounded),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        );
      },
    );
  }
}
