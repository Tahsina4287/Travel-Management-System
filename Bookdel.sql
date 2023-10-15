SET LINESIZE 32767;

set serveroutput on;
set verify off;


ACCEPT X13   NUMBER PROMPT "Enter The Trip ID for deletion : "
DECLARE
	id NUMBER;
BEGIN
	id := &x13;
	delete from booked1 where B_ID = id;
	delete from booked2@site_link where B_ID = id;
	
	delete from payment3  where B_ID = id;
	delete from payment1  where B_ID = id;
	delete from payment2@site_link  where B_ID = id;
END;
/
select * from booked1;
select * from booked2@site_link;
select * from Payment1;
select * from Payment2@site_link;
select * from Payment3;
commit;