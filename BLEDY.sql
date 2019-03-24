

CREATE TABLE aa_err_logs  
(er_id NUMBER(15),    
er_lp NUMBER(10),    
er_nr NUMBER(10),    
er_komunikat VARCHAR2(2000),    
er_uzytkownik VARCHAR2(30) NOT NULL,    
er_data DATE NOT NULL ,    
er_program VARCHAR2(4000),    
er_typ VARCHAR2(1) DEFAULT 'E' NOT NULL,   
er_par1 VARCHAR2(4000),    
er_par2 VARCHAR2(4000),    
er_par3 VARCHAR2(4000),    
er_par4 VARCHAR2(4000),    
er_par5 VARCHAR2(4000),   
CONSTRAINT er_pk PRIMARY KEY (er_id, er_lp)  ); 

/

CREATE SEQUENCE seq_er START WITH 1000; 

/

create or replace PROCEDURE aa_error_zapisz(   
p_er_id         
NUMBER,   p_er_lp         
NUMBER,   p_er_nr         
NUMBER   := NULL,   p_er_kom       
VARCHAR2 := NULL,   p_er_program    
VARCHAR2 := NULL,   p_er_typ        
VARCHAR2 := NULL,   p_er_par1
VARCHAR2 := NULL,   p_er_par2    
VARCHAR2 := NULL,   p_er_par3
VARCHAR2 := NULL,   p_er_par4    
VARCHAR2 := NULL,   p_er_par5     
VARCHAR2 := NULL ) IS   PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN   
INSERT INTO aa_err_logs ( er_id, er_lp, er_nr, er_komunikat, er_uzytkownik,
er_data,er_program,er_typ,er_par1,er_par2,er_par3, er_par4, er_par5 )        
VALUES ( p_er_id, p_er_lp, p_er_nr, p_er_kom, user, sysdate,
p_er_program, p_er_typ, p_er_par1, p_er_par2, p_er_par3, 
p_er_par4, p_er_par5 );   
COMMIT; 
END;

/


--SQLCODE 
--SQLERRM 
/

create or replace PROCEDURE aa_nowy_blad (p_kom IN VARCHAR2) IS   v_err_id NUMBER; 
BEGIN   -- Wycofanie transakcji, bo dana operacja si� nie powiod�a   
ROLLBACK;   
-- Powo�anie nowego stosu   
SELECT seq_er.nextval     INTO v_err_id     FROM dual;   
-- Zapisanie nowego komunikatu do logu   
aa_error_zapisz( p_er_id => v_err_id,           p_er_lp => 1,           p_er_kom => p_kom ,           p_er_typ => 'B');   
-- Zg�oszenie komunikatu b��du sk�adaj�cego si� z jego numeru   
raise_application_error(-20101,'{{'||v_err_id||'}}'); 
END; 
/


--lapanie bledow:

PROCEDURE zlap_blad (
  p_sqlcode    IN NUMBER,
  p_sqlerrm    IN VARCHAR2,
  p_proc
  IN VARCHAR2,
  p_par1
  IN VARCHAR2 := NULL,
  p_par2
  IN VARCHAR2 := NULL,
  p_par3
  IN VARCHAR2 := NULL,
  p_par4
  IN VARCHAR2 := NULL,
  p_par5
  IN VARCHAR2 := NULL ) IS   v_err_id_txt VARCHAR2(100);   v_err_id
NUMBER;   v_lp
 NUMBER; BEGIN
-- W zale�no�ci od sqlcode r�ne czynno�ci   IF p_sqlcode in (-20100, -20101) THEN
-- B��dy ju� zalogowane, tylko odnotowuje kolejne wyst�pienie
v_err_id_txt := substr(p_sqlerrm,instr(p_sqlerrm,'{{')+2);
v_err_id_txt := substr(v_err_id_txt,1,instr(v_err_id_txt,'}}')-1);
v_err_id
:= to_number(v_err_id_txt);
-- Pobieram kolejn� liczb� porz�dkow�
SELECT max(er_lp)+1
  INTO v_lp
  FROM err_logs
 WHERE er_id = v_err_id;
-- Zapisuj� informacj� o b��dzie
zapisz(
  p_er_id => v_err_id,
  p_er_lp => v_lp,
  p_er_nr   => p_sqlcode,
  p_er_program => p_proc,
  p_er_typ => CASE p_sqlcode WHEN -20100 THEN 'E' ELSE'B' END,
  p_er_par1 => p_par1,
  p_er_par2 => p_par2,
  p_er_par3 => p_par3,
  p_er_par4 => p_par4,
  p_er_par5 => p_par5 );
-- Propaguj� dalej ten sam b��d
raise_application_error(p_sqlcode, '{{'|| v_err_id ||'}}');   ELSE
-- Ka�dy inny b��d traktuje jako nieprzewidziany
--   i niezanotowany dotychczas
SELECT seq_er.nextval
  INTO v_err_id
  FROM dual;
zapisz(
  p_er_id   => v_err_id,
  p_er_lp   => 1,
  p_er_nr   => p_sqlcode,
  p_er_kom  => p_sqlerrm,
  p_er_program  => p_proc||'::'||dbms_utility.format_error_backtrace||


'@@'||DBMS_UTILITY.FORMAT_ERROR_STACK,
  p_er_typ => 'E',
  p_er_par1 => p_par1,
  p_er_par2 => p_par2,
  p_er_par3 => p_par3,
  p_er_par4 => p_par4,
  p_er_par5 => p_par5 );
  -- Dla nieprzewidzianych b��d�w nale�y wycofa� transakcj�
  ROLLBACK;
END IF;
-- Propaguj� dalej b��d
raise_application_error(-20100, '{{'|| v_err_id ||'}}'); END; 


-- blad dla usera:
FUNCTION daj_komunikat( p_err_id IN NUMBER)   RETURN VARCHAR2 IS   v_blad VARCHAR2(2000);   v_typ VARCHAR2(1); BEGIN   SELECT er_komunikat, er_typ     INTO v_blad, v_typ     FROM err_logs    WHERE er_id = p_err_id      AND er_lp = 1;      IF v_typ = 'E' THEN        v_blad := 'Wyst�pi� b��d techniczny. Prosz� skontaktowa� ' ||               'si� z serwisem podaj�c numer referencyjny:'||p_err_id;   END IF;   RETURN v_blad; END; 

--

CREATE OR REPLACE PROCEDURE test_bledow(p_nr NUMBER) IS   c_proc constant varchar2(65) := $$PLSQL_UNIT;   v_liczba NUMBER(10); BEGIN   IF p_nr = 1 THEN     pck_err.nowy_blad('Podano b��dn� warto�� numeru: ' || p_nr);   ELSIF p_nr = 2 THEN     v_liczba := p_nr / 0;   END IF; EXCEPTION   WHEN OTHERS THEN     pck_err.zlap_blad(sqlcode, sqlerrm, c_proc, p_nr); END


/

-- Test b��du biznesowego BEGIN    test_bledow(1);  END; / -- Pobranie komunikatu dla b��du biznesowego SELECT pck_err.daj_komunikat(1000)    FROM dual; -- Test b��du nieprzewidzianego BEGIN    test_bledow(2);  END; / -- Pobranie komunikatu dla b��du nieprzewidzianego SELECT pck_err.daj_komunikat(1001)    FROM dual; -- Wy�wietlenie informacji o b��dach   SELECT *    FROM err_logs; 
