CREATE OR REPLACE PROCEDURE book_status_report
--http://127.0.0.1:8080/apex/lib_manager.book_status_report
AS
	       v_book_id		NUMBER(10);
	       v_book_name		VARCHAR2(100);
	       v_issue_date		DATE;
	       v_expected_return_date	DATE;
	       v_member_id		NUMBER(10);
	       v_first_name		VARCHAR2(100);
	CURSOR c_book_status_report
	IS
	SELECT * FROM book_status_v;
BEGIN
	page_formatting('BEFORE');
	FOR i IN c_book_status_report
	LOOP
	       v_book_id		:=	i.book_id;
	       v_book_name		:=	i.book_name;
	       v_issue_date		:=	i.issue_date;
	       v_expected_return_date	:=	i.expected_return_date;
	       v_member_id		:=	i.member_id;
	       v_first_name		:=	i.first_name;
	HTP.P(v_book_id
       ||' '||v_book_name
       ||' '||v_issue_date
       ||' '||v_expected_return_date
       ||' '||v_member_id
       ||' '||v_first_name);
       HTP.P('<BR>');
	END LOOP;
	page_formatting('AFTER');
END;
/
GRANT EXECUTE ON lib_manager.book_status_report TO ANONYMOUS;
SHOW ERROR;
