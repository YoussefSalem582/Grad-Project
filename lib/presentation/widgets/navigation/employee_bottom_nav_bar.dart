import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

class EmployeeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const EmployeeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Map current screen to bottom nav index
    int currentIndex;
    switch (selectedIndex) {
      case 0: // Dashboard
        currentIndex = 0;
        break;
      case 1: // Analysis Tools / Tool
      case 5: // Analysis Tools Screen
      case 6: // Video Analysis
      case 7: // Text Analysis
      case 8: // Voice Analysis
        currentIndex = 1;
        break;
      case 4: // Tickets
        currentIndex = 2;
        break;
      case 3: // Profile
        currentIndex = 3;
        break;
      default:
        currentIndex = 0;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.25),
            const Color(0xFF764BA2).withValues(alpha: 0.2),
            const Color(0xFF48CAE4).withValues(alpha: 0.15),
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
            color: const Color(0xFF667EEA).withValues(alpha: 0.2),
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
                  Icons.home_outlined,
                  Icons.home,
                  'Home',
                  0,
                  currentIndex == 0,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.analytics_outlined,
                  Icons.analytics,
                  'Tool',
                  1,
                  currentIndex == 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.task_outlined,
                  Icons.task_rounded,
                  'Tickets',
                  2,
                  currentIndex == 2,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.person_outline,
                  Icons.person,
                  'Profile',
                  3,
                  currentIndex == 3,
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
        // Map bottom nav index to actual screen index
        int targetScreenIndex;
        switch (index) {
          case 0: // Home
            targetScreenIndex = 0;
            break;
          case 1: // Tool (Analysis Tools)
            targetScreenIndex = 5;
            break;
          case 2: // Tickets
            targetScreenIndex = 4;
            break;
          case 3: // Profile
            targetScreenIndex = 3;
            break;
          default:
            targetScreenIndex = 0;
        }

        onItemTapped(targetScreenIndex);
        // Add haptic feedback for better UX
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.4),
                      const Color(0xFF667EEA).withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.3),
                    ],
                  )
                  : null,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  )
                  : null,
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
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
