import 'package:equatable/equatable.dart';

class LanguageModel extends Equatable {
  final String code;
  final String value;

  const LanguageModel({required this.code, required this.value});

  @override
  List<Object?> get props => [code];
}
