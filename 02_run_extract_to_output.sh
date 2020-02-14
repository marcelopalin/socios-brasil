#!/bin/bash

set -e

echo "-----------------------------------------------------------------------"
echo "Atenção: crie um ambiente virtual python e instale os requirements!"
echo "-----------------------------------------------------------------------"

virtualenv -p python3 venv
source venv/bin/activate
pip3 install -r requirements.txt


echo "-----------------------------------------------------------------------"
echo " ATIVADO O AMBIENTE VIRTUAL:"
echo "-----------------------------------------------------------------------"

echo "Extraindo os dados para data/output com --no_censorship"
function extract_data() {
	time python extract_dump.py data/output/ data/download/DADOS_ABERTOS_CNPJ*.zip --no_censorship
}

# Chamando o metodo extract_data
extract_data
echo "FINALIZADO a EXTRAÇÃO PARA data/output!"
