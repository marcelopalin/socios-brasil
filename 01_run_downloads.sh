#!/bin/bash

set -e

echo "Criando os diretórios: data/download data/output"
mkdir -p data/download data/output

echo "Baixando os arquivos .zip para data/download com 8 conexões!"

if [ "$1" = "--use-mirror" ]; then
	USE_MIRROR=true
	echo "BAIXANDO DO MIRROR: https://data.brasil.io/mirror/socios-brasil!"
else
	USE_MIRROR=false
	echo "BAIXANDO DIRETO DA RECEITA FEDERAL!"
fi

function download_data() {
	CONNECTIONS=8
	DOWNLOAD_URL="https://receita.economia.gov.br/orientacao/tributaria/cadastros/cadastro-nacional-de-pessoas-juridicas-cnpj/dados-publicos-cnpj"
	FILE_URLS=$(wget --quiet --no-check-certificate -O - "$DOWNLOAD_URL" \
		| grep --color=no DADOS_ABERTOS_CNPJ \
		| grep --color=no ".zip" \
		| sed 's/.*"http:/http:/; s/".*//' \
		| sort)
	MIRROR_URL="https://data.brasil.io/mirror/socios-brasil"

	for url in $FILE_URLS; do
		if $USE_MIRROR; then
			url="$MIRROR_URL/$(basename $url)"
		fi
		time aria2c --auto-file-renaming=false --continue=true -s $CONNECTIONS -x $CONNECTIONS --dir=data/download "$url"
	done
}

# Chamando o metodo
download_data
echo "DOWNLOAD FINALIZADO!"
