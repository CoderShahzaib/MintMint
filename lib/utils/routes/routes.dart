import 'package:flutter/material.dart';
import 'package:mindmint/view/ai_tutor_screen.dart';
import 'package:mindmint/view/all_quiz.dart';
import 'package:mindmint/view/categories_screen.dart';
import 'package:mindmint/view/home_screen.dart';
import 'package:mindmint/view/notifications_screen.dart';
import 'package:mindmint/view/progress_bar.dart';
import 'package:mindmint/view/quiz_screen.dart';
import 'package:mindmint/view/splash_screen.dart';
import 'package:mindmint/utils/routes/routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return _defaultRoute(SplashScreen());
      case RoutesName.home:
        return _defaultRoute(HomeScreen());
      case RoutesName.allQuiz:
        return _slideFromRightRoute(AllQuiz());
      case RoutesName.progressBarScreen:
        return _slideFromRightRoute(ProgressbarScreen());
      case RoutesName.questionScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final String quizUrl = args['quizUrl'];
        final title = args['title'];
        return _slideFromRightRoute(
          QuizScreen(categoryUrl: quizUrl, categoryName: title),
        );
      case RoutesName.selectCategoryScreen:
        return _slideFromRightRoute(SelectCategoryScreen());
      case RoutesName.notificationScreen:
        return _slideFromRightRoute(NotificationScreen());
      case RoutesName.aiTutorialScreen:
        return _slideFromRightRoute(AiTutorScreen());
      default:
        return _defaultRoute(
          Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }

  static Route _defaultRoute(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }

  static Route _slideFromRightRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
