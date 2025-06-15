import pymupdf as fitz  # PyMuPDF
import re
import os

def pdf_to_txt_with_formatting(pdf_path, output_path=None):
    """
    Converte PDF para TXT mantendo formatação de negrito e removendo espaços desnecessários
    
    Args:
        pdf_path (str): Caminho para o arquivo PDF
        output_path (str): Caminho para salvar o arquivo TXT (opcional)
    
    Returns:
        str: Texto extraído com formatação
    """
    
    if not os.path.exists(pdf_path):
        raise FileNotFoundError(f"Arquivo PDF não encontrado: {pdf_path}")
    
    try:
        # Abrir o documento PDF
        doc = fitz.open(pdf_path)
        texto_completo = []
        
        for num_pagina in range(len(doc)):
            pagina = doc.load_page(num_pagina)
            
            # Extrair texto com informações de formatação
            blocos = pagina.get_text("dict")
            
            texto_pagina = processar_pagina(blocos)
            
            if texto_pagina.strip():  # Só adiciona se não estiver vazio
                texto_completo.append(f"=== PÁGINA {num_pagina + 1} ===\n")
                texto_completo.append(texto_pagina)
                texto_completo.append("\n")
        
        doc.close()
        
        # Juntar todo o texto
        texto_final = "".join(texto_completo)
        
        # Limpar espaços desnecessários
        texto_final = limpar_espacos(texto_final)
        
        # Salvar arquivo se caminho foi especificado
        if output_path:
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(texto_final)
            print(f"Arquivo TXT salvo em: {output_path}")
        
        return texto_final
        
    except Exception as e:
        raise Exception(f"Erro ao processar PDF: {str(e)}")

def processar_pagina(blocos):
    """
    Processa os blocos de texto de uma página mantendo formatação
    """
    texto_pagina = []
    
    for bloco in blocos["blocks"]:
        if "lines" in bloco:  # Bloco de texto
            for linha in bloco["lines"]:
                texto_linha = []
                
                for span in linha["spans"]:
                    texto = span["text"]
                    flags = span["flags"]
                    
                    # Verificar se é negrito (flag 16 = bold)
                    if flags & 2**4:  # Bold flag
                        texto = f"**{texto}**"
                    
                    texto_linha.append(texto)
                
                if texto_linha:
                    linha_completa = "".join(texto_linha)
                    texto_pagina.append(linha_completa + "\n")
    
    return "".join(texto_pagina)

def limpar_espacos(texto):
    """
    Remove espaços desnecessários mantendo a estrutura do texto
    """
    # Remover espaços no início e fim das linhas
    linhas = texto.split('\n')
    linhas_limpas = []
    
    for linha in linhas:
        linha_limpa = linha.strip()
        
        # Remover múltiplos espaços consecutivos, mas manter um espaço
        linha_limpa = re.sub(r' +', ' ', linha_limpa)
        
        linhas_limpas.append(linha_limpa)
    
    # Juntar linhas e remover múltiplas quebras de linha consecutivas
    texto_limpo = '\n'.join(linhas_limpas)
    texto_limpo = re.sub(r'\n\s*\n\s*\n+', '\n\n', texto_limpo)
    
    return texto_limpo.strip()

def main():
    """
    Função principal para testar o conversor
    """
    # Exemplo de uso
    pdf_path = "/home/daniel/Documentos/UFPI-2025.1/Parasitados/parasitados/assets/pdf/questions.pdf"
    
    if not pdf_path:
        print("Caminho não fornecido!")
        return
    
    try:
        # Gerar nome do arquivo de saída
        base_name = os.path.splitext(os.path.basename(pdf_path))[0]
        output_path = "/home/daniel/Documentos/UFPI-2025.1/Parasitados/parasitados/assets/pdf/file.txt"
        
        print("Convertendo PDF...")
        texto = pdf_to_txt_with_formatting(pdf_path, output_path)
        
        print(f"\nConversão concluída!")
        print(f"Texto extraído ({len(texto)} caracteres)")
        print(f"Arquivo salvo como: {output_path}")
        
        # Mostrar prévia do texto
        print("\n" + "="*50)
        print("PRÉVIA DO TEXTO EXTRAÍDO:")
        print("="*50)
        print(texto[:500] + "..." if len(texto) > 500 else texto)

    except Exception as e:
        print(f"Erro: {e}")

if __name__ == "__main__":
    main()