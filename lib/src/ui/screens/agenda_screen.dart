import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../widgets.dart';
import 'orders_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime selected = DateTime(2026, 10, 6);
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final days = List.generate(7, (i) => DateTime(2026, 10, 4 + i));
    final orders =
        state.orders
            .where(
              (o) =>
                  o.date.year == selected.year &&
                  o.date.month == selected.month &&
                  o.date.day == selected.day,
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                title: 'Agenda',
                subtitle: 'Organize a capacidade e os compromissos da equipe.',
                action: FilledButton.icon(
                  onPressed: () => showNewOrderDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Agendar'),
                ),
              ),
              const SizedBox(height: 22),
              SectionCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chevron_left),
                        ),
                        const Expanded(
                          child: Text(
                            'Outubro de 2026',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: days.map((day) {
                        final active = day.day == selected.day;
                        const labels = [
                          'DOM',
                          'SEG',
                          'TER',
                          'QUA',
                          'QUI',
                          'SEX',
                          'SÁB',
                        ];
                        return Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => setState(() => selected = day),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.orange
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    labels[day.weekday % 7],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: active
                                          ? Colors.white70
                                          : AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: active
                                          ? Colors.white
                                          : AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${orders.length} compromissos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: orders.isEmpty
                            ? const EmptyState(
                                icon: Icons.event_available,
                                title: 'Dia livre',
                                message:
                                    'Não há serviços agendados para esta data.',
                              )
                            : ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final o = orders[index],
                                      vehicle = state.vehicle(o.vehicleId),
                                      customer = state.customer(o.customerId);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.canvas,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 55,
                                            child: Text(
                                              time(o.date),
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.ink,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 3,
                                            height: 48,
                                            color: o.status.color,
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  o.service,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.ink,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${customer.name} • ${vehicle.displayName} • ${vehicle.plate}',
                                                ),
                                              ],
                                            ),
                                          ),
                                          StatusBadge(o.status),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
