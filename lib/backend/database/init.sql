-- Active: 1750347638268@@127.0.0.1@5432@parasitados
CREATE TABLE IF NOT EXISTS questions (
    id SERIAL PRIMARY KEY,
    topico TEXT NOT NULL,
    pergunta TEXT NOT NULL,
    alternativas TEXT[] NOT NULL,
    resposta TEXT NOT NULL
);