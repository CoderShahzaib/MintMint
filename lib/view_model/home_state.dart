import 'package:mindmint/model/allquiz_model.dart';

class HomeState {
  final List<AllquizModel> allQuizCards;
  final List<AllquizModel> filteredQuizCards;
  final bool isExpanded;
  final bool isInitializing;
  final bool isSeaching;

  HomeState({
    required this.allQuizCards,
    this.filteredQuizCards = const [],
    this.isExpanded = false,
    this.isInitializing = true,
    this.isSeaching = false,
  });

  List<AllquizModel> get displayedQuizzes =>
      filteredQuizCards.isNotEmpty ? filteredQuizCards : allQuizCards;

  HomeState copyWith({
    List<AllquizModel>? allQuizCards,
    List<AllquizModel>? filteredQuizCards,
    bool? isExpanded,
    bool? isInitializing,
    bool? isSearching,
  }) {
    return HomeState(
      allQuizCards: allQuizCards ?? this.allQuizCards,
      filteredQuizCards: filteredQuizCards ?? this.filteredQuizCards,
      isExpanded: isExpanded ?? this.isExpanded,
      isInitializing: isInitializing ?? this.isInitializing,
      isSeaching: isSearching ?? isSeaching,
    );
  }
}
