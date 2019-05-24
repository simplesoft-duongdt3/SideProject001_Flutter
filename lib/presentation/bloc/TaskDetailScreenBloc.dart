import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class TaskDetailScreenBloc {
  TaskRepository _eventRepository = diResolver.resolve();

  Future<DailyTaskDetailPresentationModel> getDailyTaskDetail(
      String taskId) async {
    var taskDetail = await _eventRepository.getDailyTaskDetail(taskId);
    return _mapDailyTaskDetail(taskDetail);
  }

  Future<OneTimeTaskDetailPresentationModel> getOneTimeTaskDetail(
      String taskId) async {
    var taskDetail = await _eventRepository.getOneTimeTaskDetail(taskId);
    return _mapOneTimeTaskDetail(taskDetail);
  }

  DailyTaskDetailPresentationModel _mapDailyTaskDetail(
      DailyTaskDetailDomainModel taskDetailDomainModel) {
    DailyTaskDetailPresentationModel detailPresentationModel;

    if (taskDetailDomainModel != null) {
      detailPresentationModel = DailyTaskDetailPresentationModel(
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

  OneTimeTaskDetailPresentationModel _mapOneTimeTaskDetail(
      OneTimeTaskDetailDomainModel taskDetail) {
    return OneTimeTaskDetailPresentationModel(
      taskDetail.name,
      taskDetail.expiredHour,
      taskDetail.expiredMinute,
      taskDetail.expiredDay,
      taskDetail.expiredMonth,
      taskDetail.expiredYear,
    );
  }
}
