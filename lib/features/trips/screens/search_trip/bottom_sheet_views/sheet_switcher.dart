import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/enums/bottom_sheet_view.enum.dart';

class SheetSwitcher extends StatelessWidget {
  final BottomSheetView currentView;
  final ScrollController scrollController;

  /// Widgets for each view
  final Widget Function(ScrollController) buildSearchForm;
  final Widget Function(ScrollController) buildResults;
  final Widget Function(ScrollController) buildDetails;

  const SheetSwitcher({
    super.key,
    required this.currentView,
    required this.scrollController,
    required this.buildSearchForm,
    required this.buildResults,
    required this.buildDetails,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentView) {
      case BottomSheetView.searchForm:
        return buildSearchForm(scrollController);
      case BottomSheetView.results:
        return buildResults(scrollController);
      case BottomSheetView.details:
        return buildDetails(scrollController);
      case BottomSheetView.loading:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
