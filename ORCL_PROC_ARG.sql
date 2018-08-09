

create or replace procedure 
dodaj(
param_1 in number, 
param_2 in number
) 
is 
par_1 number;
par_2 number;
sum_1 number;
sum_2 number;
cursor gm is 
select 1 from dual;
cursor mg is 
select 2 from dual;
begin
  open gm;
  fetch gm into par_1;
  close gm;
  open mg;
  fetch mg into par_2;
  close mg;
sum_1 := param_1 * par_1;
sum_2 := param_2 * par_2;
DBMS_OUTPUT.PUT_LINE('Wartosci przerobione: '||sum_1||' oraz '||sum_2);
END;
