import 'package:equatable/equatable.dart';

// TODO what is this used for even?
class AuthModel extends Equatable {
  const AuthModel({
    // TODO chnage this to id, not auth ID
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });
  final int id;
  final String email;
  // TODO not sure why i needed these two
  final int createdAt;
  final int updatedAt;

  @override
  List<Object?> get props => [
        id,
        email,
        createdAt,
        updatedAt,
      ];
}
