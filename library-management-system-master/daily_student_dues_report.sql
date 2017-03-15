CREATE OR REPLACE PROCEDURE daily_student_dues_report
--http://127.0.0.1:8080/apex/lib_manager.daily_student_dues_report
AS
	       v_book_id		NUMBER(10);
	       v_book_name		VARCHAR2(100);
	       v_issue_date		DATE;
	       v_expected_return_date	DATE;
	       v_member_id		NUMBER(10);
	       v_first_name		VARCHAR2(100);
	CURSOR c_daily_student_dues_report
	IS
	SELECT  bd.book_id
	       ,book_name
	       ,issue_date
	       ,expected_return_date
	       ,md.member_id
	       ,first_name
	FROM    book_detail bd
	       ,member_detail md
	       ,issue_detail id
	WHERE   bd.book_id=id.book_id
	AND	id.member_id=md.member_id
	And	id.actual_return_date-expected_return_date>0;
BEGIN
	FOR i IN c_daily_student_dues_report
	LOOP
	page_formatting('BEFORE');
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
	page_formatting('AFTER');
	END LOOP;
END;
/
GRANT EXECUTE ON lib_manager.daily_student_dues_report TO ANONYMOUS;
SHOW ERROR;
