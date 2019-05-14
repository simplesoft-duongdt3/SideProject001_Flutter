import 'package:flutter_app/data/RepositoryImpl.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

class MainScreenBloc {
  EventRepository _eventRepository = EventRepositoryImpl();

  Future<List<EventPresentationModel>> loadEventList() async {
    var todayEvents = await _eventRepository.getTodayEvents();
    List<EventPresentationModel> result = _mapEventList(todayEvents);
    return result;
  }

  List<EventPresentationModel> _mapEventList(
      List<EventDomainModel> todayEvents) {
    return todayEvents
        .map((event) => EventPresentationModel(
              event.id,
              event.name,
              event.expiredHour,
              event.expiredMinute
            ))
        .toList(growable: false);
  }

  Future<void> doneTask(int eventId) async {

  }
}
