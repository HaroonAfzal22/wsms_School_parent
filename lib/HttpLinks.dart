class HttpLinks {
  static const String _localUrl = 'http://192.168.1.15:83/api/';
 // static const String _localUrl ='https://03a9-39-37-173-242.ngrok.io/api/';
  static const String _globalLocalUrl = 'https://wasisoft.com/softwares/wsms/api/';

  static const String _baseLocalUrl = _globalLocalUrl;

  static const String Url = '${_baseLocalUrl}students/';
  static const String loginUrl = '${_baseLocalUrl}student/signin';
  static const String parentLoginUrl = '${_baseLocalUrl}parent/signin';
  static const String profileUrl = '/profile';
  static const String subjectListUrl = '/subjects';
  static const String testResultUrl = '/test-schedule';
  static const String timeTableUrl = '/time-table';
  static const String monthlyExamReportUrl = '/monthly-test-report?month=00';
  static const String monthlyTestScheduleUrl = '/monthly-test-schedule';
  static const AttendanceUrl = '/attendance';

}
