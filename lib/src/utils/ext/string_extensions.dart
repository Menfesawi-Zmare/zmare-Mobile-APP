extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regExp = RegExp(pattern);
        return regExp.hasMatch(this);
  }

  bool get isNotNull {
    // ignore: unnecessary_null_comparison
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

String location(String country, String city) {
  if (country.isNotEmpty && city.isNotEmpty) {
    return '$city, $country';
  } else if (country.isNotEmpty) {
    return country;
  } else if (city.isNotEmpty) {
    return city;
  } else {
    return '';
  }
}

String realName(String? username, dynamic first, dynamic last) {
  if (first != '' && last != '') {
    return '$first $last';
  } else if (first != '') {
    return first;
  } else if (last != '') {
    return last;
  } else {
    return username!;
  }
}
