import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../theme/app_theme.dart';
import '../widgets.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final customers = state.customers
        .where(
          (customer) => '${customer.name} ${customer.phone} ${customer.email}'
              .toLowerCase()
              .contains(search.toLowerCase()),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                title: 'Clientes e veículos',
                subtitle: 'Centralize contatos e o histórico da frota.',
                action: FilledButton.icon(
                  onPressed: () => _newCustomer(context),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Novo cliente'),
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                onChanged: (value) => setState(() => search = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar por nome, telefone ou e-mail...',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: customers.isEmpty
                    ? const SectionCard(
                        child: EmptyState(
                          icon: Icons.person_search,
                          title: 'Cliente não encontrado',
                          message: 'Tente buscar usando outro termo.',
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 1050
                              ? 3
                              : constraints.maxWidth >= 650
                              ? 2
                              : 1;
                          final itemWidth =
                              (constraints.maxWidth - (columns - 1) * 14) /
                              columns;
                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: customers.map((customer) {
                                final vehicles = state.vehicles
                                    .where(
                                      (vehicle) =>
                                          vehicle.customerId == customer.id,
                                    )
                                    .toList();
                                final initials = customer.name
                                    .split(' ')
                                    .take(2)
                                    .map((word) => word[0])
                                    .join();
                                return SizedBox(
                                  width: itemWidth,
                                  child: SectionCard(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 22,
                                              backgroundColor:
                                                  AppColors.orangeSoft,
                                              child: Text(
                                                initials,
                                                style: const TextStyle(
                                                  color: AppColors.orange,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    customer.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  Text(customer.phone),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              Icons.more_vert,
                                              color: AppColors.muted,
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 28),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.mail_outline,
                                              size: 17,
                                              color: AppColors.muted,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                customer.email,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          '${vehicles.length} ${vehicles.length == 1 ? 'veículo' : 'veículos'}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.muted,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...vehicles.map(
                                          (vehicle) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 7,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: AppColors.canvas,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .directions_car_outlined,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      vehicle.displayName,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.ink,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    vehicle.plate,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _newCustomer(BuildContext context) async {
    final state = AppScope.of(context);
    final name = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Novo cliente'),
        content: SizedBox(
          width: 430,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nome completo'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isEmpty || phone.text.trim().isEmpty) return;
              state.addCustomer(
                name: name.text.trim(),
                phone: phone.text.trim(),
                email: email.text.trim(),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    name.dispose();
    phone.dispose();
    email.dispose();
  }
}
