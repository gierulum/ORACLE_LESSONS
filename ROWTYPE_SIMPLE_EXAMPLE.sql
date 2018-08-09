declare
v_emp aa_table_test_operations%ROWTYPE;
BEGIN
select * into v_emp from aa_table_test_operations
where substr(test1, 1, 1) = 'G';
DBMS_OUTPUT.PUT_LINE(v_emp.test1||' '||v_emp.test2||v_emp.test3);
END;