import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //dang ki acc
 Future<String> createAccountWithEmail(
    String email, String password, String name) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      await user.sendEmailVerification(); // Gửi email xác thực
      return 'Please check your email to verify your account';
    }
    return 'Unknown error';
  } on FirebaseAuthException catch (e) {
    return e.message.toString();
  }
}


    // Xác thực email trước khi lưu user vào Firestore
  Future<bool> checkEmailVerification(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Cập nhật trạng thái mới nhất
    user = FirebaseAuth.instance.currentUser;
    
    if (user != null && user.emailVerified) {
      // Nếu đã xác thực, lưu user vào Firestore
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "name": name ?? "No Name",
        "email": user.email,
        "createdAt": FieldValue.serverTimestamp(),
      });
      return true;
    }
    return false;
  }

// dang nhap
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'Login Successfull';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      //lấy cliend id cho web
      final GoogleSignIn googleSignIn = GoogleSignIn(
       
         scopes: ['email'],
      );
      // Bước 1: Hiển thị hộp thoại đăng nhập Google
      // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) return null; // Nếu user bấm hủy đăng nhập

      // Bước 2: Lấy thông tin xác thực từ Google
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Bước 3: Tạo credential từ Google token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Bước 4: Đăng nhập Firebase bằng credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Bước 5: Kiểm tra xem user đã có trong Firestore chưa
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Nếu user chưa tồn tại, thêm vào Firestore
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "uid": user.uid,
            "name": user.displayName ?? "No Name",
            "email": user.email,
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      return null;
    }
  }

// dang xuat
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      return snapshot.data() as Map<String, dynamic>?;
    }

    return null;
  }

  String getUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }
}
