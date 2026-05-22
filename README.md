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

Após realizar o download dos diretórios, entre em cada um e execute:

```bash
chmod 755 run_migration.sh
unzip cvs.zip
```
Após isso, basta executar o script de migração:

```bash
./run_migration.sh
```

A migração executa na seguinte ordem:

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

   
