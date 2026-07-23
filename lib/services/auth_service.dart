import 'package:coc/config/helpers/player_tag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email', 'profile'],
              // Web client ID from google-services.json (client_type 3).
              serverClientId:
                  '732642728426-9oprc6fh4ukvep1t4urb0l777jegp4ef.apps.googleusercontent.com',
            );

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseCode(e.code));
    }
  }

  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final trimmedName = name.trim();
      if (trimmedName.isNotEmpty) {
        await credential.user?.updateDisplayName(trimmedName);
        await credential.user?.reload();
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseCode(e.code));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      if (idToken == null && accessToken == null) {
        throw const AuthException(
          'Could not obtain Google credentials. Try again.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseCode(e.code));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  static String playerTagForStorage(String raw) {
    final route = playerTagForRoute(raw);
    return route.isEmpty ? '' : '#$route';
  }

  /// Tag without `#`, uppercase — used in routes and API paths.
  static String playerTagForRoute(String raw) {
    return normalizePlayerTag(raw);
  }

  static String _mapFirebaseCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication failed ($code).';
    }
  }
}
