class HttpLinks {
  static const String baseUrl = 'http://192.168.1.21:83/api/';
 // static const String baseUrl = 'https://wasisoft.com/softwares/wsms/api/';

  static const String Url = '${baseUrl}students/';
  static const String loginUrl = '${baseUrl}student/signin';
  static const String parentLoginUrl = '${baseUrl}parent/signin';
  static const String profileUrl = '/profile';
  static const String subjectListUrl = '/subjects';
  static const String childrenUrl = 'parents/children';
  static const String testResultUrl = '/test-schedule';
  static const String timeTableUrl = '/time-table';
  static const String dailyDiaryUrl = '/daily-diary';
  static const String monthlyExamReportUrl = '/monthly-test-report?month=00';
  static const String monthlyTestScheduleUrl = '/monthly-test-schedule';
  static const String AttendanceUrl = '/attendance';
  static const String SchoolInfoUrl = 'school-info';
  static const String OnlineClassUrl = '/online-classes';
  static const String leaveAppUrl = '/leave-applications';
  static const String complainAppUrl = '/complain-applications';
  static const String updateAppUrl = '${baseUrl}parents/update-session';
  static const String signOutUrl = '${baseUrl}parents/signout';
}

