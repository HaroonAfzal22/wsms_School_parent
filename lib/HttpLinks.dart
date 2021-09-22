class HttpLinks {
  static const String localUrl = 'http://192.168.1.21:83/api/';
  //static const String _localUrl ='https://066d-72-255-51-41.ngrok.io/api/';
  static const String globalUrl = 'https://wasisoft.com/softwares/wsms/api/';
  static const String _baseUrl =localUrl;
  static const String Url = '${_baseUrl}students/';
  static const String loginUrl = '${_baseUrl}student/signin';
  static const String parentLoginUrl = '${_baseUrl}parent/signin';
  static const String profileUrl = '/profile';
  static const String subjectListUrl = '/subjects';
  static const String testResultUrl = '/test-schedule';
  static const String timeTableUrl = '/time-table';
  static const String dailyDiaryUrl = '/daily-diary';
  static const String monthlyExamReportUrl = '/monthly-test-report?month=00';
  static const String monthlyTestScheduleUrl = '/monthly-test-schedule';
  static const String AttendanceUrl = '/attendance';
  static const String SchoolInfoUrl = 'school-info';
  static const String OnlineClassUrl = '/online-classes';
  static const String leaveAppUrl = '/leave-applications';

}
