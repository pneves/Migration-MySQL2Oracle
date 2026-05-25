-- 05_views.sql

SET DEFINE OFF;

CREATE OR REPLACE VIEW entradas_denario_normalizada_todos AS
SELECT
    CASE
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('SAO PAULO','SÃO PAULO','SP') THEN 'SP'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('RIO DE JANEIRO','RJ') THEN 'RJ'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('MINAS GERAIS','MG') THEN 'MG'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('ESPIRITO SANTO','ESPÍRITO SANTO','ES') THEN 'ES'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('PARANA','PARANÁ','PR') THEN 'PR'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('SANTA CATARINA','SC') THEN 'SC'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('RIO GRANDE DO SUL','RS') THEN 'RS'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('MATO GROSSO','MT') THEN 'MT'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('MATO GROSSO DO SUL','MS') THEN 'MS'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('GOIAS','GOIÁS','GO') THEN 'GO'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('DISTRITO FEDERAL','DF') THEN 'DF'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('BAHIA','BA') THEN 'BA'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('SERGIPE','SE') THEN 'SE'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('ALAGOAS','AL') THEN 'AL'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('PERNAMBUCO','PE') THEN 'PE'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('PARAIBA','PARAÍBA','PB') THEN 'PB'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('RIO GRANDE DO NORTE','RN') THEN 'RN'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('CEARA','CEARÁ','CE') THEN 'CE'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('PIAUI','PIAUÍ','PI') THEN 'PI'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('MARANHAO','MARANHÃO','MA') THEN 'MA'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('PARA','PARÁ','PA') THEN 'PA'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('AMAZONAS','AM') THEN 'AM'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('ACRE','AC') THEN 'AC'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('RONDONIA','RONDÔNIA','RO') THEN 'RO'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('RORAIMA','RR') THEN 'RR'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('AMAPA','AMAPÁ','AP') THEN 'AP'
        WHEN UPPER(TRIM(ed.ESTADO)) IN ('TOCANTINS','TO') THEN 'TO'
        ELSE 'XX'
    END AS uf,
    TRIM(ed.BLOCO) AS bloco,
    TRIM(ed."Região") AS regiao,
    TRIM(ed.IGREJA) AS cenaculo,
    TRIM(ed."Campanha/Grupo") AS grupo,
    TO_NUMBER(
        REPLACE(
            REPLACE(
                REPLACE(ed."Valor da Doação", '.', ''),
                ',', '.'
            ),
            ' ',
            ''
        )
    ) AS valor,
    TO_TIMESTAMP(
        ed."Data Recebimento SGU",
        'DD/MM/YYYY HH24:MI:SS'
    ) AS datetime_doacao
FROM entradas_denario ed;
/
