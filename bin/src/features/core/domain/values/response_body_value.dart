// // TODO this needs testing

// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// class ResponseBodyValue extends Equatable {
//   ResponseBodyValue({
//     required this.message,
//     required this.ok,
//     this.data,
//   });

//   final String message;
//   final bool ok;
//   final Map<String, Object>? data;

//   Map<String, Object?> toJson() {
//     return {
//       "ok": ok,
//       "message": message,
//       if (data != null) "data": data,
//     };
//   }

//   @override
//   String toString() {
//     return jsonEncode(toJson());
//   }

//   @override
//   List<Object?> get props => [message, ok, data];
// }

// TODO delete this