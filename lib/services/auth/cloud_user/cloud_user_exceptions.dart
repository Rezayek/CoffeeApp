class UserStorageException implements Exception {
  const UserStorageException();
}

class CouldNotFoundUserDataException extends UserStorageException{}
