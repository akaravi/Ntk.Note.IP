import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Politely prompts for store review after repeated dashboard use (S7-100).
class AppReviewService {
  AppReviewService({InAppReview? review}) : _review = review ?? InAppReview.instance;

  static const _visitKey = 'app.dashboard_visits';
  static const visitThreshold = 5;

  final InAppReview _review;

  Future<void> recordDashboardVisitAndMaybePrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final visits = (prefs.getInt(_visitKey) ?? 0) + 1;
    await prefs.setInt(_visitKey, visits);

    if (visits != visitThreshold) {
      return;
    }

    if (!await _review.isAvailable()) {
      return;
    }

    await _review.requestReview();
  }
}

final appReviewServiceProvider = AppReviewService();
