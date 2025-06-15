import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/model/allquiz_model.dart';
import 'package:mindmint/resources/components/app_urls.dart';
import 'home_state.dart';

final allQuizProvider = Provider<List<AllquizModel>>((ref) {
  return [
    AllquizModel(
      title: "General Knowledge",
      image: 'assets/general_knowledge.png',
      questions: 10,
      quizUrl: AppUrls.genralKnowledge,
    ),
    AllquizModel(
      title: "Politics",
      image: 'assets/politics.png',
      questions: 10,
      quizUrl: AppUrls.politics,
    ),
    AllquizModel(
      title: "Maths",
      image: 'assets/maths.png',
      questions: 10,
      quizUrl: AppUrls.maths,
    ),
    AllquizModel(
      title: "Sports",
      image: 'assets/sports.png',
      questions: 10,
      quizUrl: AppUrls.sports,
    ),
    AllquizModel(
      title: "History",
      image: 'assets/history.png',
      questions: 10,
      quizUrl: AppUrls.history,
    ),
    AllquizModel(
      title: "Geography",
      image: 'assets/geography.png',
      questions: 10,
      quizUrl: AppUrls.geography,
    ),
    AllquizModel(
      title: "Vehicles",
      image: 'assets/vehicles.png',
      questions: 10,
      quizUrl: AppUrls.vehicles,
    ),
    AllquizModel(
      title: "Anime",
      image: 'assets/anime.png',
      questions: 10,
      quizUrl: AppUrls.anime,
    ),
    AllquizModel(
      title: "Music",
      image: 'assets/music.png',
      questions: 10,
      quizUrl: AppUrls.music,
    ),
    AllquizModel(
      title: "Animals",
      image: 'assets/animals.png',
      questions: 10,
      quizUrl: AppUrls.animals,
    ),
    AllquizModel(
      title: "Computers",
      image: 'assets/computer.png',
      questions: 10,
      quizUrl: AppUrls.computers,
    ),
  ];
});

class HomeServicesNotifier extends StateNotifier<HomeState> {
  HomeServicesNotifier(List<AllquizModel> allQuiz)
    : super(HomeState(allQuizCards: allQuiz));

  TickerProvider? _vsync;

  AnimationController? _bannerAnimation;
  Animation<double>? _bannerOpacity;

  AnimationController? _expandAnimationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  AnimationController? _initialFadeController;
  Animation<double>? _initialFadeAnimation;

  Animation<double>? get fadeAnimate => _fadeAnimation;
  Animation<Offset>? get slideAnimate => _slideAnimation;
  Animation<double>? get initialFade => _initialFadeAnimation;
  AnimationController? get expandAnimate => _expandAnimationController;

  Animation<double>? get bannerOpacity => _bannerOpacity;

  void filterItems(String query) {
    final filtered =
        state.allQuizCards
            .where(
              (item) => item.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    state = state.copyWith(filteredQuizCards: filtered);
  }

  void bannerAnimation(TickerProvider vsync) {
    _vsync = vsync;
    if (_bannerAnimation != null) return;

    _bannerAnimation = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );
  }

  void createBannerOpacity() {
    if (_bannerAnimation == null || _bannerOpacity != null) return;

    _bannerOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _bannerAnimation!, curve: Curves.easeIn));

    _bannerAnimation!.forward();
  }

  void initialAnimation(TickerProvider vsync) {
    if (_initialFadeController != null) return;

    _initialFadeController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
    _initialFadeAnimation = CurvedAnimation(
      parent: _initialFadeController!,
      curve: Curves.easeIn,
    );
    _initialFadeController!.forward();
  }

  void expandAnimation(TickerProvider vsync) {
    if (_expandAnimationController != null) return;

    _expandAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );
  }

  void fadeAnimation(TickerProvider vsync) {
    if (_expandAnimationController == null) {
      expandAnimation(vsync);
    }

    _fadeAnimation = CurvedAnimation(
      parent: _expandAnimationController!,
      curve: Curves.easeIn,
    );
  }

  void slideAnimation() {
    if (_expandAnimationController == null) return;

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _expandAnimationController!,
        curve: Curves.easeInOut,
      ),
    );
  }

  void isExpanded() {
    final bool isExpanded = state.isExpanded;
    if (_expandAnimationController == null) return;

    if (isExpanded) {
      _expandAnimationController!.forward();
    } else {
      _expandAnimationController!.reverse();
    }
  }

  void setIsSearching(bool isSearching) {
    state = state.copyWith(isSearching: isSearching);
  }

  @override
  void dispose() {
    _bannerAnimation?.dispose();
    _initialFadeController?.dispose();
    _expandAnimationController?.dispose();
    super.dispose();
  }

  void toggleExpanded() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  void toggleInitializing() {
    state = state.copyWith(isInitializing: !state.isInitializing);
  }
}

final homeServicesProvider =
    StateNotifierProvider<HomeServicesNotifier, HomeState>((ref) {
      final allQuiz = ref.watch(allQuizProvider);
      return HomeServicesNotifier(allQuiz);
    });
