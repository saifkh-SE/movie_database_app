import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class PageNumberCubit extends Cubit<int?> {
  PageNumberCubit() : super(null);

  int pageNum = 1;
  emit(pageNum);

  // void updatePageNumber() {
  //   emit(pageNum);
  // }
}
