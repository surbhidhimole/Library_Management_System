CREATE OR REPLACE PROCEDURE about_us
--http://127.0.0.1:8080/apex/lib_manager.about_us
AS
BEGIN
	page_formatting('BEFORE');
	HTP.P('student');
	page_formatting('AFTER');
END;
/
GRANT EXECUTE ON lib_manager.about_us TO ANONYMOUS;
SHOW ERROR;
