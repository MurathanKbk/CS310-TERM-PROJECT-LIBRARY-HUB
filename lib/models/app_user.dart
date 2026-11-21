class AppUser {
  const AppUser({
    required this.fullName,
    required this.email,
    required this.studentId,
    required this.phone,
  });

  final String fullName;
  final String email;
  final String studentId;
  final String phone;

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  AppUser copyWith({
    String? fullName,
    String? email,
    String? studentId,
    String? phone,
  }) {
    return AppUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
    );
  }
}
