import re
import csv

input_md = 'archive/questoes.md'
output_csv = 'archive/questoes_md_formatadas.csv'

with open(input_md, encoding='utf-8') as f:
    lines = f.readlines()

questoes = []
topico = ''
numero = ''
enunciado = ''
alternativas = {}
resposta = ''
coletando_enunciado = False
questao_seq = 1  # Sequencial para o campo numero

def limpar_numeros(texto):
    # Remove números isolados ou seguidos de ponto, parêntese, etc, no início ou meio do texto
    new = re.sub(r'\b\d+[\.|\)|\-]?\b', '', texto).strip()
    new = new.replace('\\.', ' ')
    new = new.replace('**', '').replace("'", '')
    new = new.startswith('  ') and new[2:] or new
    new = new.startswith(' ') and new[1:] or new
    new = new[:1].upper() + new[1:]
    return new

# Regex patterns
padrao_topico = re.compile(r'^#\s*(.+)')
padrao_numero = re.compile(r'^(\d+)[\.|\-]?\s*(.*)')
padrao_alternativa = re.compile(r'^(\*\*|\*)?([A-Ea-e])\)?[\.|\-]?\s*(.+)')
padrao_resposta = re.compile(r'^\*\*([A-Ea-e])\)')
padrao_questao_sem_numero = re.compile(r'^\*\*?([A-Z][^\n]+)')

for idx, line in enumerate(lines):
    line = line.strip()
    if not line:
        continue

    # Detecta tópico
    m_topico = padrao_topico.match(line)
    if m_topico:
        topico = m_topico.group(1).strip()
        continue

    # Detecta início de questão (com número)
    m_num = padrao_numero.match(line)
    if m_num:
        # Salva questão anterior
        if enunciado and alternativas:
            questoes.append([
                topico, str(questao_seq), limpar_numeros(enunciado.strip()),
                alternativas.get('A', ''), alternativas.get('B', ''),
                alternativas.get('C', ''), alternativas.get('D', ''),
                alternativas.get('E', ''), resposta
            ])
            questao_seq += 1
        numero = m_num.group(1)
        enunciado = m_num.group(2).strip()
        alternativas = {}
        resposta = ''
        coletando_enunciado = True
        continue

    # Detecta início de questão sem número (ex: **1. ...)
    if line.startswith('**') and not padrao_alternativa.match(line):
        # Salva questão anterior
        if enunciado and alternativas:
            questoes.append([
                topico, str(questao_seq), limpar_numeros(enunciado.strip()),
                alternativas.get('A', ''), alternativas.get('B', ''),
                alternativas.get('C', ''), alternativas.get('D', ''),
                alternativas.get('E', ''), resposta
            ])
            questao_seq += 1
        numero = ''
        enunciado = re.sub(r'^\*\*', '', line).strip()
        alternativas = {}
        resposta = ''
        coletando_enunciado = True
        continue

    # Detecta alternativa
    m_alt = padrao_alternativa.match(line)
    if m_alt:
        letra = m_alt.group(2).upper()
        texto = m_alt.group(3).strip('*').strip()
        texto = texto[:1].upper() + texto[1:]
        
        if line.startswith('**'):
            resposta = letra
        alternativas[letra] = texto
        coletando_enunciado = False
        continue

    # Se não for alternativa, nem tópico, nem início de questão, é continuação do enunciado
    if coletando_enunciado:
        enunciado += ' ' + line

# Salva última questão
if enunciado and alternativas:
    questoes.append([
        topico, str(questao_seq), limpar_numeros(enunciado.strip()),
        alternativas.get('A', ''), alternativas.get('B', ''),
        alternativas.get('C', ''), alternativas.get('D', ''),
        alternativas.get('E', ''), resposta
    ])

# Escreve no CSV
with open(output_csv, 'w', newline='', encoding='utf-8-sig') as f:
    writer = csv.writer(f)
    writer.writerow(['topico', 'numero', 'pergunta', 'alternativa_a', 'alternativa_b', 'alternativa_c', 'alternativa_d', 'alternativa_e', 'resposta'])
    writer.writerows(questoes)

print('Arquivo CSV gerado com sucesso.')