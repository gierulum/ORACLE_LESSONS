@"E:/app/MG/product/12.1.0/dbhome_1/RDBMS/ADMIN/profload.sql"
@"E:/app/MG/product/12.1.0/dbhome_1/RDBMS/ADMIN/proftab.sql"
@"E:/app/MG/product/12.1.0/dbhome_1/RDBMS/ADMIN/tracetab.sql"
/

exec dbms_profiler.START_PROFILER('text_1','text_2'); 

exec dbms_profiler.FLUSH_DATA; 

exec dbms_profiler.STOP_PROFILER; 

select * from PLSQL_PROFILER_RUNS 
select * from PLSQL_PROFILER_UNITS 
select * from PLSQL_PROFILER_DATA


--for programming indicators to path we have to compile them in debug mode: 
ALTER SESSION SET PLSQL_DEBUG = TRUE; 
CREATE OR REPLACE PROCEDURE ..... 
ALTER SESSION SET PLSQL_DEBUG = FALSE; 
-- OR  
ALTER PROCEDURE p2 COMPILE DEBUG; 

/

--run: tracetab.sql 

dbms_trace.SET_PLSQL_TRACE( poziom_1 + poziom_2 + ...); 

/*
trace_all_calls 
trace_enabled_calls 


trace_all_sql 
trace_enabled_sql 

trace_all_exceptions 
trace_enabled_exceptions 

trace_enabled_lines 
trace_all_lines 
*/
 
exec dbms_trace.SET_PLSQL_TRACE( 1); 

select 1 from dual


--clear trace:
exec dbms_trace.CLEAR_PLSQL_TRACE; 

select * from plsql_trace_runs 

select * from plsql_trace_events 

