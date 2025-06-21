import csv
from typing import List, Dict

class CsvQuestionsImporter:
    
    @staticmethod
    def import_csv_to_dicts(csv_path: str) -> List[Dict]:
        questions = []
        with open(csv_path, newline='', encoding='utf-8-sig') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                # Monta as alternativas (pode ter alternativa_e vazia)
                alternativas = [row['alternativa_a'], row['alternativa_b'], row['alternativa_c'], row['alternativa_d']]
                if row.get('alternativa_e'):
                    if row['alternativa_e'].strip():
                        alternativas.append(row['alternativa_e'])
                # Monta o dicionário no formato da tabela
                question = {
                    "topico": row['topico'],
                    "pergunta": row['pergunta'],
                    "alternativas": alternativas,
                    "resposta": row['resposta']
                }
                questions.append(question)
        return questions
    
# Exemplo de uso:
if __name__ == "__main__":
    importer = CsvQuestionsImporter()
    questions = importer.import_csv_to_dicts("assets/pdf/questoes_md_formatadas.csv")
    print(questions[1])  # Mostra 