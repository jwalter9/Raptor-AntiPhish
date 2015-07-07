
DROP FUNCTION IF EXISTS emailer;

CREATE FUNCTION emailer RETURNS int SONAME 'udf_emailer.so';

