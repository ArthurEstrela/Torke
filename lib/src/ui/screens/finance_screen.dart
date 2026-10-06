import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../widgets.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final received = state.orders
        .where((order) => order.status == ServiceStatus.delivered)
        .fold<double>(0, (sum, order) => sum + order.value);
    final pending = state.orders
        .where((order) => order.status != ServiceStatus.delivered)
        .fold<double>(0, (sum, order) => sum + order.value);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                title: 'Financeiro',
                subtitle: 'Acompanhe receitas e valores em aberto.',
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth < 700
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 24) / 3;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _FinanceMetric(
                        width: width,
                        title: 'Faturamento previsto',
                        value: money(received + pending),
                        color: AppColors.blue,
                        icon: Icons.bar_chart_rounded,
                      ),
                      _FinanceMetric(
                        width: width,
                        title: 'Recebido',
                        value: money(received),
                        color: AppColors.green,
                        icon: Icons.check_circle_outline,
                      ),
                      _FinanceMetric(
                        width: width,
                        title: 'A receber',
                        value: money(pending),
                        color: AppColors.amber,
                        icon: Icons.schedule,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final chart = SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receita por categoria',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 5),
                        const Text('Participação estimada nas ordens atuais'),
                        const SizedBox(height: 30),
                        const _Bar(
                          label: 'Mecânica e revisão',
                          percent: .76,
                          amount: 'R\$ 1.530',
                        ),
                        const _Bar(
                          label: 'Estética automotiva',
                          percent: .93,
                          amount: 'R\$ 2.280',
                        ),
                        const _Bar(
                          label: 'Óleo e filtros',
                          percent: .45,
                          amount: 'R\$ 420',
                        ),
                        const _Bar(
                          label: 'Pneus e alinhamento',
                          percent: .25,
                          amount: 'R\$ 220',
                        ),
                      ],
                    ),
                  );
                  final recent = SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Últimos lançamentos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 18),
                        ...state.orders
                            .take(5)
                            .map(
                              (order) => Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          order.status ==
                                              ServiceStatus.delivered
                                          ? const Color(0xFFE2F5EC)
                                          : const Color(0xFFFFF2D9),
                                      child: Icon(
                                        order.status == ServiceStatus.delivered
                                            ? Icons.south_west
                                            : Icons.schedule,
                                        size: 18,
                                        color:
                                            order.status ==
                                                ServiceStatus.delivered
                                            ? AppColors.green
                                            : AppColors.amber,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '#${order.id} • ${order.service}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.ink,
                                            ),
                                          ),
                                          Text(
                                            state
                                                .customer(order.customerId)
                                                .name,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      money(order.value),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  );
                  if (constraints.maxWidth < 850) {
                    return Column(
                      children: [chart, const SizedBox(height: 16), recent],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: chart),
                      const SizedBox(width: 16),
                      Expanded(child: recent),
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

class _FinanceMetric extends StatelessWidget {
  const _FinanceMetric({
    required this.width,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });
  final double width;
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: SectionCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.percent,
    required this.amount,
  });
  final String label;
  final String amount;
  final double percent;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            color: AppColors.orange,
            backgroundColor: AppColors.canvas,
          ),
        ),
      ],
    ),
  );
}
