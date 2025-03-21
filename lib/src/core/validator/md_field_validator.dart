import 'package:flutter/material.dart';
import '../i18n/app_translate.dart';
import '../util/md_toolkit.dart';
import 'md_card_expiring_date_validator.dart';
import 'md_cnpj_validator.dart';
import 'md_cpf_validator.dart';
import 'md_validator.dart';

enum MdValidateTypes {
  required,
  email,
  min,
  max,
  strongPassword,
  password,
  passwordRange,
  passwordEquals,
  emailEquals,
  cpf,
  cnpj,
  cpfOrCnpj,
  number,
  alfanumeric,
  maxAge,
  minAge,
  name,
  phone,
  cellphone,
  verificationCode,
  cardNumber,
  cardExpiringDate,
  cardCVV,
  cep,
  facebook,
  instagram,
  linkedin,
  youtube,
  dribbble,
  github,
  date,
  dateGreaterThanNow,
  hex32,
}

class MdValidateRule {
  final MdValidateTypes validateTypes;
  final dynamic value;

  MdValidateRule(this.validateTypes, {this.value});
}

class MdFieldValidator {
  final List<MdValidateRule> validations;
  final BuildContext context;

  MdFieldValidator(this.validations, this.context);

  String? validate(dynamic value) {
    String? result;

    for (var i = 0; i < validations.length; i++) {
      var validateRule = validations.elementAt(i);

      var key = validateRule.validateTypes;
      var valueRule = validateRule.value;

      switch (key) {
        case MdValidateTypes.required:
          {
            if (value == null || value.toString().trim().isEmpty) {
              result = AppTranslate.tr("validador.required_field", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.strongPassword:
          {
            var isStrong = MdValidator.isStrongPassword(value);
            if (!isStrong) {
              result = AppTranslate.tr("validador.strong_password", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.password:
          {
            var isStrong = MdValidator.isValidPassword(value);
            if (!isStrong) {
              result = result =
                  AppTranslate.tr("validador.invalid_min_string", context)
                      .replaceAll("{{p1}}", '6');
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.passwordRange:
          {
            var isStrong = MdValidator.isValidPasswordRange(value);
            if (!isStrong) {
              result = result =
                  AppTranslate.tr("validador.invalid_password_range", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.alfanumeric:
          {
            var isStrong = MdValidator.isAlfanumeric(value);
            if (!isStrong) {
              result = result =
                  AppTranslate.tr("validador.invalid_alphanumeric", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.verificationCode:
          {
            var isStrong = MdValidator.isVerificationCode(value);
            if (!isStrong) {
              result = result =
                  AppTranslate.tr("validador.verification_code", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.name:
          {
            var isStrong = MdValidator.isName(value.trim());
            if (!isStrong) {
              result =
                  result = AppTranslate.tr("validador.invalid_name", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.phone:
          {
            var isStrong = MdValidator.isPhone(value);
            if (!isStrong) {
              result =
                  result = AppTranslate.tr("validador.invalid_phone", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.cellphone:
          {
            var isStrong = MdValidator.isCellPhone(
                MdToolkit.I.removeSpecialCharacters(value));
            if (!isStrong) {
              result =
                  result = AppTranslate.tr("validador.invalid_phone", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.passwordEquals:
          {
            var pass = value.toString();
            var confirm = valueRule.toString();

            var isStrong = pass == confirm;
            if (!isStrong) {
              result =
                  result = AppTranslate.tr("validador.password_diff", context);
            } else {
              result = null;
            }
            break;
          }

        case MdValidateTypes.emailEquals:
          {
            var pass = value.toString();
            var confirm = valueRule.toString();

            var isStrong = pass == confirm;
            if (!isStrong) {
              result =
                  result = AppTranslate.tr("validador.email_diff", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.email:
          {
            if (value.trim().isEmpty) {
              return null;
            }
            var emailValid = MdValidator.email(value.trim().toString());
            if (!emailValid) {
              result = AppTranslate.tr("validador.invalid_email", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.cpf:
          {
            if (!MdCPFValidator.isValid(value.toString())) {
              result = AppTranslate.tr("validador.invalid_cpf", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.cnpj:
          {
            if (!MdCNPJValidator.isValid(value.toString())) {
              result = AppTranslate.tr("validador.invalid_cnpj", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.cpfOrCnpj:
          {
            var text = MdToolkit.I.removeSpecialCharacters(value.toString());
            if (text.length == 11) {
              if (!MdCPFValidator.isValid(value.toString())) {
                result = AppTranslate.tr("validador.invalid_cpf", context);
              } else {
                result = null;
              }
            } else {
              if (!MdCNPJValidator.isValid(value.toString())) {
                result = AppTranslate.tr("validador.invalid_cnpj", context);
              } else {
                result = null;
              }
            }
            break;
          }
        case MdValidateTypes.cardNumber:
          {
            if (!MdValidator.isValidCreditCardNumber(value.toString())) {
              result =
                  AppTranslate.tr("validador.invalid_card_number", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.cardCVV:
          {
            if (!MdValidator.isValidCardCVV(value.toString())) {
              result = AppTranslate.tr("validador.invalid_card_cvv", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.cardExpiringDate:
          {
            if (!MdCardExpiringDateValidator.isValid(value.toString())) {
              result = AppTranslate.tr(
                  "validador.invalid_card_expiring_date", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.max:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value > valueRule) {
                result =
                    AppTranslate.tr("validador.invalid_max_number", context)
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length > valueRule) {
                result =
                    AppTranslate.tr("validador.invalid_max_string", context)
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else {
              result = AppTranslate.tr("validador.invalid_max_string", context)
                  .replaceAll("{{p1}}", valueRule.toString());
            }
            break;
          }
        case MdValidateTypes.maxAge:
          {
            if (value.contains("/")) {
              value = MdToolkit.I.brDatetime2IsoDatetime(value);
            }
            var date = DateTime.tryParse(value);
            var val = date != null
                ? (DateTime.now().difference(date).inDays / 365).floor()
                : int.tryParse(value) ?? 0;

            if (val >= valueRule) {
              result = AppTranslate.tr("validador.max_age", context)
                  .replaceAll("{{p1}}", valueRule.toString());
            } else {
              result = null;
            }

            break;
          }
        case MdValidateTypes.minAge:
          {
            if (value.contains("/")) {
              value = MdToolkit.I.brDatetime2IsoDatetime(value);
            }
            var date = DateTime.tryParse(value);
            var val = date != null
                ? (DateTime.now().difference(date).inDays / 365).floor()
                : int.tryParse(value) ?? 0;
            if (valueRule >= val) {
              result = AppTranslate.tr("validador.min_age", context)
                  .replaceAll("{{p1}}", valueRule.toString());
            } else {
              result = null;
            }

            break;
          }
        case MdValidateTypes.min:
          {
            if (value.runtimeType == int || value.runtimeType == double) {
              if (value < valueRule) {
                result =
                    AppTranslate.tr("validador.invalid_min_number", context)
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else if (value.runtimeType == String) {
              if (value.toString().length < valueRule) {
                result =
                    AppTranslate.tr("validador.invalid_min_string", context)
                        .replaceAll("{{p1}}", valueRule.toString());
              } else {
                result = null;
              }
            } else {
              result = AppTranslate.tr("validador.invalid_min_string", context)
                  .replaceAll("{{p1}}", valueRule.toString());
            }
            break;
          }
        case MdValidateTypes.cep:
          {
            if (value.toString().isEmpty) return null;
            if (value.length != 10) {
              result = AppTranslate.tr("validador.invalid_cep", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.facebook:
          {
            if (!MdValidator.isFacebook(value)) {
              result =
                  AppTranslate.tr("validador.invalid_facebook_url", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.instagram:
          {
            if (!MdValidator.isInstagram(value)) {
              result =
                  AppTranslate.tr("validador.invalid_instagram_url", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.linkedin:
          {
            if (!MdValidator.isLinkedin(value)) {
              result =
                  AppTranslate.tr("validador.invalid_linkedin_url", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.youtube:
          {
            if (!MdValidator.isYoutube(value)) {
              result =
                  AppTranslate.tr("validador.invalid_youtube_url", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.dribbble:
          {
            if (!MdValidator.isDribbble(value)) {
              result =
                  AppTranslate.tr("validador.invalid_dribbble_url", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.github:
          {
            if (!MdValidator.isGithub(value)) {
              result = AppTranslate.tr("validador.invalid_github_url", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.date:
          {
            if (value == null || value == "") {
              result = null;
            } else {
              if (!MdValidator.isDateValid(value)) {
                result = AppTranslate.tr("validador.invalid_date", context);
              } else {
                result = null;
              }
            }
            break;
          }
        case MdValidateTypes.dateGreaterThanNow:
          {
            if (!MdValidator.isDateGreaterThanNow(value)) {
              result = AppTranslate.tr(
                  "validador.invalid_date_greater_than_now", context);
            } else {
              result = null;
            }
            break;
          }
        case MdValidateTypes.hex32:
          {
            if (!MdValidator.isHex32Valid(value)) {
              result = AppTranslate.tr("validador.invalid_hex_32", context);
            } else {
              result = null;
            }
            break;
          }
        default:
          {
            result = null;
            break;
          }
      }
      if (result != null && result != "") {
        break;
      }
    }

    return result;
  }
}
