import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String search = '';
  ServiceStatus? filter;
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final orders = state.orders.where((o) {
      final customer = state.customer(o.customerId);
      final vehicle = state.vehicle(o.vehicleId);
      final q = search.toLowerCase();
      return (filter == null || o.status == filter) &&
          ('${o.id} ${o.service} ${customer.name} ${vehicle.plate}'
              .toLowerCase()
              .contains(q));
    }).toList()..sort((a, b) => b.id.compareTo(a.id));
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                title: 'Ordens de serviço',
                subtitle: 'Acompanhe cada veículo do orçamento à entrega.',
                action: FilledButton.icon(
                  onPressed: () => showNewOrderDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Nova OS'),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => search = v),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Buscar por cliente, placa, serviço ou OS...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  PopupMenuButton<ServiceStatus?>(
                    onSelected: (v) => setState(() => filter = v),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: null,
                        child: Text('Todos os status'),
                      ),
                      ...ServiceStatus.values.map(
                        (s) => PopupMenuItem(value: s, child: Text(s.label)),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list, size: 20),
                          const SizedBox(width: 8),
                          Text(filter?.label ?? 'Filtrar'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  child: orders.isEmpty
                      ? const EmptyState(
                          icon: Icons.assignment_outlined,
                          title: 'Nenhuma ordem encontrada',
                          message: 'Ajuste os filtros ou crie uma nova ordem de serviço.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: orders.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final o = orders[index];
                            final customer = state.customer(o.customerId);
                            final vehicle = state.vehicle(o.vehicleId);
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: o.status.color.withValues(
                                  alpha: .1,
                                ),
                                child: Icon(
                                  Icons.directions_car,
                                  color: o.status.color,
                                ),
                              ),
                              title: Text(
                                '#${o.id}  •  ${o.service}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  '${customer.name}  •  ${vehicle.displayName}  •  ${vehicle.plate}',
                                ),
                              ),
                              trailing: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 16,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        money(o.value),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      Text(
                                        shortDate(o.date),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<ServiceStatus>(
                                    tooltip: 'Alterar status',
                                    onSelected: (s) =>
                                        state.updateStatus(o.id, s),
                                    itemBuilder: (_) => ServiceStatus.values
                                        .map(
                                          (s) => PopupMenuItem(
                                            value: s,
                                            child: Text(s.label),
                                          ),
                                        )
                                        .toList(),
                                    child: StatusBadge(o.status),
                                  ),
                                ],
                              ),
                            );
                          },
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

Future<void> showNewOrderDialog(BuildContext context) async {
  final state = AppScope.of(context);
  int customerId = state.customers.first.id;
  int vehicleId = state.vehicles
      .firstWhere((v) => v.customerId == customerId)
      .id;
  final service = TextEditingController();
  final value = TextEditingController();
  DateTime selectedDate = DateTime(2026, 10, 6, 9);
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setLocal) {
        final customerVehicles = state.vehicles
            .where((v) => v.customerId == customerId)
            .toList();
        return AlertDialog(
          title: const Text('Nova ordem de serviço'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: customerId,
                    decoration: const InputDecoration(labelText: 'Cliente'),
                    items: state.customers
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setLocal(() {
                        customerId = v;
                        vehicleId = state.vehicles
                            .firstWhere((item) => item.customerId == v)
                            .id;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: vehicleId,
                    decoration: const InputDecoration(labelText: 'Veículo'),
                    items: customerVehicles
                        .map(
                          (v) => DropdownMenuItem(
                            value: v.id,
                            child: Text('${v.displayName} • ${v.plate}'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) vehicleId = v;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: service,
                    decoration: const InputDecoration(
                      labelText: 'Serviço',
                      hintText: 'Ex.: Revisão completa',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: value,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      prefixText: 'R\$ ',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Data do serviço'),
                    subtitle: Text(shortDate(selectedDate)),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2026),
                        lastDate: DateTime(2028),
                        initialDate: selectedDate,
                      );
                      if (picked != null) {
                        setLocal(
                          () => selectedDate = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            selectedDate.hour,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(value.text.replaceAll(',', '.'));
                if (service.text.trim().isEmpty || amount == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha o serviço e um valor válido.'),
                    ),
                  );
                  return;
                }
                state.addOrder(
                  customerId: customerId,
                  vehicleId: vehicleId,
                  service: service.text.trim(),
                  date: selectedDate,
                  value: amount,
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ordem de serviço criada com sucesso.'),
                  ),
                );
              },
              child: const Text('Criar ordem'),
            ),
          ],
        );
      },
    ),
  );
  service.dispose();
  value.dispose();
}
