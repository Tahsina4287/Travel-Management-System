select * from payment1 union select *from payment2@site_link union select * from payment3;
select * from user1 union select *from user3@site_link union select * from user2;
select * from booked1 natural join booked2@site_link;
select * from available1 union select *from available2@site_link;
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