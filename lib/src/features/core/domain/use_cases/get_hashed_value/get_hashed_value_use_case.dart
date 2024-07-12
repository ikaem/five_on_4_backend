import '../../../../../wrappers/libraries/crypt/crypt_wrapper.dart';

class GetHashedValueUseCase {
  GetHashedValueUseCase({
    required CryptWrapper cryptWrapper,
  }) : _cryptWrapper = cryptWrapper;

  final CryptWrapper _cryptWrapper;

  String call({
    required String value,
  }) {
    return _cryptWrapper.getHashedValue(value: value);
  }
}
