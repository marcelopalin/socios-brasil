#!/bin/bash

set -e

mkdir -p data/download data/output

if [ "$1" = "--use-mirror" ]; then
	USE_MIRROR=true
else
	USE_MIRROR=false
fi

function extract_data() {
	time python extract_dump.py data/output/ data/download/DADOS_ABERTOS_CNPJ*.zip --no_censorship
}

function extract_holdings() {
	time python extract_holdings.py data/output/socio.csv.gz data/output/empresa-socia.csv.gz
}

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

echo "Extraindo os dados baixados em data/output/"
extract_data
echo "Chamando o metodo extract_holdings.py data/output/socio.csv.gz data/output/empresa-socia.csv.gz"
extract_holdings
echo "Extraindo os cnaes de data/output/cnae-$versao.csv"
extract_cnae
