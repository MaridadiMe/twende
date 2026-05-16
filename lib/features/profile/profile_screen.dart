import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/classes/app_state.dart';
import 'package:flutter_application_1/features/auth/enums/app_mode.dart';
import 'package:flutter_application_1/features/home/main_shell.dart';
import 'package:flutter_application_1/features/profile/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller;

  const ProfileScreen({super.key, required this.controller});

  bool get canDrive => controller.user?.hasPermission('CREATE_TRIPS') ?? false;

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool? showTrailing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: Theme.of(context).brightness == Brightness.light ? 2 : 1,
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),
              )
            : null,
        trailing: (showTrailing ?? true)
            ? Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user;
        if (user == null) {
          return const Center(child: Text('User not logged in'));
        }

        return CustomScrollView(
          slivers: [
            // 🔹 Top profile section
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phone,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 16)),

            // 🔹 Settings Section
            SliverToBoxAdapter(child: _buildSectionTitle(context, 'Settings')),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildListTile(
                  context: context,
                  icon: Icons.person,
                  title: 'My Account',
                  onTap: () {},
                ),
                _buildListTile(
                  context: context,
                  icon: Icons.description,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
                _buildListTile(
                  context: context,
                  icon: Icons.support_agent,
                  title: 'Support',
                  onTap: () {},
                ),
                _buildListTile(
                  context: context,
                  icon: Icons.phone,
                  title: 'Contact Us',
                  onTap: () {},
                ),
              ]),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 16)),

            // Toggle Mode (only for drivers)
            if (canDrive)
              SliverToBoxAdapter(
                child: _buildSectionTitle(context, 'App Mode'),
              ),

            if (canDrive)
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildListTile(
                    context: context,
                    icon: Icons.swap_horiz,
                    title: AppState.mode == AppMode.driver
                        ? 'Switch to Rider Mode'
                        : 'Switch to Driver Mode',
                    subtitle: 'Change how you use the app',
                    onTap: () {
                      final newMode = AppState.mode == AppMode.driver
                          ? AppMode.rider
                          : AppMode.driver;

                      controller.switchMode(newMode);

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainShell()),
                      );
                    },
                  ),
                ]),
              ),

            // 🔹 Other Settings Section
            SliverToBoxAdapter(
              child: _buildSectionTitle(context, 'Other Settings'),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildListTile(
                  context: context,
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {},
                ),
                _buildListTile(
                  context: context,
                  icon: Icons.brightness_6,
                  title: 'Theme',
                  subtitle: Theme.of(context).brightness == Brightness.light
                      ? 'Light'
                      : 'Dark',
                  onTap: () {},
                ),
                _buildListTile(
                  context: context,
                  icon: Icons.logout,
                  title: 'Logout',
                  showTrailing: false,
                  onTap: () async {
                    await controller.logout();

                    if (!context.mounted) return;

                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                ),
              ]),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
