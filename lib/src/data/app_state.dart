import 'package:flutter/material.dart';

import '../models/models.dart';

class AppState extends ChangeNotifier {
  AppState.seeded()
    : customers = [
        Customer(
          id: 1,
          name: 'Marcos Almeida',
          phone: '(11) 98765-4321',
          email: 'marcos@email.com',
          since: DateTime(2024, 3, 12),
        ),
        Customer(
          id: 2,
          name: 'Fernanda Lima',
          phone: '(11) 97654-1098',
          email: 'fernanda@email.com',
          since: DateTime(2025, 1, 8),
        ),
        Customer(
          id: 3,
          name: 'Ricardo Santos',
          phone: '(11) 99882-7766',
          email: 'ricardo@email.com',
          since: DateTime(2025, 7, 21),
        ),
        Customer(
          id: 4,
          name: 'Camila Oliveira',
          phone: '(11) 96645-3322',
          email: 'camila@email.com',
          since: DateTime(2026, 2, 4),
        ),
      ],
      vehicles = const [
        Vehicle(
          id: 1,
          customerId: 1,
          brand: 'Honda',
          model: 'Civic',
          plate: 'ABC1D23',
          year: 2022,
          color: 'Prata',
        ),
        Vehicle(
          id: 2,
          customerId: 2,
          brand: 'Jeep',
          model: 'Compass',
          plate: 'FTR8E42',
          year: 2023,
          color: 'Preto',
        ),
        Vehicle(
          id: 3,
          customerId: 3,
          brand: 'Toyota',
          model: 'Corolla',
          plate: 'GHJ4K90',
          year: 2021,
          color: 'Branco',
        ),
        Vehicle(
          id: 4,
          customerId: 4,
          brand: 'Volkswagen',
          model: 'T-Cross',
          plate: 'LMN2P18',
          year: 2024,
          color: 'Cinza',
        ),
        Vehicle(
          id: 5,
          customerId: 1,
          brand: 'Ford',
          model: 'Ranger',
          plate: 'QRS7T56',
          year: 2020,
          color: 'Azul',
        ),
      ],
      orders = [
        ServiceOrder(
          id: 1048,
          customerId: 1,
          vehicleId: 1,
          service: 'Revisão completa',
          date: DateTime(2026, 10, 6, 9),
          value: 890,
          status: ServiceStatus.inProgress,
        ),
        ServiceOrder(
          id: 1049,
          customerId: 2,
          vehicleId: 2,
          service: 'Higienização interna',
          date: DateTime(2026, 10, 6, 11),
          value: 350,
          status: ServiceStatus.scheduled,
        ),
        ServiceOrder(
          id: 1050,
          customerId: 3,
          vehicleId: 3,
          service: 'Polimento técnico',
          date: DateTime(2026, 10, 6, 14, 30),
          value: 680,
          status: ServiceStatus.awaitingApproval,
        ),
        ServiceOrder(
          id: 1051,
          customerId: 4,
          vehicleId: 4,
          service: 'Troca de óleo e filtros',
          date: DateTime(2026, 10, 6, 16),
          value: 420,
          status: ServiceStatus.ready,
        ),
        ServiceOrder(
          id: 1047,
          customerId: 1,
          vehicleId: 5,
          service: 'Vitrificação de pintura',
          date: DateTime(2026, 10, 5, 10),
          value: 1250,
          status: ServiceStatus.delivered,
        ),
        ServiceOrder(
          id: 1052,
          customerId: 2,
          vehicleId: 2,
          service: 'Alinhamento e balanceamento',
          date: DateTime(2026, 10, 7, 9, 30),
          value: 220,
          status: ServiceStatus.scheduled,
        ),
      ];
  final List<Customer> customers;
  final List<Vehicle> vehicles;
  final List<ServiceOrder> orders;
  Customer customer(int id) => customers.firstWhere((item) => item.id == id);
  Vehicle vehicle(int id) => vehicles.firstWhere((item) => item.id == id);
  void addCustomer({
    required String name,
    required String phone,
    required String email,
  }) {
    customers.add(
      Customer(
        id: customers.length + 1,
        name: name,
        phone: phone,
        email: email,
        since: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addOrder({
    required int customerId,
    required int vehicleId,
    required String service,
    required DateTime date,
    required double value,
  }) {
    final nextId =
        orders.fold<int>(1000, (max, item) => item.id > max ? item.id : max) +
        1;
    orders.add(
      ServiceOrder(
        id: nextId,
        customerId: customerId,
        vehicleId: vehicleId,
        service: service,
        date: date,
        value: value,
        status: ServiceStatus.scheduled,
      ),
    );
    notifyListeners();
  }

  void updateStatus(int id, ServiceStatus status) {
    final index = orders.indexWhere((item) => item.id == id);
    if (index < 0) return;
    orders[index] = orders[index].copyWith(status: status);
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState notifier, required super.child})
    : super(notifier: notifier);
  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope não encontrado');
    return scope!.notifier!;
  }
}
