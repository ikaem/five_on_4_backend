// import 'package:test/test.dart';

// import '../../../../../../../bin/src/features/core/domain/values/response_body_value.dart';

// void main() {
//   group("$ResponseBodyValue", () {
//     group(".toJson()", () {
//       test(
//         "given a ResponseBodyValue instance without data"
//         "when toJson() is called"
//         "then should return expected map",
//         () async {
//           // setup

//           // given
//           final responseBodyValue = ResponseBodyValue(
//             message: "message",
//             ok: false,
//           );

//           // when
//           final result = responseBodyValue.toJson();

//           // then
//           expect(
//             result,
//             equals({
//               "ok": false,
//               "message": "message",
//             }),
//           );

//           // cleanup
//         },
//       );

//       test(
//         "given a ResponseBodyValue instance with data"
//         "when toJson() is called"
//         "then should return expected map",
//         () async {
//           // setup

//           // given
//           final responseBodyValue = ResponseBodyValue(
//             message: "message",
//             ok: true,
//             data: {
//               "key": "value",
//             },
//           );

//           // when
//           final result = responseBodyValue.toJson();

//           // then
//           expect(
//             result,
//             equals({
//               "ok": true,
//               "message": "message",
//               "data": {
//                 "key": "value",
//               },
//             }),
//           );

//           // cleanup
//         },
//       );
//     });
//   });
// }
