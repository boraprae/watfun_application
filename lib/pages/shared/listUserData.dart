class UserData {
  final int id_user;
  final String username;
  final String email;
  final String password;
  final String payment_info;
  final String bio_text;
  final String profile_image_path;
  final String cover_profile_image_path;

  const UserData(
      {required this.id_user,
      required this.username,
      required this.email,
      required this.password,
      required this.payment_info,
      required this.bio_text,
      required this.profile_image_path,
      required this.cover_profile_image_path});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id_user: json['id_user'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      payment_info: json['payment_info'],
      bio_text: json['bio_text'],
      profile_image_path: json['profile_image_path'],
      cover_profile_image_path: json['cover_profile_image_path'],
    );
  }
}
