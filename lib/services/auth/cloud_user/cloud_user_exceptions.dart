class UserStorageException implements Exception {
  const UserStorageException();
}
class CouldNotUpdateUserDataEception implements Exception{}
class CouldNotFoundUserDataException extends UserStorageException{}
