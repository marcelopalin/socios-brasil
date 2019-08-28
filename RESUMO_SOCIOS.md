# RESUMO

HIPÓTESE:

- já rodamos o script e baixamos os arquivos da RECEITA FEDERAL em data/download
os arquivos de DADOS_ABERTOS_CNPJ_01.zip até DADOS_ABERTOS_CNPJ_20.zip

Foram baixados ao rodarmos runs.sh

Baixado de: https://receita.economia.gov.br/orientacao/tributaria/cadastros/cadastro-nacional-de-pessoas-juridicas-cnpj/dados-publicos-cnpj

Data da geração do arquivo: 07 de agosto de 2019.


# CRIADO O BD POSTGRESQL

Para importar os arquivos para o BD foi rodado **import-postgresql_all.sh**, lembrando que antes de rodar temos
que configurar qual é o user, senha e nome do BD em postgres.

STATUS DO SERVIÇO

sudo service postgresql status
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: active (exited) since Wed 2019-08-28 09:44:03 -03; 2h 24min ago
  Process: 3716 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 3716 (code=exited, status=0/SUCCESS)

ago 28 09:44:03 mpi-300E5K-300E5Q systemd[1]: Starting PostgreSQL RDBMS...
ago 28 09:44:03 mpi-300E5K-300E5Q systemd[1]: Started PostgreSQL RDBMS.


# REINICIAR SERVIÇO

sudo service postgresql restart


Crie o usuário no postgresql de sua preferência, se for logo depois que instalou, logue-se com:

```bash
socios-brasil$ sudo -u postgres psql
psql (11.4 (Ubuntu 11.4-1.pgdg18.10+1), servidor 10.9 (Ubuntu 10.9-1.pgdg18.10+1))
Digite "help" para ajuda.

postgres=# 
```

## LISTE OS USUÁRIOS

```
sudo -u postgres psql
psql (11.4 (Ubuntu 11.4-1.pgdg18.10+1), servidor 10.9 (Ubuntu 10.9-1.pgdg18.10+1))
Digite "help" para ajuda.

postgres=# \du
                                    Lista de roles
 Nome da role |                         Atributos                         | Membro de 
--------------+-----------------------------------------------------------+-----------
 ampere       | Cria BD                                                   | {}
 mpi          | Cria BD                                                   | {}
 palin        |                                                           | {}
 postgres     | Super-usuário, Cria role, Cria BD, Replicação, Ignora RLS | {}

postgres=# 
```

## LISTAR OS SCHEMAS


postgres=# \dn
 Lista de esquemas
  Nome  |   Dono   
--------+----------
 public | postgres
(1 registro)


# ALTERAR A SENHA DO USUÁRIO EXISTE

sudo -u postgres psql

ALTER USER <user> WITH PASSWORD '<senha>';

Teste logando com o usuário:

```bash
psql -U ampere -h localhost -d postgres
```


# DROP DATABASE

sudo -u postgres psql
ou 
psql -U ampere -h localhost -d postgres

## DESCONECTE OS USUÁRIOS

postgres=# SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'empresas';

Delete o BD:

DROP DATABASE empresas;


# BACKUP BD EMPRESA DE OUTRA MÁQUINA

Liste os BDs:

```
sudo -u postgres psql
ou 
psql -U ampere -h localhost -d postgres

\l
```

```
     Nome      |   Dono   | Codificação |   Collate   |    Ctype    | Privilégios de acesso 
---------------+----------+-------------+-------------+-------------+-----------------------
 empresa       | postgres | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | 
 empresas      | mpi      | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | 
 knowledge     | postgres | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | =Tc/postgres         +
               |          |             |             |             | postgres=CTc/postgres+
               |          |             |             |             | mpi=CTc/postgres
 postgres      | postgres | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | 
 proj_udemy_db | mpi      | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | 
 template0     | postgres | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | =c/postgres          +
               |          |             |             |             | postgres=CTc/postgres
 template1     | postgres | UTF8        | pt_BR.UTF-8 | pt_BR.UTF-8 | =c/postgres          +
               |          |             |             |             | postgres=CTc/postgres
(7 registros)
```

Deslogue-se do postgres com \q e faça:

```bash
pg_dump -h localhost -U ampere -W -F t empresa > empresa.tar
```

Examinando o comando:

-U postgres:  especifica o usuário que se conectará.
-W: força o pg_dump a perguntar o password antes de conectar-se.
-F : especifica o formato da saída do arquivo. que pode ser uma das seguintes: 
	*  c: formato personalizado 
	*  d: arquivo em formato de diretório
	*  t: tar
	*  p: arquivo texto de SQL 

# 

# CRIAR O USUÁRIO

```
CREATE ROLE <nome_user> WITH LOGIN PASSWORD 'senha';
```

# LOGIN COM O USUÁRIO - SINTAXE


psql -U mpi -h localhost -d postgres


# CRIANDO O BD
Crie o BD:

```
CREATE DATABASE "empresa";
```

```
GRANT ALL PRIVILEGES ON DATABASE "empresa" TO <nome_user>;
```


Configure a linha:

POSTGRESQL_URI="postgres://<user>:<pass>@localhost:5432/<db_name>"

do script import-postgresql_all.sh e então rode ele depois
de ter configurado o BD e usuário do Postgres.