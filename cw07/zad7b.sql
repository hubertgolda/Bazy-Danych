-- 7b_1 Fibonacci
create or replace function fibonacci(fib int)
returns int
language plpgsql
as $$
declare x1 int default 0;
declare x2 int default 1;
declare x3 int;
begin
	if fib = 1 then
	return x1;
	elseif fib = 2 or fib = 3 then
	return x2;
	else
		while fib>2 loop
			x3=x1+x2;
			x1=x2;
			x2=x3;
			fib=fib-1;
		end loop;
		return x3;
	end if;
end;
$$;
 

create or replace procedure procedura1(n int) language plpgsql as $$
declare x int default 1;
begin 
	while n>0 loop
		raise notice '%', fibonacci(x);
		x=x+1;
		n=n-1;
	end loop;
end;
$$;

call procedura1(10)

-- 7b_2 Tworzenie triggera na tabeli Person
CREATE OR REPLACE FUNCTION uppercase_lastname()
RETURNS TRIGGER AS $$
BEGIN
    NEW.LastName := UPPER(NEW.LastName);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_lastname_uppercase_trigger
BEFORE INSERT OR UPDATE ON person.person
FOR EACH ROW EXECUTE FUNCTION uppercase_lastname();


-- 7b_3 Tworzenie triggera na tabeli SalesTaxRate
CREATE OR REPLACE FUNCTION check_tax_rate_change()
RETURNS TRIGGER AS $$
DECLARE
    old_tax_rate DECIMAL(8,4);
    new_tax_rate DECIMAL(8,4);
BEGIN
    old_tax_rate := OLD.taxrate;
    new_tax_rate := NEW.taxrate;

    IF ABS(new_tax_rate - old_tax_rate) / old_tax_rate > 0.30 THEN
        RAISE EXCEPTION 'Zmiana wartości pola TaxRate o więcej niż 30%% jest niedozwolona.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER taxRateMonitoring
BEFORE UPDATE ON sales.salestaxrate 
FOR EACH ROW
EXECUTE FUNCTION check_tax_rate_change();