# 1. CONFIGURE .ENV

# 2. Atenção: esta é a conexão Padrão
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=Modelos
DB_USERNAME=ampere
DB_PASSWORD=ampere

# 3. ATENÇÃO: você pode adicionar o SCHEMA AQUI NO .env
# 4. e CONFIGURAR config/database.php com env('DB_PGSQL_SCHEMA','public'),

> COLOQUE esta linha no

```ini
DB_PGSQL_SCHEMA=fes
```

# 5. EDITE: config/database.php

```php

'default' => env('DB_CONNECTION', 'pgsql'),

'pgsql' => [
            'driver'   => 'pgsql',
            'host'     => env('DB_HOST', 'localhost'),
            'database' => env('DB_DATABASE', 'forge'),
            'username' => env('DB_USERNAME', 'forge'),
            'password' => env('DB_PASSWORD', ''),
            'charset'  => 'utf8',
            'prefix'   => '',
            // Notice the following has been modified
            'schema'   => env('DB_PGSQL_SCHEMA','public'),
        ],

```

OU

```php
       'pgsql' => [
            'driver' => 'pgsql',
            'host' => env('DB_HOST', '127.0.0.1'),
            'port' => env('DB_PORT', '5432'),
            'database' => env('DB_DATABASE', 'Modelos'),
            'username' => env('DB_USERNAME', 'ampere'),
            'password' => env('DB_PASSWORD', ''),
            'charset' => 'utf8',
            'prefix' => '',
            'schema' => 'public',
            'sslmode' => 'prefer',
        ],
```


# 6. COMO RESTAURAR O BACKUP DO BD EM POSTGRES

Logue-se no prompt do psql:
```
sudo -u postgres psql
```

Crie o BD (obs: para criar com letra Maiuscula use o nome do BD entre aspas):
```
psql =# CREATE DATABASE modelos;
```

Crie o Schema 'laravel':
```
postgres=# \connect modelos
You are now connected to database "modelos" as user "postgres".
modelos=# \dn
   List of schemas
   Name   |  Owner
----------+----------
 dadossin | postgres
 horizon  | postgres
 montador | postgres
 public   | postgres
(4 rows)

modelos=# CREATE SCHEMA laravel;
CREATE SCHEMA
modelos=# \dn
   List of schemas
   Name   |  Owner
----------+----------
 dadossin | postgres
 horizon  | postgres
 laravel  | postgres
 montador | postgres
 public   | postgres
(5 rows)

```

Liste os BDs:
```
\l
```

Saia do terminal psql:
```
\q
```

Conecte-se como usuário postgres:
```
sudo su - postgres
```

## 6.1. BACKUP POSTGRES

Versão testada, porém, pede a senha do usuário postgres:

```bash
pg_dump -h localhost -U postgres -W -F t nome_do_bd > nome_do_bd.tar
```


Examinando o comando:

-U postgres:  especifica o usuário que se conectará.

-W: força o pg_dump a perguntar o password antes de conectar-se.

-F : especifica o formato da saída do arquivo. que pode ser uma das seguintes: 

	*  c: formato personalizado 
	*  d: arquivo em formato de diretório
	*  t: tar
	*  p: arquivo texto de SQL 



## 6.2. CRIANDO BD

```bash
sudo -u postgres createdb modelos
```

ou, depois de logar:

```bash
sudo -u postgres psql

# CREATE DATABASE modelos;
```

## 6.3. DROP DATABASE POSTGRESQL

```
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'modelos';
```

## 6.4. Restaurando um Banco de Dados

```bash
pg_restore -h localhost -U postgre -W -F t -d modelos Modelos.tar
```



