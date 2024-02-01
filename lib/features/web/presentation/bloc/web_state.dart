part of 'web_bloc.dart';

abstract class WebState extends Equatable {
  const WebState();  

  @override
  List<Object> get props => [];
}
class WebInitial extends WebState {}
