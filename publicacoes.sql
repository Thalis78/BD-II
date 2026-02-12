CREATE TABLE ASSUNTO (
    CODIGO INT PRIMARY KEY,
    DESCRICAO VARCHAR(100)
);

CREATE TABLE EDITORA (
    CODIGO INT PRIMARY KEY,
    CNPJ VARCHAR(14) NOT NULL UNIQUE,
    NOME VARCHAR(100) NOT NULL
);

CREATE TABLE NACIONALIDADE (
    CODIGO INT PRIMARY KEY,
    PAIS VARCHAR(50)
);

CREATE TABLE AUTOR (
    CODIGO INT PRIMARY KEY,
    NOME VARCHAR(100) NOT NULL,
    PASSAPORTE VARCHAR(30) NOT NULL UNIQUE,
    DATANASCIMENTO DATE,
    NACIONALIDADE_CODIGO INT,
    FOREIGN KEY (NACIONALIDADE_CODIGO) REFERENCES NACIONALIDADE(CODIGO)
);

CREATE TABLE LIVRO (
    CODIGO INT PRIMARY KEY,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    TITULO VARCHAR(50) NOT NULL,
    PRECO DECIMAL(10,2) NOT NULL,
    DATALANCAMENTO DATE,
    ASSUNTO_CODIGO INT NOT NULL,
    EDITORA_CODIGO INT NOT NULL,
    FOREIGN KEY (ASSUNTO_CODIGO) REFERENCES ASSUNTO(CODIGO),
    FOREIGN KEY (EDITORA_CODIGO) REFERENCES EDITORA(CODIGO)
);

CREATE TABLE AUTOR_LIVRO (
    AUTOR_CODIGO INT NOT NULL,
    LIVRO_CODIGO INT NOT NULL,
    PRIMARY KEY (AUTOR_CODIGO, LIVRO_CODIGO),
    FOREIGN KEY (AUTOR_CODIGO) REFERENCES AUTOR(CODIGO),
    FOREIGN KEY (LIVRO_CODIGO) REFERENCES LIVRO(CODIGO)
);

INSERT INTO ASSUNTO (codigo, descricao) VALUES
(1, 'Banco de Dados'),
(2, 'Estruturas de Dados'),
(3, 'Programação'),
(4, 'Redes de Computadores'),
(5, 'Engenharia de Software');

INSERT INTO EDITORA (CODIGO, CNPJ, NOME) VALUES
(1, '11111111000111', 'Books Editora'),
(2, '22222222000122', 'Tech Press'),
(3, '33333333000133', 'Alpha Editora'),
(4, '44444444000144', 'Global Books'),
(5, '55555555000155', 'Editora Antiga');

INSERT INTO NACIONALIDADE (CODIGO, PAIS) VALUES
(1, 'Brasil'),
(2, 'Portugal'),
(3, 'Estados Unidos'),
(4, 'França'),
(5, 'Argentina');

INSERT INTO AUTOR (CODIGO, NOME, PASSAPORTE, DATANASCIMENTO, NACIONALIDADE_CODIGO) VALUES
(1, 'Machado de Assis', 'BR0001', '1839-06-21', 1),
(2, 'João Silva', 'BR0002', '1980-03-10', 1),
(3, 'Luis Fernando', 'BR0003', '1975-08-15', 1),
(4, 'Ana Souza', 'PT0004', '1990-01-20', 2),
(5, 'John Doe', 'US0005', '1985-07-07', 3),
(6, 'João Pedro', 'FR0006', '1965-12-01', 4),
(7, 'Carlos Mendes', 'AR0007', '1915-05-30', 5);

INSERT INTO LIVRO (CODIGO, ISBN, TITULO, PRECO, DATALANCAMENTO, ASSUNTO_CODIGO, EDITORA_CODIGO) VALUES
(1, '9780000000001', 'Banco de Dados Moderno', 120.00, '2015-06-01', 1, 1),
(2, '9780000000002', 'Bancos de Dados Avancados', 180.00, '2018-03-15', 1, 1),
(3, '9780000000003', 'Estruturas de Dados em C', 75.00, '2010-09-10', 2, 2),
(4, '9780000000004', 'Algoritmos e Estruturas', 95.00, '2012-05-20', 2, 2),
(5, '9780000000005', 'Introducao a Programacao', 45.00, '2020-01-10', 3, 3),
(6, '9780000000006', 'Programacao OO', 150.00, '2019-11-05', 3, 3),
(7, '9780000000007', 'Redes de Computadores', 200.00, '2016-08-25', 4, 4),
(8, '9780000000008', 'Engenharia de Software', 130.00, NULL, 5, 4),
(9, '9780000000009', 'Banco de Dados Distribuidos', 220.00, '2021-04-01', 1, 5),
(10,'9780000000010', 'Dados para Analise', 60.00, NULL, 1, 2);


INSERT INTO AUTOR_LIVRO (AUTOR_CODIGO, LIVRO_CODIGO) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 2),
(3, 6),
(3, 9),
(4, 5),
(5, 7),
(5, 10),
(6, 4),
(6, 6),
(7, 8);

-- 1. Livros que possuam preços superiores a R$ 50,00.
SELECT * FROM LIVRO WHERE PRECO > 50;
-- 2. Livros que possuam preços entre R$ 100,00 e R$ 200,00.
SELECT * FROM LIVRO WHERE PRECO >= 100 AND PRECO <= 200;
-- 3. Livros cujos títulos possuam a palavra ‘Banco’.
SELECT * FROM LIVRO WHERE TITULO LIKE "%Banco%";
-- 4. Livros cujos títulos iniciam com a palavra ‘Banco’.
SELECT * FROM LIVRO WHERE TITULO LIKE "Banco%";
-- 5. Livros cujos títulos terminam com a palavra ‘Dados’.
SELECT * FROM LIVRO WHERE TITULO LIKE "%Dados";
-- 6. Livros cujos títulos possuem a expressão ‘Banco de Dados’ ou ‘Bancos de Dados’.
SELECT *  FROM LIVRO WHERE TITULO LIKE "%Banco de Dados%" OR TITULO LIKE "%Bancos de Dados%";
-- 7. Livros que foram lançados há mais de 5 anos.
SELECT * FROM LIVRO WHERE DATALANCAMENTO < '2021-02-07';
-- 8. Livros que ainda não foram lançados, ou seja, com a data de lançamento nula.
SELECT * FROM LIVRO WHERE NOT DATALANCAMENTO;
-- 9. Livros cujo assunto seja ‘Estruturas de Dados’.
SELECT * FROM LIVRO WHERE ASSUNTO_CODIGO IN(
SELECT CODIGO FROM ASSUNTO WHERE DESCRICAO LIKE '%Estruturas de Dados%');
-- 10. Livros cujo assunto tenha código 1, 2 ou 3.
SELECT * FROM LIVRO WHERE ASSUNTO_CODIGO IN (1, 2, 3);
-- 11. Quantidade de livros.
SELECT COUNT(*) FROM LIVRO;
-- 12. Quantidade de livros que ainda não foram lançados, ou seja, com a data de lançamento nula.
SELECT COUNT(*) FROM LIVRO WHERE DATALANCAMENTO IS NULL;
-- 13. Soma dos preços dos livros.
SELECT SUM(PRECO) FROM LIVRO;
-- 14. Média de preços dos livros.
SELECT AVG(PRECO) FROM LIVRO;
-- 15. Maior preço dos livros.
SELECT MAX(PRECO) FROM LIVRO;
-- 16. Menor preço dos livros. 
SELECT MIN(PRECO) FROM LIVRO;
-- 17. O preço médio dos livros para cada assunto. 
SELECT ASSUNTO_CODIGO, AVG(PRECO) FROM LIVRO GROUP BY ASSUNTO_CODIGO;
-- 18. Quantidade de livros para cada assunto. 
SELECT ASSUNTO_CODIGO, COUNT(*) FROM LIVRO GROUP BY ASSUNTO_CODIGO;
-- 19. O preço do livro mais caro de cada assunto, dentre aqueles que já foram lançados. 
SELECT ASSUNTO_CODIGO, MAX(PRECO) FROM LIVRO WHERE DATALANCAMENTO IS NOT NULL GROUP BY ASSUNTO_CODIGO;
-- 20. Quantidade de livros lançados por editora. 
SELECT EDITORA_CODIGO, COUNT(*) FROM LIVRO WHERE EDITORA_CODIGO IS NOT NULL GROUP BY EDITORA_CODIGO;
-- 21. Assuntos cujo preço médio dos livros ultrapassa R$ 50,00. 
SELECT ASSUNTO_CODIGO, AVG(PRECO) FROM LIVRO GROUP BY ASSUNTO_CODIGO HAVING AVG(PRECO) > 50;
-- 22. Assuntos que possuem pelo menos 2 livros. 
SELECT ASSUNTO_CODIGO, COUNT(*) FROM `LIVRO` GROUP BY ASSUNTO_CODIGO HAVING COUNT(*) >=  2
-- 23. Assuntos que possuem pelo menos 2 livros já lançados.
SELECT ASSUNTO_CODIGO, COUNT(*) FROM LIVRO WHERE DATALANCAMENTO IS NOT NULL GROUP BY ASSUNTO_CODIGO HAVING COUNT(*) >= 2;
-- 24. Quantidade de livros lançados por assunto.
SELECT ASSUNTO_CODIGO,COUNT(*) FROM LIVRO WHERE DATALANCAMENTO IS NOT NULL GROUP BY ASSUNTO_CODIGO;
-- 25. Nome e passaporte dos autores que possuem a palavra ‘João’ no nome.
SELECT NOME,PASSAPORTE FROM AUTOR WHERE NOME LIKE "%João%";
-- 26. Nome e passaporte dos autores que nasceram após 1° de janeiro de 1970.
SELECT NOME,PASSAPORTE FROM AUTOR WHERE DATANASCIMENTO > '1970-01-01';
-- 27. Nome e passaporte dos autores que não são brasileiros.
SELECT NOME, PASSAPORTE FROM AUTOR WHERE NACIONALIDADE_CODIGO IN (
SELECT CODIGO FROM NACIONALIDADE WHERE PAIS != 'Brasil');
-- 28. Quantidade de autores.
SELECT COUNT(*) AS QUANTIDADE_AUTORES FROM AUTOR;
-- 29. Quantidade média de autores dos livros.
 SELECT AVG(QTD_AUTORES) AS MEDIA_AUTORES_POR_LIVRO FROM (SELECT LIVRO_CODIGO, COUNT(AUTOR_CODIGO) AS QTD_AUTORES FROM AUTOR_LIVRO GROUP BY LIVRO_CODIGO) AS SUB;
-- 30. Livros que possuem ao menos 2 autores.
SELECT LIVRO_CODIGO FROM AUTOR_LIVRO GROUP BY LIVRO_CODIGO HAVING COUNT(AUTOR_CODIGO) >= 2;
