import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/domain/DomainModel.dart';
import 'package:flutter_app/domain/Repository.dart';
import 'package:flutter_app/domain/Util.dart';

import '../main.dart';
import 'FirebaseController.dart';
import 'FirebaseDataModel.dart';

class UserRepositoryImpl implements UserRepository {
  FireAuthController _fireAuthController = diResolver.resolve();
  FireDatabaseController _fireDatabaseController = diResolver.resolve();

  @override
  Future<void> signInWithGoogleAccount() async {
    await _fireAuthController.signInWithGoogle();

    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      DataSnapshot userData = await _fireDatabaseController
          .reference()
          .child("user/${loginUser.uid}")
          .once();
      if (userData.value == null) {
        await _fireDatabaseController
            .reference()
            .child("user/${loginUser.uid}")
            .set(loginUser.toJson());
      }
    }
  }

  @override
  Future<void> logout() async {
    await _fireAuthController.signOut();
  }

  @override
  Future<bool> isLogin() async {
    var isLogin = await _fireAuthController.isLogin();
    return isLogin;
  }

  @override
  Future<LoginUserDomainModel> getCurrentUser() async {
    var mapLoginUser = await _fireAuthController.getLoginUser();
    return _mapLoginUser(mapLoginUser);
  }

  LoginUserDomainModel _mapLoginUser(LoginUserFirebaseDataModel loginUser) {
    LoginUserDomainModel result;
    if (loginUser != null) {
      result = LoginUserDomainModel(
          loginUser.uid, loginUser.userName, loginUser.email);
    }
    return result;
  }
}

class EventRepositoryImpl implements EventRepository {
  FireDatabaseController _fireDatabaseController = diResolver.resolve();
  FireAuthController _fireAuthController = diResolver.resolve();

  //final List<EventFirebaseDataModel> databaseEventFake = [];
  //final List<EventHistoryFirebaseDataModel> databaseHistoryFake = [];

  @override
  Future<void> createEvent(SaveEventDomainModel saveEventDataModel) async {
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      bool defaultEventEnable = true;
      var nowMilliseconds = _getNowMilliseconds();
      int createdTime = nowMilliseconds;
      int updatedTime = 0;
      int enableTimeStart = nowMilliseconds;
      int enableTimeEnd = 0;
      var taskTimeExpired = Util.calcTaskTimeExpired(
          saveEventDataModel.expiredHour, saveEventDataModel.expiredMinute);
      EventFirebaseDataModel eventDataModel = EventFirebaseDataModel(
          saveEventDataModel.name,
          saveEventDataModel.expiredHour,
          saveEventDataModel.expiredMinute,
          taskTimeExpired,
          defaultEventEnable,
          enableTimeStart,
          enableTimeEnd,
          createdTime,
          updatedTime,
          saveEventDataModel.monday,
          saveEventDataModel.tuesday,
          saveEventDataModel.wednesday,
          saveEventDataModel.thursday,
          saveEventDataModel.friday,
          saveEventDataModel.saturday,
          saveEventDataModel.sunday);

      var pushTask = _fireDatabaseController
          .reference()
          .child("task/${loginUser.uid}")
          .push();
      await pushTask.set(eventDataModel.toJson());
    }
  }

  @override
  Future<void> disableEvent(
      DisableEventDomainModel disableEventDataModel) async {
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var taskPath = "task/$uid/${disableEventDataModel.eventId}";
      DataSnapshot historyData =
          await _fireDatabaseController.reference().child(taskPath).once();
      if (historyData.value != null) {
        var nowMilliseconds = _getNowMilliseconds();
        var updateTime = nowMilliseconds;
        var enableTimeEnd = nowMilliseconds;
        await _fireDatabaseController.reference().child(taskPath).update({
          "enable": false,
          "enableTimeEnd": enableTimeEnd,
          "updateTime": updateTime,
        });
      }
    }
  }

  @override
  Future<void> doneEvent(DoneEventDomainModel doneEventDomainModel) async {
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var historyPath = "task_history/$uid/${doneEventDomainModel.historyId}";
      DataSnapshot historyData =
          await _fireDatabaseController.reference().child(historyPath).once();
      if (historyData.value != null) {
        var findHistory = EventHistoryFirebaseDataModel.from(
            historyData.key, historyData.value);
        var nowMilliseconds = _getNowMilliseconds();
        var doneTime = nowMilliseconds;
        var status = _getDoneStatus(findHistory);
        var updateTime = nowMilliseconds;
        await _fireDatabaseController.reference().child(historyPath).update({
          "updateTime": updateTime,
          "doneTime": doneTime,
          "status": status,
        });
      }
    }
  }

  int _getDoneStatus(EventHistoryFirebaseDataModel findHistory) {
    int status = EventHistoryFirebaseDataModel.STATUS_DONE;
    var now = DateTime.now();
    var currentTime = (now.hour * 100) + now.minute;
    var taskExpiredTime = findHistory.expiredTime;
    if (currentTime > taskExpiredTime) {
      status = EventHistoryFirebaseDataModel.STATUS_DONE_LATE;
    }

    return status;
  }

  @override
  Future<List<EventHistoryDomainModel>> getEventHistoryReport(
      ReportTimeEnum reportTimeEnum) async {
    List<EventHistoryDomainModel> results = [];
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      await _createTodayHistoryEventsIfNeed(uid);
      List<int> dateValues = _getReportDateValues(reportTimeEnum);
      List<EventHistoryFirebaseDataModel> foundHistories = [];
      for (var findDate in dateValues) {
        DataSnapshot dataSnapshot = await _fireDatabaseController
            .reference()
            .child("task_history/$uid")
            .orderByChild("date")
            .equalTo(findDate)
            .once();
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> values = dataSnapshot.value;
          values.forEach((key, values) {
            foundHistories
                .add(EventHistoryFirebaseDataModel.from(key, values));
          });
        }
      }

      foundHistories.sort((a, b) {
        var dateCompareTo = a.date.compareTo(b.date);
        if (dateCompareTo == 0) {
          return a.expiredTime.compareTo(b.expiredTime);
        }
        return dateCompareTo;
      });

      results = foundHistories
          .map((history) => _mapHistory(history))
          .toList(growable: true);
    }
    return results;
  }

  @override
  Future<List<TodayTodoDomainModel>> getTodayEvents() async {
    List<TodayTodoDomainModel> matchedEvents = [];
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      await _createTodayHistoryEventsIfNeed(uid);

      var dateValueToday = _getDateValueToday();
      List<EventHistoryFirebaseDataModel> foundHistories = [];
      DataSnapshot dataSnapshot = await _fireDatabaseController
          .reference()
          .child("task_history/$uid")
          .orderByChild("date")
          .equalTo(dateValueToday)
          .once();

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          foundHistories.add(EventHistoryFirebaseDataModel.from(key, values));
        });
      }

      foundHistories = foundHistories
          .where((history) =>
              history.status == EventHistoryFirebaseDataModel.STATUS_TODO)
          .toList(growable: true);
      foundHistories.sort((a, b) => a.expiredTime.compareTo(b.expiredTime));
      matchedEvents = foundHistories
          .map((eventDataModel) => _mapEventDataToEventDomain(eventDataModel))
          .toList(growable: true);
      return matchedEvents;
    }
    return matchedEvents;
  }

  TodayTodoDomainModel _mapEventDataToEventDomain(
      EventHistoryFirebaseDataModel historyModel) {
    return TodayTodoDomainModel(
        historyModel.eventId,
        historyModel.id,
        historyModel.eventName,
        historyModel.expiredHour,
        historyModel.expiredMinute,
        _mapStatus(historyModel.status));
  }

  List<int> buildWeekdays(SaveEventDomainModel saveEventDataModel) {
    List<int> result = [];
    if (saveEventDataModel.sunday) {
      result.add(DateTime.sunday);
    }
    if (saveEventDataModel.monday) {
      result.add(DateTime.monday);
    }
    if (saveEventDataModel.tuesday) {
      result.add(DateTime.tuesday);
    }
    if (saveEventDataModel.wednesday) {
      result.add(DateTime.wednesday);
    }
    if (saveEventDataModel.thursday) {
      result.add(DateTime.thursday);
    }
    if (saveEventDataModel.friday) {
      result.add(DateTime.friday);
    }
    if (saveEventDataModel.saturday) {
      result.add(DateTime.saturday);
    }

    return result;
  }

  bool _checkWeekdayInToday(EventFirebaseDataModel event) {
    var nowWeekday = DateTime.now().weekday;
    if (nowWeekday == DateTime.monday) {
      return event.monday;
    }
    if (nowWeekday == DateTime.tuesday) {
      return event.tuesday;
    }
    if (nowWeekday == DateTime.wednesday) {
      return event.wednesday;
    }
    if (nowWeekday == DateTime.thursday) {
      return event.thursday;
    }
    if (nowWeekday == DateTime.friday) {
      return event.friday;
    }
    if (nowWeekday == DateTime.saturday) {
      return event.saturday;
    }
    if (nowWeekday == DateTime.sunday) {
      return event.sunday;
    }

    return false;
  }

  Future<List<EventFirebaseDataModel>> _getTodayActiveTasks(String uid) async {
    List<EventFirebaseDataModel> matchedTasks = await _getActiveTasks(uid);
    return matchedTasks.where((task) => _checkWeekdayInToday(task)).toList(growable: false);
  }

  Future<void> _createTodayHistoryEventsIfNeed(String uid) async {
    List<EventFirebaseDataModel> matchedTasks = await _getTodayActiveTasks(uid);

    int dateValue = _getDateValueToday();

    var listOfTaskId = [for (var task in matchedTasks) task.id];

    List<EventHistoryFirebaseDataModel> todayHistoryModels =
        await _findTodayHistoryModels(listOfTaskId, dateValue, uid);
    for (var task in matchedTasks) {
      bool isCreateHistory = true;
      var history = todayHistoryModels.firstWhere(
          (history) => history.eventId == task.id,
          orElse: () => null);
      if (history != null) {
        isCreateHistory = false;
      }

      if (isCreateHistory) {
        _createHistory(task, dateValue, uid);
      }
    }
  }

  Future<List<EventFirebaseDataModel>> _getActiveTasks(String uid) async {
    List<EventFirebaseDataModel> matchedTasks = [];
    DataSnapshot dataSnapshot = await _fireDatabaseController
        .reference()
        .child("task/$uid")
        .once();
    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        matchedTasks.add(EventFirebaseDataModel.from(key, values));
      });
    }
    matchedTasks = matchedTasks
        .where((event) => event.enable)
        .toList(growable: true);
    return matchedTasks;
  }

  Future<void> _createHistory(
      EventFirebaseDataModel task, int dateValue, String uid) async {
    var nowMilliseconds = _getNowMilliseconds();
    var doneTime = nowMilliseconds;
    var createdTime = nowMilliseconds;

    EventHistoryFirebaseDataModel eventHistoryFirebaseDataModel =
        EventHistoryFirebaseDataModel(
      task.id,
      task.name,
      doneTime,
      task.expiredHour,
      task.expiredMinute,
      task.expiredTime,
      createdTime,
      dateValue,
      EventHistoryFirebaseDataModel.STATUS_TODO,
    );

    var pushTaskHistory =
        _fireDatabaseController.reference().child("task_history/$uid").push();
    await pushTaskHistory.set(eventHistoryFirebaseDataModel.toJson());
  }

  int _getDateValueToday() {
    var now = DateTime.now();
    int dateValue = _getDateValue(now);
    return dateValue;
  }

  int _getDateValue(DateTime dateSelect) {
    var utcDateTime = dateSelect.toUtc();
    var year = utcDateTime.year;
    var month = utcDateTime.month;
    var date = utcDateTime.day;
    int dateValue = (year * 10000) + (month * 100) + date;
    return dateValue;
  }

  Future<List<EventHistoryFirebaseDataModel>> _findTodayHistoryModels(
      List<String> listOfTaskId, int dateValue, String uid) async {
    List<EventHistoryFirebaseDataModel> foundHistories = [];
    DataSnapshot dataSnapshot = await _fireDatabaseController
        .reference()
        .child("task_history/$uid")
        .orderByChild("date")
        .equalTo(dateValue)
        .once();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        foundHistories.add(EventHistoryFirebaseDataModel.from(key, values));
      });
    }

    foundHistories = foundHistories
        .where((history) =>
            history.date == dateValue && listOfTaskId.contains(history.eventId))
        .toList(growable: true);

    return foundHistories;
  }

  TaskStatus _mapStatus(int status) {
    if (status == EventHistoryFirebaseDataModel.STATUS_DONE) {
      return TaskStatus.DONE;
    } else if (status == EventHistoryFirebaseDataModel.STATUS_DONE_LATE) {
      return TaskStatus.DONE_LATE;
    } else {
      return TaskStatus.TODO;
    }
  }

  List<int> _getReportDateValues(ReportTimeEnum reportTimeEnum) {
    List<int> dateValues = [];

    var now = DateTime.now();
    switch (reportTimeEnum) {
      case ReportTimeEnum.TODAY:
        dateValues.add(_getDateValueToday());
        break;
      case ReportTimeEnum.YESTERDAY:
        DateTime dateSelect = now.subtract(Duration(days: 1));
        dateValues.add(_getDateValue(dateSelect));
        break;
      case ReportTimeEnum.LAST_WEEK:
        DateTime startCurrentWeek =
            now.subtract(Duration(days: now.weekday - 1));
        DateTime startLastWeek = startCurrentWeek.subtract(Duration(days: 7));
        int i = 0;
        do {
          DateTime dateSelect = startLastWeek.add(Duration(days: i));
          var dateValue = _getDateValue(dateSelect);
          dateValues.add(dateValue);
          i++;
        } while (i <= 6);
        break;
    }
    return dateValues;
  }

  EventHistoryDomainModel _mapHistory(EventHistoryFirebaseDataModel history) {
    return EventHistoryDomainModel(
        history.eventId,
        history.eventName,
        history.doneTime,
        history.expiredHour,
        history.expiredMinute,
        history.createdTime,
        _mapStatus(history.status));
  }

  int _getNowMilliseconds() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  @override
  Future<List<TaskDomainModel>> getActiveTasks() async {
    List<TaskDomainModel> tasks = [];
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      List<EventFirebaseDataModel> matchedTasks = await _getActiveTasks(uid);

      matchedTasks.sort((a, b) {
        return a.expiredTime.compareTo(b.expiredTime);
      });

      tasks =
          matchedTasks.map((task) => _mapTask(task)).toList(growable: false);
    }

    return tasks;
  }

  TaskDomainModel _mapTask(EventFirebaseDataModel task) {
    return TaskDomainModel(
        task.id, task.name, task.expiredHour, task.expiredMinute);
  }

  @override
  Future<TaskDetailDomainModel> getTaskDetail(String taskId) async {
    TaskDetailDomainModel taskDetailDomainModel;
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      List<EventFirebaseDataModel> matchedTasks = [];
      DataSnapshot dataSnapshot = await _fireDatabaseController
          .reference()
          .child("task/$uid/$taskId")
          .once();
      var eventFirebaseDataModel = EventFirebaseDataModel.from(dataSnapshot.key, dataSnapshot.value);
      taskDetailDomainModel = _mapDetailTask(eventFirebaseDataModel);
    }
    return taskDetailDomainModel;
  }

  TaskDetailDomainModel _mapDetailTask(EventFirebaseDataModel eventFirebaseDataModel) {
    TaskDetailDomainModel taskDetailDomainModel;
    if (eventFirebaseDataModel != null) {
      taskDetailDomainModel = TaskDetailDomainModel(
          eventFirebaseDataModel.name,
          eventFirebaseDataModel.expiredHour,
          eventFirebaseDataModel.expiredMinute,
          eventFirebaseDataModel.monday,
          eventFirebaseDataModel.tuesday,
          eventFirebaseDataModel.wednesday,
          eventFirebaseDataModel.thursday,
          eventFirebaseDataModel.friday,
          eventFirebaseDataModel.saturday,
          eventFirebaseDataModel.sunday,
      );
    }
    return taskDetailDomainModel;
  }
}
