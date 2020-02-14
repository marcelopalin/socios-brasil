# OBJETIVO

Este projeto é um clone da versão https://github.com/turicas/socios-brasil. Fiz algumas adaptações ao excelente projeto deles.

Como está explicado no projeto deles o objetivo é rodar Scripts que baixam todos os dados de sócios das empresas brasileiras [disponíveis
no site da Receita
Federal](https://receita.economia.gov.br/orientacao/tributaria/cadastros/cadastro-nacional-de-pessoas-juridicas-cnpj/dados-publicos-cnpj),
extrai, limpa e converte para CSV. [Veja mais
detalhes](http://dados.gov.br/noticia/governo-federal-disponibiliza-os-dados-abertos-do-cadastro-nacional-da-pessoa-juridica).


## Licença

A licença do código é [LGPL3](https://www.gnu.org/licenses/lgpl-3.0.en.html) e
dos dados convertidos [Creative Commons Attribution
ShareAlike](https://creativecommons.org/licenses/by-sa/4.0/). Caso utilize os
dados, **cite a fonte original e quem tratou os dados**, como: **Fonte: Receita
Federal do Brasil, dados tratados por Álvaro
Justen/[Brasil.IO](https://brasil.io/)**. Caso compartilhe os dados, **utilize
a mesma licença**.


# AVISO

Se esse programa e/ou os dados resultantes foram úteis a você ou à sua empresa,
considere [fazer uma doação ao projeto Brasil.IO](https://brasil.io/doe), que é
mantido voluntariamente.


# NA PRÁTICA

Todas as informações com maiores detalhes poderão ser encontrados em https://github.com/turicas/socios-brasil. O foco aqui é instruir como executar o projeto e obter no final um BD em SQLite ou PostgreSQL.


# ADAPTAÇÃO 01

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

### Privacidade

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



## PREPARANDO

### Instalando as Dependências

Esse script depende de Python 3.7, de algumas bibliotecas e do software
[aria2](https://aria2.github.io/). Depois de instalar o Python 3.7 e o aria2,
instale as bibliotecas executando:

```bash
pip install -r requirements.txt
```

### MODO DE EXECUÇÃO COMPLETA - 1 SCRIPT APENAS

Então basta executar o script `run-original.sh` para baixar os arquivos necessários e
fazer as conversões:

```bash
./run-original.sh
```

No final você terá os arquivos .Zip na pasta data/downloads e os arquivos .csv.gz na pasta data/output.



# GERANDO O SQLITE em data/output/socios-brasil.sqlite

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

