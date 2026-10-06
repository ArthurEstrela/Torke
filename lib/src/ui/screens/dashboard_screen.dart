import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final today =
        state.orders
            .where(
              (o) =>
                  o.date.year == 2026 && o.date.month == 10 && o.date.day == 6,
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    final open = state.orders
        .where((o) => o.status != ServiceStatus.delivered)
        .length;
    final revenue = state.orders
        .where((o) => o.status == ServiceStatus.delivered)
        .fold<double>(0, (sum, o) => sum + o.value);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                title: 'Bom dia, Rafael!',
                subtitle: 'Aqui está o resumo da sua operação hoje.',
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, c) {
                  final width = c.maxWidth < 700
                      ? c.maxWidth
                      : (c.maxWidth - 36) / 4;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _Metric(
                        width: width,
                        label: 'Serviços hoje',
                        value: '${today.length}',
                        detail: '+2 desde ontem',
                        icon: Icons.calendar_today_rounded,
                        color: AppColors.blue,
                      ),
                      _Metric(
                        width: width,
                        label: 'Ordens abertas',
                        value: '$open',
                        detail: '2 aguardam atenção',
                        icon: Icons.build_circle_outlined,
                        color: AppColors.amber,
                      ),
                      _Metric(
                        width: width,
                        label: 'Faturamento',
                        value: money(revenue),
                        detail: 'Recebido no período',
                        icon: Icons.trending_up_rounded,
                        color: AppColors.green,
                      ),
                      _Metric(
                        width: width,
                        label: 'Clientes ativos',
                        value: '${state.customers.length}',
                        detail: '${state.vehicles.length} veículos',
                        icon: Icons.people_alt_outlined,
                        color: AppColors.orange,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, c) {
                  final narrow = c.maxWidth < 850;
                  final schedule = _TodaySchedule(orders: today);
                  final status = _StatusOverview(orders: state.orders);
                  return narrow
                      ? Column(
                          children: [
                            schedule,
                            const SizedBox(height: 16),
                            status,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: schedule),
                            const SizedBox(width: 16),
                            Expanded(flex: 2, child: status),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.width,
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final double width;
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 9),
          Text(detail, style: const TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}

class _TodaySchedule extends StatelessWidget {
  const _TodaySchedule({required this.orders});
  final List<ServiceOrder> orders;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Agenda de hoje',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              const Text(
                '06 OUT',
                style: TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...orders.map((order) {
            final vehicle = state.vehicle(order.vehicleId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      time(order.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 48,
                    decoration: BoxDecoration(
                      color: order.status.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.service,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${vehicle.displayName} • ${vehicle.plate}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(order.status),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatusOverview extends StatelessWidget {
  const _StatusOverview({required this.orders});
  final List<ServiceOrder> orders;
  @override
  Widget build(BuildContext context) => SectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Visão das ordens', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 7),
        const Text('Distribuição por etapa atual'),
        const SizedBox(height: 22),
        ...ServiceStatus.values.where((s) => s != ServiceStatus.delivered).map((
          status,
        ) {
          final count = orders.where((o) => o.status == status).length;
          final max = orders
              .where((o) => o.status != ServiceStatus.delivered)
              .length;
          return Padding(
            padding: const EdgeInsets.only(bottom: 17),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: status.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        status.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    Text(
                      '$count',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: max == 0 ? 0 : count / max,
                    minHeight: 7,
                    color: status.color,
                    backgroundColor: AppColors.canvas,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
