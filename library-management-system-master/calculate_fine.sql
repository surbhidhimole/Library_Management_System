CREATE OR REPLACE FUNCTION calculate_fine (p_book_id IN NUMBER
				          ,p_member_id IN NUMBER)
RETURN NUMBER
AS
	v_fine		NUMBER(10);
	
BEGIN
	SELECT	(TRUNC(SYSDATE)-TRUNC(expected_return_date))*5
	INTO	v_fine
	FROM	issue_detail
	WHERE	book_id=p_book_id
	AND	member_id=p_member_id
	AND	actual_return_date IN NULL;

	RETURN v_fine;

EXCEPTION
	WHEN	NO_DATA_FOUND
	THEN	DBMS_OUTPUT.PUT_LINE(SQLCODE||' '||SQLERRM);
		RETURN NULL;

END;
/