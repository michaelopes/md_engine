import 'package:flutter/material.dart';

import 'core/util/md_asset_icon.dart';

class MdPaymentIcons {
  MdPaymentIcons._();

  static final I = MdPaymentIcons._();

  MdAssetIcon get amex => MdAssetIcon(
        fileName: "cards/amex.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get aura => MdAssetIcon(
        fileName: "cards/aura.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.contain,
      );
  MdAssetIcon get chip => MdAssetIcon(
        fileName: "cards/chip.svg",
        package: true,
      );
  MdAssetIcon get diners => MdAssetIcon(
        fileName: "cards/diners.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get discover => MdAssetIcon(
        fileName: "cards/discover.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get elo => MdAssetIcon(
        fileName: "cards/elo.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get hipercard => MdAssetIcon(
        fileName: "cards/hipercard.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get jcb => MdAssetIcon(
        fileName: "cards/jcb.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get mastercard => MdAssetIcon(
        fileName: "cards/mastercard.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );

  MdAssetIcon get pix => MdAssetIcon(
        fileName: "cards/pix.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );
  MdAssetIcon get visa => MdAssetIcon(
        fileName: "cards/visa.svg",
        package: true,
        width: 48,
        height: 48,
        fit: BoxFit.fitWidth,
      );

  MdAssetIcon byName(String name) {
    return MdAssetIcon(
      fileName: "cards/$name.svg",
      package: true,
      width: 48,
      height: 48,
      fit: BoxFit.fitWidth,
    );
  }
}
