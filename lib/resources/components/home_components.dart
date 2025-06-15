import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/model/allquiz_model.dart';
import 'package:mindmint/model/categories_model.dart';
import 'package:mindmint/resources/color.dart';
import 'package:mindmint/utils/routes/routes_name.dart';
import 'package:mindmint/view_model/categories_rows_provider.dart';
import 'package:mindmint/view_model/home_services_notifier.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuizCard extends StatelessWidget {
  final AllquizModel data;
  const QuizCard({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(
          context,
          RoutesName.questionScreen,
          arguments: {'quizUrl': data.quizUrl, 'title': data.title},
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: screenHeight * 0.15,
          width: screenWidth * 0.45,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.13,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage(data.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                "10 Questions",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableCard extends ConsumerStatefulWidget {
  const ExpandableCard({super.key});

  @override
  ConsumerState<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends ConsumerState<ExpandableCard>
    with TickerProviderStateMixin {
  bool hasInitialized = false;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(homeServicesProvider.notifier);
    notifier.initialAnimation(this);
    notifier.expandAnimation(this);
    notifier.fadeAnimation(this);
    notifier.slideAnimation();
  }

  @override
  void dispose() {
    ref.read(homeServicesProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(homeServicesProvider.notifier);
    final state = ref.watch(homeServicesProvider);
    final categoryAsync = ref.watch(categoryRowsProvider);

    ref.listen(homeServicesProvider, (previous, next) {
      if (previous?.isExpanded != next.isExpanded) {
        notifier.isExpanded();
      }
    });

    final isExpanded = state.isExpanded;

    return Center(
      child: FadeTransition(
        opacity: notifier.initialFade ?? const AlwaysStoppedAnimation(1.0),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: categoryAsync.when(
              data: (rows) {
                final totalItems = rows.length;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      totalItems < 2 ? totalItems : 2,
                      (index) => CategoryRow(data: rows[index]),
                    ),
                    if (isExpanded && totalItems > 2)
                      ...List.generate(totalItems - 2, (index) {
                        final actualIndex = index + 2;
                        return FadeTransition(
                          opacity:
                              notifier.fadeAnimate ??
                              const AlwaysStoppedAnimation(1.0),
                          child: SlideTransition(
                            position:
                                notifier.slideAnimate ??
                                const AlwaysStoppedAnimation(Offset.zero),
                            child: CategoryRow(data: rows[actualIndex]),
                          ),
                        );
                      }),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: notifier.toggleExpanded,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blueAccent,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: isExpanded ? 0.5 : 0.0,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final CategoryRowData data;

  const CategoryRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            Image.asset(
              data.image,
              height: 40,
              width: 40,
              errorBuilder:
                  (context, error, stackTrace) => Image.asset(
                    'assets/default_category.png',
                    height: 40,
                    width: 40,
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Questions: ${data.questions}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            CircularPercentIndicator(
              radius: 28,
              lineWidth: 5,
              progressColor: AppColors.sky,
              percent: (data.percentage / 100).clamp(0.0, 1.0),
              center: Text(
                "${data.percentage.toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 13, color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllQuizScreen extends ConsumerWidget {
  const AllQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeServicesProvider);
    final quizzes =
        state.filteredQuizCards.isNotEmpty
            ? state.filteredQuizCards
            : state.allQuizCards;

    if (quizzes.isEmpty) {
      return const Center(child: Text("No quizzes found."));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: quizzes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return QuizCard2(data: quizzes[index]);
        },
      ),
    );
  }
}

final kAlwaysCompleteAnimation = AlwaysStoppedAnimation<double>(1.0);

class QuizCard2 extends ConsumerWidget {
  final AllquizModel data;

  const QuizCard2({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final notifier = ref.read(homeServicesProvider.notifier);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesName.questionScreen,
          arguments: {'quizUrl': data.quizUrl, 'title': data.title},
        );
      },
      child: FadeTransition(
        opacity: notifier.initialFade ?? kAlwaysCompleteAnimation,
        child: Container(
          height: screenHeight * 0.2,
          width: screenWidth * 0.4,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(backgroundImage: AssetImage(data.image), radius: 28),
              const SizedBox(height: 10),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Questions: ${data.questions}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
