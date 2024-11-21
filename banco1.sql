CREATE DATABASE ECommerce;

USE ECommerce;

-- Tabela Clientes
CREATE TABLE Clientes (
    idClientes INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    CPF VARCHAR(45),
    Endereco VARCHAR(45),
    TipoCliente ENUM('PJ', 'PF') NOT NULL,
    CNPJ VARCHAR(45),
    CHECK (
        (TipoCliente = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL) OR
        (TipoCliente = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL)
    )
);

-- Tabela Transportadora
CREATE TABLE Transportadora (
    idTransportadora INT AUTO_INCREMENT PRIMARY KEY,
    DataEntrega DATE,
    MetodoEnvio VARCHAR(45),
    CNPJ VARCHAR(45),
    Endereco VARCHAR(45)
);

-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    CNPJ VARCHAR(45)
);

-- Tabela Produtos
CREATE TABLE Produtos (
    idProdutos INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45),
    Categoria VARCHAR(45),
    Descricao VARCHAR(45),
    Valor FLOAT NOT NULL
);

-- Tabela Estoque
CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Local VARCHAR(45)
);

-- Tabela Produtos Estoque
CREATE TABLE Produtos_Estoque (
    Produtos_idProdutos INT,
    Estoque_idEstoque INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (Produtos_idProdutos, Estoque_idEstoque),
    FOREIGN KEY (Produtos_idProdutos) REFERENCES Produtos(idProdutos),
    FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque(idEstoque)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45),
    Clientes_idClientes INT,
    Frete FLOAT,
    StatusEntrega VARCHAR(45),
    CodRastreio VARCHAR(45),
    FOREIGN KEY (Clientes_idClientes) REFERENCES Clientes(idClientes)
);

-- Tabela Pedido Transportadora
CREATE TABLE Pedido_Transportadora (
    idPedido INT,
    Transportadora_idTransportadora INT,
    PRIMARY KEY (idPedido, Transportadora_idTransportadora),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (Transportadora_idTransportadora) REFERENCES Transportadora(idTransportadora)
);

-- Tabela Relacao Pedido e Produtos
CREATE TABLE Relacao_Pedido_Produtos (
    Pedido_idPedido INT,
    Produtos_idProdutos INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (Pedido_idPedido, Produtos_idProdutos),
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (Produtos_idProdutos) REFERENCES Produtos(idProdutos)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    TipoPagamento VARCHAR(45),
    DataPagamento DATE,
    Valor FLOAT NOT NULL,
    StatusPagamento VARCHAR(45),
    Pedido_idPedido INT,
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
);

-- Tabela Produtos por Vendedor
CREATE TABLE Produtos_por_Vendedor (
    idTerceiroVendedor INT,
    Produtos_idProdutos INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (idTerceiroVendedor, Produtos_idProdutos),
    FOREIGN KEY (idTerceiroVendedor) REFERENCES Terceiro_Vendedor(idTerceiroVendedor),
    FOREIGN KEY (Produtos_idProdutos) REFERENCES Produtos(idProdutos)
);

-- Tabela Terceiro Vendedor
CREATE TABLE Terceiro_Vendedor (
    idTerceiroVendedor INT AUTO_INCREMENT PRIMARY KEY,
    RazaoSocial VARCHAR(45),
    Local VARCHAR(45)
);

-- Tabela Fornece Produtos
CREATE TABLE Fornece_Produtos (
    Fornecedor_idFornecedor INT,
    Produtos_idProdutos INT,
    Prazo DATE,
    PRIMARY KEY (Fornecedor_idFornecedor, Produtos_idProdutos),
    FOREIGN KEY (Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor),
    FOREIGN KEY (Produtos_idProdutos) REFERENCES Produtos(idProdutos)
);


SELECT Nome, Valor
FROM Produtos;

SELECT Nome, Valor
FROM Produtos
WHERE Valor > 100;


SELECT 
    p.Nome,
    (pe.Quantidade * p.Valor) AS ValorTotalEstoque
FROM Produtos p
JOIN Produtos_Estoque pe ON p.idProdutos = pe.Produtos_idProdutos;


SELECT Nome, Endereco
FROM Clientes
ORDER BY Nome ASC;


SELECT 
    f.Nome AS Fornecedor,
    COUNT(fp.Produtos_idProdutos) AS TotalProdutos
FROM Fornecedor f
JOIN Fornece_Produtos fp ON f.idFornecedor = fp.Fornecedor_idFornecedor
GROUP BY f.Nome
HAVING COUNT(fp.Produtos_idProdutos) > 10;


SELECT 
    p.idPedido,
    c.Nome AS Cliente,
    t.MetodoEnvio AS Transportadora,
    p.StatusEntrega
FROM Pedido p
JOIN Clientes c ON p.Clientes_idClientes = c.idClientes
JOIN Pedido_Transportadora pt ON p.idPedido = pt.idPedido
JOIN Transportadora t ON pt.Transportadora_idTransportadora = t.idTransportadora;
