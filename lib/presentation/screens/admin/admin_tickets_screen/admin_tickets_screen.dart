import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../cubit/tickets/tickets_cubit.dart';
import '../../../widgets/common/animated_background_widget.dart';
import 'widgets/widgets.dart';

class AdminTicketsScreen extends StatefulWidget {
  const AdminTicketsScreen({super.key});

  @override
  State<AdminTicketsScreen> createState() => _AdminTicketsScreenState();
}

class _AdminTicketsScreenState extends State<AdminTicketsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );
    _backgroundController.repeat();

    _searchController = TextEditingController();

    // Load tickets when screen initializes
    context.read<TicketsCubit>().loadAllTickets(isAdminView: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main content
          SafeArea(
            child: BlocBuilder<TicketsCubit, TicketsState>(
              builder: (context, state) {
                if (state is TicketsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TicketsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(height: customSpacing.md),
                        Text(
                          'Error loading tickets',
                          style: theme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: customSpacing.sm),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: customSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TicketsCubit>().loadAllTickets(
                              isAdminView: true,
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TicketsSuccess &&
                    state.isAdminView &&
                    state.adminData != null) {
                  return _buildTicketsContent(
                    context,
                    state.adminData!,
                    customSpacing,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsContent(
    BuildContext context,
    AdminTicketsData data,
    CustomSpacing spacing,
  ) {
    final cubit = context.read<TicketsCubit>();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: AdminTicketsHeader(
            totalCount: data.totalCount,
            onCreateTicket: () {
              // TODO: Implement create ticket functionality
            },
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),

        // Search and filters
        SliverToBoxAdapter(
          child: AdminTicketsFilters(
            searchController: _searchController,
            cubit: cubit,
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),

        // Tickets list
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ticket = data.filteredTickets[index];
              return AdminTicketCard(ticket: ticket, cubit: cubit);
            }, childCount: data.filteredTickets.length),
          ),
        ),

        // Bottom padding
        SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
      ],
    );
  }
}
