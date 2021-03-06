import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class TodayTodosScreenBloc {
  UserRepository _userRepository = diResolver.resolve();
  TaskRepository _eventRepository = diResolver.resolve();

  Future<List<TodayTodoPresentationModel>> loadEventList() async {
    var todayEvents = await _eventRepository.getTodayTodos();
    List<TodayTodoPresentationModel> result = _mapEventList(todayEvents);
    return result;
  }

  List<TodayTodoPresentationModel> _mapEventList(
      List<TodayTodoDomainModel> todayEvents) {
    return todayEvents
        .map((event) => TodayTodoPresentationModel(
              event.eventId,
              event.historyId,
              event.name,
              event.expiredHour,
              event.expiredMinute,
              event.status,
              event.type,
            ))
        .toList(growable: false);
  }

  Future<void> doneDailyTask(String eventId, String historyId) async {
    await _eventRepository
        .doneDailyTask(DoneDailyTaskDomainModel(eventId, historyId));
  }

  Future<void> doneOneTimeTask(String eventId, String historyId) async {
    await _eventRepository
        .doneOneTimeTask(DoneOneTimeTaskDomainModel(eventId, historyId));
  }

  Future<void> logout() async {
    await _userRepository.logout();
  }
}
