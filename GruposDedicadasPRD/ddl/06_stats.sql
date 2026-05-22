-- 06_stats.sql - estatísticas após carga e criação de índices/constraints

BEGIN
  DBMS_STATS.GATHER_SCHEMA_STATS(
    ownname => USER,
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
    method_opt      => 'FOR ALL COLUMNS SIZE AUTO',
    cascade => TRUE,
    degree  => DBMS_STATS.AUTO_DEGREE
  );
END;
/
