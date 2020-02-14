#!/bin/bash

set -e

echo "-----------------------------------------------------------------------"
echo "Atenção: crie um ambiente virtual em venv - caso não exista!"
echo "-----------------------------------------------------------------------"

source venv/bin/activate

echo "-----------------------------------------------------------------------"
echo " USANDO O AMBIENTE VIRTUAL:"
echo "-----------------------------------------------------------------------"

echo "Extraindo os dados das Empresas Sócias para data/output"
function extract_data() {
	time python extract_holdings.py data/output/socio.csv.gz data/output/empresa-socia.csv.gz
}

# Chamando o metodo extract_data
extract_data
echo "FINALIZADO a EXTRAÇÃO EMPRESAS SOCIAS PARA data/output!"
