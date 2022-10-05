import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class LoadingCubit extends Cubit<bool?> {
  LoadingCubit() : super(null);

  bool isLoading = false;
	emit(isLoading);

  // void updateLoading() {
	// 	emit(isLoading);
  // }
}
