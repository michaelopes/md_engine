import '../util/md_toolkit.dart';
import 'md_cnpj_validator.dart';
import 'md_cpf_validator.dart';

class MdValidator {
  static bool email(String email) {
    return RegExp(
                r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email) &&
        !blockEmoji().hasMatch(email);
  }

  static bool isValidCPF(String document) =>
      document.isEmpty ? true : MdCPFValidator.isValid(document);

  static bool isValidCNPJ(String document) =>
      document.isEmpty ? true : MdCNPJValidator.isValid(document);

  static bool isValidPassword(String? password) =>
      (password == null || password.isEmpty)
          ? true
          : password.trim().length >= 6;

  static bool isValidPasswordRange(String? password) =>
      (password ?? "").trim().length >= 6 &&
      (password ?? "").trim().length <= 20;

  /*static bool isStrongPassword(String password) => RegExp(
          r"^(?=.*[A-Za-z])(?=.*\d)[a-zA-Z0-9 £¢¬¹²³ßáàâãäéèêëíïóôõöúçñüÁÀÂÃÄÉÈÊËÍÏÓÒÖÚÇÑÜ´_<>:;,.!@#$%^&*\+\-\(\)\\\/\{\}\[\]]{6,20}$")
      .hasMatch(password.toString());*/

  static bool isStrongPassword(String password) =>
      password.length >= 8 &&
      containSpetialChars(password) &&
      containUppercaseLetter(password) &&
      containLowercaseLetter(password);

  static bool isAlfanumeric(String text) {
    return RegExp(r"^[a-zA-Z0-9À-ÖØ-öø-ÿ&\- ]*$").hasMatch(text);
  }

  static bool isVerificationCode(String text) {
    return text.length == 8 && isAlfanumeric(text);
  }

  static bool isName(String text) {
    if (text.isEmpty) {
      return true;
    }
    var splited = text.trim().split(" ");
    if (splited.length == 1) return false;
    return RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ&\- ]*$").hasMatch(text);
  }

  static bool containSpetialChars(String text) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
  }

  static bool containUppercaseLetter(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  static bool containLowercaseLetter(String text) {
    return RegExp(r'[a-z]').hasMatch(text);
  }

  static bool containNumber(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  static bool isFacebook(String text) {
    if (text.isEmpty) return true;
    return RegExp(r'^(https?://)?(www\.)?facebook\.com/.*$')
        .hasMatch(text.toLowerCase());
  }

  static bool isYoutube(String text) {
    if (text.isEmpty) return true;
    return RegExp(r'^(https?://)?(www\.)?youtube\.com/.*$')
        .hasMatch(text.toLowerCase());
  }

  static bool isDribbble(String text) {
    if (text.isEmpty) return true;
    return RegExp(r'^(https?://)?(www\.)?dribbble\.com/.*$')
        .hasMatch(text.toLowerCase());
  }

  static bool isInstagram(String text) {
    if (text.isEmpty) return true;
    return RegExp(r'^(https?://)?(www\.)?instagram\.com/.*$|(@[a-z]*)')
        .hasMatch(text.toLowerCase());
  }

  static bool isLinkedin(String text) {
    if (text.isEmpty) return true;
    return RegExp(r'^(https?://)?(www\.)?linkedin\.com/.*$')
        .hasMatch(text.toLowerCase());
  }

  static bool isGithub(String text) {
    if (text.isEmpty) return true;
    return RegExp(r'^(https?://)?(www\.)?github\.com/.*$')
        .hasMatch(text.toLowerCase());
  }

  static bool isPhone(String text) {
    var phone = MdToolkit.I.removeSpecialCharacters(text);
    return phone.length == 11 || phone.length == 10;
  }

  static bool isCellPhone(String text) {
    var phone = MdToolkit.I.removeSpecialCharacters(text).replaceAll(" ", "");
    if (phone.isEmpty) {
      return true;
    }
    return phone.length == 11;
  }

  static RegExp blockEmoji() {
    return RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  }

  static bool isValidCardCVV(String value) {
    if ((value.length == 3 || value.length == 4)) {
      return true;
    }
    return false;
  }

  static bool isValidCreditCardNumber(String input) {
    if (input.isEmpty) {
      return false;
    }
    input = input.replaceAll(" ", "");

    if (input.length < 8 || input.length > 16) {
      // No need to even proceed with the validation if it's less than 8
      return false;
    }

    var sum = 0;
    var length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      var digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return true;
    }
    return false;
  }

  static bool isDateValid(String input) {
    try {
      var year = 0;
      var month = 0;
      var day = 0;

      if (input.contains("-")) {
        var dateParts = input.split('-');
        if (dateParts.length != 3) {
          return false;
        }
        year = int.parse(dateParts[0]);
        month = int.parse(dateParts[1]);
        day = int.parse(dateParts[2]);
      } else if (input.contains("/")) {
        var dateParts = input.split('/');
        if (dateParts.length != 3) {
          return false;
        }
        year = int.parse(dateParts[2]);
        month = int.parse(dateParts[1]);
        day = int.parse(dateParts[0]);
      }

      if (year < 1900) {
        return false;
      }

      if (month < 1 || month > 12) {
        return false;
      }
      var lastDayOfMonth = DateTime(year, month + 1, 0).day;
      if (day < 1 || day > lastDayOfMonth) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isDateGreaterThanNow(String input) {
    try {
      var date = DateTime.parse(input);
      return date.millisecondsSinceEpoch >
          DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      return false;
    }
  }
}
