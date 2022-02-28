import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:wsms/ChildrenModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDb extends ChangeNotifier {
  int initCount=0;


  void updateCount(int count) {
    initCount = count;
    print('initcount $initCount');
    print('count $count');
    notifyListeners();
  }
}



class CounterCubit extends Cubit<int>{
  CounterCubit() :super(0);

  void increment()=>emit(state+1);
  @override
  void onChange(Change<int> change) {
    // TODO: implement onChange
    print(change);
    super.onChange(change);
  }
}


class SimpleObserver extends BlocObserver{
  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
  print('trans $transition');
  }
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // TODO: implement onError
    super.onError(bloc, error, stackTrace);
  print('${bloc.runtimeType}  $error  $stackTrace');
  }

}

abstract class CountEvent{}// create abstract class

class CounterIncrement extends CountEvent{}

class CounterBloc extends Bloc<CountEvent,int>{
  CounterBloc(): super(0){
    on<CounterIncrement>((event, emit) {
        emit(state+1);
    });
  }
}

