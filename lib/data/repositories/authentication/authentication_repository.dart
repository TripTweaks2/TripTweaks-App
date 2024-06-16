import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tesis3/data/repositories/user/user_repository.dart';
import 'package:tesis3/features/Question/screens/Question.dart';
import 'package:tesis3/features/authentication/screens/Login/LogIn.dart';
import 'package:tesis3/features/authentication/screens/OnBoarding/OnBoarding.dart';
import 'package:tesis3/features/authentication/screens/SignUp/verify_email.dart';
import 'package:tesis3/navigation_menu.dart';
import 'package:tesis3/utils/local_storage/storage_utility.dart';
import '../../../localization/GeolocationController.dart';
import '../../../localization/GeolocationDisabledContainer.dart';
import '../../../utils/exceptions/TFacebookAuthException.dart';
import '../../../utils/exceptions/TFirebaseAuthException.dart';
import '../../../utils/exceptions/TFirebaseException.dart';
import '../../../utils/exceptions/TFormatException.dart';
import '../../../utils/exceptions/TPlatformException.dart';

class AuthenticationRepository extends GetxController
{
  static AuthenticationRepository get instance =>Get.find();

  final deviceStorage=GetStorage();
  final _auth=FirebaseAuth.instance;

  User? get authUser=> _auth.currentUser;

  @override
  void onReady()
  {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async{
    final user = _auth.currentUser;
    final GeolocationController geolocationController = Get.find<GeolocationController>();

    if(user!=null){
      if(user.emailVerified){
        await LocalStorage.init(user.uid);
        if (!geolocationController.isGeolocationEnabled.value) {
          Get.to(() => GeolocationDisabledContainer());
        }
        else {
          Get.offAll(() => const OnboardingScreen(showBackArrow: false));
        }
      } else {
        Get.offAll(() => VerifyEmail(email: _auth.currentUser?.email));
      }
    } else{
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ?  Get.offAll(()=>const LoginScreen())
          :Get.offAll(const OnBoardingScreen());
    }
  }

  /*EMAIL & PASSWORD SIGN IN*/


  ///Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async{
    try{
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }

  }


  ///Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async{
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }

  }


  Future<void> sendEmailVerification() async{
    try{
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

  ///FORGET PASSWORD
  Future<void> sendPasswordResendEmail(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async{
    try{
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }



  //AUTENTICACION GOOGLE
  Future<UserCredential> signInWithGoogle() async{
    try{
      final GoogleSignInAccount? userAccount=await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth=await userAccount?.authentication;
      final credentials=GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);
      print("Facebook login status: ${loginResult.status}");

      // Create a credential from the access token
      final AccessToken accessToken = loginResult.accessToken!;
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    }  on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo salió mal. Intentar más tarde';
    }
  }



  Future<void> logout() async{
    try{
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(()=>const LoginScreen());
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }

  }


  Future<void> deleteAccount() async{
    try{
      await UserRepository.instance.removeUser(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_){
      throw const TFormatException();
    } on PlatformException catch(e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }

  }

}