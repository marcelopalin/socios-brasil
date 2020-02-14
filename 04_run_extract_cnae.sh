#!/bin/bash

set -e

echo "-----------------------------------------------------------------------"
echo "Atenção: crie um ambiente virtual em venv - caso não exista!"
echo "-----------------------------------------------------------------------"

source venv/bin/activate

echo "-----------------------------------------------------------------------"
echo " USANDO O AMBIENTE VIRTUAL:"
echo "-----------------------------------------------------------------------"

echo "Extraindo os CNAES data/output"
function extract_cnae() {
	for versao in "1.0" "1.1" "2.0" "2.1" "2.2" "2.3"; do
		filename="data/output/cnae-$versao.csv"
		rm -rf "$filename"
		time scrapy runspider \
			-s RETRY_HTTP_CODES="500,503,504,400,404,408" \
			-s HTTPCACHE_ENABLED=true \
			--loglevel=INFO \
			-a versao="$versao" \
			-o "$filename" \
			cnae.py
		gzip "$filename"
	done
}
# Chamando o metodo extract_cnae
extractextract_cnae_data
echo "FINALIZADO a EXTRAÇÃO DOS CNAES PARA data/output!"

echo "PROXIMOS PASSOS - RODAR: (as linhas foram adaptadas somente para lembrar)"
echo "rows csv2sqlite --schemas=schema-full/empresa.csv data/output/empresa.csv.gz '$ DB_NAME'"
echo "rows csv2sqlite --schemas=schema-full/socio.csv data/output/socio.csv.gz '$ DB_NAME'"
echo "rows csv2sqlite --schemas=schema-full/socio.csv data/output/empresa-socia.csv.gz '$ DB_NAME'"
echo "rows csv2sqlite --schemas=schema-full/cnae-secundaria.csv data/output/cnae-secundaria.csv.gz '$ DB_NAME'"

echo "ATENCAO: se nao esqueca de rodar com schema-full!"
