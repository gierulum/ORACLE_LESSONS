

create table schema_audit (
  ddl_date date,
  ddl_user varchar2(40),
  object_created varchar2(40),
  object_name varchar2(40),
  ddl_operation varchar(40))

create or replace trigger hr_audit_tr
after ddl on schema
begin 
insert into schema_audit values (sysdate, 
sys_context('USERENV', 'CURRENT_USER'),
ora_dict_obj_type,
ora_dict_obj_name,
ora_sysevent);
END;

create table aaa_a (aaa varchar2(10))

select * from schema_audit 
