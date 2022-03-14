import 'package:bloc/bloc.dart';
import 'package:coffee_app/services/auth/auth_provider.dart';
import 'package:coffee_app/services/auth/bloc/auth_event.dart';
import 'package:coffee_app/services/auth/bloc/auth_state.dart';
import 'package:coffee_app/services/auth/cloud_user/auth_user_data_constants.dart';
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
        emit(const AuthStateRegistering(exception: null));
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
        final coupons = event.coupons;
        FirebaseUserCloudStorage _userDataStorage = FirebaseUserCloudStorage();

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
            userCoupons: coupons,
          );
          emit(const AuthStateNeedsVerification());
          await provider.sendEmailVerification();
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e));
        }
      },
    );

    //initialize
    on<AuthEventInitialize>(
      ((event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null));
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
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e));
        }
      }),
    );

    on<AuthEventLogOut>(
      ((event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e));
        }
      }),
    );

    on<AuthEventForgotPassword>(((event, emit) async {
      final email = event.email;

      if (email == null) {
        return;
      }
      bool didsendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didsendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didsendEmail = false;
        exception = e;
      }
      emit(
        AuthStateForgotPassword(
            exception: exception, hasSentEmail: didsendEmail),
      );
    }));
  }
}
