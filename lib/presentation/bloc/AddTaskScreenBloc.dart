import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class AddTaskScreenBloc {
  TaskRepository _eventRepository = diResolver.resolve();

  Future<void> createDailyTask(
      AddDailyTaskPresentationModel addTaskPresentationModel) async {
    await _eventRepository
        .createDailyTask(_mapDailyTask(addTaskPresentationModel));
  }

  Future<void> createOneTimeTask(
      AddOneTimeTaskPresentationModel addTaskPresentationModel) async {
    await _eventRepository
        .createOneTimeTask(_mapOneTimeTask(addTaskPresentationModel));
  }

  SaveDailyTaskDomainModel _mapDailyTask(
      AddDailyTaskPresentationModel addEventPresentationModel) {
    return SaveDailyTaskDomainModel(
      addEventPresentationModel.name,
      addEventPresentationModel.expiredHour,
      addEventPresentationModel.expiredMinute,
      addEventPresentationModel.monday,
      addEventPresentationModel.tuesday,
      addEventPresentationModel.wednesday,
      addEventPresentationModel.thursday,
      addEventPresentationModel.friday,
      addEventPresentationModel.saturday,
      addEventPresentationModel.sunday,
    );
  }

  SaveOneTimeTaskDomainModel _mapOneTimeTask(
      AddOneTimeTaskPresentationModel addTaskPresentationModel) {
    return SaveOneTimeTaskDomainModel(
      addTaskPresentationModel.name,
      addTaskPresentationModel.expiredHour,
      addTaskPresentationModel.expiredMinute,
      addTaskPresentationModel.expiredDay,
      addTaskPresentationModel.expiredMonth,
      addTaskPresentationModel.expiredYear,
    );
  }
}
