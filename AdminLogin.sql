SET LINESIZE 32767;

SET SERVEROUTPUT ON;
set verify off;

ACCEPT X1   CHAR PROMPT "Enter your User ID  : "
---------------IN PARAMETER----------------------


	
CREATE OR REPLACE PROCEDURE Login(id IN AdminTable.U_ID%type)
IS

BEGIN
	FOR R IN (SELECT * FROM AdminTable) LOOP
		IF (id = R.u_id AND id = '10') THEN 
			DBMS_OUTPUT.PUT_LINE('Do Admin Work');
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Your id not found');
		END IF;
		
	END LOOP;
END Login;
/

DECLARE
	id AdminTable.U_ID%type;
BEGIN
	id :='&X1';
	Login(id);
END;
/
commit;