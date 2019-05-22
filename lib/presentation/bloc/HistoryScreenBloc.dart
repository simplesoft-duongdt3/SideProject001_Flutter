import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class HistoryScreenBloc {
  EventRepository _eventRepository = diResolver.resolve();

  Future<List<TaskHistoryPresentationModel>> loadHistoryList(
      ReportTimeEnum reportTime) async {
    var todayEvents = await _eventRepository.getTaskHistoryReport(reportTime);
    List<TaskHistoryPresentationModel> result = _mapEventList(todayEvents);
    return result;
  }

  List<TaskHistoryPresentationModel> _mapEventList(
      List<TaskHistoryDomainModel> todayEvents) {
    return todayEvents
        .map((history) => TaskHistoryPresentationModel(
              history.eventId,
              history.eventName,
              history.doneTime,
              history.expiredHour,
              history.expiredMinute,
              history.createdTime,
              history.status,
            ))
        .toList(growable: false);
  }
}
