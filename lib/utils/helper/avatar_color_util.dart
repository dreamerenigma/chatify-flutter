import 'dart:ui';

class AvatarColorUtil {
  static const List<({Color background, Color icon})> colors = [
    (background: Color(0xFF4F6FAD), icon: Color(0xFFAEC4F2)),
    (background: Color(0xFF4D8A70), icon: Color(0xFFA8E0C5)),
    (background: Color(0xFFB56A4F), icon: Color(0xFFF2B9A2)),
    (background: Color(0xFF7956A8), icon: Color(0xFFD0B7F5)),
    (background: Color(0xFF43839A), icon: Color(0xFFA8DFED)),
    (background: Color(0xFFA8506A), icon: Color(0xFFF0B2C5)),
  ];

  static ({Color background, Color icon}) get(String userId) {
    return colors[userId.hashCode.abs() % colors.length];
  }
}
