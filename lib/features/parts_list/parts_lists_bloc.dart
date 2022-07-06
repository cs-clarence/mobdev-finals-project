part of "./parts_list.dart";

@immutable
class PartsListsEvent {
  const PartsListsEvent();
}

class PartsListsForUserLoaded extends PartsListsEvent {
  final String userName;

  const PartsListsForUserLoaded({required this.userName});
}

class PartsListsForUserCreated extends PartsListsEvent {
  final String userName;
  final String partsListName;
  final Iterable<String> partsUpcs;

  const PartsListsForUserCreated({
    required this.userName,
    required this.partsListName,
    required this.partsUpcs,
  });
}

class PartsListsForUserUpdated extends PartsListsEvent {
  final String partsListId;
  final String userName;
  final String? newPartsListName;
  final Iterable<String>? newPartsUpcs;

  const PartsListsForUserUpdated({
    required this.userName,
    required this.partsListId,
    this.newPartsUpcs,
    this.newPartsListName,
  });
}

class PartsListsForUserDeleted extends PartsListsEvent {
  final String partsListId;
  final String userName;

  const PartsListsForUserDeleted({
    required this.partsListId,
    required this.userName,
  });
}

@immutable
class PartsListsState {
  const PartsListsState();
}

class PartsListsInitial extends PartsListsState {
  const PartsListsInitial();
}

class PartsListsLoadInProgress extends PartsListsState {
  const PartsListsLoadInProgress();
}

class PartsListsLoadSuccess extends PartsListsState {
  final Iterable<PartsListModel> partsLists;

  const PartsListsLoadSuccess({
    required this.partsLists,
  });
}

class PartsListsLoadFailure extends PartsListsState {}

class PartsListsBloc extends Bloc<PartsListsEvent, PartsListsState> {
  final PartsListRepository _repository;

  PartsListsBloc(this._repository) : super(const PartsListsInitial()) {
    on<PartsListsForUserLoaded>((event, emit) async {
      emit(const PartsListsLoadInProgress());
      final partsLists = await _repository.getPartsListsForUser(event.userName);
      emit(PartsListsLoadSuccess(partsLists: partsLists));
    });

    on<PartsListsForUserCreated>((event, emit) async {
      emit(const PartsListsLoadInProgress());
      await _repository.save(
        userName: event.userName,
        partsListName: event.partsListName,
        partsUpcs: event.partsUpcs,
      );

      add(PartsListsForUserLoaded(userName: event.userName));
    });

    on<PartsListsForUserUpdated>((event, emit) async {
      emit(const PartsListsLoadInProgress());
      _repository.update(
        id: event.partsListId,
        newPartsListName: event.newPartsListName,
        newPartsUpcs: event.newPartsUpcs,
      );
      add(PartsListsForUserLoaded(userName: event.userName));
    });

    on<PartsListsForUserDeleted>((event, emit) async {
      emit(const PartsListsLoadInProgress());
      _repository.deleteById(event.partsListId);
      add(PartsListsForUserLoaded(userName: event.userName));
    });
  }
}
