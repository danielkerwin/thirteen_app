import '../services/database.service.dart';

class UserData {
  final String uid;
  final String nickname;
  final bool isDarkMode;

  const UserData({
    required this.uid,
    required this.nickname,
    this.isDarkMode = false,
  });

  factory UserData.fromFirestore(DocSnapshot doc) {
    Map<String, dynamic> data = doc.data() ?? {};
    return UserData(
      uid: doc.id,
      nickname: data['nickname'] ?? '',
      isDarkMode: data['isDarkMode'] ?? false,
    );
  }
}
