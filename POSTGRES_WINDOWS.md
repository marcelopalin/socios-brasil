## 6.5. Instalando PostgreSQL no Windows

O objetivo é instalarmos o PostgreSQL para depois trabalharmos com o Laravel na parte de desenvolvimento do **backend** utilizando o servidor embutido **artisan**. 

No windows a instalação é feita através de um arquivo binário que pode ser baixado em:

https://www.postgresql.org/download/windows/


![fig01](images/postgresql/fig01.PNG)

Depois de clicar em Download Installers você será redirecionado para:

https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

![fig02](images/postgresql/fig02.PNG)


Neste momento (25/10/2019) foi lançado o PostgreSQL 11, porém, ainda utilizaremos a versão 9.6.



## 6.6. Configurando o WampServer no Windows para PostgreSQL

Abra o terminal do DOS no windows e digite:

```bash
php -v
```

Você verá qual é a versão do PHP que você está utilizando. Lembrando que para o Laravel é necessário PHP 7.1+.  Caso não esteja configurado para esta versão basta ir no ícone do Wampserver próximo ao relógio do windows e alterá-la para que comece a utilizar uma versão de PHP 7.1+. No meu caso, neste momento tenho a versão PHP 7.1.9.

Portanto, a saída do comando é:

```bash
PHP 7.1.9 (cli) (built: Aug 30 2017 18:34:46) ( ZTS MSVC14 (Visual C++ 2015) x64 )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies
    with Xdebug v2.6.0, Copyright (c) 2002-2018, by Derick Rethans
```

Uma vez confirmado que a versão do PHP é 7.1+ verifique qual é o arquivo **PHP.INI** que está sendo utilizado.

```bash
php --ini
```

```bash
Configuration File (php.ini) Path: C:\WINDOWS
Loaded Configuration File:         C:\wamp64\bin\php\php7.1.9\php.ini
Scan for additional .ini files in: (none)
Additional .ini files parsed:      (none)
```

Pronto, agora sabemos que devemos editar o arquivo **C:\wamp64\bin\php\php7.1.9\php.ini**. Vá até este arquivo e descomente (remova o ; do início da linha) os drivers do PDO para PostgreSQL:

```
;extension=php_pdo_firebird.dll
extension=php_pdo_mysql.dll
;extension=php_pdo_oci.dll
;extension=php_pdo_odbc.dll
extension=php_pdo_pgsql.dll
extension=php_pdo_sqlite.dll
extension=php_pgsql.dll
```

Em geral, sempre teremos descomentado o **sqlite**, **mysql** e agora o **pgsql**.

Para garantir que irá funcionar quando fizermos a **migration** do laravel execute o comando redirecionando a saída para um arquivo TXT para facilitar a visualização depois, pois a saída é um pouco grande.

```bash
php -i > c:\wamp64\www\SAIDA.txt
```

Abra o arquivo **SAIDA.txt** e confira se encontra as linhas:

```ini
PDO

PDO support => enabled
PDO drivers => mysql, pgsql, sqlite

pdo_mysql

PDO Driver for MySQL => enabled
Client API version => mysqlnd 5.0.12-dev - 20150407 - $Id: b396954eeb2d1d9ed7902b8bae237b287f21ad9e $

pdo_pgsql

PDO Driver for PostgreSQL => enabled
PostgreSQL(libpq) Version => 9.6.2
Module version => 7.1.9
Revision =>  $Id: 93712a6af603ebb2ee5792c5be271d4d03edfbde $ 

pdo_sqlite

PDO Driver for SQLite 3.x => enabled
SQLite Library => 3.15.1

pgsql

PostgreSQL Support => enabled
PostgreSQL(libpq) Version => 9.6.2
PostgreSQL(libpq)  => PostgreSQL 9.6.2 (win32)
Multibyte character support => enabled
SSL support => enabled
Active Persistent Links => 0
Active Links => 0

Directive => Local Value => Master Value
pgsql.allow_persistent => On => On
pgsql.auto_reset_persistent => Off => Off
pgsql.ignore_notice => Off => Off
pgsql.log_notice => Off => Off
pgsql.max_links => Unlimited => Unlimited
pgsql.max_persistent => Unlimited => Unlimited
```

Pronto! Agora você pode testar criando um projeto Laravel:

```
composer create-project --prefer-dist laravel/laravel blog
```

Configurando o arquivo **.env** para:

```
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=meubancodados
DB_USERNAME=admin
DB_PASSWORD=senhabd
```

Atenção: não se esqueça que a porta do POSTGRESQL é a 5432!

Crie o BD no windows utilizando o Prompt do PostgreSQL (localize teclando a tecla do Windows e buscando por SQL -> aparecerá SQL Shell (psql)).

Ele pedirá para você confirmar algumas informações, se for utilizar a default que está entre [], basta ir teclando ENTER:

![fig03](images/postgresql/fig03.PNG)



Criando o BD no postgres (uma vez que esteja logado no ambiente):

```
CREATE DATABASE meubancodados;
```

```
postgres=# CREATE DATABASE meubancodados;
CREATE DATABASE
postgres=#
```

Para verificar:

```
postgres=# \l
                                            Lista dos bancos de dados
     Nome      |   Dono   | CodificaþÒo |        Collate         |         Ctype          | PrivilÚgios de acesso
---------------+----------+-------------+------------------------+------------------------+-----------------------
 meubancodados | postgres | UTF8        | Portuguese_Brazil.1252 | Portuguese_Brazil.1252 |
 postgres      | postgres | UTF8        | Portuguese_Brazil.1252 | Portuguese_Brazil.1252 |
 template0     | postgres | UTF8        | Portuguese_Brazil.1252 | Portuguese_Brazil.1252 | =c/postgres          +
               |          |             |                        |                        | postgres=CTc/postgres
 template1     | postgres | UTF8        | Portuguese_Brazil.1252 | Portuguese_Brazil.1252 | =c/postgres          +
               |          |             |                        |                        | postgres=CTc/postgres
 teste         | postgres | UTF8        | Portuguese_Brazil.1252 | Portuguese_Brazil.1252 |
(5 registros)


postgres=#
```