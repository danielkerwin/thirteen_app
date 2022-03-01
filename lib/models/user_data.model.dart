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

  factory UserData.fromEmpty([bool isDarkMode = false]) {
    return UserData(nickname: '', uid: '', isDarkMode: isDarkMode);
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
