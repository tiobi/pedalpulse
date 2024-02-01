import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'web_event.dart';
part 'web_state.dart';

class WebBloc extends Bloc<WebEvent, WebState> {
  WebBloc() : super(WebInitial()) {
    on<WebEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
