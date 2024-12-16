-- Criação do Banco de dados para o cenário de e-commerce
create database ecommerce;
drop database ecommerce; 
use ecommerce;

-- criar tabela cliente
create table cliente (
	idCliente int auto_increment primary key,
    logradouro varchar(45) not null,
    numLogradouro varchar(5) not null,
    bairro varchar(30) not null,
    cidade varchar(30) not null,
    estado enum ('AC', 'AL', 'AP', 'AM', 'BA','CE', 'DF', 'ES', 'GO', 'MA', 'MT',
				'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 
                'RR', 'SC', 'SP', 'SE', 'TO') default 'SP',
	cep char(8));
    
-- criar tabela PessoaFisica
create table PessoaFisica (
		idCliente int primary key,
		Pnome varchar(10) not null,
        NmeioInicial char(1) not null,
        Sobrenome varchar(15) not null,
        CPF char(11) not null,
        DataNasc date not null,
        constraint cpf_cliente unique(CPF),
        constraint fk_idCliente_fisico foreign key (idCliente) references Cliente(idCliente)
);
-- criar tabela PessoaJuridica
create table PessoaJuridica (
		idCliente int primary key,
		RazaoSocial varchar(45) not null,
        CNPJ char(14) not null,
        constraint cnpj_cliente unique(CNPJ),
        constraint fk_idCliente_juridico foreign key (idCliente) references Cliente(idCliente)
);
-- criar tabela Pagamento
create table Pagamento (
	idCartao int auto_increment primary key,
    idCliente int,
	Bandeira ENUM('Mastercard', 'Visa', 'Elo', 'American Express', 'Hipercard', 'Alelo') default 'Mastercard',
	NumCartao varchar(16) not null,
	Validade date not null,
	CVV char(3),
	constraint numero_cartao unique (NumCartao),
    constraint fk_idCliente_Pag foreign key (idCliente) references Cliente(idCliente));

-- criar tabela Pedido
create table Pedido (
	idPedido int auto_increment primary key,
    idCliente int,
	StatusPedido enum('Pedido recebido', 'Pagamento aprovado', 'Em preparação', 'Enviado', 'Aguardando pagamento', 'Pedido em processamento', 'Pedido cancelado') default 'Pedido em processamento',
	Frete float default 10,
	CodRastreio char(10) not null,
	constraint codigo_rastreio unique(CodRastreio),
    constraint fk_idCliente_Pedido foreign key (idCliente) references Cliente(idCliente));

-- criar tabela produto
create table Produto(
	idProduto int auto_increment primary key,
	ProdCategoria varchar(30) not null,
	DescProduto varchar(120) not null,
	Pvalor float not null
);

-- criar tabela associativa PedidoProduto
create table PedidoProduto (
	idPedido int,
    idProduto int,
    PedidoQtd int default 1,
    primary key (idPedido, idProduto),
    constraint fk_idPedido foreign key (idPedido) references Pedido(idPedido),
    constraint fk_idProduto_Pedido foreign key (idProduto) references Produto(idProduto)
    );
-- criar tabela Estoque
create table Estoque(
	idEstoque int auto_increment primary key,
	Elogradouro varchar(45) not null,
	EnumLogradouro varchar(5) not null,
	Ebairro varchar (30) not null,
	Ecidade varchar (30) not null,
	Eestado enum ('AC', 'AL', 'AP', 'AM', 'BA','CE', 'DF', 'ES', 'GO', 'MA', 'MT',
				'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 
                'RR', 'SC', 'SP', 'SE', 'TO') default 'SP',
	Ecep char(8));
-- criar tabela associativa ProdutoEstoque
create table ProdutoEstoque(
	idProduto int,
    idEstoque int,
    ProdutoQtd int not null,
    primary key (idProduto, idEstoque),
    constraint fk_idProduto_Estoque foreign key (idProduto) references Produto(idProduto),
    constraint fk_idEstoque foreign key (idEstoque) references Estoque(idEstoque));
    
-- criar tabela Fornecedor
create table Fornecedor(
	idFornecedor int auto_increment primary key,
	RazaoSocial varchar(45) not null,
	CNPJ varchar (14) not null,
	Flogradouro varchar(45) not null,
	FnumLogradouro varchar(5) not null,
	Fbairro varchar (30) not null,
	Fcidade varchar (30) not null,
	Festado enum ('AC', 'AL', 'AP', 'AM', 'BA','CE', 'DF', 'ES', 'GO', 'MA', 'MT',
				'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 
                'RR', 'SC', 'SP', 'SE', 'TO') default 'SP',
	Fcep char(8),
    constraint cnpj_fornecedor unique (CNPJ));
    -- criar tabela associativa ProdutoEstoque
create table ProdutoFornecedor(
	idProduto int,
    idFornecedor int,
    primary key (idProduto, idFornecedor),
    constraint fk_idProduto_Fornecedor foreign key (idProduto) references Produto(idProduto),
    constraint fk_idFornecedor foreign key (idFornecedor) references Fornecedor(idFornecedor));
    
-- criar tabela Terceiro
    create table Terceiro(
	idTerceiro int auto_increment primary key,
	TrazaoSocial varchar(45) not null,
	Tcnpj char(14) not null,
	Tlogradouro varchar(45) not null,
	TnumLogradouro varchar(5) not null,
	Tbairro varchar (30) not null,
	Tcidade varchar (30) not null,
	Testado enum ('Selecione','AC', 'AL', 'AP', 'AM', 'BA','CE', 'DF', 'ES', 'GO', 'MA', 'MT',
				'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 
                'RR', 'SC', 'SP', 'SE', 'TO') default 'SP',
	Tcep char(8),
	constraint cnpj_terceiro unique(Tcnpj));
-- criar tabela associativa ProdutoTerceiro
create table ProdutoTerceiro(
	idProduto int,
    idTerceiro int,
    TercQtd int not null,
    primary key (idProduto, idTerceiro),
    constraint fk_idProduto_Terceiro foreign key (idProduto) references Produto(idProduto),
    constraint fk_idTerceiro foreign key (idTerceiro) references Terceiro(idTerceiro));

-- Consultas
-- desc PessoaFisica
-- show tables;
-- use information_schema;
-- desc table_constraints;
-- select * from referential_constraints where constraint_schema = 'ecommerce';

-- ALTERAÇÕES DE TABELAS:
alter table Cliente auto_increment = 1;
alter table Pagamento auto_increment = 1;
alter table Pedido auto_increment = 1;
alter table Produto auto_increment = 1;
alter table Estoque auto_increment = 1;
alter table Fornecedor auto_increment = 1;
alter table Terceiro auto_increment = 1;

-- INSERÇÕES DE DADOS:
INSERT INTO cliente (logradouro, numLogradouro, bairro, cidade, estado, cep)
VALUES 
('Rua das Flores', '123', 'Jardim Primavera', 'São Paulo', 'SP', '01001000'),
('Avenida Brasil', '567', 'Centro', 'Rio de Janeiro', 'RJ', '20040030'),
('Travessa do Sol', '45', 'Boa Vista', 'Recife', 'PE', '52060000'),
('Rua Dom Pedro', '89', 'Centro', 'Curitiba', 'PR', '80010020'),
('Alameda das Palmeiras', '321', 'Jardim das Árvores', 'Salvador', 'BA', '40020050');

INSERT INTO PessoaFisica (idCliente, Pnome, NmeioInicial, Sobrenome, CPF, DataNasc)
VALUES 
(1, 'Carlos', 'A', 'Silva', '12345678901', '1985-04-15'),
(2, 'Mariana', 'B', 'Oliveira', '23456789012', '1992-09-20'),
(3, 'João', 'C', 'Pereira', '34567890123', '1978-01-10'),
(4, 'Ana', 'D', 'Santos', '45678901234', '1989-06-25'),
(5, 'Paulo', 'E', 'Costa', '56789012345', '1995-11-30');

INSERT INTO PessoaJuridica (idCliente, RazaoSocial, CNPJ)
VALUES 
(1, 'Loja da Silva LTDA', '12345678000195'),
(2, 'Oliveira & Cia Comércio', '23456789000181'),
(3, 'Pereira Distribuidora Ltda', '34567890000167'),
(4, 'Santos Empreendimentos S.A.', '45678901000153'),
(5, 'Costa & Costa Comércio Ltda', '56789012000139');

INSERT INTO Pagamento (idCliente, Bandeira, NumCartao, Validade, CVV)
VALUES 
(1, 'Mastercard', '1234123412341234', '2026-07-15', '123'),
(2, 'Visa', '2345234523452345', '2025-10-20', '234'),
(3, 'Elo', '3456345634563456', '2027-03-11', '345'),
(4, 'American Express', '4567456745674567', '2028-01-30', '456'),
(5, 'Hipercard', '5678567856785678', '2026-12-05', '567');

INSERT INTO Pedido (idCliente, StatusPedido, Frete, CodRastreio)
VALUES 
(1, 'Pedido recebido', 15.50, 'R123456789'),
(2, 'Pagamento aprovado', 10.00, 'R987654321'),
(3, 'Em preparação', 20.00, 'R456789012'),
(4, 'Enviado', 12.50, 'R789012345'),
(5, 'Aguardando pagamento', 18.00, 'R321654987'),
(1, 'Pedido em processamento', 8.00, 'R654987321'),
(2, 'Pedido cancelado', 10.00, 'R159357486'),
(3, 'Pedido recebido', 25.00, 'R852963741'),
(4, 'Pagamento aprovado', 12.00, 'R741258963'),
(5, 'Em preparação', 30.00, 'R963852741'),
(1, 'Enviado', 22.00, 'R147258369'),
(2, 'Aguardando pagamento', 15.00, 'R369852147'),
(3, 'Pedido em processamento', 20.00, 'R258369147'),
(4, 'Pedido cancelado', 12.00, 'R753951456'),
(5, 'Pedido recebido', 17.50, 'R456123789');

INSERT INTO Produto (ProdCategoria, DescProduto, Pvalor)
VALUES 
('Roupas', 'Camiseta masculina de algodão, tamanho M, cor azul', 39.90),
('Roupas', 'Camiseta feminina de algodão, tamanho P, cor branca', 35.90),
('Roupas', 'Calça jeans masculina, tamanho 42, cor azul escuro', 89.90),
('Calçados', 'Sapato social masculino, tamanho 42, cor preta', 149.90),
('Calçados', 'Sapato feminino casual, tamanho 38, cor nude', 129.90),
('Acessórios', 'Relógio de pulso masculino, à prova d\'água', 199.90),
('Acessórios', 'Bolsa de couro feminina, tamanho médio, cor vermelha', 299.90),
('Livros', 'Livro de ficção científica, autor brasileiro, 350 páginas', 39.90),
('Livros', 'Livro de receitas rápidas para iniciantes na cozinha', 29.90),
('Mídia', 'DVD de filme de ação, edição especial', 19.90),
('Roupas', 'Camiseta personalizada com estampa, tamanho único', 49.90),
('Eletrônicos', 'Smartphone com tela de 6.5 polegadas e 64GB de armazenamento', 799.99),
('Eletrônicos', 'Fone de ouvido Bluetooth com cancelamento de ruído', 249.90),
('Beleza', 'Perfume feminino floral, 100ml', 119.90),
('Cozinha', 'Panela de pressão 5L, alumínio, com tampa de segurança', 159.90);


INSERT INTO PedidoProduto (idPedido, idProduto, PedidoQtd)
VALUES 
(1, 1, 2),  
(1, 2, 4),  
(2, 3, 1),  
(2, 4, 2),  
(3, 5, 6),  
(3, 6, 1),  
(4, 7, 8),  
(4, 8, 2),  
(5, 9, 2),  
(5, 10, 9), 
(6, 11, 1), 
(6, 12, 5), 
(7, 13, 3), 
(7, 14, 7), 
(8, 15, 10); 

INSERT INTO Estoque (Elogradouro, EnumLogradouro, Ebairro, Ecidade, Eestado, Ecep)
VALUES 
('Rua dos Lírios', '145', 'Jardim das Flores', 'São Paulo', 'SP', '01234000'),
('Avenida Brasil', '765', 'Centro', 'Rio de Janeiro', 'RJ', '20050010'),
('Rua do Comércio', '89', 'Vila Nova', 'Salvador', 'BA', '40320000'),
('Rua das Palmeiras', '233', 'Bairro Alto', 'Curitiba', 'PR', '80060000'),
('Alameda dos Anjos', '456', 'Zona Norte', 'Fortaleza', 'CE', '60420000');

INSERT INTO ProdutoEstoque (idProduto, idEstoque, ProdutoQtd)
VALUES 
(1, 1, 50),  
(2, 2, 30),  
(3, 3, 100), 
(4, 4, 20),  
(5, 5, 10);  

INSERT INTO Fornecedor (RazaoSocial, CNPJ, Flogradouro, FnumLogradouro, Fbairro, Fcidade, Festado, Fcep)
VALUES 
('Fornecedor A Ltda', '12345678000195', 'Rua das Flores', '123', 'Jardim Primavera', 'São Paulo', 'SP', '01234000'),
('Fornecedor B S.A.', '23456789000181', 'Avenida Brasil', '456', 'Centro', 'Rio de Janeiro', 'RJ', '20050010'),
('Fornecedor C Comercio', '34567890000167', 'Rua do Comércio', '789', 'Vila Nova', 'Salvador', 'BA', '40320000'),
('Fornecedor D EPP', '45678901000153', 'Rua das Palmeiras', '101', 'Bairro Alto', 'Curitiba', 'PR', '80060000'),
('Fornecedor E Ltda', '56789012000139', 'Alameda dos Anjos', '202', 'Zona Norte', 'Fortaleza', 'CE', '60420000');

INSERT INTO ProdutoFornecedor (idProduto, idFornecedor)
VALUES 
(1, 1),  
(2, 2),  
(3, 3),  
(4, 4),  
(5, 5);  

INSERT INTO Terceiro (TrazaoSocial, Tcnpj, Tlogradouro, TnumLogradouro, Tbairro, Tcidade, Testado, Tcep)
VALUES 
('Terceiro A Serviços', '12345678000195', 'Rua das Palmeiras', '100', 'Bairro Central', 'São Paulo', 'SP', '01001000'),
('Terceiro B Consultoria', '23456789000181', 'Avenida Brasil', '200', 'Centro Comercial', 'Rio de Janeiro', 'RJ', '20050010'),
('Terceiro C Logística', '34567890000167', 'Rua do Comércio', '300', 'Vila Nova', 'Salvador', 'BA', '40320000'),
('Terceiro D Tecnologia', '45678901000153', 'Rua das Acácias', '400', 'Jardim das Flores', 'Curitiba', 'PR', '80060000'),
('Terceiro E Transporte', '56789012000139', 'Alameda dos Anjos', '500', 'Zona Norte', 'Fortaleza', 'CE', '60420000');

INSERT INTO ProdutoTerceiro (idProduto, idTerceiro, TercQtd)
VALUES 
(1, 1, 100),  
(2, 2, 50),   
(3, 3, 200),  
(4, 4, 75),   
(5, 5, 30);

-- CONSULTAS

-- Quantos clientes pessoa física tiveram seu pedido entregue?
select count(*) from pessoafisica pf 
	inner join cliente c on pf.idCliente = c.idCliente
	inner join pedido p on c.idCliente = p.idCliente
    where p.statuspedido = 'Pedido recebido';
-- Quantos clientes pessoa jurídica ainda aguardam o recebimento do pedido?
select count(*) from pessoajuridica pj
	inner join cliente c on pj.idCliente = c.idCliente
    inner join pedido p on c.idCliente = p.idCliente
    where p.statuspedido = 'Enviado';
-- Quem são os clientes pessoa jurídica que compraram produtos da categoria "Eletrônicos"?
select RazaoSocial as nome_da_empresa, 
	prodcategoria as categoria,
    DescProduto as produto,
    PedidoQtd as quantidade
    from pessoajuridica pj
	inner join cliente c on pj.idcliente = c.idcliente
    inner join pedido p on c.idcliente = p.idcliente
    inner join pedidoproduto pp on pp.idpedido = p.idpedido
    inner join produto pr on pr.idproduto = pp.idproduto
    where pr.prodcategoria = 'Eletrônicos';
    
desc produto;

-- Qual é o valor total do pedido, considerando os preços, quantidade e o valor do frete?
select p.idpedido, round(sum(pr.pvalor * pp.pedidoqtd) + p.frete, 2) as valor_total
	from Pedido p
	inner join PedidoProduto pp on p.idPedido = pp.idPedido
    inner join Produto pr on pp.idProduto = pr.idProduto
    group by p.idPedido;
    
-- Calcule o total de mercadorias de terceiros com a quantidade total de produtos armazenados no centro de distribuição.
select pr.DescProduto as produto, 
    round(sum(ProdutoQtd + TercQtd), 2) as quantidade_total
	from ProdutoEstoque pe
	inner join Produto pr on pr.idProduto = pe.idProduto
    inner join ProdutoTerceiro pt on pt.idProduto =pr.idProduto
    group by pe.idProduto;

-- Do total de cada, avalie qual deles tem mais de 80 unidades disponíveis em estoque    
select pr.DescProduto as produto, 
    round(sum(ProdutoQtd + TercQtd), 2) as quantidade_total
	from ProdutoEstoque pe
	inner join Produto pr on pr.idProduto = pe.idProduto
    inner join ProdutoTerceiro pt on pt.idProduto =pr.idProduto
    group by pe.idProduto
    having quantidade_total >= 90
    ;


