import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharma_signal/models/drugs.dart';
import 'package:pharma_signal/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharma_signal/utils/functions.dart';
import 'package:pharma_signal/views/search/panel_report/searching_list_med.dart';
import 'package:pharma_signal/views/search/report_user_list.dart';
import 'scan_datamatrix.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchViewItem extends StatefulWidget {
  final String imagePath;
  final String medicamentName;
  final String signalementState;

  const SearchViewItem({
    super.key,
    required this.imagePath,
    required this.medicamentName,
    required this.signalementState,
  });

  @override
  _SearchViewState createState() => _SearchViewState();
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Medicament?> _searchResults = [];

  @override
  void initState() {
    super.initState();
    if (Data.dataValue.isNotEmpty) {
      _searchController.text = Data.dataValue;
      startSearchForScan(); // Démarrez la recherche automatiquement si une valeur est présente
    }
  }

  void startSearch() {
    setState(() {
      _isSearching = true;
    });
    _performSearch(_searchController.text);
  }

  void startSearchForScan() {
    setState(() {
      _isSearching = true;
    });
    _performSearchForData();
  }

  void endSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults.clear();
    });
  }

  Timer? _debounceTimer;

  void _debounceSearch(String query) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 150), () async {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
        });
        return;
      }

      try {
        String queryUpperCase = query.toUpperCase();

        Query queryRef = FirebaseFirestore.instance
            .collection('medicament')
            .orderBy('Dénomination')
            .where('Dénomination', isGreaterThanOrEqualTo: queryUpperCase)
            .where('Dénomination', isLessThanOrEqualTo: '$queryUpperCase\uf8ff')
            .limit(8); // Limite directement dans la requête

        QuerySnapshot querySnapshot = await queryRef.get();

        var results = querySnapshot.docs;

        setState(() {
          _searchResults = results
              .map((doc) => MedicamentWithId.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();
        });
      } catch (e) {
        print('Erreur lors de la recherche : $e');
      }
    });
  }

  Future<void> _performSearchForData() async {
    setState(() {
      _searchResults = [];
    });

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('medicament')
          .doc(Data.dataValue) // direct avec le scan
          .get();

      if (documentSnapshot.exists) {
        MedicamentWithId medicament = MedicamentWithId.fromMap(
            documentSnapshot.data() as Map<String, dynamic>,
            documentSnapshot.id);
        setState(() {
          _searchResults = [medicament];
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.0, 0.0),
                colors: [Constants.lightBlue, Constants.white],
              ),
            ),
          ),
          Visibility(
            visible: !_isSearching,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/img/logo/logo-text.svg',
                fit: BoxFit.cover,
                width: 30,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: _isSearching
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    constraints: const BoxConstraints(maxHeight: 60),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Constants.white,
                        hintText: AppLocalizations.of(context)?.findYourMedicine ?? Constants.notAvailable,
                        hintStyle: const TextStyle(
                            color: Constants.lightGrey, fontSize: 16),
                        prefixIcon: _isSearching
                            ? GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _isSearching = false;
                                    _searchController.clear();
                                    _searchResults.clear();
                                  });
                                },
                                child: const Icon(Icons.close),
                              )
                            : const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            'assets/img/page_recherche/icon_scan.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () => WidgetFunction.goToThePageWithoutNav(
                              context, const ScanData()),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Constants.lightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Constants.darkBlue),
                        ),
                      ),
                      onTap: () {
                        startSearch();
                      },
                      onChanged: (value) {
                        _debounceSearch(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_isSearching)
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.42,
              child: const Padding(
                padding: EdgeInsets.only(left: 15, right: 20, top: 12),
                child: ReportUserList(),
              ),
            ),
          if (_isSearching) SearchingListMed(searchResults: _searchResults)
        ],
      ),
    );
  }
}
