import 'package:flutter/material.dart';
import '../../data/models/terms_model.dart';
import '../../data/services/terms_service.dart';
import '../../../../core/errors/failures.dart';

class TermsProvider extends ChangeNotifier {
  final TermsService _termsService;
  List<TermsModel> _terms = [];
  Map<int, bool> _agreements = {};
  bool _isLoading = false;
  String? _error;

  TermsProvider(this._termsService);

  List<TermsModel> get terms => _terms;
  Map<int, bool> get agreements => _agreements;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAllAgreed => _agreements.isNotEmpty && _agreements.values.every((agreed) => agreed);

  Future<void> loadTerms() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _terms = await _termsService.getSignUpTerms();
      _agreements = {for (var term in _terms) term.id: false};
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e is Failure ? e.message : e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getTermsContent(String resourceUrl) async {
    try {
      final content = await _termsService.getTermsContent(resourceUrl);
      return content;
    } catch (e) {
      print('Error in TermsProvider.getTermsContent: $e');
      if (e is Failure) {
        _error = e.message;
        notifyListeners();
      }
      rethrow;
    }
  }

  void toggleAgreement(int id) {
    _agreements[id] = !(_agreements[id] ?? false);
    notifyListeners();
  }

  void toggleAllAgreements(bool value) {
    _agreements = {for (var term in _terms) term.id: value};
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 