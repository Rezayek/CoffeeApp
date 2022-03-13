import 'package:bloc/bloc.dart';
import 'package:coffee_app/services/auth/auth_provider.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';
import 'package:coffee_app/services/auth/cloud_user/firabase_user_cloud_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(AuthStateUnInitialized()) {
    //send verification

    on<AuthEventSendEmailVerification>(
      ((event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      }),
    );
    on<AuthEventShouldRegister>(
      ((event, emit) {
        emit(const AuthStateRegistering());
      }),
    );

    //register

    on<AuthEventRegister>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;
        final firstName = event.firstName;
        final secondName = event.secondName;
        final address = event.address;
        final phone = event.phone;
        FirebaseUserCloudStorage _userDataStorage = FirebaseUserCloudStorage();
        emit(const AuthStateNeedsVerification());
        try {
          final user =
              await provider.creatUser(email: email, password: password);

          await _userDataStorage.creatNewUserData(
            userId: user.id,
            userFirstName: firstName,
            userSecondName: secondName,
            userEmail: email,
            userPhone: phone,
            userAddress: address,
          );
          await provider.sendEmailVerification();
        } catch (e) {}
      },
    );

    //initialize
    on<AuthEventInitialize>(
      ((event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut());
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      }),
    );

    on<AuthEventLogIn>(
      ((event, emit) async {
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification());
          } else {
            //emit(const AuthStateLoggedOut());
            emit(AuthStateLoggedIn(user: user));
          }
        } catch (e) {}
      }),
    );

    on<AuthEventLogOut>(
      ((event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut());
        } catch (e) {}
      }),
    );
  }
}
