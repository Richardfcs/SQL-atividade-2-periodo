SELECT * FROM petshop.empregado;

-- 01 Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, 
-- trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), 
-- ordenado por data de admissão decrescente;

select emp.nome as "Nome", emp.cpf "CPF" , date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão",
	concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário", dep.nome "Departamento",
    coalesce(tel.numero, 'não informado') "Telefone"
    from empregado emp
		left join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
        left join telefone tel on Empregado_cpf = emp.cpf
			where dataAdm between "2019-01-01" and "2022-03-31"
            	order by dataAdm desc;

-- um ano a menos para aparecer a tabela --        
select emp.nome as "Nome", emp.cpf "CPF" , date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão",
	concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário", dep.nome "Departamento",
    coalesce(tel.numero, 'não informado') "Telefone"
    from empregado emp
		left join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
        left join telefone tel on Empregado_cpf = emp.cpf
			where dataAdm between "2019-01-01" and "2023-03-31"
            	order by dataAdm desc;		
        
-- 02  Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, 
-- trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone),
-- ordenado por nome do empregado;

select emp.nome as "Nome", emp.cpf "CPF" , date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão",
	concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário", dep.nome "Departamento",
    coalesce(tel.numero, 'não informado') "Telefone"
    from empregado emp
		left join departamento dep on dep.idDepartamento = emp.Departamento_idDepartamento
        left join telefone tel on Empregado_cpf = emp.cpf
			where salario < (select avg(salario) from empregado)
            	order by nome;
            
-- apenas para ver a média            
select concat('R$ ', format(avg(salario), 2, 'de_DE')) "Média Salarial" from empregado;

-- 03 Lista dos departamentos com a quantidade de empregados total por cada departamento,
-- trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos empregados do departamento,
-- com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão), 
-- ordenado por nome do departamento;

select dep.nome as "Nome Departamento", count(emp.Departamento_idDepartamento) "Quantidade de Empregados",
 concat('R$ ', format(avg(emp.salario), 2, 'de_DE')) "Média salarial", 
 concat('R$ ', format(avg(emp.comissao), 2, 'de_DE')) "Média da Comissão"
	from departamento dep
		inner join empregado emp ON dep.idDepartamento = emp.Departamento_idDepartamento
        	group by dep.nome
    			order by dep.nome;
    
-- 04 Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado,
-- além da soma do valor total das vendas do empregado e a soma de suas comissões,
-- trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas),
-- ordenado por quantidade total de vendas realizadas

select emp.nome "Nome", emp.cpf "CPF", emp.sexo "Gênero", count(ven.Empregado_cpf) "quantidade de vendas" ,
 concat('R$ ', format(sum(ven.valor), 2, 'de_DE')) "Total Valor Vendido", 
 concat('R$ ', format(sum(ven.comissao), 2, 'de_DE')) "Total Comissão das Vendas"
	from empregado emp
		join venda ven on emp.cpf = ven.Empregado_cpf and ven.comissao and ven.valor
        	group by emp.cpf
				order by count(ven.Empregado_cpf) desc; -- coloquei desc para manter o maior no topo --
    
SELECT count(idVenda) from venda; -- só para contar mesmo --

-- 05 Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado,
-- além da soma do valor total apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões,
-- trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço),
-- ordenado por quantidade total de vendas realizadas;

select emp.nome as "Nome", emp.cpf "CPF" , sexo "Gênero",
	concat('R$ ', format(emp.salario, 2, 'de_DE')) "Salário",
    count(its.quantidade)"Quantidade Vendas com Serviço",
    concat('R$ ', format(sum(its.valor), 2, 'de_DE'))"Total Valor Vendido com Serviço",
    coalesce(concat('R$ ', format(sum(ven.comissao), 2, 'de_DE')), "Sem comissão com serviços" ) "Total Comissão das Vendas com Serviço"
    from empregado emp
		inner join itensservico its on emp.cpf = its.Empregado_cpf
        left join venda ven on emp.cpf = ven.Empregado_cpf
        	group by emp.cpf
				order by count(its.valor) desc;
        
-- 06 Relatório 6 - Lista dos serviços já realizados por um Pet,
-- trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço),
-- ordenado por data do serviço da mais recente a mais antiga;

select pet.nome as "Nome do Pet", date_format(ven.data, '%d/%m/%Y') "Data do Serviço", ser.nome "Nome do Serviço", its.quantidade "Quantidade",
  concat('R$ ', format(its.valor, 2, 'de_DE')) "Valor", emp.nome "Empregado que realizou o Serviço"
	from pet pet
		inner join itensservico its on pet.idPET = its.PET_idPET
		join venda ven on ven.idVenda = its.Venda_idVenda 
		join empregado emp on emp.cpf = its.Empregado_cpf 
		join servico ser on ser.idServico = its.Servico_idServico
			order by ven.data desc;

-- 07 Lista das vendas já realizados para um Cliente,
-- trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda),
-- ordenado por data do serviço da mais recente a mais antiga;

select date_format(ven.data, '%d/%m/%Y') "Data da Venda", concat('R$ ', format(ven.valor, 2, 'de_DE')) "Valor",
 concat('R$ ', format(ven.desconto, 2, 'de_DE')) "Desconto", concat('R$ ', format((ven.valor - ven.desconto), 2, 'de_DE')) "Valor Final",
 emp.nome "Empregado que realizou a venda"
	from venda ven
		join empregado emp on emp.cpf = ven.Empregado_cpf
		join cliente cli on cli.cpf = ven.Cliente_cpf
			where cli.cpf = "001.172.372-64"
				order by ven.data desc;

-- 08 Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido,
-- trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido),
-- ordenado por quantidade total de vendas realizadas;

select ser.nome "Nome do Serviço",
 sum(its.quantidade) "Quantidade Vendas",
 concat('R$ ', format(sum(its.valor), 2, 'de_DE')) "Total Valor Vendido"
	from servico ser
		inner join itensservico its on Servico_idServico = ser.idServico
        	group by ser.nome
				order by sum(its.quantidade) desc
    				limit 10;
    
-- !!! APARTIR DAQUI MEU CÓDIGO FOI PERDIDO, PROCUREI NOS HIISTÓRICO DOS DOCUMENTOS E COLEI, NÃO SEI SE ESTÁ 100% !!!--
    
-- 09 Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas,
-- informando quantas vendas cada forma de pagamento já foi relacionada,
-- trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido),
-- ordenado por quantidade total de vendas realizadas;

select tipo "Tipo Forma Pagamento", count(tipo)"Quantidade Vendas", concat('R$ ', format(sum(valorPago), 2, 'de_DE')) "Total Valor Vendido"
	from formapgvenda 
    	group by tipo
    		order by count(tipo) desc; -- obs, fiz alter table pois tinha dinherio

-- 10 Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia,
-- trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda),
-- ordenado por Data Venda da mais recente a mais antiga;

select date_format(ven.data, '%d/%m/%Y') as "Data Venda",
(count(ivp.quantidade) + count(its.quantidade)) "Quantidade de Vendas",
 concat('R$ ', format((ven.valor), 2, 'de_DE')) "Valor Total Venda"
	from venda ven
    	left join itensvendaprod ivp on ivp.Venda_idVenda = ven.idVenda
		left join itensservico its on its.Venda_idVenda = ven.idVenda
    		group by (ven.idVenda)
				order by ven.data desc;

-- 11 Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto,
-- trazendo as colunas (Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor),
-- ordenado por Nome Produto;

select pro.nome "Nome Produto", concat('R$ ', format(sum(pro.valorVenda), 2, 'de_DE')) "Valor Produto", pro.marca "Categoria do Produto",
 coalesce(max(frn.nome), 'sem registro') "Nome Fornecedor", coalesce(max(frn.email), 'sem registro') "Email Fornecedor", coalesce(max(tel.numero), 'sem registro') "Telefone Fornecedor"
	from produtos pro
    	left join itenscompra itc on itc.Produtos_idProduto = pro.idProduto
    	left join compras com on com.idCompra = itc.Compras_idCompra
    	left join fornecedor frn on frn.cpf_cnpj = com.Fornecedor_cpf_cnpj
    	left join telefone tel on tel.Fornecedor_cpf_cnpj = frn.cpf_cnpj
    		group by pro.idProduto
 				order by pro.nome;

-- teste dos numeros
select f.nome "Nome", f.email "E-mail", t.numero "Telefone"
	from fornecedor f
        join telefone t on t.Fornecedor_cpf_cnpj = f.cpf_cnpj;

-- 12 Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas e o total de valor apurado com a venda do produto,
-- trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, Valor Total Recebido pela Venda do Produto),
-- ordenado por quantidade de vezes que o produto participou em vendas;

select pro.nome "Nome Produto", count(ivp.quantidade) "Quantidade (Total) Vendas",
 concat('R$ ', format(sum(ivp.valor), 2, 'de_DE'))  "Valor Total Recebido pela Venda do Produto)"
	from produtos pro
		join itensvendaprod ivp on ivp.Produto_idProduto = pro.idProduto
			group by pro.nome
				order by count(ivp.quantidade) desc