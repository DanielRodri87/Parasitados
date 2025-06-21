
CREATE TABLE IF NOT EXISTS questions (
    id SERIAL PRIMARY KEY,
    topico TEXT NOT NULL,
    pergunta TEXT NOT NULL,
    alternativas TEXT[] NOT NULL,
    resposta TEXT NOT NULL
);

CREATE TABLE pessoas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
    -- outros campos...
);

CREATE TABLE IF NOT EXISTS ranking_jogadores (
    id_da_pessoa INT NOT NULL,
    qtd_acertos INT NOT NULL,
    taxa_de_acerto FLOAT NOT NULL,
    tempo_realizado FLOAT NOT NULL,
    CONSTRAINT fk_pessoa FOREIGN KEY (id_da_pessoa) REFERENCES pessoas(id)
);

WITH dados AS (
  SELECT
    r.id_da_pessoa,
    p.nome,
    r.qtd_acertos,
    r.taxa_de_acerto,
    r.tempo_realizado,
    MIN(r.tempo_realizado) OVER () AS min_tempo,
    MAX(r.qtd_acertos) OVER () AS max_acertos
  FROM ranking_jogadores r
  JOIN pessoas p ON r.id_da_pessoa = p.id
),
scores AS (
  SELECT
    *,
    (CASE WHEN tempo_realizado = 0 THEN 0 ELSE min_tempo / tempo_realizado END) AS tempo_normalizado,
    ((qtd_acertos::float / NULLIF(max_acertos,0)) * 0.2 + (taxa_de_acerto * 0.4) +
     (CASE WHEN tempo_realizado = 0 THEN 0 ELSE (min_tempo / tempo_realizado) END * 0.4)) AS score
  FROM dados
),
ordenado AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY score DESC) AS posicao
  FROM scores
)
SELECT posicao
FROM ordenado
WHERE id_da_pessoa = 2;