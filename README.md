# 1. OBJETIVO

Este projeto é um clone da versão https://github.com/turicas/socios-brasil. Fiz algumas adaptações ao excelente projeto deles.

Como está explicado no projeto deles o objetivo é rodar Scripts que baixam todos os dados de sócios das empresas brasileiras [disponíveis
no site da Receita
Federal](https://receita.economia.gov.br/orientacao/tributaria/cadastros/cadastro-nacional-de-pessoas-juridicas-cnpj/dados-publicos-cnpj),
extrai, limpa e converte para CSV. [Veja mais
detalhes](http://dados.gov.br/noticia/governo-federal-disponibiliza-os-dados-abertos-do-cadastro-nacional-da-pessoa-juridica).

## 1.1. Licença

A licença do código é [LGPL3](https://www.gnu.org/licenses/lgpl-3.0.en.html) e
dos dados convertidos [Creative Commons Attribution
ShareAlike](https://creativecommons.org/licenses/by-sa/4.0/). Caso utilize os
dados, **cite a fonte original e quem tratou os dados**, como: **Fonte: Receita
Federal do Brasil, dados tratados por Álvaro
Justen/[Brasil.IO](https://brasil.io/)**. Caso compartilhe os dados, **utilize
a mesma licença**.

# 2. AVISO

Se esse programa e/ou os dados resultantes foram úteis a você ou à sua empresa,
considere [fazer uma doação ao projeto Brasil.IO](https://brasil.io/doe), que é
mantido voluntariamente.

# 3. NA PRÁTICA

Todas as informações com maiores detalhes poderão ser encontrados em https://github.com/turicas/socios-brasil. O foco aqui é instruir como executar o projeto e obter no final um BD em SQLite ou PostgreSQL.

# 4. ADAPTAÇÃO 01

Quebrei o script bash em vários scripts para termos maior controle.

Como resultado na pasta **data/output** teremos os seguintes arquivos
após rodarmos os scripts (.sh):

- `empresa.csv.gz`: cadastro das empresas;
- `socio.csv.gz`: cadastro dos sócios;
- `cnae-secundaria.csv.gz`: lista de CNAEs secundárias;
- `empresa-socia.csv.gz`: cadastro das empresas que são sócias de outras
  empresas (é o arquivo `socio.csv.gz` filtrado por sócios do tipo PJ).

Além disso, os arquivos contidos nas pastas [schema](schema/) e
[schema-full](schema-full/) podem te ajudar a importar os dados para um banco
de dados (veja comandos para [SQLite](#sqlite) e [PostgreSQL](#postgresql)
abaixo).

> Nota 1: a extensão `.gz` quer dizer que o arquivo foi compactado usando gzip.
> Para descompactá-lo execute o comando `gunzip arquivo.gz` (**não é necessário
> descompactá-los** caso você siga as instruções de importação em
> [SQLite](#sqlite) e [PostgreSQL](#postgresql)).

> Nota 2: a codificação de caracteres original é ISO-8859-15, mas o script gera
> os arquivos CSV em UTF-8.

### 4.0.1. Privacidade

Para garantir a privacidade, evitar SPAM e publicar apenas dados corretos, o
script deleta/limpa algumas colunas com informações sensíveis. Essa será a
forma padrão de funcionamento para não facilitar a exposição desses dados. Os
dados censurados são:

- `empresa.csv.gz`: deletadas as colunas "codigo_pais", "correio_eletronico" e
  "nome_pais" (nome/código do país incorreto);
- `socio.csv.gz`: deletadas as colunas "codigo_pais" e "nome_pais" (incorretos)
  e, caso seja MEI, as colunas "complemento", "ddd_fax", "ddd_telefone_1",
  "ddd_telefone_2", "descricao_tipo_logradouro", "logradouro", "numero" terão
  seus valores em branco e na razão social não constará o CPF do dono.

> ATENÇÃO:

Caso queira rodar o script sem o modo censura, altere o `run.sh` e adicione a
opção `--no_censorship` na linha do `extract_dump.py`.

> Já acrescentei tanto no script **run-origina.sh** quanto no script **02_run_extract_to_output.sh**

## 4.1. PREPARANDO

### 4.1.1. Instalando as Dependências

Esse script depende de Python 3.7, de algumas bibliotecas e do software
[aria2](https://aria2.github.io/). Depois de instalar o Python 3.7 e o aria2,
instale as bibliotecas executando:

```bash
pip install -r requirements.txt
```

### 4.1.2. MODO DE EXECUÇÃO COMPLETA - 1 SCRIPT APENAS

Então basta executar o script `run-original.sh` para baixar os arquivos necessários e
fazer as conversões:

```bash
./run-original.sh
```

No final você terá os arquivos .Zip na pasta data/downloads e os arquivos .csv.gz na pasta data/output.

```
data/download$ tree -L 2 .
.
├── DADOS_ABERTOS_CNPJ_01.zip
├── DADOS_ABERTOS_CNPJ_02.zip
├── DADOS_ABERTOS_CNPJ_03.zip
├── DADOS_ABERTOS_CNPJ_04.zip
├── DADOS_ABERTOS_CNPJ_05.zip
├── DADOS_ABERTOS_CNPJ_06.zip
├── DADOS_ABERTOS_CNPJ_07.zip
├── DADOS_ABERTOS_CNPJ_08.zip
├── DADOS_ABERTOS_CNPJ_09.zip
├── DADOS_ABERTOS_CNPJ_10.zip
├── DADOS_ABERTOS_CNPJ_11.zip
├── DADOS_ABERTOS_CNPJ_12.zip
├── DADOS_ABERTOS_CNPJ_13.zip
├── DADOS_ABERTOS_CNPJ_14.zip
├── DADOS_ABERTOS_CNPJ_15.zip
├── DADOS_ABERTOS_CNPJ_16.zip
├── DADOS_ABERTOS_CNPJ_17.zip
├── DADOS_ABERTOS_CNPJ_18.zip
├── DADOS_ABERTOS_CNPJ_19.zip
└── DADOS_ABERTOS_CNPJ_20.zip

```

Tamanho dos arquivos baixados em download:
data/download$ ls -lah
```
total 6,2G
drwxr-xr-x 2 mpi mpi 4,0K fev 13 23:36 .
drwxr-xr-x 4 mpi mpi 4,0K fev 12 23:25 ..
-rw-r--r-- 1 mpi mpi 262M fev 13 00:29 DADOS_ABERTOS_CNPJ_01.zip
-rw-r--r-- 1 mpi mpi 272M fev 13 00:29 DADOS_ABERTOS_CNPJ_02.zip
-rw-r--r-- 1 mpi mpi 283M fev 13 00:24 DADOS_ABERTOS_CNPJ_03.zip
-rw-r--r-- 1 mpi mpi 288M fev 13 00:33 DADOS_ABERTOS_CNPJ_04.zip
-rw-r--r-- 1 mpi mpi 280M fev 13 01:06 DADOS_ABERTOS_CNPJ_05.zip
-rw-r--r-- 1 mpi mpi 301M fev 13 01:13 DADOS_ABERTOS_CNPJ_06.zip
-rw-r--r-- 1 mpi mpi 318M fev 13 01:21 DADOS_ABERTOS_CNPJ_07.zip
-rw-r--r-- 1 mpi mpi 332M fev 13 01:19 DADOS_ABERTOS_CNPJ_08.zip
-rw-r--r-- 1 mpi mpi 339M fev 13 01:28 DADOS_ABERTOS_CNPJ_09.zip
-rw-r--r-- 1 mpi mpi 342M fev 13 01:23 DADOS_ABERTOS_CNPJ_10.zip
-rw-r--r-- 1 mpi mpi 355M fev 13 07:16 DADOS_ABERTOS_CNPJ_11.zip
-rw-r--r-- 1 mpi mpi 360M fev 13 07:18 DADOS_ABERTOS_CNPJ_12.zip
-rw-r--r-- 1 mpi mpi 371M fev 13 07:20 DADOS_ABERTOS_CNPJ_13.zip
-rw-r--r-- 1 mpi mpi 364M fev 13 07:32 DADOS_ABERTOS_CNPJ_14.zip
-rw-r--r-- 1 mpi mpi 366M fev 13 07:30 DADOS_ABERTOS_CNPJ_15.zip
-rw-r--r-- 1 mpi mpi 363M fev 13 07:32 DADOS_ABERTOS_CNPJ_16.zip
-rw-r--r-- 1 mpi mpi 363M fev 13 07:30 DADOS_ABERTOS_CNPJ_17.zip
-rw-r--r-- 1 mpi mpi 280M fev 13 07:32 DADOS_ABERTOS_CNPJ_18.zip
-rw-r--r-- 1 mpi mpi 219M fev 13 07:30 DADOS_ABERTOS_CNPJ_19.zip
-rw-r--r-- 1 mpi mpi 258M fev 13 07:55 DADOS_ABERTOS_CNPJ_20.zip

```



```
tree -L 2 output/
output/
├── cnae-1.0.csv.gz
├── cnae-1.1.csv.gz
├── cnae-2.0.csv.gz
├── cnae-2.1.csv.gz
├── cnae-2.2.csv.gz
├── cnae-2.3.csv.gz
├── cnae-secundaria.csv.gz
├── empresa.csv.gz - 3 Giga
├── empresa-socia.csv.gz
├── error.csv.gz
├── header.csv.gz
├── socio.csv.gz
├── socios-brasil.sqlite - BD final 13 G
└── trailler.csv.gz
```

Tamanhos dos arquivos gerados em output:

```
/socios-brasil/data/output$ ls -lah
total 17G
drwxr-xr-x 2 mpi mpi 4,0K fev 14 01:17 .
drwxr-xr-x 4 mpi mpi 4,0K fev 12 23:25 ..
-rwxrwxrwx 1 mpi mpi 132K fev 13 23:02 cnae-1.0.csv.gz
-rwxrwxrwx 1 mpi mpi 150K fev 13 23:02 cnae-1.1.csv.gz
-rwxrwxrwx 1 mpi mpi 185K fev 13 23:02 cnae-2.0.csv.gz
-rwxrwxrwx 1 mpi mpi 188K fev 13 23:02 cnae-2.1.csv.gz
-rwxrwxrwx 1 mpi mpi 189K fev 13 23:02 cnae-2.2.csv.gz
-rwxrwxrwx 1 mpi mpi 190K fev 13 23:02 cnae-2.3.csv.gz
-rwxrwxrwx 1 mpi mpi 224M fev 13 23:02 cnae-secundaria.csv.gz
-rwxrwxrwx 1 mpi mpi 3,0G fev 13 23:07 empresa.csv.gz
-rwxrwxrwx 1 mpi mpi  13M fev 13 23:02 empresa-socia.csv.gz
-rwxrwxrwx 1 mpi mpi   35 fev 13 23:07 error.csv.gz
-rwxrwxrwx 1 mpi mpi  107 fev 13 23:07 header.csv.gz
-rwxrwxrwx 1 mpi mpi 414M fev 13 23:07 socio.csv.gz
-rwxrwxrwx 1 mpi mpi  13G fev 14 01:13 socios-brasil.sqlite
-rwxrwxrwx 1 mpi mpi  106 fev 13 23:07 trailler.csv.gz
```

O maior CSV é o empresa.csv.gz com 3 G e o BD Sqlite final fica com 13G.

# 5. GERANDO O SQLITE em data/output/socios-brasil.sqlite

Instale a CLI da rows e a versão de desenvolvimento da biblioteca rodando
(requer Python 3.7+):

```bash
pip install rows[cli]
pip install -U https://github.com/turicas/rows/archive/develop.zip
```

Lembrando que você deve ter criado o ambiente virtual do python:

```bash
virtualenv -p python3 venv
source venv/bin/activate
pip3 install -r requirements.txt
```

Dentro da pasta do projeto **socios-brasil** rode:

```ini
DB_NAME="data/output/socios-brasil.sqlite"
rows csv2sqlite --schemas=schema-full/empresa.csv data/output/empresa.csv.gz "$DB_NAME"
rows csv2sqlite --schemas=schema-full/socio.csv data/output/socio.csv.gz "$DB_NAME"
rows csv2sqlite --schemas=schema-full/socio.csv data/output/empresa-socia.csv.gz "$DB_NAME"
rows csv2sqlite --schemas=schema-full/cnae-secundaria.csv data/output/cnae-secundaria.csv.gz "$DB_NAME"
```

Pegue um café, aguarde alguns minutos e depois desfrute do banco de dados em
`data/output/socios-brasil.sqlite`. :)
