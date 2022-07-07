part of "user.dart";

class UsersService extends ChangeNotifier {
  final UserRepository _repository;
  Iterable<UserModel>? _cachedResults;
  bool _isDirty = false;

  UsersService(this._repository);

  Future<void> updateUser({
    required String userName,
    String? newUserName,
    String? newEmail,
    String? newPassword,
    int? newAccessLevel,
    String? newFirstName,
    String? newMiddleName,
    String? newLastName,
    String? newNameSuffix,
  }) async {
    await _repository.update(
      userName: userName,
      newLastName: newLastName,
      newMiddleName: newMiddleName,
      newNameSuffix: newNameSuffix,
      newPassword: newPassword,
      newFirstName: newFirstName,
      newEmail: newEmail,
      newUserName: newUserName,
      newAccessLevel: newAccessLevel,
    );
    notifyListeners();
  }

  Future<void> deleteUser(String userName) async {
    await _repository.deleteByUserName(userName);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _isDirty = true;
    super.notifyListeners();
  }

  Future<void> createUser({
    required String userName,
    required String email,
    required String password,
    int accessLevel = 0,
    required String firstName,
    String? middleName,
    required String lastName,
    String? nameSuffix,
  }) async {
    await _repository.save(
      userName: userName,
      password: password,
      lastName: lastName,
      firstName: firstName,
      email: email,
      middleName: middleName,
      accessLevel: accessLevel,
      nameSuffix: nameSuffix,
    );
    notifyListeners();
  }

  Future<Iterable<UserModel>> getAllUsers() async {
    if (_isDirty || _cachedResults == null) {
      _cachedResults = await _repository.getAll();
    }

    return _cachedResults!;
  }

  void invalidateCache() {
    _isDirty = true;
    notifyListeners();
  }
}
