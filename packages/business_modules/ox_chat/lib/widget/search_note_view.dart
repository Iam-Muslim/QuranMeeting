import 'package:flutter/material.dart';

/// Public Moments/Notes search is removed in this Nostr Meet build.
class SearchNoteView extends StatelessWidget {
  final String searchQuery;
  const SearchNoteView({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
