// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String description;
  final bool check;

  const Task({
    required this.id,
    required this.description,
    this.check = false,
  });

  @override
  List<Object> get props => [id, description, check];

  Task copyWith({
    int? id,
    String? description,
    bool? check,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      check: check ?? this.check,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'check': check,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      description: map['description'] as String,
      check: map['check'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
