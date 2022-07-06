part of "./parts_list.dart";

@immutable
class PcPartsEvent {
  const PcPartsEvent();
}

class PcPartsLoaded extends PcPartsEvent {
  const PcPartsLoaded();
}

class PcPartsDeleted extends PcPartsEvent {
  final String upc;

  const PcPartsDeleted(this.upc);
}

class PcPartsUpdated extends PcPartsEvent {
  final String upc;
  final String? newName;
  final String? newBrand;
  final double? newPrice;

  const PcPartsUpdated({
    required this.upc,
    this.newPrice,
    this.newBrand,
    this.newName,
  });
}

class PcPartsCreated extends PcPartsEvent {
  final String upc;
  final String name;
  final String brand;
  final String type;
  final double price;

  const PcPartsCreated({
    required this.upc,
    required this.price,
    required this.brand,
    required this.name,
    required this.type,
  });
}

@immutable
class PcPartsState {
  const PcPartsState();
}

class PcPartsInitial extends PcPartsState {
  const PcPartsInitial();
}

class PcPartsLoadInProgress extends PcPartsState {
  const PcPartsLoadInProgress();
}

class PcPartsLoadSuccess extends PcPartsState {
  final List<PcPartModel> pcParts;

  const PcPartsLoadSuccess({
    required this.pcParts,
  });
}

class PcPartsLoadFailure extends PartsListsState {}

class PcPartsBloc extends Bloc<PcPartsEvent, PcPartsState> {
  final PcPartRepository _repository;

  PcPartsBloc(this._repository) : super(const PcPartsInitial()) {
    on<PcPartsLoaded>((event, emit) async {
      emit(const PcPartsLoadInProgress());

      final all = await _repository.getAll();

      emit(PcPartsLoadSuccess(pcParts: all.toList()));
    });
    on<PcPartsCreated>((event, emit) async {
      _repository.save(PcPartModel(
        name: event.name,
        type: event.type,
        upc: event.upc,
        brand: event.brand,
        price: event.price,
      ));
      add(const PcPartsLoaded());
    });

    on<PcPartsDeleted>((event, emit) async {
      _repository.deleteByUpc(event.upc);
      add(const PcPartsLoaded());
    });

    on<PcPartsUpdated>((event, emit) async {
      _repository.update(
        upc: event.upc,
        newBrand: event.newBrand,
        newName: event.newName,
        newPrice: event.newPrice,
      );
      add(const PcPartsLoaded());
    });
  }
}
