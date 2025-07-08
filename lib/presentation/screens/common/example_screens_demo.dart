import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../common/common_screens.dart';

/// Example implementation showing how to use the enhanced screen components
class ExampleScreensDemo extends StatefulWidget {
  const ExampleScreensDemo({super.key});

  @override
  State<ExampleScreensDemo> createState() => _ExampleScreensDemoState();
}

class _ExampleScreensDemoState extends State<ExampleScreensDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Screens Demo'),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDemoCard(
            title: 'Loading Screen',
            description: 'Animated loading indicators with progress support',
            onTap: () => _showLoadingScreen(),
          ),
          _buildDemoCard(
            title: 'Error Screen',
            description: 'Comprehensive error handling with retry functionality',
            onTap: () => _showErrorScreen(),
          ),
          _buildDemoCard(
            title: 'Empty State Screen',
            description: 'Various empty states with action buttons',
            onTap: () => _showEmptyStateScreen(),
          ),
          _buildDemoCard(
            title: 'Onboarding Wizard',
            description: 'Step-by-step onboarding with animations',
            onTap: () => _showOnboardingWizard(),
          ),
          _buildDemoCard(
            title: 'Settings Screen',
            description: 'Organized settings with different item types',
            onTap: () => _showSettingsScreen(),
          ),
          _buildDemoCard(
            title: 'Search Screen',
            description: 'Advanced search with filters and results',
            onTap: () => _showSearchScreen(),
          ),
          _buildDemoCard(
            title: 'Profile Screen',
            description: 'Editable profile with organized sections',
            onTap: () => _showProfileScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLoadingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingScreen(
          message: 'Loading demo data...',
          showProgress: true,
          progress: 0.7,
        ),
      ),
    );

    // Simulate loading completion
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  void _showErrorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ErrorScreen.network(
          onAction: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showEmptyStateScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmptyStateScreen.noData(
          onAction: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showOnboardingWizard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardingWizard(
          steps: [
            const OnboardingStep(
              title: 'Welcome to EmoSense',
              description: 'Discover the power of emotional intelligence with our advanced AI platform.',
              icon: Icons.psychology,
              primaryColor: AppColors.primary,
              secondaryColor: AppColors.accent,
            ),
            const OnboardingStep(
              title: 'Analyze Emotions',
              description: 'Get deep insights into emotions from text, voice, and video content.',
              icon: Icons.analytics,
              primaryColor: AppColors.accent,
              secondaryColor: AppColors.secondary,
            ),
            const OnboardingStep(
              title: 'Make Better Decisions',
              description: 'Use emotional insights to improve customer experiences and business outcomes.',
              icon: Icons.trending_up,
              primaryColor: AppColors.success,
              secondaryColor: AppColors.primary,
            ),
          ],
          onComplete: () => Navigator.pop(context),
          onSkip: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          sections: [
            SettingsSection(
              title: 'Account',
              items: [
                SettingsItem.navigation(
                  title: 'Profile',
                  subtitle: 'Manage your profile information',
                  icon: Icons.person,
                  onTap: () {},
                ),
                SettingsItem.navigation(
                  title: 'Security',
                  subtitle: 'Password and authentication',
                  icon: Icons.security,
                  onTap: () {},
                ),
              ],
            ),
            SettingsSection(
              title: 'Preferences',
              items: [
                SettingsItem.toggle(
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  icon: Icons.notifications,
                  value: true,
                  onChanged: (value) {},
                ),
                SettingsItem.toggle(
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme',
                  icon: Icons.dark_mode,
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
            SettingsSection(
              title: 'About',
              items: [
                SettingsItem.info(
                  title: 'Version',
                  icon: Icons.info,
                  trailingText: '1.0.0',
                ),
                SettingsItem.action(
                  title: 'Contact Support',
                  icon: Icons.support,
                  trailingIcon: Icons.open_in_new,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          hintText: 'Search for emotions, analytics...',
          onSearch: (query, filters) async {
            // Simulate search
            await Future.delayed(const Duration(seconds: 1));
            return List.generate(5, (index) => 'Result ${index + 1} for "$query"');
          },
          itemBuilder: (context, item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(item.toString()),
                subtitle: Text('Description for ${item}'),
                leading: const Icon(Icons.search),
                onTap: () {},
              ),
            );
          },
        ),
      ),
    );
  }

  void _showProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          profileData: const ProfileData(
            name: 'John Doe',
            email: 'john.doe@example.com',
            role: 'Admin',
            avatarUrl: null,
          ),
          sections: [
            ProfileSection(
              title: 'Personal Information',
              items: [
                ProfileItem(
                  title: 'Email',
                  value: 'john.doe@example.com',
                  icon: Icons.email,
                  isEditable: true,
                ),
                ProfileItem(
                  title: 'Phone',
                  value: '+1 (555) 123-4567',
                  icon: Icons.phone,
                  isEditable: true,
                ),
                ProfileItem(
                  title: 'Location',
                  value: 'New York, NY',
                  icon: Icons.location_on,
                  isEditable: true,
                ),
              ],
            ),
            ProfileSection(
              title: 'Preferences',
              items: [
                ProfileItem(
                  title: 'Language',
                  value: 'English',
                  icon: Icons.language,
                  isEditable: true,
                ),
                ProfileItem(
                  title: 'Timezone',
                  value: 'EST (UTC-5)',
                  icon: Icons.schedule,
                  isEditable: true,
                ),
              ],
            ),
          ],
          isEditable: true,
          onSave: () {
            // Handle save
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          },
        ),
      ),
    );
  }
}
