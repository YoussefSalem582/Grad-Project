import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AdminBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B6B).withValues(alpha: 0.25),
            const Color(0xFFFF8E53).withValues(alpha: 0.2),
            const Color(0xFFE056FD).withValues(alpha: 0.15),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
          BoxShadow(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.dashboard_outlined,
                  Icons.dashboard,
                  'Dashboard',
                  0,
                  selectedIndex == 0,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.people_outline,
                  Icons.people,
                  'Users',
                  1,
                  selectedIndex == 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.confirmation_number_outlined,
                  Icons.confirmation_number,
                  'Tickets',
                  2,
                  selectedIndex == 2,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.settings_outlined,
                  Icons.settings,
                  'System',
                  3,
                  selectedIndex == 3,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.person_outline,
                  Icons.person,
                  'Profile',
                  4,
                  selectedIndex == 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        onItemTapped(index);
        // Add haptic feedback for better UX
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.3),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: const Color(0xFFFF8E53).withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with smooth transition
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isSelected ? filledIcon : outlinedIcon,
                key: ValueKey('$index-$isSelected'),
                color: Colors.white,
                size: isSelected ? 22 : 20,
              ),
            ),
            const SizedBox(height: 2),
            // Label with overflow protection and responsive font size
            Flexible(
              child: Container(
                constraints: const BoxConstraints(minHeight: 12),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: isSelected ? 0.2 : 0.0,
                    height: 1.0,
                  ),
                  child: Text(
                    label,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
