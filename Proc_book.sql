SET LINESIZE 32767;

SET SERVEROUTPUT ON;
set verify off;

create or replace view myview2 as 
select * from available1 union select * from available2@site_link;

ACCEPT X1   NUMBER PROMPT "Enter Trip ID you want to book : "
ACCEPT X2   CHAR PROMPT "Payment method you want to use : "
ACCEPT X3   CHAR PROMPT "Enter your user id : "
ACCEPT X4   NUMBER PROMPT "Total Person : "
---------------IN PARAMETER----------------------
CREATE OR REPLACE FUNCTION calculateAmount(amount IN available1.AMOUNT%type,person IN booked1.person%type)
RETURN NUMBER
IS
	total available1.AMOUNT%type;
BEGIN
    total  := amount*person;
	RETURN total;
	
END calculateAmount;
/

CREATE OR REPLACE PROCEDURE paymentcomplete(pid IN payment1.P_ID%type, ui IN user1.U_ID%type, aid IN available1.A_ID%type,bid IN booked1.B_ID%type, Totalamount IN available1.AMOUNT%type, pay IN payment1.METHOD%type , s IN payment1.STATUS%type )
IS

BEGIN
	IF pay = 'Bkash'THEN
		insert into  PAYMENT1 VALUES (pid,ui,aid,bid,Totalamount,pay,s);
	ELSIF pay = 'Nagad' THEN
		insert into  payment3 VALUES (pid,ui,aid,bid,Totalamount,pay,s);
	ELSE 
		insert into  payment2@site_link VALUES (pid,ui,aid,bid,Totalamount,pay,s);
	END IF;
	
END paymentcomplete;
/

	
CREATE OR REPLACE PROCEDURE Booking(id IN available1.A_ID%type ,pay IN payment1.METHOD%type, ui IN user1.U_ID%type,s IN payment1.STATUS%type,person IN booked1.person%type)
IS
	aid available1.A_ID%type;
	sour available1.SOURCE%type;
	des available1.DESTINATION%type;
	datb available1.DATEOFBOOK%type;
	amount available1.AMOUNT%type;
	bid booked1.B_ID%type;
	pid payment1.P_ID%type;
	Totalamount available1.AMOUNT%type;

BEGIN
	select A_ID,SOURCE,DESTINATION,DATEOFBOOK,AMOUNT into 
	aid, sour, des, datb, amount FROM myview2 WHERE id = A_ID ;
	
	bid := dbms_random.value(1,1000);
	pid := dbms_random.value(1001,2000);
	
	DBMS_OUTPUT.PUT_LINE('book id: '|| bid);
	
	Totalamount := calculateAmount(amount,person);
	
	DBMS_OUTPUT.PUT_LINE('Total : '|| Totalamount);
	
	insert into  BOOKED1 VALUES (bid,ui,person);
	insert into  BOOKED2@site_link VALUES (bid,sour,des,datb);
	paymentcomplete(pid,ui,aid,bid,Totalamount,pay,s);
	
END Booking;
/

DECLARE
	id available1.A_ID%type;
	pay payment1.METHOD%type;
	ui user1.U_ID%type;
	s payment1.STATUS%type;
	person booked1.person%type;
	
BEGIN
	id :=&X1;
	pay := '&X2';
	ui := '&X3';
	s := ' ';
	person := &X4;
	Booking(id,pay,ui,s,person);
END;
/ 
select * from Booked1;
select * from booked2@site_link;
select * from Payment1;
select * from Payment2@site_link;
select * from Payment3;
commit;