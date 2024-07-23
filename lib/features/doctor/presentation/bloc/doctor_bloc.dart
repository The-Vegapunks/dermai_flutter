import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  DoctorBloc() : super(DoctorInitial()) {
    on<DoctorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
