-- tabela de Produtos
CREATE TABLE Produtos (
    ID_Produto INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Descricao TEXT,
    Preco DECIMAL(10, 2) NOT NULL,
    QuantidadeEmEstoque INT NOT NULL
);

-- tabela de Fornecedores
CREATE TABLE Fornecedores (
    ID_Fornecedor INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20),
    Email VARCHAR(255)
);

-- tabela de Compras
CREATE TABLE Compras (
    ID_Compra INT PRIMARY KEY,
    DataCompra DATE,
    Fornecedor_ID INT,
    Produto_ID INT,
    QuantidadeComprada INT,
    PrecoUnitario DECIMAL(10, 2),
    TotalCompra DECIMAL(10, 2),
    FOREIGN KEY (Fornecedor_ID) REFERENCES Fornecedores(ID_Fornecedor),
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);

-- tabela de Vendas
CREATE TABLE Vendas (
    ID_Venda INT PRIMARY KEY,
    DataVenda DATE,
    Cliente_ID INT, -- Se aplicável
    Produto_ID INT,
    QuantidadeVendida INT,
    PrecoUnitario DECIMAL(10, 2),
    TotalVenda DECIMAL(10, 2),
    FOREIGN KEY (Cliente_ID) REFERENCES Clientes(ID_Cliente), -- Se aplicável
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);

-- tabela de Clientes
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20),
    Email VARCHAR(255)
);

-- Inserir um novo produto no estoque
INSERT INTO Produtos (ID_Produto, Nome, Descricao, Preco, QuantidadeEmEstoque)
VALUES (1, 'Produto A', 'Descrição do Produto A', 19.99, 100);

-- Registrar uma compra de produtos
INSERT INTO Compras (ID_Compra, DataCompra, Fornecedor_ID, Produto_ID, QuantidadeComprada, PrecoUnitario, TotalCompra)
VALUES (1, '2023-10-18', 1, 1, 50, 19.99, 999.50);

-- Registrar uma venda de produtos
INSERT INTO Vendas (ID_Venda, DataVenda, Cliente_ID, Produto_ID, QuantidadeVendida, PrecoUnitario, TotalVenda)
VALUES (1, '2023-10-19', 1, 1, 10, 24.99, 249.90);

-- Atualizar a quantidade de produtos em estoque após uma venda
UPDATE Produtos
SET QuantidadeEmEstoque = QuantidadeEmEstoque - 10
WHERE ID_Produto = 1;


-- Relatórios Gerenciais para obter uma lista dos produtos mais vendidos
SELECT p.Nome AS Produto, SUM(v.QuantidadeVendida) AS TotalVendido
FROM Produtos p
JOIN Vendas v ON p.ID_Produto = v.Produto_ID
GROUP BY p.Nome
ORDER BY TotalVendido DESC;

--  Alertas de estoque baixo que exibe os produtos com menos de 20 unidades (exemplo)
SELECT Nome, QuantidadeEmEstoque
FROM Produtos
WHERE QuantidadeEmEstoque < 20;

-- Registrar uma devolução
INSERT INTO Devolucoes (ID_Devolucao, DataDevolucao, Venda_ID, Produto_ID, QuantidadeDevolvida)
VALUES (1, '2023-10-20', 1, 1, 2);

-- Atualizar o estoque após uma devolução
UPDATE Produtos
SET QuantidadeEmEstoque = QuantidadeEmEstoque + 2
WHERE ID_Produto = 1;

-- Tabela de Histórico de Preços
CREATE TABLE HistoricoPrecos (
    ID_Historico INT PRIMARY KEY,
    Produto_ID INT,
    PrecoAnterior DECIMAL(10, 2),
    NovoPreco DECIMAL(10, 2),
    DataAlteracao DATE,
    FOREIGN KEY (Produto_ID) REFERENCES Produtos(ID_Produto)
);

-- Registrar um novo preço
INSERT INTO HistoricoPrecos (Produto_ID, PrecoAnterior, NovoPreco, DataAlteracao)
VALUES (1, 19.99, 24.99, '2023-10-20');

-- Consulta para verificar produtos vencidos
SELECT Nome, Lote, DataValidade
FROM Produtos
WHERE DataValidade < CURDATE();





