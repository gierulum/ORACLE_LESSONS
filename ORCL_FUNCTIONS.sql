
create table a_departments (
dept_id number(10),
dept_name varchar2(30)
)

insert into a_departments (dept_id,dept_name) values (8, 'BIOLOGY');
insert into a_departments (dept_id, dept_name) values (7, 'PR');

/

select 
add_department('AAAA')
from dual


select * from a_departments 

/

create or replace 
function add_department(new_department in varchar2) 
return varchar2
is 

new_dept_num varchar2(20);

cursor dep_id is 
select max(dept_id)+1 
from a_departments;


begin 
  open dep_id;
  fetch dep_id into new_dept_num;
--execute immediate  'insert into a_departments (dept_name) values ('||new_dept_num||')';
  close dep_id; 

  return new_dept_num;
end; 
