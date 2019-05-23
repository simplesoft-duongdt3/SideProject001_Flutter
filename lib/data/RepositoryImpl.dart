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

  Future<LoginUserFirebaseDataModel> _getLoginUser() async {
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    return loginUser;
  }

  @override
  Future<void> signInWithGoogleAccount() async {
    await _fireAuthController.signInWithGoogle();

    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      DataSnapshot userData =
          await _fireDatabaseController.getUserRef(uid).once();
      if (userData.value == null) {
        await _fireDatabaseController.getUserRef(uid).set(loginUser.toJson());
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
    var mapLoginUser = await _getLoginUser();
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

  Future<LoginUserFirebaseDataModel> _getLoginUser() async {
    LoginUserFirebaseDataModel loginUser =
        await _fireAuthController.getLoginUser();
    return loginUser;
  }

  @override
  Future<void> createDailyTask(
      SaveDailyTaskDomainModel saveEventDataModel) async {
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      bool defaultEventEnable = true;
      var nowMilliseconds = _getNowMilliseconds();
      int createdTime = nowMilliseconds;
      int updatedTime = 0;
      int enableTimeStart = nowMilliseconds;
      int enableTimeEnd = 0;
      var taskTimeExpired = Util.calcTaskTimeExpired(
          saveEventDataModel.expiredHour, saveEventDataModel.expiredMinute);
      DailyTaskFirebaseDataModel eventDataModel = DailyTaskFirebaseDataModel(
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

      var uid = loginUser.uid;
      var pushTask = _fireDatabaseController.getDailyTaskRef(uid).push();
      await pushTask.set(eventDataModel.toJson());
    }
  }

  @override
  Future<void> disableDailyEvent(
      DisableDailyTaskDomainModel disableEventDataModel) async {
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var taskId = disableEventDataModel.eventId;
      DataSnapshot historyData = await _fireDatabaseController
          .getDailyTaskWithIdRef(uid, taskId)
          .once();
      if (historyData.value != null) {
        var nowMilliseconds = _getNowMilliseconds();
        var updateTime = nowMilliseconds;
        var enableTimeEnd = nowMilliseconds;
        await _fireDatabaseController
            .getDailyTaskWithIdRef(uid, taskId)
            .update({
          "enable": false,
          "enableTimeEnd": enableTimeEnd,
          "updateTime": updateTime,
        });
      }
    }
  }

  @override
  Future<void> doneDailyTask(
      DoneDailyTaskDomainModel doneEventDomainModel) async {
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var historyId = doneEventDomainModel.historyId;
      DataSnapshot historyData = await _fireDatabaseController
          .getDailyTaskHistoryWithIdRef(uid, historyId)
          .once();
      if (historyData.value != null) {
        var findHistory = DailyTaskHistoryFirebaseDataModel.from(
            historyData.key, historyData.value);
        var nowMilliseconds = _getNowMilliseconds();
        var doneTime = nowMilliseconds;
        var status = _getDailyTaskDoneStatus(findHistory);
        var updateTime = nowMilliseconds;
        await _fireDatabaseController
            .getDailyTaskHistoryWithIdRef(uid, historyId)
            .update({
          "updateTime": updateTime,
          "doneTime": doneTime,
          "status": status,
        });
      }
    }
  }

  int _getDailyTaskDoneStatus(DailyTaskHistoryFirebaseDataModel findHistory) {
    int status = TaskStatusDataConstant.STATUS_DONE;
    var now = DateTime.now();
    var currentTime = Util.calcTaskTimeExpired(now.hour, now.minute);
    var taskExpiredTime = findHistory.expiredTime;
    if (currentTime > taskExpiredTime) {
      status = TaskStatusDataConstant.STATUS_DONE_LATE;
    }

    return status;
  }

  @override
  Future<List<TaskHistoryDomainModel>> getTaskHistoryReport(
      ReportTimeEnum reportTimeEnum) async {
    List<TaskHistoryDomainModel> results = [];
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var dailyHistories =
          await _getDailyTaskHistoryReport(uid, reportTimeEnum);
      results.addAll(dailyHistories);
      var oneTimeHistories =
          await _getOneTimeTaskHistoryReport(uid, reportTimeEnum);
      results.addAll(oneTimeHistories);
    }
    return results;
  }

  Future<List<TaskHistoryDomainModel>> _getDailyTaskHistoryReport(
      String uid, ReportTimeEnum reportTimeEnum) async {
    List<int> dateValues = _getReportDateValues(reportTimeEnum);
    List<DailyTaskHistoryFirebaseDataModel> foundHistories = [];
    for (var findDate in dateValues) {
      DataSnapshot dataSnapshot = await _fireDatabaseController
          .getDailyTaskHistoryRef(uid)
          .orderByChild("date")
          .equalTo(findDate)
          .once();
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          foundHistories
              .add(DailyTaskHistoryFirebaseDataModel.from(key, values));
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

    return foundHistories
        .map((history) => _mapDailyHistory(history))
        .toList(growable: true);
  }

  Future<List<TaskHistoryDomainModel>> _getOneTimeTaskHistoryReport(
      String uid, ReportTimeEnum reportTimeEnum) async {
    var dateValues = _getReportDateValues(reportTimeEnum);
    List<OneTimeTaskHistoryFirebaseDataModel> foundHistories = [];

    for (var date in dateValues) {
      DataSnapshot dataSnapshot = await _fireDatabaseController
          .getOneTimeTaskHistoryRef(uid)
          .orderByChild("date")
          .equalTo(date)
          .once();

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          foundHistories
              .add(OneTimeTaskHistoryFirebaseDataModel.from(key, values));
        });
      }
    }

    foundHistories = foundHistories
        .where((history) =>
            history.status == TaskStatusDataConstant.STATUS_TODO &&
            history.enable)
        .toList(growable: true);
    foundHistories.sort((a, b) {
      var dateCompare = a.date.compareTo(b.date);
      if (dateCompare == 0) {
        return a.expiredTime.compareTo(b.expiredTime);
      } else {
        return dateCompare;
      }
    });

    return foundHistories
        .map((history) => _mapOneTimeHistory(history))
        .toList(growable: true);
  }

  @override
  Future<List<TodayTodoDomainModel>> getTodayTodos() async {
    List<TodayTodoDomainModel> matchedEvents = [];
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var todayDailyTodos = await _getTodayDailyTodos(uid);
      matchedEvents.addAll(todayDailyTodos);

      var todayOneTimeTodos = await _getTodayOneTimeTodos(uid);
      matchedEvents.addAll(todayOneTimeTodos);
      return matchedEvents;
    }
    return matchedEvents;
  }

  Future<List<TodayTodoDomainModel>> _getTodayDailyTodos(String uid) async {
    await _createTodayHistoryDailyTasksIfNeed(uid);

    var dateValueToday = _getDateValueToday();
    List<DailyTaskHistoryFirebaseDataModel> foundHistories = [];
    DataSnapshot dataSnapshot = await _fireDatabaseController
        .getDailyTaskHistoryRef(uid)
        .orderByChild("date")
        .equalTo(dateValueToday)
        .once();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        foundHistories.add(DailyTaskHistoryFirebaseDataModel.from(key, values));
      });
    }

    foundHistories = foundHistories
        .where(
            (history) => history.status == TaskStatusDataConstant.STATUS_TODO)
        .toList(growable: true);
    foundHistories.sort((a, b) {
      var dateCompare = a.date.compareTo(b.date);
      if (dateCompare == 0) {
        return a.expiredTime.compareTo(b.expiredTime);
      } else {
        return dateCompare;
      }
    });
    List<TodayTodoDomainModel> matchedEvents = foundHistories
        .map((eventDataModel) => _mapDailyTaskDataToTaskDomain(eventDataModel))
        .toList(growable: true);
    return matchedEvents;
  }

  Future<List<TodayTodoDomainModel>> _getTodayOneTimeTodos(String uid) async {
    int dateValue = _getDateValueToday();
    List<OneTimeTaskHistoryFirebaseDataModel> foundHistories = [];
    DataSnapshot dataSnapshot =
        await _fireDatabaseController.getOneTimeTaskHistoryRef(uid).once();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        foundHistories
            .add(OneTimeTaskHistoryFirebaseDataModel.from(key, values));
      });
    }

    foundHistories = foundHistories
        .where((history) =>
            history.date == dateValue &&
            history.status == TaskStatusDataConstant.STATUS_TODO &&
            history.enable)
        .toList(growable: true);
    foundHistories.sort((a, b) {
      var dateCompare = a.date.compareTo(b.date);
      if (dateCompare == 0) {
        return a.expiredTime.compareTo(b.expiredTime);
      } else {
        return dateCompare;
      }
    });
    List<TodayTodoDomainModel> matchedEvents = foundHistories
        .map(
            (eventDataModel) => _mapOneTimeTaskDataToTaskDomain(eventDataModel))
        .toList(growable: true);
    return matchedEvents;
  }

  TodayTodoDomainModel _mapOneTimeTaskDataToTaskDomain(
      OneTimeTaskHistoryFirebaseDataModel historyModel) {
    return TodayTodoDomainModel(
      historyModel.oneTimeTaskId,
      historyModel.id,
      historyModel.oneTimeTaskName,
      historyModel.expiredHour,
      historyModel.expiredMinute,
      _mapStatus(historyModel.status),
      TaskType.ONE_TIME,
    );
  }

  TodayTodoDomainModel _mapDailyTaskDataToTaskDomain(
      DailyTaskHistoryFirebaseDataModel historyModel) {
    return TodayTodoDomainModel(
      historyModel.eventId,
      historyModel.id,
      historyModel.eventName,
      historyModel.expiredHour,
      historyModel.expiredMinute,
      _mapStatus(historyModel.status),
      TaskType.DAILY,
    );
  }

  List<int> buildWeekdays(SaveDailyTaskDomainModel saveEventDataModel) {
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

  bool _checkWeekdayInToday(DailyTaskFirebaseDataModel event) {
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

  Future<List<DailyTaskFirebaseDataModel>> _getTodayActiveTasks(
      String uid) async {
    List<DailyTaskFirebaseDataModel> matchedTasks =
        await _getActiveDailyTasks(uid);
    return matchedTasks
        .where((task) => _checkWeekdayInToday(task))
        .toList(growable: false);
  }

  Future<void> _createTodayHistoryDailyTasksIfNeed(String uid) async {
    List<DailyTaskFirebaseDataModel> matchedTasks =
        await _getTodayActiveTasks(uid);

    int dateValue = _getDateValueToday();

    var listOfTaskId = [for (var task in matchedTasks) task.id];

    List<DailyTaskHistoryFirebaseDataModel> todayHistoryModels =
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

  Future<List<OneTimeTaskFirebaseDataModel>> _getActiveOneTimeTasks(
      String uid) async {
    List<OneTimeTaskFirebaseDataModel> matchedTasks = [];
    DataSnapshot dataSnapshot =
        await _fireDatabaseController.getOneTimeTaskRef(uid).once();
    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        matchedTasks.add(OneTimeTaskFirebaseDataModel.from(key, values));
      });
    }

    var todayDateValue = _getDateValueToday();
    matchedTasks =
        matchedTasks.where((task) => task.enable && task.expiredDate >= todayDateValue).toList(growable: true);
    return matchedTasks;
  }

  Future<List<DailyTaskFirebaseDataModel>> _getActiveDailyTasks(
      String uid) async {
    List<DailyTaskFirebaseDataModel> matchedTasks = [];
    DataSnapshot dataSnapshot =
        await _fireDatabaseController.getDailyTaskRef(uid).once();
    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        matchedTasks.add(DailyTaskFirebaseDataModel.from(key, values));
      });
    }
    matchedTasks =
        matchedTasks.where((event) => event.enable).toList(growable: true);
    return matchedTasks;
  }

  Future<void> _createHistory(
      DailyTaskFirebaseDataModel task, int dateValue, String uid) async {
    var nowMilliseconds = _getNowMilliseconds();
    var doneTime = nowMilliseconds;
    var createdTime = nowMilliseconds;

    DailyTaskHistoryFirebaseDataModel eventHistoryFirebaseDataModel =
        DailyTaskHistoryFirebaseDataModel(
      task.id,
      task.name,
      doneTime,
      task.expiredHour,
      task.expiredMinute,
      task.expiredTime,
      createdTime,
      dateValue,
      TaskStatusDataConstant.STATUS_TODO,
    );

    var pushTaskHistory =
        _fireDatabaseController.getDailyTaskHistoryRef(uid).push();
    await pushTaskHistory.set(eventHistoryFirebaseDataModel.toJson());
  }

  int _getDateValueToday() {
    var now = DateTime.now();
    int dateValue = _getDateValue(now);
    return dateValue;
  }

  int _getDateValue(DateTime dateSelect) {
    var year = dateSelect.year;
    var month = dateSelect.month;
    var date = dateSelect.day;
    int dateValue = Util.calcTaskDateExpired(year, month, date);
    return dateValue;
  }

  Future<List<DailyTaskHistoryFirebaseDataModel>> _findTodayHistoryModels(
      List<String> listOfTaskId, int dateValue, String uid) async {
    List<DailyTaskHistoryFirebaseDataModel> foundHistories = [];
    DataSnapshot dataSnapshot = await _fireDatabaseController
        .getDailyTaskHistoryRef(uid)
        .orderByChild("date")
        .equalTo(dateValue)
        .once();

    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, values) {
        foundHistories.add(DailyTaskHistoryFirebaseDataModel.from(key, values));
      });
    }

    foundHistories = foundHistories
        .where((history) =>
            history.date == dateValue && listOfTaskId.contains(history.eventId))
        .toList(growable: true);

    return foundHistories;
  }

  TaskStatus _mapStatus(int status) {
    if (status == TaskStatusDataConstant.STATUS_DONE) {
      return TaskStatus.DONE;
    } else if (status == TaskStatusDataConstant.STATUS_DONE_LATE) {
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

  TaskHistoryDomainModel _mapDailyHistory(
      DailyTaskHistoryFirebaseDataModel history) {
    return TaskHistoryDomainModel(
        history.eventId,
        history.eventName,
        history.doneTime,
        history.expiredHour,
        history.expiredMinute,
        history.createdTime,
        _mapStatus(history.status));
  }

  TaskHistoryDomainModel _mapOneTimeHistory(
      OneTimeTaskHistoryFirebaseDataModel history) {
    return TaskHistoryDomainModel(
        history.oneTimeTaskId,
        history.oneTimeTaskName,
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
  Future<List<DailyTaskDomainModel>> getActiveDailyTasks() async {
    List<DailyTaskDomainModel> tasks = [];
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      List<DailyTaskFirebaseDataModel> matchedTasks =
          await _getActiveDailyTasks(uid);

      matchedTasks.sort((a, b) {
        return a.expiredTime.compareTo(b.expiredTime);
      });

      tasks = matchedTasks
          .map((task) => _mapDailyTask(task))
          .toList(growable: false);
    }

    return tasks;
  }

  @override
  Future<List<OneTimeTaskDomainModel>> getActiveOneTimeTasks() async {
    List<OneTimeTaskDomainModel> tasks = [];
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      List<OneTimeTaskFirebaseDataModel> matchedTasks =
          await _getActiveOneTimeTasks(uid);

      matchedTasks.sort((a, b) {
        var dateCompare = a.expiredDate.compareTo(b.expiredDate);
        if (dateCompare == 0) {
          return a.expiredTime.compareTo(b.expiredTime);
        } else {
          return dateCompare;
        }
      });

      tasks = matchedTasks
          .map((task) => _mapOneTimeTask(task))
          .toList(growable: false);
    }

    return tasks;
  }

  OneTimeTaskDomainModel _mapOneTimeTask(OneTimeTaskFirebaseDataModel task) {
    return OneTimeTaskDomainModel(
      task.id,
      task.name,
      task.expiredHour,
      task.expiredMinute,
      task.expiredDay,
      task.expiredMonth,
      task.expiredYear,
    );
  }

  DailyTaskDomainModel _mapDailyTask(DailyTaskFirebaseDataModel task) {
    return DailyTaskDomainModel(
        task.id, task.name, task.expiredHour, task.expiredMinute);
  }

  @override
  Future<DailyTaskDetailDomainModel> getDailyTaskDetail(String taskId) async {
    DailyTaskDetailDomainModel taskDetailDomainModel;
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      DataSnapshot dataSnapshot = await _fireDatabaseController
          .getDailyTaskWithIdRef(uid, taskId)
          .once();
      if (dataSnapshot.value != null) {
        var eventFirebaseDataModel = DailyTaskFirebaseDataModel.from(
            dataSnapshot.key, dataSnapshot.value);
        taskDetailDomainModel = _mapDailyTaskDetail(eventFirebaseDataModel);
      }
    }
    return taskDetailDomainModel;
  }

  DailyTaskDetailDomainModel _mapDailyTaskDetail(
      DailyTaskFirebaseDataModel eventFirebaseDataModel) {
    DailyTaskDetailDomainModel taskDetailDomainModel;
    if (eventFirebaseDataModel != null) {
      taskDetailDomainModel = DailyTaskDetailDomainModel(
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

  Future<void> _createOnTimeTaskHistory(
      OneTimeTaskFirebaseDataModel task, int dateValue, String uid) async {
    var nowMilliseconds = _getNowMilliseconds();
    var doneTime = nowMilliseconds;
    var createdTime = nowMilliseconds;

    OneTimeTaskHistoryFirebaseDataModel eventHistoryFirebaseDataModel =
        OneTimeTaskHistoryFirebaseDataModel(
      task.id,
      task.name,
      doneTime,
      task.expiredHour,
      task.expiredMinute,
      task.expiredTime,
      task.expiredDay,
      task.expiredMonth,
      task.expiredYear,
      task.expiredDate,
      createdTime,
      dateValue,
      TaskStatusDataConstant.STATUS_TODO,
      true,
    );

    var pushTaskHistory =
        _fireDatabaseController.getOneTimeTaskHistoryRef(uid).push();
    await pushTaskHistory.set(eventHistoryFirebaseDataModel.toJson());
  }

  @override
  Future<void> createOneTimeTask(
      SaveOneTimeTaskDomainModel saveEventDataModel) async {
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      bool defaultEventEnable = true;
      var nowMilliseconds = _getNowMilliseconds();
      int createdTime = nowMilliseconds;
      int updatedTime = 0;
      int enableTimeStart = nowMilliseconds;
      int enableTimeEnd = 0;
      var taskTimeExpired = Util.calcTaskTimeExpired(
        saveEventDataModel.expiredHour,
        saveEventDataModel.expiredMinute,
      );

      var taskDateExpired = Util.calcTaskDateExpired(
        saveEventDataModel.expiredYear,
        saveEventDataModel.expiredMonth,
        saveEventDataModel.expiredDay,
      );

      OneTimeTaskFirebaseDataModel oneTimeTaskDataModel =
          OneTimeTaskFirebaseDataModel(
        saveEventDataModel.name,
        saveEventDataModel.expiredHour,
        saveEventDataModel.expiredMinute,
        taskTimeExpired,
        saveEventDataModel.expiredDay,
        saveEventDataModel.expiredMonth,
        saveEventDataModel.expiredYear,
        taskDateExpired,
        defaultEventEnable,
        enableTimeStart,
        enableTimeEnd,
        createdTime,
        updatedTime,
      );

      var uid = loginUser.uid;
      var pushTask = _fireDatabaseController.getOneTimeTaskRef(uid).push();
      oneTimeTaskDataModel.id = pushTask.key;
      await pushTask.set(oneTimeTaskDataModel.toJson());
      await _createOnTimeTaskHistory(
          oneTimeTaskDataModel, taskDateExpired, uid);
    }
  }

  @override
  Future<void> disableOneTimeEvent(
      DisableOneTimeTaskDomainModel disableEventDataModel) async {
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var oneTimeEventId = disableEventDataModel.oneTimeEventId;
      DataSnapshot oneTimeTaskData = await _fireDatabaseController
          .getOneTimeTaskWithIdRef(uid, oneTimeEventId)
          .once();
      if (oneTimeTaskData.value != null) {
        var nowMilliseconds = _getNowMilliseconds();
        var updateTime = nowMilliseconds;
        var enableTimeEnd = nowMilliseconds;
        await _fireDatabaseController
            .getOneTimeTaskWithIdRef(uid, oneTimeEventId)
            .update({
          "enable": false,
          "enableTimeEnd": enableTimeEnd,
          "updateTime": updateTime,
        });
        await _removeHistoryOneTimeTask(uid, oneTimeEventId);
      }
    }
  }

  Future<void> _removeHistoryOneTimeTask(
      String uid, String oneTimeEventId) async {
    DataSnapshot oneTimeTaskHistoryData = await _fireDatabaseController
        .getOneTimeTaskHistoryRef(uid)
        .orderByChild("oneTimeTaskId")
        .equalTo(oneTimeEventId)
        .once();
    if (oneTimeTaskHistoryData.value != null) {
      String historyKey = oneTimeTaskHistoryData.key;
      await _fireDatabaseController
          .getOneTimeTaskWithIdRef(uid, historyKey)
          .update({"enable": false});
    }
  }

  OneTimeTaskDetailDomainModel _mapOneTimeTaskDetail(
      OneTimeTaskFirebaseDataModel task) {
    OneTimeTaskDetailDomainModel taskDetailDomainModel;
    if (task != null) {
      taskDetailDomainModel = OneTimeTaskDetailDomainModel(
        task.name,
        task.expiredHour,
        task.expiredMinute,
        task.expiredDay,
        task.expiredMonth,
        task.expiredYear,
      );
    }
    return taskDetailDomainModel;
  }

  @override
  Future<OneTimeTaskDetailDomainModel> getOneTimeTaskDetail(String taskId) async {
    OneTimeTaskDetailDomainModel taskDetailDomainModel;
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      DataSnapshot dataSnapshot = await _fireDatabaseController
          .getOneTimeTaskWithIdRef(uid, taskId)
          .once();
      if (dataSnapshot.value != null) {
        var task = OneTimeTaskFirebaseDataModel.from(
            dataSnapshot.key, dataSnapshot.value);
        taskDetailDomainModel = _mapOneTimeTaskDetail(task);
      }
    }
    return taskDetailDomainModel;
  }

  @override
  Future<void> doneOneTimeTask(
      DoneOneTimeTaskDomainModel doneOneTimeTaskDomainModel) async {
    LoginUserFirebaseDataModel loginUser = await _getLoginUser();
    if (loginUser != null) {
      var uid = loginUser.uid;
      var historyId = doneOneTimeTaskDomainModel.historyId;
      DataSnapshot historyData = await _fireDatabaseController
          .getOneTimeTaskHistoryWithIdRef(uid, historyId)
          .once();
      if (historyData.value != null) {
        var findHistory = OneTimeTaskHistoryFirebaseDataModel.from(
            historyData.key, historyData.value);
        var nowMilliseconds = _getNowMilliseconds();
        var doneTime = nowMilliseconds;
        var status = _getOneTimeTaskDoneStatus(findHistory);
        var updateTime = nowMilliseconds;
        await _fireDatabaseController
            .getOneTimeTaskHistoryWithIdRef(uid, historyId)
            .update({
          "updateTime": updateTime,
          "doneTime": doneTime,
          "status": status,
        });
      }
    }
  }

  int _getOneTimeTaskDoneStatus(
      OneTimeTaskHistoryFirebaseDataModel findHistory) {
    int status = TaskStatusDataConstant.STATUS_DONE;
    var now = DateTime.now();
    var currentTime = Util.calcTaskTimeExpired(now.hour, now.minute);
    var taskExpiredTime = findHistory.expiredTime;
    if (currentTime > taskExpiredTime) {
      status = TaskStatusDataConstant.STATUS_DONE_LATE;
    }

    return status;
  }
}
