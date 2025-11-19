import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure({required this.message});
  @override
  List<Object?> get props => [];
}

class NetWorkFailure extends Failure {
  final String message;
  NetWorkFailure({required this.message});
  @override
  List<Object?> get props => [];
}
