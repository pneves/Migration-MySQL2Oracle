# Migration-MySQL2Oracle

Modelo de passos envolvidos na migração de databases MySQL para Oracle Exadata.

---

# Visão Geral

Este projeto contém um conjunto de scripts e utilitários utilizados para migrar:

- schemas MySQL
- conteúdo das tabelas
- índices
- foreign keys
- views
- estatísticas

---

# Estratégia de Schemas Oracle

Como iremos trabalhar com dois schemas Oracle isolados, serão criados dois usuários Oracle distintos correspondentes aos databases MySQL existentes, onde cada aplicação/database possuirá seu próprio schema Oracle.

- `UNIPAGDB`
- `GRUPOSDEDICADASPRD`

```

# Passo 1 — Criação dos Usuários Oracle

Exemplo para `UNIPAGDB`:

```sql
CREATE USER UNIPAGDB IDENTIFIED BY "senha_forte"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO UNIPAGDB;
GRANT CREATE TABLE TO UNIPAGDB;
GRANT CREATE VIEW TO UNIPAGDB;
GRANT CREATE SEQUENCE TO UNIPAGDB;
GRANT CREATE PROCEDURE TO UNIPAGDB;
```

Repetir o mesmo processo para:

```text
GRUPOSDEDICADASPRD
```

---

# Passo 2 — Executar a Migração

Para cada schema, o mesmo procedimento deverá ser adotado. O script já contém os nomes dos usuários e senhas a serem utilizadas durante a conexão com o Oracle. 

Para download do pacote, execute:

```bash
wget https://github.com/pneves/Migration-MySQL2Oracle/archive/refs/heads/main.tar.gz

tar xzf main.tar.gz

cd Migration-MySQL2Oracle-main
```

Após realizar o download do pacote, entre em cada diretório (GruposDedicadasPRD e UnipagDb) e edite  o script de migração, substituindo o nome do host e o nome do serviço na linha ORACLE_CONN="host:1521/service_name".

Com o script alterado e com os usuários já criados, basta executar:

```bash
./run_migration.sh
```

A migração será então executada na seguinte ordem:

```text
01_tables.sql
02_primary_unique_constraints.sql
Carga CSV via SQL*Loader
03_foreign_keys.sql
04_indexes.sql
05_views.sql
06_stats.sql
```
As definições das tabelas, control files e conteúdos estão sob so diretótios "ddl", "ctl" e csv, respectivamente

---

# Observações Importantes

- Colunas especiais são preservadas utilizando quoted identifiers Oracle.
- O SQL*Loader utiliza ASCII Unit Separator (`X'1F'`) como delimitador.
- Os CSVs são gerados sem header.

   
