import 'package:five_on_4_backend/src/features/core/utils/constants/reg_exp_constants.dart';

// TODO this needs testing too probably
mixin StringCheckerMixin {
  bool checkIsValidEmail(String email) {
    final emailRegExp = RegExp(
      RegExpConstants.EMAIL.value,
    );

    final isValid = emailRegExp.hasMatch(email);
    return isValid;
  }

  bool checkIfContainsLettersAndNumbers(String value) {
    final alphaNumericRegExp = RegExp(
      RegExpConstants.LETTERS_AND_NUMBERS.value,
    );

    final isValid = alphaNumericRegExp.hasMatch(value);
    return isValid;
  }
}
