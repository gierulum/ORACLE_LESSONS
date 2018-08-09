
--create table aa_cyferki (id number(10))
--select * from aa_cyferki
--drop table aa_cyferki


declare 
type t_tab is table of varchar2(10) index by pls_integer;
v_tab t_tab;
begin 
v_tab(1) := '1';
v_tab(2) := '2';
v_tab(3) := '3';
v_tab(4) := 'y';
v_tab(5) := 'x';
v_tab(6) := '6';
v_tab(7) := '7';

forall i in 1..v_tab.last save exceptions   --dzieki temu bledy beda przekazane do kolekcji z bledami 
  insert into aa_cyferki values (v_tab(i));

exception
  when others then 
  dbms_output.put_line('wystapilo bledow: '||sql%bulk_exceptions.count); --kolekcja przechowujaca informacje  exceptions
  for i in 1..sql%bulk_exceptions.count loop
    dbms_output.put_line('na pozycji numer '||sql%bulk_exceptions(i).error_index||' wystapil blad o tresci '||sqlerrm(-sql%bulk_exceptions(i).error_code));
    end loop;
end;

