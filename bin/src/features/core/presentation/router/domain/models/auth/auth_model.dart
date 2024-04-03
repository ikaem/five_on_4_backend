import 'package:equatable/equatable.dart';

class AuthModel extends Equatable {
  const AuthModel({
    // TODO chnage this to id, not auth ID
    required this.authId,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });
  final int authId;
  final String email;
  final int createdAt;
  final int updatedAt;

  @override
  List<Object?> get props => [
        authId,
        email,
        createdAt,
        updatedAt,
      ];
}
