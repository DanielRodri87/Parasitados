import re
import json

with open('assets/pdf/file.txt', encoding='utf-8') as f:
    lines = f.readlines()

questions = []
q_num = 1
i = 0
while i < len(lines):
    line = lines[i].strip()
    # Detecta início de questão
    match = re.match(r'^(\d+)\.\s*(.+)', line)
    if match:
        # Junta todas as linhas do enunciado até encontrar a primeira alternativa
        enunciado = [match.group(2).strip()]
        i += 1
        while i < len(lines) and not re.match(r'(\*\*)?[A-Ea-e]\)', lines[i].strip()):
            enunciado.append(lines[i].strip())
            i += 1
        pergunta = ' '.join(enunciado).replace('  ', ' ').replace(' .', '.').strip()

        alternativas = []
        resposta = None
        alt_labels = ['a', 'b', 'c', 'd']
        alt_idx = 0
        # Coleta alternativas
        while i < len(lines) and alt_idx < len(alt_labels):
            alt_line = lines[i].strip()
            alt_match = re.match(r'(\*\*)?([A-Ea-e])\)\s*(.+?)(\*\*)?$', alt_line)
            if alt_match:
                label = alt_labels[alt_idx]
                texto = alt_match.group(3).strip()
                if alt_match.group(1) or alt_match.group(4):
                    resposta = label
                alternativas.append({label: texto})
                alt_idx += 1
            i += 1
        questions.append({
            q_num: {
                "pergunta": pergunta,
                "resposta": resposta,
                "alternativas": alternativas
            }
        })
        q_num += 1
    else:
        i += 1

with open('assets/pdf/questions.json', 'w', encoding='utf-8') as f:
    json.dump(questions, f, ensure_ascii=False, indent=2)