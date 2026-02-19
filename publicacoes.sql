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
-- 31. Preço médio dos livros por editora.
SELECT E.NOME,AVG(L.PRECO) AS MEDIA_VALORES FROM EDITORA E 
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO 
GROUP BY E.NOME;
-- 32. Preço máximo, preço mínimo e preço médio dos livros cujos códigos do assunto são 1, 2 ou 3, para
-- cada editora.
SELECT E.NOME,AVG(L.PRECO) AS MEDIA_VALORES,MAX(L.PRECO) AS VALOR_MAX,MIN(L.PRECO) AS VALOR_MIN FROM EDITORA E 
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO 
WHERE L.ASSUNTO_CODIGO IN(1,2,3)
GROUP BY E.NOME;
-- 33. Quantidade de autores para cada nacionalidade.
SELECT N.PAIS,COUNT(A.NOME) AS QUANT_AUTOR FROM NACIONALIDADE N
INNER JOIN AUTOR A ON A.NACIONALIDADE_CODIGO = N.CODIGO 
GROUP BY N.PAIS;
-- 34. Quantidade de autores que nasceram antes de 1°de janeiro de 1920, para cada nacionalidade.
SELECT N.PAIS,COUNT(A.NOME) AS QUANT_AUTOR FROM NACIONALIDADE N
INNER JOIN AUTOR A ON A.NACIONALIDADE_CODIGO = N.CODIGO
WHERE A.DATANASCIMENTO < '1920-01-01'
GROUP BY N.PAIS;
-- 35. A data de nascimento do autor mais velho.
SELECT MIN(DATANASCIMENTO) FROM AUTOR;
-- 36. A data de nascimento do autor mais novo.
SELECT MAX(DATANASCIMENTO) FROM AUTOR;
-- 37. Os novos preços dos livros se os valores fossem reajustados em 10%.
SELECT L.PRECO AS PRECO_ANTIGO, (L.PRECO + (L.PRECO * 0.10)) AS PRECO_NOVO FROM LIVRO L;
-- 38. O dia da publicação do livro de código 1.
SELECT DATALANCAMENTO FROM LIVRO WHERE CODIGO IN (1);
-- 39. O mês e o ano da publicação dos livros cujo assunto tem código 1.
SELECT MONTH(DATALANCAMENTO) AS MES, YEAR(DATALANCAMENTO) AS ANO FROM LIVRO WHERE ASSUNTO_CODIGO IN(1) AND DATALANCAMENTO IS NOT NULL;
-- 40. Quantidade de autores distintos que estão associados a livros na tabela AUTOR_LIVRO.
SELECT COUNT(DISTINCT AUTOR_CODIGO) FROM AUTOR_LIVRO;
-- 41. Título, assunto e preço, ordenado em ordem crescente por assunto e decrescente por preço.
SELECT L.TITULO,A.DESCRICAO,L.PRECO FROM LIVRO L 
INNER JOIN ASSUNTO A ON L.ASSUNTO_CODIGO = A.CODIGO
ORDER BY A.DESCRICAO ASC,L.PRECO DESC;
-- 42. Editoras ordenadas alfabeticamente. A coluna de nomes deve ter a palavra ‘Editora’ como título.
SELECT E.NOME AS EDITORA FROM EDITORA E
ORDER BY E.NOME ASC;
-- 43. Preços e os títulos dos livros, em ordem decrescente de preço.
SELECT L.TITULO , L.PRECO FROM LIVRO L
ORDER BY L.PRECO DESC;
-- 44. Editoras que já publicaram livros, sem repetições.
SELECT DISTINCT E.NOME FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
ORDER BY E.NOME ASC;
-- 45. Autores brasileiros com mês e ano de nascimento, por ordem decrescente de idade e por ordem
-- crescente de nome do autor.
SELECT MONTH(A.DATANASCIMENTO),YEAR(A.DATANASCIMENTO),A.NOME FROM AUTOR A
INNER JOIN NACIONALIDADE N ON A.NACIONALIDADE_CODIGO = N.CODIGO
WHERE N.PAIS = 'Brasil'
ORDER BY A.DATANASCIMENTO ASC, A.NOME ASC;
-- 46. Editora (nome da editora), assunto (código do assunto) e quantidade (livros publicados pela editora para
-- cada assunto) em ordem decrescente de quantidade.
SELECT E.NOME, A.CODIGO, COUNT(L.CODIGO) AS QUANTIDADE FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
INNER JOIN ASSUNTO A ON L.ASSUNTO_CODIGO = A.CODIGO
GROUP BY E.NOME,A.CODIGO
ORDER BY QUANTIDADE DESC;
-- 47. Títulos cujo título tenha comprimento superior a 15 caracteres.
SELECT TITULO FROM LIVRO WHERE CHAR_LENGTH(TITULO) > 15;
-- 48. Títulos dos livros já lançados e a descrição dos seus assuntos.
SELECT L.TITULO,A.DESCRICAO FROM LIVRO L
INNER JOIN ASSUNTO A ON L.ASSUNTO_CODIGO = A.CODIGO
WHERE DATALANCAMENTO IS NOT NULL;
-- 49. Título do livro, nome da editora que o publicou e a descrição do assunto.
SELECT L.TITULO,A.DESCRICAO,E.NOME FROM LIVRO L
INNER JOIN ASSUNTO A ON L.ASSUNTO_CODIGO = A.CODIGO
INNER JOIN EDITORA E ON L.EDITORA_CODIGO = E.CODIGO;
-- 50. Editoras e títulos dos livros lançados pela editora, ordenada por nome da editora e pelo título do livro.
SELECT E.NOME AS NOME_EDITORA, L.TITULO AS TITULO FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
WHERE L.DATALANCAMENTO IS NOT NULL
ORDER BY NOME_EDITORA ASC,TITULO ASC;
-- 51. Editoras cadastradas e para aquelas que possuem livros publicados, relacionar também o título do livro,
-- em ordem de nome da editora e pelo título do livro.
SELECT E.NOME AS NOME_EDITORA, L.TITULO AS TITULO FROM EDITORA E
LEFT JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
ORDER BY NOME_EDITORA ASC, TITULO ASC;
-- 52. Assuntos, contendo os títulos dos livros dos respectivos assuntos, ordenada pela descrição do assunto.
SELECT A.DESCRICAO AS DESCRICAO_ASSUNTO, L.TITULO AS TITULO FROM ASSUNTO A
LEFT JOIN LIVRO L ON L.ASSUNTO_CODIGO = A.CODIGO
ORDER BY DESCRICAO_ASSUNTO ASC;
-- 53. Títulos e editoras, relacionando a obra com a editora que a publica, quando for o caso.
SELECT L.TITULO,E.NOME AS EDITORA FROM LIVRO L
LEFT JOIN EDITORA E ON L.EDITORA_CODIGO = E.CODIGO;
-- 54. Descrição de todos os assuntos e os títulos dos livros de cada um. Quando não existir um livro
-- associado ao assunto, escrever o texto ‘Sem publicações’.
SELECT A.DESCRICAO AS ASSUNTO, IFNULL(L.TITULO, 'SEM PUBLICAÇÕES') AS TITULO FROM ASSUNTO A
LEFT JOIN LIVRO L ON L.ASSUNTO_CODIGO = A.CODIGO
ORDER BY A.DESCRICAO ASC;
-- 55. Nomes dos autores e os livros de sua autoria, ordenada pelo nome do autor.
SELECT A.NOME AS AUTOR,L.TITULO FROM AUTOR A
LEFT JOIN AUTOR_LIVRO AL ON A.CODIGO = AL.AUTOR_CODIGO
LEFT JOIN LIVRO L ON AL.LIVRO_CODIGO = L.CODIGO
ORDER BY A.NOME ASC;
-- 56. Editoras que publicaram livros escritos pelo autor ‘Machado de Assis’.
SELECT E.NOME,l.TITULO,A.NOME FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
INNER JOIN AUTOR_LIVRO AL ON AL.LIVRO_CODIGO = L.CODIGO
INNER JOIN AUTOR A ON AL.AUTOR_CODIGO = A.CODIGO
WHERE A.NOME = 'Machado de Assis';
-- 57. Quantidade de livros lançados que foram escritos por um autor cujo nome possui a palavra ‘Luis’.
SELECT COUNT(DISTINCT L.CODIGO) AS QUANTIDADE_LIVRO FROM LIVRO L
INNER JOIN AUTOR_LIVRO AL ON AL.LIVRO_CODIGO = L.CODIGO
INNER JOIN AUTOR A ON AL.AUTOR_CODIGO = A.CODIGO
WHERE A.NOME LIKE '%Luis%';
-- 58. O preço do livro mais caro publicado pela editora ‘Books Editora’ sobre banco de dados.
SELECT E.NOME, MAX(L.PRECO) AS LIVRO_MAIS_CARO FROM LIVRO L
INNER JOIN EDITORA E ON L.EDITORA_CODIGO = E.CODIGO
WHERE E.NOME = 'Books Editora' AND L.ASSUNTO LIKE '%Banco de Dados%'
GROUP BY E.NOME;
-- 59. Editoras que não publicaram livros.
SELECT E.NOME FROM EDITORA E
LEFT JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
WHERE L.DATALANCAMENTO IS NULL;
-- 60. Título do livro e o nome da editora que o publica para todos os livros que custam menos que R$ 50,00.
SELECT E.NOME,L.TITULO, L.PRECO FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
WHERE L.PRECO < 50;
-- 61. Nome e passaporte do autor brasileiro que tenha nascido antes de 1° de janeiro de 1950 e os títulos dos
-- livros de sua autoria, ordenado pelo nome do autor e pelo título do livro.
SELECT A.NOME, A.PASSAPORTE, L.TITULO FROM AUTOR A
INNER JOIN NACIONALIDADE N ON N.CODIGO = A.NACIONALIDADE_CODIGO
INNER JOIN AUTOR_LIVRO AL ON AL.AUTOR_CODIGO = A.CODIGO
INNER JOIN LIVRO L ON L.CODIGO = AL.LIVRO_CODIGO
WHERE N.PAIS = 'Brasil' AND A.DATANASCIMENTO < '1950-01-01'
ORDER BY A.NOME, L.TITULO;
-- 62. Nome e passaporte do autor e o preço máximo dos livros de sua autoria.
SELECT A.NOME, A.PASSAPORTE,MAX(L.PRECO) FROM AUTOR A
INNER JOIN AUTOR_LIVRO AL ON AL.AUTOR_CODIGO = A.CODIGO
INNER JOIN LIVRO L ON AL.LIVRO_CODIGO = L.CODIGO
GROUP BY A.NOME,A.PASSAPORTE;
-- 63. Nome do autor e nome da editora que já lançaram pelo menos 2 livros.
SELECT A.NOME, E.NOME FROM AUTOR A
INNER JOIN AUTOR_LIVRO AL ON AL.AUTOR_CODIGO = A.CODIGO
INNER JOIN LIVRO L ON L.CODIGO = AL.LIVRO_CODIGO
INNER JOIN EDITORA E ON E.CODIGO = L.EDITORA_CODIGO
GROUP BY A.NOME, E.NOME
HAVING COUNT(DISTINCT L.CODIGO) >= 2;
-- 64. Descrição do assunto referenciado em pelo menos 10 livros.
SELECT A.DESCRICAO FROM ASSUNTO A
INNER JOIN LIVRO L ON L.ASSUNTO_CODIGO = A.CODIGO
GROUP BY A.DESCRICAO
HAVING COUNT(L.CODIGO) >= 10;
-- 65. Nomes das editoras que possuem livros lançados.
SELECT DISTINCT E.NOME FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
WHERE L.DATALANCAMENTO IS NOT NULL;
-- 66. Assuntos não foram lançados livros.
SELECT A.DESCRICAO FROM ASSUNTO A
WHERE NOT EXISTS (
SELECT 1 FROM LIVRO L WHERE L.ASSUNTO_CODIGO = A.CODIGO);
-- 67. Descrição dos assuntos e quantidade de livros lançados de cada um.
SELECT A.DESCRICAO, COUNT(L.CODIGO) AS QUANTIDADE_LIVROS FROM ASSUNTO A
LEFT JOIN LIVRO L ON L.ASSUNTO_CODIGO = A.CODIGO AND L.DATALANCAMENTO IS NOT NULL
GROUP BY A.DESCRICAO;
-- 68. Nome das editoras e o preço médio dos livros de cada uma.
SELECT E.NOME, AVG(L.PRECO) FROM EDITORA E
LEFT JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
GROUP BY E.NOME;
-- 69. Nome das editoras e os livros das editoras que lançaram ao menos 2 livros, ordenados pelo nome da
-- editora e pelo título da publicação.
SELECT E.NOME,L.TITULO FROM EDITORA E
INNER JOIN LIVRO L ON L.EDITORA_CODIGO = E.CODIGO
WHERE E.CODIGO IN (
SELECT EDITORA_CODIGO FROM LIVRO
WHERE DATALANCAMENTO IS NOT NULL
GROUP BY EDITORA_CODIGO
HAVING COUNT(*) >= 2)
ORDER BY E.NOME, L.TITULO;
-- 70. Títulos dos livros dos assuntos cujo preço médio do livro é superior a R$ 40,00, juntamente com os
-- respectivos assuntos.
SELECT L.TITULO,A.DESCRICAO FROM LIVRO L
INNER JOIN ASSUNTO A ON A.CODIGO = L.ASSUNTO_CODIGO
WHERE L.ASSUNTO_CODIGO IN (
SELECT ASSUNTO_CODIGO FROM LIVRO
GROUP BY ASSUNTO_CODIGO
HAVING AVG(PRECO) > 40);
-- 71. Títulos dos livros cujo assunto é ‘Banco de Dados’ ou que foram lançados por editoras que contenham
-- ‘Books’ no nome.
SELECT L.TITULO FROM LIVRO L
INNER JOIN ASSUNTO A ON A.CODIGO = L.ASSUNTO_CODIGO
INNER JOIN EDITORA E ON E.CODIGO = L.EDITORA_CODIGO
WHERE A.DESCRICAO = 'Banco de Dados' OR E.NOME LIKE '%Books%';

-- 72. Títulos dos livros cujo assunto é ‘Banco de Dados’ e que foram lançados por editoras que contenham
-- ‘Books’ no nome.
SELECT L.TITULO FROM LIVRO L
INNER JOIN ASSUNTO A ON A.CODIGO = L.ASSUNTO_CODIGO
INNER JOIN EDITORA E ON E.CODIGO = L.EDITORA_CODIGO
WHERE A.DESCRICAO = 'Banco de Dados' AND E.NOME LIKE '%Books%';
-- 73. Títulos dos livros cujo assunto é ‘Banco de Dados’ e que não foram lançados por editoras que
-- contenham ‘Books’ no nome.
SELECT L.TITULO FROM LIVRO L
INNER JOIN ASSUNTO A ON A.CODIGO = L.ASSUNTO_CODIGO
INNER JOIN EDITORA E ON E.CODIGO = L.EDITORA_CODIGO
WHERE A.DESCRICAO = 'Banco de Dados'AND E.NOME NOT LIKE '%Books%';
-- 74. Títulos dos livros que não foram lançados por editoras que contenham ‘Books’ no nome cujo assunto é
-- ‘Banco de Dados’.
SELECT L.TITULO FROM LIVRO L
INNER JOIN ASSUNTO A ON A.CODIGO = L.ASSUNTO_CODIGO
INNER JOIN EDITORA E ON E.CODIGO = L.EDITORA_CODIGO
WHERE E.NOME NOT LIKE '%Books%'AND A.DESCRICAO = 'Banco de Dados';
-- 75. Excluir as editoras que não publicaram livros.
DELETE FROM EDITORA
WHERE CODIGO NOT IN (
SELECT DISTINCT EDITORA_CODIGO FROM LIVRO);
