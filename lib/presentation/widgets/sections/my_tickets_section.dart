import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../employee/employee_widgets.dart';
import '../buttons/modern_button.dart';
import '../dialogs/create_ticket_dialog.dart';
import '../dialogs/ticket_details_dialog.dart';
import '../../cubit/employee_tickets/employee_tickets_cubit.dart';

class MyTicketsSection extends StatefulWidget {
  final CustomSpacing customSpacing;

  const MyTicketsSection({super.key, required this.customSpacing});

  @override
  State<MyTicketsSection> createState() => _MyTicketsSectionState();
}

class _MyTicketsSectionState extends State<MyTicketsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeTicketsCubit, EmployeeTicketsState>(
      builder: (context, state) {
        if (state is EmployeeTicketsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeTicketsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                ElevatedButton(
                  onPressed: () =>
                      context.read<EmployeeTicketsCubit>().loadTickets(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is EmployeeTicketsSuccess) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(widget.customSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmployeeSectionHeader(
                  title: 'My Support Tickets',
                  onActionPressed: _createNewTicket,
                  actionText: 'New Ticket',
                  actionIcon: Icons.add,
                  actionStyle: ModernButtonStyle.primary,
                ),

                // Filter tabs
                EmployeeFilterChips(
                  labels: ['All', 'Open', 'In Progress', 'Resolved'],
                  counts: state.data.filterCounts,
                  selectedIndex: state.data.selectedFilterIndex,
                  onSelectionChanged: (index) {
                    context.read<EmployeeTicketsCubit>().changeFilter(index);
                  },
                ),
                SizedBox(height: widget.customSpacing.lg),

                // Tickets list
                ...state.data.tickets.map((ticket) {
                  return _buildTicketCard(ticket);
                }).toList(),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    return EmployeeTicketCard(
      ticketId: ticket['id'] as String,
      title: ticket['title'] as String,
      description: ticket['description'] as String,
      priority: ticket['priority'] as String,
      status: ticket['status'] as String,
      customer: ticket['customer'] as String,
      assignee: ticket['assignee'] as String,
      created: ticket['created'] as String,
      onTap: () => _viewTicketDetails(ticket),
    );
  }

  void _createNewTicket() {
    showDialog(
      context: context,
      builder: (context) => CreateTicketDialog(
        onTicketCreated: () {
          // Refresh tickets list
          context.read<EmployeeTicketsCubit>().refreshTickets();
        },
      ),
    );
  }

  void _viewTicketDetails(Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (context) => TicketDetailsDialog(ticket: ticket),
    );
  }
}
