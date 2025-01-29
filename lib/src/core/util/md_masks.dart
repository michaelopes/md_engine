import 'package:easy_mask/easy_mask.dart';

import 'md_toolkit.dart';

class MdMasks {
  MdMasks._internal();
  static final MdMasks I = MdMasks._internal();

  TextInputMask get cellphone => TextInputMask(
        mask: '(99) 9 9999-9999',
      );

  TextInputMask get cep => TextInputMask(
        mask: '99.999-999',
      );

  TextInputMask get brDate => TextInputMask(
        mask: '99/99/9999',
      );

  TextInputMask get cpf => TextInputMask(
        mask: '999.999.999-99',
      );
  TextInputMask get cnpj => TextInputMask(
        mask: '99.999.999/9999-99',
      );

  TextInputMask get cardNumber => TextInputMask(
        mask: '9999 9999 9999 9999',
      );

  TextInputMask get cardNumberOfusqued => TextInputMask(
        mask: '9999 XXXX XXXX 9999',
      );

  TextInputMask get cardExpiringDate => TextInputMask(
        mask: '99/99',
      );

  TextInputMask get money => TextInputMask(
        mask: '9+.999,99',
        placeholder: '0',
        maxPlaceHolders: 3,
        reverse: true,
      );
}

extension TextInputMaskExt on TextInputMask {
  String maskText(String text, {bool ofuscate = false}) {
    final result = magicMask.getMaskedString(text);
    return ofuscate ? MdToolkit.I.ofuscateCPF(result) : result;
  }
}
