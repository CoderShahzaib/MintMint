import 'package:flutter/material.dart';
import 'package:mindmint/core/services/notification_services.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/resources/components/home_components.dart';
import 'package:mindmint/resources/components/quiz_assistant_card.dart';
import 'package:mindmint/utils/routes/routes_name.dart';
import 'package:mindmint/view_model/home_services_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mindmint/model/notification_model.dart';
import 'package:mindmint/view_model/notification_state_notifer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    final homeServices = ref.read(homeServicesProvider.notifier);
    homeServices.bannerAnimation(this);
    homeServices.createBannerOpacity();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notificationServices.initialize();
      await notificationServices.requestPermission();
      final token = await notificationServices.getDeviceToken();
      notificationServices.firebaseInit();
      notificationServices.handleNotificationTap(context);
      notificationServices.markNotificationsAsSeen();
      print('Device Token: $token');
    });
  }

  @override
  void dispose() {
    ref.read(homeServicesProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unseenCount = ref.watch(notificationStateProvider);
    final state = ref.watch(homeServicesProvider);
    final notifier = ref.read(homeServicesProvider.notifier);
    final animation = notifier.bannerOpacity;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          "MindMint",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/logo.png'),
            radius: 30,
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable:
                Hive.box<NotificationModel>('notifications').listenable(),
            builder: (context, Box<NotificationModel> box, _) {
              final notifications = box.values.toList();
              int unseenCount = 0;
              return FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final lastSeen =
                        snapshot.data!.getInt('last_seen_notification') ?? 0;
                    unseenCount =
                        notifications
                            .where(
                              (n) => n.time.millisecondsSinceEpoch > lastSeen,
                            )
                            .length;
                  }

                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await notificationServices.markNotificationsAsSeen();
                          ref
                              .read(notificationStateProvider.notifier)
                              .updateUnseenCount(unseenCount);
                          Navigator.pushNamed(
                            context,
                            RoutesName.notificationScreen,
                          );
                        },
                        icon: const Icon(Icons.notifications, size: 28),
                      ),
                      if (unseenCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$unseenCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (animation != null)
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Opacity(opacity: animation.value, child: child);
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.selectCategoryScreen,
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.9,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage('assets/banner1.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quiz",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.allQuiz);
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              if (animation != null)
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Opacity(opacity: animation.value, child: child);
                  },
                  child: Hero(
                    tag: 'allquiz',
                    child: SizedBox(
                      height: screenHeight * 0.22,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 400),
                            tween: Tween(begin: 0.8, end: 1.0),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: QuizCard(
                                    data: state.allQuizCards[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress bar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.progressBarScreen,
                      );
                    },
                    child: Icon(Icons.arrow_forward, color: AppColors.black),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              ExpandableCard(),
              const SizedBox(height: 20),
              QuizAssistantCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
