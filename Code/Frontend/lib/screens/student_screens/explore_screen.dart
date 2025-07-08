import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../services/api_services.dart';

class SearchResult {
  final String id;
  final double score;
  final String paragraph;
  final String topic;

  SearchResult({required this.id, required this.score, required this.paragraph, required this.topic});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      score: json['score'],
      paragraph: json['paragraph'],
      topic: json['metadata']['topic'],
    );
  }
}

class ExploreScreen extends StatefulWidget {
  final Function(Locale) updateLocale;
  const ExploreScreen({Key? key, required this.updateLocale}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  bool _searchAttempted = false;

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
      _searchAttempted = true;
    });

    try {
      final results = await ApiService.faissSearch(_searchController.text);
      setState(() {
        _searchResults = results.map((json) => SearchResult.fromJson(json)).toList();
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load results: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).explore,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              !_searchAttempted ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).exploreScreenTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
                
            ),
            const SizedBox(height: 24),
            TextField(
              cursorColor: Colors.orange,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: S.of(context).searchForATopic,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusColor: Colors.orange,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 16),
            if (_searchAttempted)
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange))
                    : _error != null
                        ? Center(
                            child: Text(_error!,
                                style: const TextStyle(color: Colors.red)))
                        : _searchResults.isEmpty
                            ? Center(child: Text(S.of(context).noResultsFound))
                            : ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final result = _searchResults[index];
                                  return Card(
                                    elevation: 2.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ExpansionTile(
                                      iconColor: Colors.orange,
                                      collapsedIconColor: Colors.orange,
                                      title: Text(
                                        result.topic,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.normal),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0)
                                              .copyWith(top: 0),
                                          child: Text(
                                            result.paragraph,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontSize: 16,
                                              height: 1.5,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
              ),
          ],
        ),
      ),
    );
  }
}