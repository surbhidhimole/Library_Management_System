CONNECT lib_manager/05031992@xe;
CREATE OR REPLACE PACKAGE BODY lib_mgmt
AS
	PROCEDURE book_issue_return(p_book_id    IN  NUMBER
				   ,p_member_id  IN NUMBER
				   ,p_mode       IN VARCHAR2
				   )
	AS
		v_issue_count   NUMBER(10);
		v_book_count    NUMBER(10);
		v_member_count  NUMBER(10);
	BEGIN
	page_formatting('BEFORE');
		IF UPPER(p_mode) ='ISSUE'
		THEN
			SELECT  count(*)
			INTO    v_issue_count
			FROM    issue_detail
			WHERE   member_id=p_member_id
			AND     actual_return_date IS NULL;

			SELECT  count(*) 
			INTO    v_book_count
			FROM    book_detail
			WHERE   book_id=p_book_id
			AND     status='AVAILABLE';

			SELECT count(*) 
			INTO   v_member_count
			FROM   member_detail
			WHERE  member_id=p_member_id;

			HTP.P('ISSUE COUNT  ='   || v_issue_count)  ;
			HTP.P('BOOK COUNT   ='   || v_book_count)   ;
			HTP.P('MEMBER COUNT = '  || v_member_count) ;
		IF     v_issue_count <2
		AND    v_book_count >0
		AND    v_member_count >0
		THEN
			INSERT INTO issue_detail(issue_id              
						,book_id               
						,member_id            
						,issue_date           
						,expected_return_date  
						,actual_return_date    
						,creation_date          
						,created_by           
						,last_updated_date     
						,last_updated_by        
						) 
			VALUES			(issue_id_seq.NEXTVAL
						,p_book_id
						,p_member_id
						,SYSDATE
						,SYSDATE + 15
						,NULL
						,SYSDATE
						,USER
						,SYSDATE
						,USER
						);
			UPDATE    book_detail
			SET       status   ='NOT AVAILABLE'
				 ,last_updated_date = SYSDATE
				 ,last_updated_by   = USER
			WHERE     book_id=p_book_id ;

		ELSE
			HTP.P('book not issued');
		END IF ;
		commit ;

		ELSIF     UPPER(p_mode)             =  'RETURN'
		THEN
			UPDATE    book_detail
			SET       status             =  'AVAILABLE'
				 ,last_updated_date  =   SYSDATE
				 ,last_updated_by    =   USER
			WHERE     book_id=p_book_id  ;

		IF SQL%NOTFOUND
		THEN 
			HTP.P('invalid book id');
		END IF;

			UPDATE    issue_detail
			SET       actual_return_date =   SYSDATE
				 ,last_updated_date  =   SYSDATE
				 ,last_updated_by    =   USER
			WHERE     book_id            = p_book_id
			AND       member_id          = p_member_id     ;
		IF SQL%FOUND
		THEN  
			HTP.P('book returned');
		ELSIF SQL%NOTFOUND
		THEN
			HTP.P('book  not returned');
		END IF;

		ELSE      HTP.P('invalid mode') ;
	END IF;
	commit;
	page_formatting('AFTER');
	EXCEPTION 
	WHEN NO_DATA_FOUND
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN TOO_MANY_ROWS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN OTHERS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	END;

	PROCEDURE enter_and_maintain_books(p_book_id           IN      VARCHAR2
					  ,p_book_name         IN      VARCHAR2
					  ,p_author            IN      VARCHAR2 
					  ,p_publisher         IN      VARCHAR2 
					  ,p_purchase_date     IN      DATE
					  ,p_purchase_price    IN      NUMBER
					  ,p_book_category_id  IN      VARCHAR2 
					  ,p_mode              IN      VARCHAR2    
					  )
	AS
		v_old_book_name			VARCHAR2(50);    
		v_old_author			VARCHAR2(50);
		v_old_publisher			VARCHAR2(50);
		v_old_purchase_date		DATE;
		v_old_purchase_price		NUMBER(10);
		v_old_book_category_id		VARCHAR2 (50);

	BEGIN
	page_formatting('BEFORE');
		IF UPPER(p_mode) = 'INSERT'
		THEN
			INSERT INTO book_detail (book_id
						,book_name
						,author
						,publisher
						,purchase_date
						,purchase_price
						,book_category_id
						,status
						,creation_date
						,created_by
						,last_updated_date
						,last_updated_by
						 )
			VALUES			(book_id_seq.NEXTVAL
						,UPPER(p_book_name)
						,UPPER(p_author)
						,UPPER(p_publisher)
						,UPPER(p_purchase_date)
						,p_purchase_price
						,UPPER(p_book_category_id)
						,'AVAILABLE'
						,SYSDATE
						,USER
						,SYSDATE
						,USER
						);

		ELSIF UPPER(p_mode) ='UPDATE'
		THEN

			SELECT	 book_name
				,author
				,publisher
				,purchase_date
				,purchase_price
				,book_category_id
			INTO 
				 v_old_book_name
				,v_old_author
				,v_old_publisher
				,v_old_purchase_date
				,v_old_purchase_price
				,v_old_book_category_id
			FROM	 book_detail
			WHERE	 book_id = p_book_id;

			UPDATE	 book_detail
			SET	 book_name          = NVL(p_book_name        ,v_old_book_name) 
				,author             = NVL(p_author           ,v_old_author)
				,publisher          = NVL(p_publisher        ,v_old_publisher)
				,purchase_date      = NVL(p_purchase_date    ,v_old_purchase_date)
				,purchase_price     = NVL(p_purchase_price   ,v_old_purchase_price)
				,book_category_id   = NVL(p_book_category_id ,v_old_book_category_id)
				,last_updated_date  = SYSDATE
				,last_updated_by    = USER
			WHERE	 book_id            = p_book_id;
		ELSE	HTP.P('invalid mode');

		END IF;
	page_formatting('AFTER');
	EXCEPTION 
	WHEN NO_DATA_FOUND
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN TOO_MANY_ROWS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN OTHERS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	commit;
	END;

	PROCEDURE enter_and_maintain_members(p_member_id		IN	NUMBER
					    ,p_first_name		IN	VARCHAR2
					    ,p_last_name		IN	VARCHAR2
					    ,p_contact_no		IN	NUMBER
					    ,p_email			IN	VARCHAR2
					    ,p_date_of_birth		IN	DATE
					    ,p_effective_start_date	IN	DATE
					    ,p_effective_end_date	IN	DATE
					    ,p_mode			IN	VARCHAR2
		)
	AS

	v_old_first_name         VARCHAR2(100);             
	v_old_last_name          VARCHAR2 (100); 
	v_old_contact_no         NUMBER(10);
	v_old_email              VARCHAR2(100) ; 
	v_old_date_of_birth      DATE;
	v_old_effective_start_date DATE;
	v_old_effective_end_date  DATE;


	BEGIN
	page_formatting('BEFORE');
	IF UPPER( p_mode)='INSERT'
	THEN 

	IF p_effective_start_date<=p_effective_end_date
	THEN 


	INSERT INTO member_detail(member_id           
	,first_name         
	,last_name           
	,contact_no          
	,email               
	,date_of_birth        
	,effective_start_date 
	,effective_end_date   
	,creation_date        
	,created_by           
	,last_updated_date   
	,last_updated_by      
	)
	VALUES                  (member_id_seq.NEXTVAL
	,UPPER(p_first_name)
	,UPPER(p_last_name)
	,p_contact_no
	,UPPER(p_email)
	,p_date_of_birth
	,p_effective_start_date
	,p_effective_end_date
	,SYSDATE
	,USER
	,SYSDATE
	,USER
	);
	commit;
	ELSE HTP.P('invalid start end date');
	END IF;
	ELSIF UPPER( p_mode)='UPDATE'
	THEN
	SELECT      first_name                     
	,last_name           
	,contact_no           
	,email                
	,date_of_birth      
	,effective_start_date 
	,effective_end_date
	INTO        v_old_first_name                     
	,v_old_last_name           
	,v_old_contact_no           
	,v_old_email                
	,v_old_date_of_birth      
	,v_old_effective_start_date 
	,v_old_effective_end_date
	FROM member_detail
	WHERE      member_id            =    p_member_id;
	UPDATE      member_detail
	SET         first_name           =  NVL  (p_first_name, v_old_first_name)           
	,last_name            =  NVL ( p_last_name,v_old_last_name)
	,contact_no           =    NVL( p_contact_no,v_old_contact_no)
	,email                =  NVL ( p_email ,v_old_email  )
	,date_of_birth        =   NVL (p_date_of_birth,v_old_date_of_birth )
	,effective_start_date =   NVL (p_effective_start_date,v_old_effective_start_date )
	,effective_end_date   =   NVL (p_effective_end_date  ,v_old_effective_end_date)
	,last_updated_date    =    SYSDATE
	,last_updated_by      =    USER
	WHERE      member_id            =    p_member_id;
	ELSE       HTP.P('invalid mode');
	END IF;
	commit;
	page_formatting('AFTER');
	EXCEPTION 
	WHEN NO_DATA_FOUND
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN TOO_MANY_ROWS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN OTHERS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	END;


	PROCEDURE enter_and_maintain_address(p_member_id	IN	NUMBER
					    ,p_address_line_1	IN	VARCHAR2 
					    ,p_address_line_2	IN	VARCHAR2
					    ,p_address_line_3	IN	VARCHAR2
					    ,p_city		IN	VARCHAR2
					    ,p_pin_code		IN	NUMBER
					    ,p_state		IN	VARCHAR2
					    ,p_country		IN	VARCHAR2
					    ,p_address_type	IN	VARCHAR2
					    ,p_mode		IN	VARCHAR2
					    )
	AS
		v_old_address_line_1        VARCHAR2 (60);
		v_old_address_line_2        VARCHAR2 (60);
		v_old_address_line_3        VARCHAR2 (60);
		v_old_city                  VARCHAR2 (60);
		v_old_pin_code               NUMBER(10);
		v_old_state                 VARCHAR2(60) ;
		v_old_country               VARCHAR2 (60);


	BEGIN
	page_formatting('BEFORE');
	IF UPPER(p_mode) ='INSERT'
	THEN
		INSERT INTO address_detail(member_id
					  ,address_line_1
					  ,address_line_2
					  ,address_line_3
					  ,city
					  ,pin_code
					  ,state
					  ,country
					  ,address_type
					  ,creation_date
					  ,created_by
					  ,last_updated_date
					  ,last_updated_by
					   )
		VALUES			  (p_member_id
					  ,UPPER(p_address_line_1)
					  ,UPPER(p_address_line_2)
					  ,UPPER(p_address_line_3)
					  ,UPPER(p_city)
					  ,UPPER(p_pin_code)
					  ,UPPER(p_state)
					  ,UPPER(p_country)
					  ,UPPER(p_address_type)
					  ,SYSDATE
					  ,USER
					  ,SYSDATE
					  ,USER
					  );
	ELSIF UPPER(p_mode) ='UPDATE'
	THEN
		SELECT   address_line_1      
			,address_line_2     
			,address_line_3     
			,city               
			,pin_code          
			,state               
			,country
		INTO     v_old_address_line_1      
			,v_old_address_line_2     
			,v_old_address_line_3     
			,v_old_city               
			,v_old_pin_code          
			,v_old_state               
			,v_old_country
		FROM	 address_detail
		WHERE	 member_id	=	p_member_id
		AND	 address_type	=	p_address_type;
		
		UPDATE  address_detail
		SET	address_line_1		=	NVL(p_address_line_1 ,v_old_address_line_1 ) 
			,address_line_2		=	NVL(p_address_line_2 ,v_old_address_line_2  )  
			,address_line_3		=	NVL(p_address_line_3 ,v_old_address_line_3  )
			,city			=	NVL(p_city           ,v_old_city  )
			,pin_code		=	NVL(p_pin_code       ,v_old_pin_code) 
			,state			=	NVL(p_state          ,v_old_state  ) 
			,country		=	NVL(p_country        ,v_old_country) 
			,last_updated_date	=	SYSDATE
			,last_updated_by	=	USER
		WHERE	 member_id		=	p_member_id
		AND	 address_type		=	p_address_type   ;
	ELSE
		HTP.P('invalid mode');
	END IF;
	page_formatting('AFTER');					      
	EXCEPTION 
	WHEN NO_DATA_FOUND
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN TOO_MANY_ROWS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	WHEN OTHERS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);						       
	END;

	FUNCTION calculate_fine (p_book_id   IN NUMBER
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
		AND	actual_return_date is NULL;
		
		IF v_fine > 0
		THEN
			RETURN v_fine;
		ELSE
			RETURN 0;
		END IF;
	EXCEPTION 
	WHEN OTHERS
	THEN HTP.P(SQLCODE ||' '|| SQLERRM);
	RETURN NULL;
	END;

	PROCEDURE get_fine		(p_book_id	IN	NUMBER
					,p_member_id	IN	NUMBER
					)
	AS
		v_fine		NUMBER(10);
	BEGIN
	page_formatting('BEFORE');
		v_fine	:=	calculate_fine(p_book_id,p_member_id);
		HTP.P(v_fine);
	page_formatting('AFTER');	
	END;
END;
/
GRANT EXECUTE ON lib_manager.lib_mgmt TO ANONYMOUS;
SHOW ERROR;
