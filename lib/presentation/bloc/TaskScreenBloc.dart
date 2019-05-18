import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class TaskScreenBloc {
  EventRepository _eventRepository = diResolver.resolve();

  Future<List<TaskPresentationModel>> loadActiveTaskList() async {
    var todayEvents = await _eventRepository.getActiveTasks();
    List<TaskPresentationModel> result = _mapEventList(todayEvents);
    return result;
  }

  List<TaskPresentationModel> _mapEventList(
      List<TaskDomainModel> todayEvents) {
    return todayEvents
        .map((event) => TaskPresentationModel(
              event.taskId,
              event.name,
              event.expiredHour,
              event.expiredMinute,
            ))
        .toList(growable: false);
  }

  Future<void> removeTask(String eventId) async {
    await _eventRepository.disableEvent(DisableEventDomainModel(eventId));
  }
}
