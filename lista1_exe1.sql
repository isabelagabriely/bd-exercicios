create table produto (
    id_nf int not null,
    id_item int not null,
    cod_prod int not null,
    valor_unit decimal(10,2) not null,
    quantidade int not null,
    desconto int 
);

insert into produto values (1, 1, 1, 25.00, 10, 5);
insert into produto values (1, 2, 2, 13.50, 3, null);
insert into produto values (1, 3, 3, 15.00, 2, null);
insert into produto values (1, 4, 4, 10.00, 1, null);
insert into produto values (1, 5, 5, 30.00, 1, null);
insert into produto values (2, 1, 3, 15.00, 4, null);
insert into produto values (2, 2, 4, 10.00, 5, null);
insert into produto values (2, 3, 5, 30.00, 7, null);
insert into produto values (3, 1, 1, 25.00, 5, null);
insert into produto values (3, 2, 4, 10.00, 4, null);
insert into produto values (3, 3, 5, 30.00, 5, null);
insert into produto values (3, 4, 2, 13.50, 7, null);
insert into produto values (4, 1, 5, 30.00, 10, 15);
insert into produto values (4, 2, 4, 10.00, 12, 5);
insert into produto values (4, 3, 1, 25.00, 13, 5);
insert into produto values (4, 4, 2, 13.50, 15, 5);
insert into produto values (5, 1, 3, 15.00, 3, null);
insert into produto values (5, 2, 5, 30.00, 6, null);
insert into produto values (6, 1, 1, 25.00, 22, 15);
insert into produto values (6, 2, 3, 15.00, 25, 20);
insert into produto values (7, 1, 1, 25.00, 10, 3);
insert into produto values (7, 2, 2, 13.50, 10, 4);
insert into produto values (7, 3, 3, 15.00, 10, 4);
insert into produto values (7, 4, 5, 30.00, 10, 1);

# Questões
/* a) Pesquise os itens que foram vendidos sem desconto. As colunas presentes no resultado da consulta são:
id_nf, id_item, cod_prod e  valor_unit.
*/
select p.id_nf, p.id_item, p.cod_prod, p.valor_unit 
from produto p
where p.desconto is null;

/* b) Pesquise os itens que foram vendidos com desconto. As colunas presentes no resultado da consulta são: 
id_nf, id_item, cod_prod, valor_unit e o valor_vendido (p.valor_unit-valor_unit*(desconto/100)).
*/
select p.id_nf, p.id_item, p.cod_prod, p.valor_unit, round(p.valor_unit - p.valor_unit * (p.desconto / 100), 2) as valor_vendido 
from produto p
where p.desconto is not null;

/* c) Altere o valor do desconto (para zero) de todos os registros onde este campo é nulo.
*/
update produto
set desconto = 0
where desconto is null;

/* d) Pesquise os itens que foram vendidos. As colunas presentes no resultado da consulta são: 
id_nf, id_item, cod_prod, valor_unit, valor_total (quantidade*valor_vendido), desconto, 
valor_vendido (valor_unit-valor_unit*(desconto/100)).
*/
select p.id_nf, p.id_item, p.cod_prod, p.valor_unit,
round(quantidade * (p.valor_unit - p.valor_unit * p.desconto / 100), 2) as valor_total, p.desconto,
round(p.valor_unit - p.valor_unit * p.desconto / 100, 2) as valor_vendido 
from produto p;

/* e) Pesquise o valor total das NF e ordene o resultado do maior valor para o menor. As
colunas presentes no resultado da consulta são: id_nf, valor_total. 
OBS: O valor_total é obtido pela fórmula: ∑ quantidade * valor_unit. Agrupe o
resultado da consulta por id_nf.
*/
select p.id_nf, round(sum(p.quantidade * p.valor_unit), 2) as valor_total
from produto p
group by id_nf
order by valor_total desc;

/* f) Pesquise o valor vendido das NF e ordene o resultado do maior valor para o menor. As
colunas presentes no resultado da consulta são: id_nf, valor_vendido, valor_total. 
OBS: O valor_total é obtido pela fórmula: ∑ quantidade * valor_unit. O
valor_vendido é igual a ∑ valor_unit - (valor_unit*(desconto/100)). Agrupe
o resultado da consulta por id_nf.
*/
select p.id_nf, round(sum(p.valor_unit - p.valor_unit * p.desconto / 100), 2) as valor_vendido, round(sum(p.quantidade * p.valor_unit), 2) as valor_total
from produto p
group by id_nf
order by valor_total desc;

/* g) Consulte o produto que mais vendeu no geral. As colunas presentes no resultado da
consulta são: cod_prod, quantidade. Agrupe o resultado da consulta por
cod_prod.
*/
select prod_totais.cod_prod, max(prod_totais.quantidade_total) as quantidade_total from
(select p.cod_prod, sum(p.quantidade) as quantidade_total
from produto p
group by p.cod_prod) as prod_totais;

/* h) Consulte as NF que foram vendidas mais de 10 unidades de pelo menos um produto.
As colunas presentes no resultado da consulta são: id_nf, cod_prod, quantidade.
Agrupe o resultado da consulta por id_nf, cod_prod.
*/
select p.id_nf, p.cod_prod, p.quantidade
from produto p
where p.quantidade > 10
group by p.id_nf, p.cod_prod;

/* i) Pesquise o valor total das NF, onde esse valor seja maior que 500, e ordene o
resultado do maior valor para o menor. As colunas presentes no resultado da consulta
são: id_nf, valor_total. 
OBS: O valor_total é obtido pela fórmula: ∑ quantidade * valor_unit. Agrupe o resultado da consulta por id_nf.
*/
select p.id_nf, sum(round(p.quantidade * p.valor_unit, 2)) as valor_total
from produto p
group by p.id_nf
having (valor_total) > 500
order by valor_total desc;

/* j) Qual o valor médio dos descontos dados por produto. As colunas presentes no
resultado da consulta são: cod_prod, media. Agrupe o resultado da consulta por
cod_prod.
*/
select p.cod_prod, round(avg(p.desconto), 2) as media_desconto
from produto p
group by cod_prod;

/* k) Qual o menor, maior e o valor médio dos descontos dados por produto. As colunas
presentes no resultado da consulta são: cod_prod, menor, maior, media. Agrupe
o resultado da consulta por cod_prod.
*/
select p.cod_prod, min(p.desconto) as menor_desconto, max(p.desconto) as maior_desconto, round(avg(p.desconto), 2) as media_desconto
from produto p 
group by p.cod_prod;

/* l) Quais as NF que possuem mais de 3 itens vendidos. As colunas presentes no resultado
da consulta são: id_nf, qtd_itens.
OBS: NÃO ESTÁ RELACIONADO A QUANTIDADE VENDIDA DO ITEM E SIM A QUANTIDADE DE ITENS POR NOTA FISCAL. 
Agrupe o resultado da consulta por id_nf.
*/
select p.id_nf, max(p.id_item) as qtd_itens
from produto p
group by p.id_nf
having (qtd_itens) > 3;
