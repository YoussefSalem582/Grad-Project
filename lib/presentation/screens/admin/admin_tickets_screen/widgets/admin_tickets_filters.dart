import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../../../../cubit/tickets/tickets_cubit.dart';

class AdminTicketsFilters extends StatelessWidget {
  final TextEditingController searchController;
  final TicketsCubit cubit;

  const AdminTicketsFilters({
    super.key,
    required this.searchController,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search tickets...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                cubit.updateSearchQuery(value, isAdminView: true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
