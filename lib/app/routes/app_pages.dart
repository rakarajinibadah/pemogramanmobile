import 'package:get/get.dart';

import '../modules/auth/login/bindings/auth_login_binding.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/auth/onboarding/bindings/auth_onboarding_binding.dart';
import '../modules/auth/onboarding/views/auth_onboarding_view.dart';
import '../modules/auth/register/bindings/auth_register_binding.dart';
import '../modules/auth/register/views/auth_register_view.dart';
import '../modules/main/gallery/detail/bindings/detail_binding.dart';
import '../modules/main/gallery/detail/views/detail_view.dart';
import '../modules/main/gallery/create/bindings/create_binding.dart';
import '../modules/main/gallery/create/views/create_view.dart';
import '../modules/main/gallery/edit/bindings/edit_binding.dart';
import '../modules/main/gallery/edit/views/edit_view.dart';
import '../modules/main/gallery/list/bindings/list_binding.dart';
import '../modules/main/gallery/list/views/list_view.dart';
import '../modules/main/gallery/show/bindings/show_binding.dart';
import '../modules/main/gallery/show/views/show_view.dart';
import '../modules/main/home/bindings/home_binding.dart';
import '../modules/main/home/views/home_view.dart';
import '../modules/main/layout/bindings/main_layout_binding.dart';
import '../modules/main/layout/views/main_layout_view.dart';
import '../modules/main/news/detail/bindings/main_news_detail_binding.dart';
import '../modules/main/news/detail/views/main_news_detail_view.dart';
import '../modules/main/news/main/bindings/main_news_main_binding.dart';
import '../modules/main/news/main/views/main_news_main_view.dart';
import '../modules/main/news/webview/bindings/main_news_webview_binding.dart';
import '../modules/main/news/webview/views/main_news_webview_view.dart';
import '../modules/onboarding/splash/bindings/onboarding_splash_binding.dart';
import '../modules/onboarding/splash/views/onboarding_splash_view.dart';
import '../modules/onboarding/welcome/bindings/onboarding_welcome_binding.dart';
import '../modules/onboarding/welcome/views/onboarding_welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING_SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const OnboardingSplashView(),
      binding: OnboardingSplashBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const OnboardingWelcomeView(),
      binding: OnboardingWelcomeBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_MAIN,
      page: () => const MainNewsMainView(),
      binding: MainNewsMainBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => const MainNewsDetailView(),
      binding: MainNewsDetailBinding(),
    ),
    GetPage(
      name: _Paths.NEWS_WEBVIEW,
      page: () => const MainNewsWebviewView(),
      binding: MainNewsWebviewBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT,
      page: () => const MainLayoutView(),
      binding: MainLayoutBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const AuthOnboardingView(),
      binding: AuthOnboardingBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const AuthRegisterView(),
      binding: AuthRegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const AuthLoginView(),
      binding: AuthLoginBinding(),
    ),
    GetPage(
      name: _Paths.CREATE,
      page: () => const CreateView(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: _Paths.LIST,
      page: () => const ListGalleriesView(),
      binding: ListBinding(),
    ),
    GetPage(
      name: _Paths.EDIT,
      page: () => const EditView(),
      binding: EditBinding(),
    ),
    GetPage(
      name: _Paths.SHOW,
      page: () => const ShowView(),
      binding: ShowBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL,
      page: () => const DetailView(),
      binding: DetailBinding(),
    ),
  ];
}
