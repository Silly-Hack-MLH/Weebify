import 'package:flutter/material.dart';
import '../enum/viewstate.dart';

class IMageUploadProvider with ChangeNotifier {
  ViewState _viewState = ViewState.Idle;
  ViewState get getViewState => _viewState;
  void setLoading() {
    _viewState = ViewState.Loading;
    notifyListeners();
  }

  void setIdle() {
    _viewState = ViewState.Idle;
    notifyListeners();
  }
}
