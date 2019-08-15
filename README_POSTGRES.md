# INSTALAÇÃO


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

# Etapa 2 - Usando funções e bancos de dados do PostgreSQL

Por padrão, o Postgres usa um conceito chamado "funções" para lidar com autenticação e autorização. Estes são, de certa forma, semelhantes às contas regulares no estilo Unix, mas o Postgres não faz distinção entre usuários e grupos e prefere o termo mais flexível "role".

Após a instalação, o Postgres é configurado para usar a autenticação ident, o que significa que ele associa as funções do Postgres a uma conta do sistema Unix / Linux correspondente. Se houver uma função no Postgres, um nome de usuário do Unix / Linux com o mesmo nome poderá entrar como essa função.

O procedimento de instalação criou uma conta de usuário chamada postgres que está associada à função padrão do Postgres. Para usar o Postgres, você pode fazer login nessa conta.

Existem algumas maneiras de utilizar essa conta para acessar o Postgres.

# VERSÃO DO POSTGRES - Client

```bash
psql --version
ou
psql -V
```

```
psql (PostgreSQL) 11.4 (Ubuntu 11.4-1.pgdg18.10+1)
```

# STATUS DO SERVIÇO

```bash
sudo systemctl status postgresql.service
```

Reiniciar o serviço do POSTGRESQL

```bash
sudo systemctl restart postgresql
```


Existem **dois processos (daemon) que atuam diretamente da execução do servidor**.

Postmaster:  processo servidor responsável diretamente pela gerência de banco de dados, aceita conexões, e é conhecido como processo servidor.
Postgres:  processo cliente responsável por atender a requisição de um cliente.
Caso o cliente não esteja  no servidor, o mesmo se comunica com o servidor através de uma conexão de rede TCP/IP.

O servidor PostgreSQL pode tratar várias conexões  simultâneas de clientes. Para esta finalidade é iniciado um novo processo para cada conexão.



# REFERÊNCIAS

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

 O Postgres funciona muito bem para se tornar utilizável desde o início sem ter que fazer nada. Por padrão, ele cria automaticamente o usuário postgres. Vamos começar usando o psql utilitário, que é um utilitário instalado com o Postgres, que permite executar funções administrativas sem precisar conhecer seus comandos SQL reais.

# CONFIGURANDO POSTGRESQL

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

# CRIANDO USUÁRIOS

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
postgres=# CREATE ROLE mpi WITH LOGIN PASSWORD 'seupass';
```
Espere! A lista de atributos para o usuário está completamente vazia. Por quê?

É assim que o Postgres gerencia com segurança os padrões. Esse usuário pode ler qualquer banco de dados, tabela ou linha para o qual tenha permissões, mas nada mais - ele não pode criar ou gerenciar bancos de dados e não possui poderes administrativos. Isto é uma coisa boa! Isso ajuda a manter seu banco de dados seguro.

Então, vamos adicionar a CREATEDB permissão ao nosso novo usuário para permitir que eles criem bancos de dados:

```
postgres=# ALTER ROLE mpi CREATEDB;
postgres=# \du 
postgres=# \q # quit
```

# LOGIN COM NOVO USUÁRIO

```
psql postgres -U mpi
```


```
sudo -u postgres createuser --interactive
[sudo] senha para user:
Digite o nome da role a ser adicionada: ampere
A nova role poderá criar um super-usuário? (s/n) s
```


 # COMANDO INICIAL LINUX

```
sudo -u postgres psql
```

psql (11.4 (Ubuntu 11.4-1.pgdg18.10+1), servidor 10.9 (Ubuntu 10.9-1.pgdg18.10+1))
Digite "help" para ajuda.

postgres=# 

# LISTANDO OS USUÁRIOS

```
postgres=# \du
                                    Lista de roles
 Nome da role |                         Atributos                         | Membro de 
--------------+-----------------------------------------------------------+-----------
 ampere       | Super-usuário, Cria role, Cria BD                         | {}
 postgres     | Super-usuário, Cria role, Cria BD, Replicação, Ignora RLS | {}

postgres=# 
```

# DELETAR USUÁRIO

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


# BACKUP


```bash
pg_dump --username postgres --host localhost Modelos | gzip -c > modelos.sql.gz
```

# RESTAURAR LINUX

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

## Desconectando usuários para fazer DROP

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

## RESTAURANDO O BD

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

## Linux Restaurando com pg_restore

pg_restore -c -i -U ampere -d Modelos -v "/tmp/modelos.tar" -W

-c to clean the database
-i to ignore any database version checks
-U to force a user
-d to select the database
-v verbose mode, don't know why
"$$" the location of the files to import in tmp to get around permission issues
-W to force asking for the password to the user (postgres)


## RESTAURANDO O BD NO WINDOWS

1) Use a tecla do Windows para buscar pela palavra SQL e aparecerá o terminal do POSTGRES. 

Depois vá teclando Enter e digite a senha do usuário postgres.

Então utilize os comandos básicos:

### DROP

```bash
drop database modelos;
```
Se tiver usuário logado execute este primeiro e depois o drop:

```bash
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'Modelos';
```

## CREATE

create database 'Modelos';

## RESTAURE

Abra o prompt do DOS e digite (supondo que abriu o prompt no mesmo diretório do arquivo horizon.sql):

```bash
psql -U ampere -h localhost -d "Modelos" -f modelos.sql
```

ou se o arquivo estiver em algum outro diretório,
No prompt do DOS (digite):

```bash
psql -U ampere -h localhost -d "Modelos" -f C:/dev/modelos.sql
```