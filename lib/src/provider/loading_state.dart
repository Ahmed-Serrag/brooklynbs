import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ✅ Provider for Global Loading State
final loadingStateProvider = ChangeNotifierProvider((ref) => LoadingState());

class LoadingState extends ChangeNotifier {
  bool isLoading = false;

  void startLoader(BuildContext context) {
    if (!isLoading) {
      isLoading = true;
      context.loaderOverlay.show(); // ✅ Show loader overlay
      notifyListeners();
    }
  }

  void stopLoader(BuildContext context) {
    if (isLoading) {
      isLoading = false;
      context.loaderOverlay.hide(); // ✅ Hide loader overlay
      notifyListeners();
    }
  }
}
