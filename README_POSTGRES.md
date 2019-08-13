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