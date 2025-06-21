import pandas as pd

# Dados de jogadores
data = [
    {"nome": "joao", "tempo": 3625, "acertos": 15, "taxa_acerto": 0.9},
    {"nome": "ana", "tempo": 3530, "acertos": 18, "taxa_acerto": 1.0},
    {"nome": "leo", "tempo": 3220, "acertos": 12, "taxa_acerto":0.6},
]

# Total de questões certas disponíveis no sistema

df = pd.DataFrame(data)

min_tempo = df["tempo"].min()
df["tempo_normalizado"] = min_tempo / df["tempo"]

# Score final com pesos ajustáveis
# Você pode mudar os pesos 0.4, 0.3, 0.3 se quiser valorizar outro critério
df["score"] = (
    (df["acertos"] / df["acertos"].max()) * 0.2 +           # quantidade
    (df["taxa_acerto"] * 0.4)  +   # progresso
    df["tempo_normalizado"] * 0.4                           # tempo (menos é melhor)
)

# Ordenar ranking
df = df.sort_values(by="score", ascending=False)

# Mostrar resultado final
df = df[["nome", "acertos", "taxa_acerto", "tempo", "tempo_normalizado", "score"]]
print(df.to_string(index=False))
