CONNECT lib_manager/05031992@xe;

DROP SEQUENCE member_id_seq;
DROP SEQUENCE book_id_seq;
DROP SEQUENCE issue_id_seq;

DROP TABLE issue_detail;
DROP TABLE member_detail;
DROP TABLE book_detail;
DROP TABLE address_detail;

CREATE SEQUENCE member_id_seq
START WITH 1001
INCREMENT BY 1
NOCYCLE
NOCACHE
MAXVALUE 9999;

CREATE SEQUENCE book_id_seq
START WITH 101
INCREMENT BY 1
NOCYCLE
NOCACHE
MAXVALUE 999;

CREATE SEQUENCE issue_id_seq
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE
MAXVALUE 99999;

CREATE TABLE  member_detail(member_id            NUMBER(10) PRIMARY KEY
                           ,first_name           VARCHAR2(100)
                           ,last_name            VARCHAR2(100)
                           ,contact_no           NUMBER(10)
                           ,email                VARCHAR2(100)
                           ,date_of_birth        DATE
                           ,effective_start_date DATE
                           ,effective_end_date   DATE
                           ,creation_date        DATE
                           ,created_by           VARCHAR2(100)
                           ,last_updated_date    DATE
                           ,last_updated_by      VARCHAR2(100)
                            );

CREATE TABLE  book_detail  (book_id              NUMBER(10) PRIMARY KEY
                           ,book_name            VARCHAR2(100)
                           ,author               VARCHAR2(100)
                           ,publisher            VARCHAR2(100)
                           ,purchase_date        DATE
                           ,purchase_price       NUMBER(10,2)
                           ,book_category_id     VARCHAR2(100)
                           ,status               VARCHAR2(100)
                           ,creation_date        DATE
                           ,created_by           VARCHAR2(100)
                           ,last_updated_date    DATE
                           ,last_updated_by      VARCHAR2(100)
                           );

CREATE TABLE issue_detail(issue_id               NUMBER(10) PRIMARY KEY
                         ,book_id                NUMBER(10) CONSTRAINT book_id_fk REFERENCES book_detail(book_id)
                         ,member_id              NUMBER(10) CONSTRAINT member_id_fk REFERENCES member_detail(member_id)
                         ,issue_date             DATE
                         ,expected_return_date   DATE
                         ,actual_return_date     DATE
                         ,creation_date          DATE
                         ,created_by             VARCHAR2(100)
                         ,last_updated_date      DATE
                         ,last_updated_by        VARCHAR2(100)
                        );

CREATE TABLE address_detail(member_id            NUMBER(10)
                           ,address_line_1       VARCHAR2(100) 
                           ,address_line_2       VARCHAR2(100)
                           ,address_line_3       VARCHAR2(100)
                           ,city                 VARCHAR2(50)
                           ,pin_code             NUMBER(10)
                           ,state                VARCHAR2(50)
                           ,country              VARCHAR2(100)
                           ,address_type         VARCHAR2(50)
                           ,creation_date        DATE
                           ,created_by           VARCHAR2(100)
                           ,last_updated_date    DATE
                           ,last_updated_by      VARCHAR2(100)
                           ,CONSTRAINTS add_comp_pk PRIMARY KEY(member_id,address_type)
                           );

CREATE OR REPLACE VIEW book_status_v
AS
SELECT      bd.book_id			book_id
           ,book_name			book_name
           ,issue_date			issue_date
           ,expected_return_date	expected_return_date
           ,md.member_id		member_id
           ,first_name			first_name
FROM	    book_detail bd
           ,member_detail md
           ,issue_detail id
WHERE  bd.book_id=id.book_id
AND        id.member_id=md.member_id
AND        id.actual_return_date IS NULL;

INSERT INTO member_detail  (member_id           
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
VALUES                     (member_id_seq.NEXTVAL
                           ,'Anamika'
                           ,'Jain'
                           ,9425475881
                           ,'anamika@gmail.com'
                           ,'12-jan-1994'
                           ,SYSDATE
                           ,SYSDATE + 365
                           ,SYSDATE
                           ,USER
                           ,SYSDATE
                           ,USER
                           );

INSERT INTO member_detail(  member_id            
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
VALUES                     (member_id_seq.NEXTVAL
                           ,'Ankita'
                           ,'rai'
                           ,9425475882
                           ,'anki@gmail.com'
                           ,'16-feb-1994'
                           ,SYSDATE
                           ,SYSDATE + 365
                           ,SYSDATE
                           ,USER
                           ,SYSDATE
                           ,USER
                           );

INSERT INTO member_detail(  member_id           
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
VALUES                     (member_id_seq.NEXTVAL
                           ,'karan'
                           ,'patel'
                           ,9425475878
                           ,'karan@gmail.com'
                           ,'19-june-1989'
                           ,SYSDATE
                           ,SYSDATE + 365
                           ,SYSDATE
                           ,USER
                           ,SYSDATE
                           ,USER
                           );

INSERT INTO member_detail(  member_id            
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
VALUES                     (member_id_seq.NEXTVAL
                           ,'kopal'
                           ,'Sahu'
                           ,9425475890
                           ,'kopal@gmail.com'
                           ,'12-jan-1978'
                           ,SYSDATE
                           ,SYSDATE + 365
                           ,SYSDATE
                           ,USER
                           ,SYSDATE
                           ,USER
                           );

INSERT INTO member_detail(  member_id            
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
VALUES                     (member_id_seq.NEXTVAL
                           ,'Aman'
                           ,'Agrawal'
                           ,9425475800
                           ,'aman@gmail.com'
                           ,'12-may-1994'
                           ,SYSDATE
                           ,SYSDATE + 365
                           ,SYSDATE
                           ,USER
                           ,SYSDATE
                           ,USER
                           );

INSERT INTO book_detail  (book_id             
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
VALUES                   (book_id_seq.NEXTVAL
                        ,'balaguruswamy'
                        ,'d.k das'
                        ,'shivani'
                        ,SYSDATE
                        ,200
                        ,'computer'
                        ,'AVAILABLE'
                        ,SYSDATE
                        ,USER
                        ,SYSDATE
                        ,USER
                        );

INSERT INTO book_detail  (book_id            
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
VALUES                   (book_id_seq.NEXTVAL
                        ,'balaguruswamy'
                        ,'d.p das'
                        ,'shivani'
                        ,SYSDATE
                        ,200
                        ,'mechanical'
                        ,'AVAILABLE'
                        ,SYSDATE
                        ,USER
                        ,SYSDATE
                        ,USER
                        );

INSERT INTO book_detail  (book_id            
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
VALUES                 (book_id_seq.NEXTVAL
                        ,'balaguruswamy'
                        ,'d.k jain'
                        ,'shivani'
                        ,SYSDATE
                        ,200
                        ,'computer'
                        ,'AVAILABLE'
                        ,SYSDATE
                        ,USER
                        ,SYSDATE
                        ,USER
                        );

INSERT INTO book_detail  (book_id             
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
VALUES                   (book_id_seq.NEXTVAL
                        ,'balaguruswamy'
                        ,'s  das'
                        ,'shivani'
                        ,SYSDATE
                        ,200
                        ,'computer'
                        ,'AVAILABLE'
                        ,SYSDATE
                        ,USER
                        ,SYSDATE
                        ,USER
                        );

INSERT INTO book_detail(  book_id            
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
VALUES                    (book_id_seq.NEXTVAL
                        ,'balaguruswamy'
                        ,'s chand'
                        ,'shivani'
                        ,SYSDATE
                        ,200
                        ,'computer'
                        ,'AVAILABLE'
                        ,SYSDATE
                        ,USER
                        ,SYSDATE
                        ,USER
                        );

INSERT INTO  issue_detail(issue_id               
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
VALUES                  (ISSUE_ID_SEQ.NEXTVAL
                        ,101
                        ,1001
                        ,sysdate-30
                        ,SYSDATE-15
                        ,NULL
                        ,sysdate
                        ,user
                        ,sysdate
                        ,user
                        );

INSERT INTO  issue_detail(issue_id               
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
VALUES                  (ISSUE_ID_SEQ.NEXTVAL
                        ,103
                        ,1003
                        ,sysdate-30
                        ,SYSDATE-20
                        ,NULL
                        ,sysdate
                        ,user
                        ,sysdate
                        ,user
                        );

COMMIT;
