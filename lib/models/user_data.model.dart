import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String nickname;
  final bool isDarkMode;

  const UserData({
    required this.uid,
    required this.nickname,
    this.isDarkMode = false,
  });

  factory UserData.fromEmpty() {
    return const UserData(nickname: '', uid: '', isDarkMode: false);
  }

  factory UserData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return UserData(
      uid: doc.id,
      nickname: data['nickname'] ?? '',
      isDarkMode: data['isDarkMode'] ?? false,
    );
  }
}
