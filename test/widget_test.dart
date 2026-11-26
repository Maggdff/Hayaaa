import 'package:flutter_test/flutter_test.dart';
import 'package:hayaa_main/core/Utils/app_routes.dart';
import 'package:hayaa_main/features/splash/views/splash_view.dart';
import 'package:hayaa_main/features/home/views/home_view.dart';

void main() {
  test('Core application routes are registered', () {
    expect(appRoutes.containsKey(SplashView.id), isTrue);
    expect(appRoutes.containsKey(HomeView.id), isTrue);
    expect(appRoutes.isNotEmpty, isTrue);
  });
}
