import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/presentation/model/PresentationModel.dart';

import '../../main.dart';

class AddTaskScreenBloc {
  EventRepository _eventRepository = diResolver.resolve();

  Future<void> createTask(
      AddEventPresentationModel addEventPresentationModel) async {
    await _eventRepository.createEvent(_mapEvent(addEventPresentationModel));
  }

  SaveEventDomainModel _mapEvent(
      AddEventPresentationModel addEventPresentationModel) {
    return SaveEventDomainModel(
        addEventPresentationModel.name,
        addEventPresentationModel.expiredHour,
        addEventPresentationModel.expiredMinute,
        addEventPresentationModel.monday,
        addEventPresentationModel.tuesday,
        addEventPresentationModel.wednesday,
        addEventPresentationModel.thursday,
        addEventPresentationModel.friday,
        addEventPresentationModel.saturday,
        addEventPresentationModel.sunday);
  }
}
