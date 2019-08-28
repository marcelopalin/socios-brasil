# CRIANDO ÍNDICES NA TABELA

Vamos criar o índice na tabela empresa do 
BD empresa

Conecte-se ao PostgreSQL:

```
psql -U ampere -h localhost -d empresa
```

Caso tenha se conectado a outro BD, basta fazer:

\c empresa

para se conectar.

Vamos criar o índice único de CNPJs da tabela empresa, 
vamos utilizar de forma concorrente:


```
create unique index concurrently empresa_cnpj_uindex on empresa (cnpj);
```

ATENÇÃO: caso dê algum erro - a forma concorrente mantém o índice quebrado no BD, então precisaremos DELETÁ-LO antes de criarmos outro novamente.

Vamos listar os índices da tabela

```
                        Tabela "public.empresa"
           Coluna            |  Tipo   | Collation | Nullable | Default 
-----------------------------+---------+-----------+----------+---------
 cnpj                        | text    |           |          | 
 identificador_matriz_filial | bigint  |           |          | 
 razao_social                | text    |           |          | 
 nome_fantasia               | text    |           |          | 
 situacao_cadastral          | bigint  |           |          | 
 data_situacao_cadastral     | date    |           |          | 
 motivo_situacao_cadastral   | bigint  |           |          | 
 nome_cidade_exterior        | text    |           |          | 
 codigo_natureza_juridica    | bigint  |           |          | 
 data_inicio_atividade       | date    |           |          | 
 cnae_fiscal                 | bigint  |           |          | 
 descricao_tipo_logradouro   | text    |           |          | 
 logradouro                  | text    |           |          | 
 numero                      | text    |           |          | 
 complemento                 | text    |           |          | 
 bairro                      | text    |           |          | 
 cep                         | bigint  |           |          | 
 uf                          | text    |           |          | 
 codigo_municipio            | bigint  |           |          | 
 municipio                   | text    |           |          | 
 ddd_telefone_1              | text    |           |          | 
 ddd_telefone_2              | text    |           |          | 
 ddd_fax                     | text    |           |          | 
 qualificacao_do_responsavel | bigint  |           |          | 
 capital_social              | numeric |           |          | 
 porte                       | bigint  |           |          | 
 opcao_pelo_simples          | boolean |           |          | 
 data_opcao_pelo_simples     | text    |           |          | 
 data_exclusao_do_simples    | text    |           |          | 
 opcao_pelo_mei              | boolean |           |          | 
 situacao_especial           | text    |           |          | 
 data_situacao_especial      | text    |           |          | 
Índices:
    "empresa_cnpj_uindex" UNIQUE, btree (cnpj)
    "idx_empresa_mei_simples" btree (opcao_pelo_mei, opcao_pelo_simples)
    "idx_empresa_situacao_cadastral" btree (situacao_cadastral)
    "idx_trgm_empresa_nome_fantasia" gin (nome_fantasia gin_trgm_ops)
    "idx_trgm_empresa_razao_social" gin (razao_social gin_trgm_ops)
```

Os índices são apresentados por último. Para deletarmos um índice basta fazermos:

```bash
DROP INDEX empresa_cnpj_uindex;
```

# CONSULTA SQL EMPRESA

```sql
SELECT E.*,
       S.nome_socio,
       S.codigo_qualificacao_socio
from empresa as E
inner join socio AS S on E.cnpj = S.cnpj
where E.cnpj = '19373880000170'
```

ou

```sql
SELECT
    empresa.*, socio.*
FROM
    empresa, socio
WHERE
    socio.cnpj = empresa.cnpj
    AND (empresa.cnpj = '19373880000170')
```

Referências

https://blog.dbi-services.com/create-index-concurrently-in-postgresql/
