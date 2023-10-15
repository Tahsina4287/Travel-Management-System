SET LINESIZE 32767;

set serveroutput on;
set verify off;
ACCEPT X1   CHAR PROMPT "Enter your User ID  : "
ACCEPT X2   CHAR PROMPT "Enter your Name : "
ACCEPT X3   CHAR PROMPT "Enter your Location(First Letter Caps) : "

DECLARE
	u_id user1.U_ID%type;
	name user1.name%type;
	location user1.location%type;
BEGIN
	u_id := '&X1';
	name := '&X2';
	location := '&X3';

	IF location='Sylhet' THEN
		insert into user2 values(u_id,name,location);
	ELSIF location='Chittagong' THEN
		insert into user3@site_link values(u_id,name,location);
	ELSE
		insert into user1 values(u_id,name,location);
	END IF;
end;
/
commit;
select * from user2;
select * from user1;
select * from user3@site_link;
