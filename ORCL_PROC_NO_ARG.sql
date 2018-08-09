--select * from AAA_PUSTA

exec pusta_dane 

create or replace procedure pusta_dane is
cursor mg is 
select (select max(id)+1 from aaa_pusta) id,
round(dbms_random.value(1, 999),0) a,
dbms_random.string('U', 8) b,
dbms_random.string('U', 4) c
from dual;
begin 
  for x in mg loop
    insert into aaa_pusta(id, name, surname, abc)
    values (x.id, x.a, x.b, x.c);
  end loop;
  commit;
end;

