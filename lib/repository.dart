import 'dart:math';

class EmailAlreadyExistsException implements Exception {
  @override
  String toString() => 'Email already exists';
}

class SumbitException implements Exception {
  @override
  String toString() => 'Sign up failure please try again later';
}

class Repository {
  Future<void> checkEmailAvailability(String email) async {
    if (email.isEmpty) return;

    await Future.delayed(const Duration(seconds: 1));
    if (email == 'joe@gmail.com') {
      throw EmailAlreadyExistsException();
    }
  }

  Future<void> submit() async {
    final random = Random();
    await Future.delayed(const Duration(seconds: 2));

    int randomInt = random.nextInt(5);

    if (randomInt == 2) {
      throw SumbitException();
    }
  }
}
