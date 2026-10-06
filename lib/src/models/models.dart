import 'package:flutter/material.dart';

enum ServiceStatus { scheduled, inProgress, awaitingApproval, ready, delivered }

extension ServiceStatusX on ServiceStatus {
  String get label => switch (this) {
    ServiceStatus.scheduled => 'Agendado',
    ServiceStatus.inProgress => 'Em execução',
    ServiceStatus.awaitingApproval => 'Aguardando aprovação',
    ServiceStatus.ready => 'Pronto',
    ServiceStatus.delivered => 'Entregue',
  };
  Color get color => switch (this) {
    ServiceStatus.scheduled => const Color(0xFF2672FF),
    ServiceStatus.inProgress => const Color(0xFFF3A522),
    ServiceStatus.awaitingApproval => const Color(0xFF8A5CF6),
    ServiceStatus.ready => const Color(0xFF24A36A),
    ServiceStatus.delivered => const Color(0xFF65717E),
  };
}

class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.since,
  });
  final int id;
  final String name;
  final String phone;
  final String email;
  final DateTime since;
}

class Vehicle {
  const Vehicle({
    required this.id,
    required this.customerId,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    required this.color,
  });
  final int id;
  final int customerId;
  final String brand;
  final String model;
  final String plate;
  final int year;
  final String color;
  String get displayName => '$brand $model';
}

class ServiceOrder {
  const ServiceOrder({
    required this.id,
    required this.customerId,
    required this.vehicleId,
    required this.service,
    required this.date,
    required this.value,
    required this.status,
  });
  final int id;
  final int customerId;
  final int vehicleId;
  final String service;
  final DateTime date;
  final double value;
  final ServiceStatus status;
  ServiceOrder copyWith({ServiceStatus? status}) => ServiceOrder(
    id: id,
    customerId: customerId,
    vehicleId: vehicleId,
    service: service,
    date: date,
    value: value,
    status: status ?? this.status,
  );
}
