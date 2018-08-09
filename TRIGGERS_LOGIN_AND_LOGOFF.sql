--SKRYPTY DO BADANIA ZALOGOWANIA UZYTKOWNIKOW:
create table hr_evnt_audit (
event_type varchar2(20),
logon_date DATE,
logon_time varchar2(15),
logof_date date,
logof_time varchar2(15)
)
--rozlaczenie z baza 
disc;

--ponowne polaczenie / zalogowanie
conn ANONYMOUS



create or replace trigger hr_lgon_audit
after logon on schema
BEGIN 
insert into hr_evnt_audit values (
ora_sysevent,
sysdate,
to_char(sysdate, 'hh24:mi:ss'),
null,
null
);
commit;
end;

--trigger log off:
create or replace trigger log_off_audit
--jezeli wylogowanie ze schematu ->>> ON DATABASE jezeli chodzi o baze
before logoff on schema
begin insert into hr_evnt_audit values (
ora_sysevent,
null,
null, 
sysdate,
to_char(sysdate, 'hh24:mi:ss'));
commit;
end;

--SKRYUPTY ODNOSNIE STATUSU BAZY DANYCH:
create table startup_audit (
event_type varchar2(30),
event_date date,
event_time varchar2(15));

create or replace trigger tr_startup_audit
after startup on database
begin
insert into startup_audit values (ora_sysevent, sysdate, to_char(sysdate, 'hh24:mi:ss'));
END;
