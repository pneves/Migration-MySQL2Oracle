OPTIONS (DIRECT=FALSE, ROWS=50000, ERRORS=100000)
LOAD DATA
CHARACTERSET AL32UTF8
INFILE './csv/ENTRADAS_DENARIO.csv'
INTO TABLE ENTRADAS_DENARIO
APPEND
FIELDS TERMINATED BY X'1F' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  "Data da Geração"                   CHAR(50) NULLIF "Data da Geração"=BLANKS,
  "Data da Aprovação"                 CHAR(50) NULLIF "Data da Aprovação"=BLANKS,
  "Data Recebimento SGU"              CHAR(50) NULLIF "Data Recebimento SGU"=BLANKS,
  ESTADO                              CHAR(50) NULLIF ESTADO=BLANKS,
  BLOCO                               CHAR(50) NULLIF BLOCO=BLANKS,
  "Região"                            CHAR(50) NULLIF "Região"=BLANKS,
  IGREJA                              CHAR(50) NULLIF IGREJA=BLANKS,
  "Campanha/Grupo"                    CHAR(50) NULLIF "Campanha/Grupo"=BLANKS,
  "Valor da Doação"                   CHAR(50) NULLIF "Valor da Doação"=BLANKS
)
