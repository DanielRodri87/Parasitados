from supabase_client import SupabaseQuestionsClient
from csv_questions_importer import CsvQuestionsImporter

import_csv = CsvQuestionsImporter.import_csv_to_dicts

client = SupabaseQuestionsClient()
questions = import_csv("assets/pdf/questoes_md_formatadas.csv")
for q in questions:
    client.add(q)