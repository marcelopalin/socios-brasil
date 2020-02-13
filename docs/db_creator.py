import csv
import logging
import os
from pathlib import Path

from tqdm import tqdm

from cnpj_api.helpers import cnae_as_int
from cnpj_api.mongodb import MongoDB
from cnpj_api.sqlite import SQLite

logging.basicConfig(format='%(asctime)-15s:%(levelname)s:%(message)s',
                    level=logging.DEBUG)
LOG = logging.getLogger(__name__)


def main():
    mongo_uri = os.environ.get('MONGO_URI', 'localhost')
    db_name = os.environ.get('DATABASE_NAME', 'cnpj_api')
    coll_name = os.environ.get('COLLECTION_NAME', 'cnpj')

    mongo = MongoDB(mongo_uri, db_name)
    if not mongo.set_collection(coll_name):
        mongo.create_collection(coll_name)
        sqlite2mongodb(mongo)
        mongo.create_text_index()
    mongo.close()


def sqlite2mongodb(mongo):
    socios_br_str = os.environ.get('SOCIOS_BRASIL')
    socios_br = Path(socios_br_str)
    quali_csv = socios_br / 'qualificacao-socio.csv'
    cnae_files = (socios_br / 'data' / 'output').glob('cnae-?.?.csv')
    sqlite_filename = socios_br / 'data' / 'output' / 'socios-brasil.sqlite'
    sqlite = SQLite(sqlite_filename)

    # SQLite class will translate codigo_qualificacao_socio and cnae_fiscal
    sqlite.qualificacao = read_quali_csv(quali_csv)
    sqlite.cnae_text = read_cnae(cnae_files)

    # Add empresas
    total = sqlite.count_total('empresa')
    empresas = sqlite.get_empresas()
    with tqdm(total=total, desc='Empresas', unit='CNPJs') as pbar:
        mongo.insert_empresas(empresas, pbar)

    # Index used to add sócios
    mongo.create_cnpj_index()

    # Sócios PF
    total = sqlite.count_total('socio')
    with tqdm(total=total, desc='Sócios PF', unit='CNPJs') as pbar:
        for cnpj, socios in sqlite.get_socios_pf_per_cnpj():
            mongo.set_socios(cnpj, socios)
            pbar.update()

    # Sócios PJ
    total = sqlite.count_total('empresa_socia')
    with tqdm(total=total, desc='Sócios PJ', unit='CNPJs') as pbar:
        for cnpj, socios in sqlite.get_socios_pj_per_cnpj():
            mongo.append_socios(cnpj, socios)
            pbar.update()


def read_quali_csv(filename):
    code_descs = {}
    with open(filename) as csv_content:
        lines = csv_content.readlines()
        for line in lines[1:]:
            code_str, desc_newline = line.split(',')
            code = int(code_str)
            desc = desc_newline.rstrip()
            code_descs[code] = desc
    return code_descs


def read_cnae(cnae_files):
    LOG.info('Reading cnae descriptions')
    cnae_text = {}
    for filename in sorted(cnae_files):
        LOG.debug('Reading %s', filename.name)
        with open(filename) as csv_file:
            reader = csv.DictReader(csv_file)
            for row in reader:
                cnae = cnae_as_int(row['id_subclasse'])
                cnae_text[cnae] = row['descricao_subclasse']
    return cnae_text
