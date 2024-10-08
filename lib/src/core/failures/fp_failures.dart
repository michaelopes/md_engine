import 'generic_failures.dart';

class DeviceNotRegistredFailure extends Failure {
  DeviceNotRegistredFailure({String message = ""}) : super(message);
}

class InvalidDeviceRegisterCodeFailure extends Failure {
  InvalidDeviceRegisterCodeFailure({String message = ""}) : super(message);
}

class EmailAlreadyRegisteredFailure extends Failure {
  EmailAlreadyRegisteredFailure({String message = ""}) : super(message);
}

class DocumentAlreadyRegisteredFailure extends Failure {
  DocumentAlreadyRegisteredFailure({String message = ""}) : super(message);
}

class CellphoneAlreadyRegisteredFailure extends Failure {
  CellphoneAlreadyRegisteredFailure({String message = ""}) : super(message);
}

class NoAddressForZipCodeFailure extends Failure {
  NoAddressForZipCodeFailure({String message = ""}) : super(message);
}

class FaceNotMatchFailure extends Failure {
  FaceNotMatchFailure({String message = ""}) : super(message);
}

class NotValidPasswordOnVerify extends Failure {
  NotValidPasswordOnVerify({String message = ""}) : super(message);
}

class PaymentFailure extends Failure {
  PaymentFailure({String message = ""}) : super(message);
}

class UserToTransferTicketNotFound extends Failure {
  UserToTransferTicketNotFound({String message = ""}) : super(message);
}
