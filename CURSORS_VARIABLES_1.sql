
create table aa_table_test_operations
(test1 varchar2(20),
test2 varchar2(20),
test3 varchar2(20))

select * from aa_table_test_operations 

/*
U - Upper case
L - Lower case
A - Alphanumeric
X - Alphanumeric with upper case alphabets.
P - Printable characters only.
*/
insert into aa_table_test_operations values (
dbms_random.string('A', 10),
dbms_random.string('A', 10),
dbms_random.string('A', 10))


declare 
V_abcd varchar2(20):= 'ABCD';
V_var_mg varchar2(20);
cursor mg is
select test1 from aa_table_test_operations
where substr(test1, 2, 1) = 'K';
BEGIN 
OPEN mg;
LOOP
FETCH mg into V_var_mg;
dbms_output.put_line(V_var_mg);
exit when mg%NOTFOUND;
end loop;
close mg;
end;

--CURSOR Z PARAMETREM:
declare 
v_ag varchar2(20);
--DEFAULT VALUE ABCD
cursor mg (var_ag_mg varchar2 ='ADCD') is
select test1 from aa_table_test_operations
--TUTAJ MOZE BYC NP WHERE XYZ = VAR_AG_MG
where substr(test1, 2, 1) = 'K';
BEGIN
OPEN MG('QWER');
LOOP
FETCH MG into v_ag;
EXIT WHEN mg%NOTFOUND;
dbms_output.put_line(v_ag);
END LOOP;
CLOSE MG;
END;


