import 'package:coc/domain/entities/player.dart';

class AchievementStats {
  final int total;
  final int completed;
  final int totalStars;
  final int earnedStars;

  const AchievementStats({
    required this.total,
    required this.completed,
    required this.totalStars,
    required this.earnedStars,
  });

  double get completionRate => total == 0 ? 0 : completed / total;
}

bool isHomeVillage(String village) => village == 'home';

bool isBuilderVillage(String village) => !isHomeVillage(village);

List<Achievement> homeAchievements(List<Achievement> achievements) =>
    achievements.where((a) => isHomeVillage(a.village)).toList();

List<Achievement> builderAchievements(List<Achievement> achievements) =>
    achievements.where((a) => isBuilderVillage(a.village)).toList();

List<Achievement> sortAchievements(List<Achievement> achievements) {
  final list = [...achievements];
  list.sort((a, b) {
    final aDone = a.target > 0 && a.value >= a.target;
    final bDone = b.target > 0 && b.value >= b.target;
    if (aDone != bDone) return aDone ? -1 : 1;
    if (a.stars != b.stars) return b.stars.compareTo(a.stars);
    final aRatio = a.target == 0 ? 0.0 : a.value / a.target;
    final bRatio = b.target == 0 ? 0.0 : b.value / b.target;
    return bRatio.compareTo(aRatio);
  });
  return list;
}

AchievementStats achievementStats(List<Achievement> achievements) {
  var completed = 0;
  var totalStars = 0;
  var earnedStars = 0;

  for (final a in achievements) {
    totalStars += a.stars;
    if (a.target > 0 && a.value >= a.target) {
      completed++;
      earnedStars += a.stars;
    }
  }

  return AchievementStats(
    total: achievements.length,
    completed: completed,
    totalStars: totalStars,
    earnedStars: earnedStars,
  );
}
