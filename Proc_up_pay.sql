SET LINESIZE 32767;

SET SERVEROUTPUT ON;
set verify off;

create or replace view myview4 as 
select * from payment1 union select *from payment2@site_link union select * from payment3;
create or replace view myview5 as 
select * from booked1 natural join booked2@site_link;

ACCEPT X2   CHAR PROMPT "DO you want to confirm or cancel the Payment? : "
ACCEPT X3   NUMBER PROMPT "Enter Your book Id : "
---------------IN PARAMETER----------------------

CREATE OR REPLACE PROCEDURE Cancelpay(pay IN payment1.STATUS%type,bid IN payment1.B_ID%type)
IS
	amount available1.AMOUNT%type;
	pid payment1.P_ID%type;
	aid available1.A_ID%type;
	m payment1.METHOD%type;
	ui user1.U_ID%type;

BEGIN
	select P_ID,U_ID,A_ID,AMOUNT, METHOD into 
	pid,ui,aid,amount,m FROM myview4 WHERE B_ID = bid;
	delete from booked1 where B_ID = bid;
	delete from booked2@site_link where B_ID = bid;
	delete from payment3  where B_ID = bid;
	delete from payment1  where B_ID = bid;
	delete from payment2@site_link  where B_ID = bid;
	
END Cancelpay;
/

CREATE OR REPLACE PROCEDURE Confirmpay(pay IN payment1.STATUS%type,bid IN payment1.B_ID%type)
IS
	amount available1.AMOUNT%type;
	pid payment1.P_ID%type;
	aid available1.A_ID%type;
	m payment1.METHOD%type;
	ui user1.U_ID%type; 

BEGIN
	select P_ID,U_ID,A_ID,AMOUNT, METHOD into 
	pid,ui,aid,amount,m FROM myview4 WHERE B_ID = bid;
	IF m = 'Bkash' THEN
		update payment1 set STATUS = pay where P_ID = pid;
	ELSIF m = 'Nagad' THEN
		update payment3 set STATUS = pay where P_ID = pid;
	ELSE
		update payment2@site_link set STATUS = pay where P_ID = pid;
	END IF;
	
END Confirmpay;
/

DECLARE
	pay payment1.STATUS%type;
	bid payment1.B_ID%type;
BEGIN
	pay := '&X2';
	bid := &X3;
	IF pay = 'confirm' THEN
		Confirmpay(pay,bid);
	ELSIF pay = 'cancel' THEN
		Cancelpay(pay,bid);
	END IF;
END;
/

select * from booked1 natural join booked2@site_link;
select * from payment1 union select *from payment2@site_link union select * from payment3;
commit;