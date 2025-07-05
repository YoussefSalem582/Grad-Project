import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../cubit/employee_tickets/employee_tickets_cubit.dart';

class EmployeeCustomerInteractionsScreen extends StatefulWidget {
  const EmployeeCustomerInteractionsScreen({super.key});

  @override
  State<EmployeeCustomerInteractionsScreen> createState() =>
      _EmployeeCustomerInteractionsScreenState();
}

class _EmployeeCustomerInteractionsScreenState
    extends State<EmployeeCustomerInteractionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _backgroundController;

  int _selectedTab = 0;
  final PageController _tabController = PageController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _backgroundController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeeTicketsCubit()..loadTickets(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Animated Background
            AnimatedBackgroundWidget(animation: _backgroundController),

            // Main Content
            FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: Column(
                  children: [
                    EmployeeTabBar(
                      titles: ['My Tickets', 'Analytics'],
                      icons: [Icons.assignment, Icons.analytics],
                      selectedIndex: _selectedTab,
                      onTabChanged: (index) {
                        setState(() => _selectedTab = index);
                        _tabController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    Expanded(
                      child: PageView(
                        controller: _tabController,
                        onPageChanged: (index) {
                          setState(() => _selectedTab = index);
                        },
                        children: [
                          MyTicketsSection(customSpacing: customSpacing),
                          AnalyticsSection(
                            theme: theme,
                            customSpacing: customSpacing,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
