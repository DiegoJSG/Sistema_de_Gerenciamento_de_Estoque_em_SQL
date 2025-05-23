-- # Sistema de Gerenciamento de Estoque
-- # vendas, compras e controle geral.
-- # Comentários feitos para facilitar o entendimento,

-- Sempre apagar tabelas antigas para evitar erro de FK
-- IMPORTANTE: Sempre apagar na ordem correta.

DROP TABLE IF EXISTS Devolucoes;
DROP TABLE IF EXISTS HistoricoPrecos;
DROP TABLE IF EXISTS Vendas;
DROP TABLE IF EXISTS Compras;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Produtos;
DROP TABLE IF EXISTS Fornecedores;

-- Tabela Clientes
-- Armazena dados dos clientes que compram produtos

CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY, -- Identificador único do cliente
    Nome VARCHAR(255) NOT NULL, -- Nome completo do cliente
    Endereco VARCHAR(255),      -- Endereço para entrega/faturamento
    Telefone VARCHAR(20),       -- Telefone para contato
    Email VARCHAR(255)          -- E-mail para comunicação
);


-- Tabela Produtos
-- Aqui ficam os produtos que a empresa vende e controla em estoque

CREATE TABLE Produtos (
    ID_Produto INT PRIMARY KEY,           -- Identificador único do produto
    Nome VARCHAR(255) NOT NULL,            -- Nome do produto para exibição
    Descricao TEXT,                        -- Descrição detalhada do produto
    Preco DECIMAL(10, 2) NOT NULL,        -- Preço atual de venda
    QuantidadeEmEstoque INT NOT NULL,      -- Quantidade disponível em estoque
    Lote VARCHAR(50),                      -- Lote para controle interno (ex: fornecedor, fabricação)
    DataValidade DATE                      -- Data de validade do produto (se aplicável)
);

-- Tabela Fornecedores
-- Cadastro dos fornecedores que vendem produtos para a empresa

CREATE TABLE Fornecedores (
    ID_Fornecedor INT PRIMARY KEY,  -- Identificador único do fornecedor
    Nome VARCHAR(255) NOT NULL,      -- Nome da empresa ou pessoa fornecedora
    Endereco VARCHAR(255),           -- Endereço para entrega ou contato
    Telefone VARCHAR(20),            -- Telefone para contato
    Email VARCHAR(255)               -- E-mail para comunicação
);

-- Tabela Compras
-- Registra cada compra feita pela empresa aos fornecedores

CREATE TABLE Compras (
    ID_Compra INT PRIMARY KEY,           -- Identificador único da compra
    DataCompra DATE,                     -- Data em que a compra foi realizada
    Fornecedor_ID INT,                   -- Referência para o fornecedor (chave estrangeira)
    Produto_ID INT,                     -- Referência para o produto comprado (chave estrangeira)
    QuantidadeComprada INT,              -- Quantidade de itens comprados nesta compra
    PrecoUnitario DECIMAL(10, 2),       -- Preço unitário pago por produto
    TotalCompra DECIMAL(10, 2),         -- Valor total da compra (QuantidadeComprada * PrecoUnitario)
    FOREIGN KEY (Fornecedor_ID) REFERENCES Fornecedores(ID_Fornecedor),
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);


-- Tabela Vendas
-- Registra cada venda realizada para clientes

CREATE TABLE Vendas (
    ID_Venda INT PRIMARY KEY,           -- Identificador único da venda
    DataVenda DATE,                    -- Data em que a venda ocorreu
    Cliente_ID INT,                    -- Referência para o cliente que comprou (chave estrangeira)
    Produto_ID INT,                   -- Referência para o produto vendido (chave estrangeira)
    QuantidadeVendida INT,             -- Quantidade de produtos vendidos nesta venda
    PrecoUnitario DECIMAL(10, 2),     -- Preço unitário cobrado na venda
    TotalVenda DECIMAL(10, 2),        -- Valor total da venda (QuantidadeVendida * PrecoUnitario)
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);


-- Tabela Devolucoes
-- Controla produtos que foram devolvidos por clientes após venda

CREATE TABLE Devolucoes (
    ID_Devolucao INT PRIMARY KEY,       -- Identificador da devolução
    DataDevolucao DATE,                 -- Data da devolução realizada
    Venda_ID INT,                      -- Referência para a venda original (FK)
    Produto_ID INT,                   -- Produto devolvido (FK)
    QuantidadeDevolvida INT,           -- Quantidade devolvida
    FOREIGN KEY (Venda_ID) REFERENCES Vendas(ID_Venda),
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);

-- Tabela HistoricoPrecos
-- Armazena mudanças de preços ao longo do tempo para análise

CREATE TABLE HistoricoPrecos (
    ID_Historico INT PRIMARY KEY,       -- Identificador do registro histórico
    Produto_ID INT,                     -- Produto que teve alteração no preço (FK)
    PrecoAnterior DECIMAL(10, 2),      -- Preço antigo antes da alteração
    NovoPreco DECIMAL(10, 2),          -- Novo preço após alteração
    DataAlteracao DATE,                 -- Data em que o preço foi alterado
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);


-- Views para facilitar consultas rápidas e demonstrar conhecimento

-- View 1: Quantidade total de produtos em estoque por produto
CREATE VIEW vw_EstoqueAtual AS
SELECT 
    ID_Produto,
    Nome,
    QuantidadeEmEstoque
FROM Produtos;

-- View 2: Total comprado por fornecedor (somando todas as compras)
CREATE VIEW vw_TotalCompradoPorFornecedor AS
SELECT 
    f.ID_Fornecedor,
    f.Nome AS NomeFornecedor,
    SUM(c.QuantidadeComprada) AS QuantidadeTotalComprada,
    SUM(c.TotalCompra) AS ValorTotalComprado
FROM Compras c
JOIN Fornecedores f ON c.Fornecedor_ID = f.ID_Fornecedor
GROUP BY f.ID_Fornecedor, f.Nome;

-- View 3: Total vendido por cliente (somando todas as vendas)
CREATE VIEW vw_TotalVendidoPorCliente AS
SELECT
    cl.ID_Cliente,
    cl.Nome AS NomeCliente,
    SUM(v.QuantidadeVendida) AS QuantidadeTotalVendida,
    SUM(v.TotalVenda) AS ValorTotalVendido
FROM Vendas v
JOIN Clientes cl ON v.Cliente_ID = cl.ID_Cliente
GROUP BY cl.ID_Cliente, cl.Nome;

-- View 4: Histórico de preço dos produtos (listando alterações)
CREATE VIEW vw_HistoricoPrecosProdutos AS
SELECT 
    p.ID_Produto,
    p.Nome,
    h.PrecoAnterior,
    h.NovoPreco,
    h.DataAlteracao
FROM HistoricoPrecos h
JOIN Produtos p ON h.Produto_ID = p.ID_Produto
ORDER BY p.ID_Produto, h.DataAlteracao DESC;
