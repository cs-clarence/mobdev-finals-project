part of "./user.dart";

abstract class UserRepository {
  Future<UserModel?> findByEmailOrUserName(String userNameOrEmail);

  Future<UserModel?> findByEmail(String email);

  Future<UserModel?> findByUserName(String userName);

  Future<void> save({
    required String userName,
    required String email,
    required String password,
    int accessLevel = 0,
    required String firstName,
    String? middleName,
    required String lastName,
    String? nameSuffix,
  });

  Future<void> update({
    required String userName,
    String? newUserName,
    String? newEmail,
    String? newPassword,
    int? newAccessLevel,
    String? newFirstName,
    String? newMiddleName,
    String? newLastName,
    String? newNameSuffix,
  });

  Future<void> deleteByUserName(String userName);

  Future<Iterable<UserModel>> getAll();
}

abstract class UserRepositoryException implements Exception {
  final String message;

  UserRepositoryException(this.message);
}

class UserNameAlreadyTakenException extends UserRepositoryException {
  UserNameAlreadyTakenException(String userName)
      : super("User name $userName is already taken");
}

class UserNameDoesNotExistException extends UserRepositoryException {
  UserNameDoesNotExistException(String userName)
      : super("User name $userName is already taken");
}

class UserEmailAlreadyTakenException extends UserRepositoryException {
  UserEmailAlreadyTakenException(String email)
      : super("Email $email is already taken");
}

class SqliteUserRepository extends UserRepository {
  final Database database;

  SqliteUserRepository(this.database);

  @override
  Future<UserModel?> findByEmailOrUserName(String userNameOrEmail) async {
    final user = await findByEmail(userNameOrEmail);
    if (user != null) {
      return user;
    }

    return await findByUserName(userNameOrEmail);
  }

  @override
  Future<void> save({
    required String userName,
    required String email,
    required String password,
    int accessLevel = 0,
    required String firstName,
    String? middleName,
    required String lastName,
    String? nameSuffix,
  }) async {
    var user = await findByUserName(userName);
    if (user != null) {
      throw UserNameAlreadyTakenException(user.account.userName);
    }
    user = await findByEmail(email);
    if (user != null) {
      throw UserEmailAlreadyTakenException(user.account.email);
    }
    await database.transaction((txn) async {
      final accountId = await txn.insert("Accounts", {
        "userName": userName,
        "email": email,
        "password": password,
        "accessLevel": accessLevel,
      });

      await txn.insert("Profiles", {
        "accountId": accountId,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "nameSuffix": nameSuffix,
      });
    });
  }

  @override
  Future<void> update({
    required String userName,
    String? newUserName,
    String? newEmail,
    String? newPassword,
    String? newFirstName,
    int? newAccessLevel,
    String? newMiddleName,
    String? newLastName,
    String? newNameSuffix,
  }) async {
    final Map<String, Object?> accountUpdate = {};
    final Map<String, Object?> profileUpdate = {};

    final originalUser = await findByUserName(userName);
    final String email;

    if (originalUser == null) {
      throw UserNameDoesNotExistException(userName);
    }

    final accountIdResult = await database.query(
      "Accounts",
      columns: ["id"],
      distinct: true,
      limit: 1,
      where: "userName = ?",
      whereArgs: [userName],
    );

    final accountId = accountIdResult.first["id"] as int;

    email = originalUser.account.email;

    if (newUserName != null && newUserName != userName) {
      final user = await findByUserName(newUserName);
      if (user != null) {
        throw UserNameAlreadyTakenException(user.account.userName);
      }
      accountUpdate["userName"] = newUserName;
    }

    if (newEmail != null && newEmail != email) {
      final user = await findByEmail(newEmail);
      if (user != null) {
        throw UserEmailAlreadyTakenException(user.account.email);
      }
      accountUpdate["email"] = newEmail;
    }

    if (newPassword != null) {
      accountUpdate["password"] = newPassword;
    }

    if (newAccessLevel != null) {
      accountUpdate["accessLevel"] = newAccessLevel;
    }

    profileUpdate["nameSuffix"] = newNameSuffix;

    profileUpdate["middleName"] = newMiddleName;

    if (newFirstName != null) {
      profileUpdate["firstName"] = newFirstName;
    }

    if (newFirstName != null) {
      profileUpdate["lastName"] = newLastName;
    }

    database.transaction((txn) async {
      final batch = txn.batch();

      txn.update(
        "Profiles",
        profileUpdate,
        where: "accountId = ?",
        whereArgs: [accountId],
      );

      txn.update(
        "Accounts",
        accountUpdate,
        where: "userName = ?",
        whereArgs: [userName],
      );

      await batch.commit();
    });
  }

  @override
  Future<UserModel?> findByEmail(String email) async {
    final userResults = await database.rawQuery(
      //language=sqlite
      """
      SELECT DISTINCT * 
        FROM Accounts AS a 
        INNER JOIN Profiles AS p 
          ON a.id = p.accountId 
      WHERE a.email = ?;
      """,
      [email],
    );

    if (userResults.isEmpty) {
      return null;
    }

    final userData = userResults.first;

    final account = AccountModel.fromJson(userData);

    final profile = ProfileModel.fromJson(userData);

    return UserModel(account: account, profile: profile);
  }

  @override
  Future<UserModel?> findByUserName(String userName) async {
    final userResults = await database.rawQuery(
      //language=sqlite
      """
      SELECT DISTINCT * 
        FROM Accounts AS a 
        INNER JOIN Profiles AS p 
          ON a.id = p.accountId 
      WHERE a.userName = ?;
      """,
      [userName],
    );

    if (userResults.isEmpty) {
      return null;
    }

    final userData = userResults.first;

    final account = AccountModel.fromJson(userData);

    final profile = ProfileModel.fromJson(userData);

    return UserModel(account: account, profile: profile);
  }

  @override
  Future<void> deleteByUserName(String userName) async {
    await database.delete(
      "Accounts",
      where: "userName = ?",
      whereArgs: [userName],
    );
  }

  @override
  Future<Iterable<UserModel>> getAll() async {
    final userResults = await database.rawQuery(
        //language=sqlite
        """
      SELECT *
        FROM Accounts AS a 
        INNER JOIN Profiles AS p 
          ON a.id = p.accountId;
      """);

    return userResults.map((e) => UserModel(
        account: AccountModel.fromJson(e), profile: ProfileModel.fromJson(e)));
  }
}
