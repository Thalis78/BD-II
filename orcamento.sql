CREATE DATABASE IF NOT EXISTS bd_orcamentos;
USE bd_orcamentos;

CREATE TABLE Produtos (
    produto_codigo INT PRIMARY KEY,
    produto_descricao VARCHAR(100),
    produto_valor DECIMAL(10, 2),
    produto_status INT,
    produto_qtd_estoque INT,
    produto_qtd_falta INT
);

CREATE TABLE Orcamentos (
    orcamento_codigo INT PRIMARY KEY,
    orcamento_data DATE,
    orcamento_status INT
);

CREATE TABLE Orcamentos_Produtos (
    orcamento_codigo INT,
    produto_codigo INT,
    item_quantidade INT,
    item_valor_unitario DECIMAL(10, 2),
    item_status INT,
    PRIMARY KEY (orcamento_codigo, produto_codigo),
    FOREIGN KEY (orcamento_codigo) REFERENCES Orcamentos(orcamento_codigo),
    FOREIGN KEY (produto_codigo) REFERENCES Produtos(produto_codigo)
);

-- QUESTÃO 01:

CREATE TABLE log_produtos_atualizados (
    log_produto_codigo INT,
    log_qtd_anterior INT,
    log_qtd_atualizada INT,
    log_valor_momento DECIMAL(10, 2)
);

CREATE TABLE produtos_em_falta_registro (
    falta_produto_codigo INT,
    falta_produto_descricao VARCHAR(100),
    falta_produto_status INT,
    falta_produto_estoque INT
);

DELIMITER $$
CREATE TRIGGER tg_produtos_update
BEFORE UPDATE ON Produtos
FOR EACH ROW
BEGIN
    INSERT INTO log_produtos_atualizados (log_produto_codigo, log_qtd_anterior, log_qtd_atualizada, log_valor_momento)
    VALUES (OLD.produto_codigo, OLD.produto_qtd_estoque, NEW.produto_qtd_estoque, NEW.produto_valor);
    
    IF NEW.produto_qtd_estoque = 0 THEN
        INSERT INTO produtos_em_falta_registro (falta_produto_codigo, falta_produto_descricao, falta_produto_status, falta_produto_estoque)
        VALUES (NEW.produto_codigo, NEW.produto_descricao, OLD.produto_status, NEW.produto_qtd_estoque);
        
        SET NEW.produto_status = NULL;
        
        UPDATE Orcamentos_Produtos SET item_status = NULL WHERE produto_codigo = NEW.produto_codigo;
    END IF;
END$$
DELIMITER ;

-- 2 QUESTÃO:

CREATE TABLE historico_produtos_deletados (
    hist_produto_codigo INT,
    hist_produto_estoque INT,
    hist_preco_venda DECIMAL(10, 2),
    hist_usuario VARCHAR(50),
    hist_data_hora DATETIME
);

CREATE TABLE auditoria_tentativas_exclusao (
    audit_data_hora DATETIME,
    audit_operacao VARCHAR(50),
    audit_produto_codigo INT,
    audit_usuario_bd VARCHAR(50)
);

DELIMITER $$
CREATE TRIGGER tg_produtos_delete
BEFORE DELETE ON Produtos
FOR EACH ROW
BEGIN
    IF OLD.produto_qtd_estoque IS NULL OR OLD.produto_qtd_estoque <= 0 THEN
        INSERT INTO historico_produtos_deletados (hist_produto_codigo, hist_produto_estoque, hist_preco_venda, hist_usuario, hist_data_hora)
        VALUES (OLD.produto_codigo, OLD.produto_qtd_estoque, OLD.produto_valor, USER(), NOW());
    ELSE
        INSERT INTO auditoria_tentativas_exclusao (audit_data_hora, audit_operacao, audit_produto_codigo, audit_usuario_bd)
        VALUES (NOW(), 'TENTATIVA DE EXCLUSÃO NEGADA', OLD.produto_codigo, USER());
        
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: Não é possível excluir produto com saldo em estoque.';
    END IF;
END$$
DELIMITER ;

-- QUESTÃO 03

CREATE TABLE orcamento_produtos_cancelados (
    canc_orcamento_codigo INT,
    canc_produto_codigo INT,
    canc_item_quantidade INT,
    canc_item_valor DECIMAL(10, 2)
);

CREATE TABLE orcamentos_cancelados_dados (
    canc_orcamento_codigo INT,
    canc_orcamento_data DATE,
    canc_orcamento_status INT
);

DELIMITER $$
CREATE TRIGGER tg_cancela_orcamento
AFTER UPDATE ON Orcamentos
FOR EACH ROW
BEGIN
    IF NEW.orcamento_status = 0 THEN
        INSERT INTO orcamento_produtos_cancelados (canc_orcamento_codigo, canc_produto_codigo, canc_item_quantidade, canc_item_valor)
        SELECT orcamento_codigo, produto_codigo, item_quantidade, item_valor_unitario
        FROM Orcamentos_Produtos WHERE orcamento_codigo = NEW.orcamento_codigo;

        DELETE FROM Orcamentos_Produtos WHERE orcamento_codigo = NEW.orcamento_codigo;

        INSERT INTO orcamentos_cancelados_dados (canc_orcamento_codigo, canc_orcamento_data, canc_orcamento_status)
        VALUES (NEW.orcamento_codigo, NEW.orcamento_data, NEW.orcamento_status);
    END IF;
END$$
DELIMITER ;

-- QUESTÃO 04:

CREATE TABLE produtos_para_requisicao (
    req_produto_codigo INT,
    req_orcamento_codigo INT,
    req_qtd_em_falta INT,
    req_data DATE,
    req_usuario_sistema VARCHAR(50)
);

DELIMITER $$
CREATE TRIGGER tg_confirma_orcamento
AFTER UPDATE ON Orcamentos
FOR EACH ROW
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_prod_cod INT;
    DECLARE v_qtd_item INT;
    DECLARE v_estoque_atual INT;
    
    DECLARE cur_itens CURSOR FOR 
        SELECT op.produto_codigo, op.item_quantidade, p.produto_qtd_estoque
        FROM Orcamentos_Produtos op JOIN Produtos p ON op.produto_codigo = p.produto_codigo
        WHERE op.orcamento_codigo = NEW.orcamento_codigo;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

    IF NEW.orcamento_status = 1 AND OLD.orcamento_status <> 1 THEN
        OPEN cur_itens;
        read_loop: LOOP
            FETCH cur_itens INTO v_prod_cod, v_qtd_item, v_estoque_atual;
            IF v_done THEN LEAVE read_loop; END IF;

            IF v_qtd_item <= v_estoque_atual THEN
                UPDATE Orcamentos_Produtos SET item_status = 1 
                WHERE orcamento_codigo = NEW.orcamento_codigo AND produto_codigo = v_prod_cod;
            ELSE
                UPDATE Orcamentos_Produtos SET item_status = 2 
                WHERE orcamento_codigo = NEW.orcamento_codigo AND produto_codigo = v_prod_cod;

                INSERT INTO produtos_para_requisicao (req_produto_codigo, req_orcamento_codigo, req_qtd_em_falta, req_data, req_usuario_sistema)
                VALUES (v_prod_cod, NEW.orcamento_codigo, (v_qtd_item - v_estoque_atual), CURDATE(), USER());
            END IF;
        END LOOP;
        CLOSE cur_itens;
    END IF;
END$$
DELIMITER ;

-- QUESTÃO 05:

DELIMITER $$
CREATE TRIGGER tg_atualiza_estoque_pendentes
BEFORE UPDATE ON Produtos
FOR EACH ROW
BEGIN
    DECLARE v_acabou INT DEFAULT FALSE;
    DECLARE v_orc_cod INT;
    DECLARE v_qtd_pedida INT;
    DECLARE v_novo_saldo INT;

    DECLARE cur_pendentes CURSOR FOR 
        SELECT orcamento_codigo, item_quantidade FROM Orcamentos_Produtos
        WHERE produto_codigo = NEW.produto_codigo AND item_status = 2
        ORDER BY orcamento_codigo ASC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_acabou = TRUE;

    IF NEW.produto_qtd_estoque > OLD.produto_qtd_estoque THEN
        SET v_novo_saldo = NEW.produto_qtd_estoque;
        OPEN cur_pendentes;
        loop_atendimento: LOOP
            FETCH cur_pendentes INTO v_orc_cod, v_qtd_pedida;
            IF v_acabou THEN LEAVE loop_atendimento; END IF;

            IF v_novo_saldo >= v_qtd_pedida THEN
                SET v_novo_saldo = v_novo_saldo - v_qtd_pedida;
                UPDATE Orcamentos_Produtos SET item_status = 1 
                WHERE orcamento_codigo = v_orc_cod AND produto_codigo = NEW.produto_codigo;
            END IF;
        END LOOP;
        CLOSE cur_pendentes;
        SET NEW.produto_qtd_estoque = v_novo_saldo;
    END IF;
END$$
DELIMITER ;
