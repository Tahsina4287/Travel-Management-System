SET LINESIZE 32767;

SET SERVEROUTPUT ON;
set verify off;

create or replace view myview as 
select * from available1 union select *from available2@site_link;

create or replace view myuserview as 
select * from user1 union select *from user3@site_link union select * from user2;

ACCEPT X1   CHAR PROMPT "Enter your User ID  : "
---------------IN PARAMETER----------------------

CREATE OR REPLACE PROCEDURE Show(id IN user1.U_ID%type)
IS

BEGIN
	DBMS_OUTPUT.PUT_LINE('Showing Available trips');
	FOR R IN (SELECT * FROM myview) LOOP
		DBMS_OUTPUT.PUT_LINE('Trip id: ' || R.A_ID);
		DBMS_OUTPUT.PUT_LINE('Source: ' || R.SOURCE);
		DBMS_OUTPUT.PUT_LINE('Destination: ' || R.DESTINATION);
		DBMS_OUTPUT.PUT_LINE('Date of booking : ' || R.DATEOFBOOK);
		DBMS_OUTPUT.PUT_LINE('Amount: ' || R.AMOUNT);
		DBMS_OUTPUT.PUT_LINE(chr(13)||chr(10));
	END LOOP;
END Show;
/

	
CREATE OR REPLACE PROCEDURE Login(id IN user1.U_ID%type)
IS

BEGIN
	FOR R IN (SELECT * FROM myuserview) LOOP
		IF (id = R.u_id AND id != '10') THEN 
			DBMS_OUTPUT.PUT_LINE('Login successful');
			Show(id);
		ELSE 
			DBMS_OUTPUT.PUT_LINE('User not found');
		END IF;
		
	END LOOP;
END Login;
/

DECLARE
	id user1.U_ID%type;
BEGIN
	id :='&X1';
	Login(id);
END;
/
commit;