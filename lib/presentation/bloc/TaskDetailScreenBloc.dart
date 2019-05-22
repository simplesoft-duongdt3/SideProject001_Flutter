import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class TaskDetailScreenBloc {
  EventRepository _eventRepository = diResolver.resolve();

  Future<TaskDetailPresentationModel> getTaskDetail(String taskId) async {
    var taskDetail = await _eventRepository.getTaskDailyDetail(taskId);
    return _mapTaskDetail(taskDetail);
  }

  TaskDetailPresentationModel _mapTaskDetail(
      TaskDetailDomainModel taskDetailDomainModel) {
    TaskDetailPresentationModel detailPresentationModel;

    if (taskDetailDomainModel != null) {
      detailPresentationModel = TaskDetailPresentationModel(
          taskDetailDomainModel.name,
          taskDetailDomainModel.expiredHour,
          taskDetailDomainModel.expiredMinute,
          taskDetailDomainModel.monday,
          taskDetailDomainModel.tuesday,
          taskDetailDomainModel.wednesday,
          taskDetailDomainModel.thursday,
          taskDetailDomainModel.friday,
          taskDetailDomainModel.saturday,
          taskDetailDomainModel.sunday);
    }

    return detailPresentationModel;
  }
}
