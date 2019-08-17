# 1. INSTALAÇÃO


Execute:

```bash
sudo apt-get install wget ca-certificates

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

sudo apt update
sudo apt install postgresql postgresql-contrib

```

```bash
[sudo] senha para mpi: 
Lendo listas de pacotes... Pronto
Construindo árvore de dependências       
Lendo informação de estado... Pronto
The following additional packages will be installed:
  postgresql-10 postgresql-client-10 postgresql-client-common
  postgresql-common sysstat
Pacotes sugeridos:
  postgresql-doc locales-all postgresql-doc-10 libjson-perl isag
Os NOVOS pacotes a seguir serão instalados:
  postgresql postgresql-10 postgresql-client-10 postgresql-client-common
  postgresql-common postgresql-contrib sysstat
0 pacotes atualizados, 7 pacotes novos instalados, 0 a serem removidos e 3 não atualizados.
```

```bash
    Success. You can now start the database server using:

    /usr/lib/postgresql/10/bin/pg_ctl -D /var/lib/postgresql/10/main -l logfile start

Ver Cluster Port Status Owner    Data directory              Log file
10  main    5432 down   postgres /var/lib/postgresql/10/main /var/log/postgresql/postgresql-10-main.log
update-alternatives: a usar /usr/share/postgresql/10/man/man1/postmaster.1.gz para disponibilizar /usr/share/man/man1/postmaster.1.gz (postmaster.1.gz) em modo auto
Configurando postgresql (10+193) ...
Configurando postgresql-contrib (10+193) ...
A processar 'triggers' para systemd (239-7ubuntu10.14) ...
```

Duas informações passadas, que para iniciar o BD:

```
/usr/lib/postgresql/10/bin/pg_ctl -D /var/lib/postgresql/10/main -l logfile start
```

Porta e Log:

```
main    5432 down   postgres /var/lib/postgresql/10/main /var/log/postgresql/postgresql-10-main.log
```

Agora que o software está instalado, podemos ver como ele funciona e como ele pode ser diferente de sistemas de gerenciamento de banco de dados semelhantes que você possa ter usado.

# 2. Etapa 2 - Usando funções e bancos de dados do PostgreSQL

Por padrão, o Postgres usa um conceito chamado "funções" para lidar com autenticação e autorização. Estes são, de certa forma, semelhantes às contas regulares no estilo Unix, mas o Postgres não faz distinção entre usuários e grupos e prefere o termo mais flexível "role".

Após a instalação, o Postgres é configurado para usar a autenticação ident, o que significa que ele associa as funções do Postgres a uma conta do sistema Unix / Linux correspondente. Se houver uma função no Postgres, um nome de usuário do Unix / Linux com o mesmo nome poderá entrar como essa função.

O procedimento de instalação criou uma conta de usuário chamada postgres que está associada à função padrão do Postgres. Para usar o Postgres, você pode fazer login nessa conta.

Existem algumas maneiras de utilizar essa conta para acessar o Postgres.

# 3. VERSÃO DO POSTGRES - Client

```bash
psql --version
ou
psql -V
```

```
psql (PostgreSQL) 11.4 (Ubuntu 11.4-1.pgdg18.10+1)
```

# 4. STATUS DO SERVIÇO

```bash
sudo systemctl status postgresql.service
ou 
sudo service postgresql status
```

Reiniciar o serviço do POSTGRESQL

```bash
sudo systemctl restart postgresql
ou
sudo service postgresql restart
```


Existem **dois processos (daemon) que atuam diretamente da execução do servidor**.

Postmaster:  processo servidor responsável diretamente pela gerência de banco de dados, aceita conexões, e é conhecido como processo servidor.
Postgres:  processo cliente responsável por atender a requisição de um cliente.
Caso o cliente não esteja  no servidor, o mesmo se comunica com o servidor através de uma conexão de rede TCP/IP.

O servidor PostgreSQL pode tratar várias conexões  simultâneas de clientes. Para esta finalidade é iniciado um novo processo para cada conexão.



# 5. REFERÊNCIAS

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04

https://www.devmedia.com.br/postgresql-tutorial/33025

https://www.devmedia.com.br/instalacao-e-configuracao-do-servidor-postgresql-no-linux/26184

https://blog.profissionaislinux.com.br/linux/postgresql/


 # CONFIGURAÇÃO

 https://www.digitalocean.com/community/tutorials/introduction-to-queries-postgresql

Para começar, abra um prompt do PostgreSQL como seu superusuário do postgres:

```
sudo -u postgres psql
```

Obs: depois que configurar um usuário, a forma de se logar passa a ser:

```
psql -U mpi -h localhost -d postgres
```
passando o usuário, host e database

 O Postgres funciona muito bem para se tornar utilizável desde o início sem ter que fazer nada. Por padrão, ele cria automaticamente o usuário postgres. Vamos começar usando o psql utilitário, que é um utilitário instalado com o Postgres, que permite executar funções administrativas sem precisar conhecer seus comandos SQL reais.

# 6. CONFIGURANDO POSTGRESQL

Autenticação de pares - Peer authentication

O método de autenticação peer funciona obtendo o nome de usuário do sistema operacional do cliente a partir do kernel e usando-o como o nome de usuário do banco de dados permitido (com mapeamento de nome de usuário opcional). Este método é suportado apenas em conexões locais.

Autenticação de senha

Os métodos de autenticação baseados em senha são md5 e senha. Esses métodos funcionam de maneira semelhante, exceto pelo modo como a senha é enviada pela conexão, ou seja, com hash MD5 e texto não criptografado, respectivamente.

Se você está preocupado com ataques de "sniffing" de senha, o md5 é o preferido. A senha simples deve sempre ser evitada, se possível. No entanto, o md5 não pode ser usado com o recurso db_user_namespace. Se a conexão estiver protegida pela criptografia SSL, a senha poderá ser usada com segurança (embora a autenticação com certificado SSL possa ser uma opção melhor, dependendo da utilização do SSL).


* trust - anyone who can connect to the server is authorized to access the database

* peer - use client's operating system user name as database user name to access it.

* md5 - password-base authentication

No arquivo:

/etc/postgresql/11/main/pg_hba.conf

```
# Database administrative login by Unix domain socket
local   all             postgres                 peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                      peer
```

Altere para:

```
# Database administrative login by Unix domain socket
local   all             postgres                 md5

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                      md5
```


REINICIAR:

sudo service postgresql restart
mpi@mpi-300E5K-300E5Q:~/www/socios-brasil$ sudo service postgresql status
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: active (exited) since Wed 2019-08-14 14:13:58 -03; 5s ago
  Process: 29012 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 29012 (code=exited, status=0/SUCCESS)

ago 14 14:13:58 mpi-300E5K-300E5Q systemd[1]: Starting PostgreSQL RDBMS...
ago 14 14:13:58 mpi-300E5K-300E5Q systemd[1]: Started PostgreSQL RDBMS.

# 7. CRIANDO USUÁRIOS

O Postgres **não gerencia usuários ou grupos diretamente**, como a maioria dos modelos de permissão padrão. Em vez disso, gerencia diretamente o que chama de papéis (ROLES) .

Embora seja certamente conveniente que o Postgres configure um conjunto de **usuários padrão** para você, é uma péssima idéia usá-los para qualquer coisa, exceto desenvolvimento local, porque eles são muito conhecidos e, mais importante, são super contas de usuário - eles podem fazer qualquer coisa, incluindo excluir bancos de dados. Isso não é seguro para um banco de dados de produção - **precisamos de usuários com permissões limitadas**. Então, como criamos e usamos novos usuários (papéis)?

Existem duas maneiras principais de fazer isso:

https://www.codementor.io/engineerapart/getting-started-with-postgresql-on-mac-osx-are8jcopb#i-introduction

* Executar diretamente a consulta CREATE ROLE no banco de dados
* Usar o createuser utilitário que vem instalado com o Postgres (que é apenas um invólucro para execução CREATE ROLE).

A sintaxe básica para se **CREATE ROLE** parece com isso:

```sql
CREATE ROLE username WITH LOGIN PASSWORD 'quoted password' [OPTIONS]
```

Onde username está o usuário que você deseja criar, e a senha vai no final entre aspas. Nós vamos chegar às opções mais tarde.

Criando o usuário **mpi**

```
sudo -u postgres psql
postgres=# CREATE ROLE mpi WITH LOGIN PASSWORD 'vh3mqxi';
```
Espere! A lista de atributos para o usuário está completamente vazia. Por quê?

É assim que o Postgres gerencia com segurança os padrões. Esse usuário pode ler qualquer banco de dados, tabela ou linha para o qual tenha permissões, mas nada mais - ele não pode criar ou gerenciar bancos de dados e não possui poderes administrativos. Isto é uma coisa boa! Isso ajuda a manter seu banco de dados seguro.

Então, vamos adicionar a CREATEDB permissão ao nosso novo usuário para permitir que eles criem bancos de dados:

```
postgres=# ALTER ROLE mpi CREATEDB;
postgres=# \du 
postgres=# \q # quit
```

# 8. LOGIN COM NOVO USUÁRIO

Conectando o usuário no BD postgres padrão.

```
psql -U mpi -h localhost postgres
```


 # COMANDO INICIAL LINUX

```
sudo -u postgres psql
```

psql (11.4 (Ubuntu 11.4-1.pgdg18.10+1), servidor 10.9 (Ubuntu 10.9-1.pgdg18.10+1))
Digite "help" para ajuda.

postgres=# 

# 9. LISTANDO OS USUÁRIOS

```
postgres=# \du
                                    Lista de roles
 Nome da role |                         Atributos                         | Membro de 
--------------+-----------------------------------------------------------+-----------
 ampere       | Super-usuário, Cria role, Cria BD                         | {}
 postgres     | Super-usuário, Cria role, Cria BD, Replicação, Ignora RLS | {}

postgres=# 
```

# 10. DELETAR USUÁRIO

```
sudo -u postgres psql
postgres=# DROP USER ampere;
```

postgres=# \du
                                    Lista de roles
 Nome da role |                         Atributos                         | Membro de 
--------------+-----------------------------------------------------------+-----------
 postgres     | Super-usuário, Cria role, Cria BD, Replicação, Ignora RLS | {}

postgres=# 


# 11. BACKUP


```bash
pg_dump --username postgres --host localhost Modelos | gzip -c > modelos.sql.gz
```

# 12. RESTAURAR LINUX

Logue-se:

```bash
sudo -u postgres psql
```

Crie o BD

Logue-se:

```bash
drop database "Modelos";
create database "Modelos";
```

```bash
gunzip -c modelos.sql.gz | psql -U ampere -h localhost -d "Modelos"
```

## 12.1. Desconectando usuários para fazer DROP

Logue-se:

```bash
sudo -u postgres psql
```

Então execute:
```bash
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'modelos';
```

E depois:

```bash
drop database modelos;
```

## 12.2. RESTAURANDO O BD

Logue-se:

```bash
sudo -u postgres psql
```

Crie o BD

Logue-se:

```bash
create database "Modelos";
```

Deve ser entre Aspas para ele respeitar a Maiúscula.

Vá até o diretório onde se encontra o arquivo .sql.gz e
execute:

```bash
gunzip -c modelos.sql.gz | psql -U ampere -h localhost -d "Modelos"
```

## 12.3. Linux Restaurando com pg_restore

pg_restore -c -i -U ampere -d Modelos -v "/tmp/modelos.tar" -W

-c to clean the database
-i to ignore any database version checks
-U to force a user
-d to select the database
-v verbose mode, don't know why
"$$" the location of the files to import in tmp to get around permission issues
-W to force asking for the password to the user (postgres)


## 12.4. RESTAURANDO O BD NO WINDOWS

1) Use a tecla do Windows para buscar pela palavra SQL e aparecerá o terminal do POSTGRES. 

Depois vá teclando Enter e digite a senha do usuário postgres.

Então utilize os comandos básicos:

### 12.4.1. DROP

```bash
drop database modelos;
```
Se tiver usuário logado execute este primeiro e depois o drop:

```bash
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'Modelos';
```

## 12.5. CREATE

create database 'Modelos';

## 12.6. RESTAURE

Abra o prompt do DOS e digite (supondo que abriu o prompt no mesmo diretório do arquivo horizon.sql):

```bash
psql -U ampere -h localhost -d "Modelos" -f modelos.sql
```

ou se o arquivo estiver em algum outro diretório,
No prompt do DOS (digite):

```bash
psql -U ampere -h localhost -d "Modelos" -f C:/dev/modelos.sql
```

# 13. Instalando o PostgreSQL no Linux

## 13.1. Drop Database - Desconectando usuários

```
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'modelos';
```

## 13.2. Restaurando no Windows

Para restaurar no Windows, abra o terminal no diretório onde está seu arquivo *.sql e execute:

```bash
psql.exe -U ampere -d modelos -f modelos.sql
```

Onde o BD se chama "modelos". Será solicitada a senha do usuário "ampere".


## 13.3. Backup 

Para fazer o Backup no Linux AWS:

```bash
pg_dump --username postgres --host localhost Modelos | gzip -c > modelos.sql.gz
```


## 13.4. RESTAURAR I - Arquivo SQL.GZ

Acesse como usuário postgres:

```
sudo su - postgres
```

Vá até o diretório onde se encontra o arquivo .sql.gz e
execute:

```bash
gunzip -c modelos.sql.gz | psql -U postgres -d modelos
```

## 13.5. RESTAURAR II - arquivo descompactado .sql (Windows)

Para RESTAURAR (certifique-se de que tenha colocado o PostgreSQL) no PATH:

1) Caso tenha criado o BD já pelo pgAdmin (web).

Supondo que tenha criado o BD **Modelos** vazio. E vamos restaurar o bd nele:

Abra o prompt do DOS e digite (supondo que abriu o prompt no mesmo diretório do arquivo horizon.sql):

```bash
psql -U ampere -h localhost -d "Modelos" -f modelos.sql
```

ou se o arquivo estiver em algum outro diretório,
No prompt do DOS (digite):

```bash
psql -U ampere -h localhost -d "Modelos" -f C:/dev/modelos.sql
```



Referências:

https://www.digitalocean.com/community/tutorials/como-instalar-e-utilizar-o-postgresql-no-ubuntu-16-04-pt


http://www.postgresqltutorial.com/postgresql-backup-database/


```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
```

O procedimento de instalação criou um usuário chamado postgres que é associado com o role padrão do Postgres. Para usar o Postgres, podemos fazer login nessa conta.

Alterne para a conta postgres no seu servidor digitando:

```bash
sudo -i -u postgres
```

## 13.6. Criando Usuário

Primeiro, logue-se:

```bash
sudo -u postgres psql
postgres=# CREATE USER <username>;
```

Liste os usuários criados:

```bash
=# SELECT usename FROM pg_user;
```

Para listarmos as Roles digite:

```bash
\du
```

Exemplo:

```bash
postgres=# CREATE USER ampere;
CREATE ROLE
postgres=# SELECT usename FROM pg_user;
 usename
----------
 postgres
 ampere
(2 rows)

postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 ampere    |                                                            | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
```

## 13.7. Alterando o usuário para Superuser

```bash
ALTER USER ampere WITH SUPERUSER;
```


## 13.8. Criando uma Senha para o Usuário

```bash
sudo -u postgres psql
psql=\# \password ampere;
```

ou 

```bash
sudo -u postgres psql
psql=\# ALTER USER ampere WITH ENCRYPTED PASSWORD '<password>';
psql=\# \password ampere;
```

## 13.9. Dando Permissões ao Usuário

```bash
psql=\# GRANT ALL PRIVILEGES ON DATABASE "<dbname>" TO <username>;
psql=\# GRANT ALL PRIVILEGES ON DATABASE "Modelos" TO ampere;
```



## 13.10. Conceitos de permissão do PostgreSQL
O PostgreSQL (ou simplesmente "postgres") gerencia permissões através do conceito de "papéis" "ROLES".

As funções são diferentes das permissões tradicionais no estilo Unix, pois não há distinção entre usuários e grupos. As funções podem ser manipuladas para se assemelhar a essas convenções, mas também são mais flexíveis.

Por exemplo, os papéis podem ser membros de outros papéis, permitindo que eles assumam as características de permissão de papéis previamente definidos. As funções também podem possuir objetos e controlar o acesso a esses objetos para outras funções.

## 13.11. Como visualizar funções no PostgreSQL
Podemos visualizar as funções atuais definidas no PostgreSQL, fazendo login na interface de prompt com o seguinte comando:

```bash
sudo -u postgres psql
```

Para obter uma lista de funções, digite isto:

```bash
\du
```

## 13.12. Fazendo Backup com PostgreSQL

Versão testada (prompt do linux):

```bash
 pg_dump --username postgres --host localhost <nomedb> | gzip -c > backup.sql.gz
 pg_dump --username postgres --host localhost Modelos | gzip -c > modelos.sql.gz
```

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



## 13.13. Criando BD

```bash
sudo -u postgres createdb modelos
```

ou, depois de logar:

```bash
sudo -u postgres psql

# CREATE DATABASE modelos;
```

## 13.14. DROP DATABASE 

```
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'modelos';
```

## 13.15. Restaurando um Banco de Dados

```bash
pg_restore -d <nomebd>.tar

pg_restore -h localhost -U postgre -W -F t -d modelos Modelos.tar
```

## 13.16. Instalando PgAdmin3 no Ubuntu 16

```
sudo apt-get install pgadmin3
```

Once the installation has finished, it's time to set up a password for the main account; you'll log in to postgresql:

The version of postgres may vary slightly depending upon the Ubuntu version

```bash
sudo -u postgres psql 
```

```
psql (9.1.10)
Type "help" for help.
And then type \password postgres, and you'll be prompted for your password:

postgres=# \password postgres
```

## 13.17. Instalando PostgreSQL no Windows

O objetivo é instalarmos o PostgreSQL para depois trabalharmos com o Laravel na parte de desenvolvimento do **backend** utilizando o servidor embutido **artisan**. 

No windows a instalação é feita através de um arquivo binário que pode ser baixado em:

https://www.postgresql.org/download/windows/


![fig01](images/postgresql/fig01.PNG)

Depois de clicar em Download Installers você será redirecionado para:

https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

![fig02](images/postgresql/fig02.PNG)


Neste momento (25/10/2019) foi lançado o PostgreSQL 11, porém, ainda utilizaremos a versão 9.6.



## 13.18. Configurando o WampServer no Windows para PostgreSQL

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
