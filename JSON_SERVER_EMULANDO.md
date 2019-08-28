## 1.2. Utilizando um Servidor 

**Instalação do Jsonserver: **

```bash
npm install -g json-server
npm install -save-dev json-server
```

Antes de começar a desenvolver no Front End, abra um NOVO terminal e inicie o webservice:

Na pasta **database** coloquei um arquivo chamado **db_temp.json** então execute:

```bash
json-server --watch db_temp.json
```