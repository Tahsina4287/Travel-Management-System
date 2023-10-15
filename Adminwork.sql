SET LINESIZE 32767;

set serveroutput on;
set verify off;

create or replace view myuserview6 as 
select * from available1 union select *from available2@site_link;

ACCEPT X4   NUMBER PROMPT "Enter Trip ID  : "
ACCEPT X6   CHAR PROMPT "Enter Starting point : "
ACCEPT X7   CHAR PROMPT "Enter Destination : "
ACCEPT X9   NUMBER PROMPT "Enter Estimated Expense : "

CREATE OR REPLACE PROCEDURE entry(aid IN available1.A_ID%type, amount IN available1.amount%type,src AVAILABLE1.SOURCE%type, dst AVAILABLE1.DESTINATION%type, dtbook AVAILABLE1.DATEOFBOOK%type)
IS

BEGIN
	IF amount >= 2000 THEN
		insert into  AVAILABLE1 VALUES(aid,src,dst,dtbook,amount);
	ELSE
		insert into  AVAILABLE2@site_link VALUES(aid,src,dst,dtbook,amount);
	END IF;
END entry;
/

DECLARE
	aid AVAILABLE1.A_ID%type;
	src AVAILABLE1.SOURCE%type;
	dst AVAILABLE1.DESTINATION%type;
	dtbook AVAILABLE1.DATEOFBOOK%type;
	amount AVAILABLE1.AMOUNT%type;
	userDefException EXCEPTION;
BEGIN
	
	aid := &X4;
	src := '&X6';
	dst := '&X7';
	dtbook := SYSDATE+3;
	amount := &X9;
		IF (aid > 0 AND amount > 0) THEN 
			entry(aid, amount, src, dst, dtbook);
		ELSE
			RAISE userDefException;
		END IF;
EXCEPTION
	WHEN userDefException THEN
		DBMS_OUTPUT.PUT_LINE('Invalid Amount or available ID or Does not exist');
	
end;
/
commit;

select * from user1;
select * from user2;
select * from user3@site_link;
select * from booked1;
select * from booked2@site_link;
select * from available1;
select * from available2@site_link;
select * from Payment1;
select * from Payment2@site_link;
select * from Payment3;


