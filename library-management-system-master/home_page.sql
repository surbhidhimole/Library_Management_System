CREATE OR REPLACE PROCEDURE home_page
--http://127.0.0.1:8080/apex/lib_manager.home_page
AS
BEGIN
	page_formatting('BEFORE');
	HTP.P('HOME');
	page_formatting('AFTER');
END;
/
GRANT EXECUTE ON lib_manager.home_page TO ANONYMOUS;
SHOW ERROR;
