import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class TaskScreenBloc {
  EventRepository _eventRepository = diResolver.resolve();

  Future<List<DailyTaskPresentationModel>> getActiveDailyTaskList() async {
    var tasks = await _eventRepository.getActiveDailyTasks();
    List<DailyTaskPresentationModel> result = _mapEventList(tasks);
    return result;
  }

  Future<List<OneTimeTaskPresentationModel>> getActiveOneTimeTaskList() async {
    var tasks = await _eventRepository.getActiveOneTimeTasks();
    List<OneTimeTaskPresentationModel> result = _mapOneTimeTaskList(tasks);
    return result;
  }

  List<OneTimeTaskPresentationModel> _mapOneTimeTaskList(
      List<OneTimeTaskDomainModel> tasks) {
    return tasks
        .map((task) => OneTimeTaskPresentationModel(
              task.taskId,
              task.name,
              task.expiredHour,
              task.expiredMinute,
              task.expiredDay,
              task.expiredMonth,
              task.expiredYear,
            ))
        .toList(growable: false);
  }

  List<DailyTaskPresentationModel> _mapEventList(
      List<DailyTaskDomainModel> tasks) {
    return tasks
        .map((task) => DailyTaskPresentationModel(
              task.taskId,
              task.name,
              task.expiredHour,
              task.expiredMinute,
            ))
        .toList(growable: false);
  }

  Future<void> removeTask(String eventId) async {
    await _eventRepository
        .disableDailyEvent(DisableDailyTaskDomainModel(eventId));
  }
}
