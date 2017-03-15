CREATE OR REPLACE PROCEDURE reports
--http://127.0.0.1:8080/apex/lib_manager.contact_us
AS
BEGIN
	page_formatting('BEFORE');
	HTP.P('<li><a href="lib_manager.book_status_report">BOOK STATUS REPORT</a></li>');
	HTP.P('<BR>');
	HTP.P('<li><a href="lib_manager.daily_student_dues_report">DAILY STUDENT DUES REPORT</a></li>');
	page_formatting('AFTER');
END;
/
GRANT EXECUTE ON lib_manager.reports TO ANONYMOUS;
SHOW ERROR;
