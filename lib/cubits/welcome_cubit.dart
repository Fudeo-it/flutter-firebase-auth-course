import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeCubit extends Cubit<int> {
  final PageController controller = PageController();

  WelcomeCubit() : super(0) {
    controller.addListener(() {
      emit(controller.page != null ? controller.page!.toInt() : 0);
    });
  }

  @override
  Future<void> close() {
    controller.dispose();

    return super.close();
  }
}