--
create table aa_curtest (
data_a varchar2(10));
--
create table aa_curaddtest (
data_b varchar2(10));


create or replace trigger aa_add_cur_test
after insert or delete or update on aa_curtest
for each row
enable
declare cur_var varchar2(10);
begin 
select user into cur_var from dual;
if inserting then 
insert into aa_curaddtest values (new:data_a);
end if;
end;