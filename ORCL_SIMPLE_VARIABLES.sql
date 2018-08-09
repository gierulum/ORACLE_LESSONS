--VARIABLES
declare 
v_test varchar2(30):= 'HERE IS SOME TEXT';
BEGIN
 dbms_output.put_line(v_test);
END;

declare 
V_ID aa_absencje.prac_id%TYPE;
V_PI CONSTANT NUMBER(7,6) DEFAULT 3.141592;
BEGIN
select PRAC_ID INTO V_ID
from AA_ABSENCJE 
where to_date(to_char(data_od, 'yyyy-mm-dd' ), 'yyyy-mm-dd') = to_date('2016-01-17', 'yyyy-mm-dd');
DBMS_OUTPUT.put_line(v_ID);
DBMS_OUTPUT.put_line(v_PI);
END;

DECLARE
COND_VAR NUMBER(10):= 1;
BEGIN
if (COND_VAR > 2) THEN
DBMS_OUTPUT.PUT_LINE('WIEKSZE!');
ELSIF (COND_VAR < 1) THEN
DBMS_OUTPUT.PUT_LINE('MNIEJSZE!');
ELSE
DBMS_OUTPUT.PUT_LINE('ROWNE!');
END IF;
END;

--SIMPLE LOOP:
DECLARE 
V_CC number := 0;
V_RR number;
BEGIN
LOOP
V_RR := 19 + V_CC;
DBMS_OUTPUT.PUT_LINE('TEXT X'||' V_CC >>' || V_CC);
V_CC := V_CC + 1;
IF V_CC > 10 THEN EXIT;
END IF;
END LOOP;
END;

--WHILE LOOP:
DECLARE
VAR_BOOL BOOLEAN:= TRUE;
VAR_OBL number:= 0;
BEGIN
WHILE VAR_BOOL = TRUE LOOP
VAR_OBL := VAR_OBL + 1;
dbms_output.put_line(VAR_OBL);
IF VAR_OBL > 10 THEN VAR_BOOL := FALSE; 
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('abc');
END;

--LISTAGG:
select prac_id, listagg(prac_id, '...') within group (order by data_od) from AA_ABSENCJE
group by prac_id




--https://www.youtube.com/watch?v=AFx6QYcY1CU&list=PLMlNiWEoh5Qofm_RmXf-VD_C423CsUN3e&index=11