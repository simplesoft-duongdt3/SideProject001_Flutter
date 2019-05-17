import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class MainScreenBloc {
  UserRepository _userRepository = diResolver.resolve();
  EventRepository _eventRepository = diResolver.resolve();

  Future<List<EventPresentationModel>> loadEventList() async {
    var todayEvents = await _eventRepository.getTodayEvents();
    List<EventPresentationModel> result = _mapEventList(todayEvents);
    return result;
  }

  List<EventPresentationModel> _mapEventList(
      List<EventDomainModel> todayEvents) {
    return todayEvents
        .map((event) => EventPresentationModel(
              event.eventId,
              event.historyId,
              event.name,
              event.expiredHour,
              event.expiredMinute,
              event.status
            ))
        .toList(growable: false);
  }

  Future<void> doneTask(String eventId, String historyId) async {
    await _eventRepository.doneEvent(DoneEventDomainModel(eventId, historyId));
  }

  Future<void> logout() async {
    await _userRepository.logout();
  }
}
