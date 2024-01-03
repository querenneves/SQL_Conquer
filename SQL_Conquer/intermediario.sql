select 
category
-- apelidando tabela por meio do 'as' -- 
,count * as TOTAL_LINHAS
-- realiza contagem de quantidade de linhas desta tabela distinc ignora a contagem da coluna --
	, count  distinct product_id as TOTAL_PRODUTOS
    -- funcao para extrair media --
    , avg price MEDIA_VALOR
    -- funcao para extrair o maximo valor --
    , max price MAIOR_VALOR
     -- funcao para extrair o valor minumo --
    , min price MENOR_VALOR
from product as P 
group by category
-- agrupando com distinct ou pode ser group by--
select distinct category 
from product

-- ordem (select, from, where, group by, order by e limit) so o 'limit' nao funciona em todos os sql, pode usar todos ou combinar de acordo com a necessidade -- 

-- qual a prioridade e onde está minha informação? --
select
	sub_category
    , category
    -- funcao para extrair valor total de produtos --
    , sum price valor_total
    , avg price valor_medio
from product 
-- filtrando --
where price between 10 and 1000
-- se tenho agrupamento --
group by 
sub_category
    , category
    -- ordenando pela quarta coluna sendo o valor medio da sub_category --
order by 4
-- resposta mais rapida -- 
limit 8
-- unindo tabelas com left join -- 
select 
-- tornando padrão a busca 'P.'
P.product_name
, P.price
, count distinct S.Order_ID QTDE_VENDAS
from product P
-- unindo tabelas -- 
left join sales S
-- juntando com apelidos usando como referencia o id --
	on S.Product_ID = P.Product_id
group by 
P.product_name
	, P.price
order by price desc
limit 5
-- treino de case --
select 
	C.city
    , count distinct S.order_id qtde_vendas
from sales S
left join customer C
	on S.customer_id = C.costumer_id
group by C.city
order by 2
limit 10

-- outros metodos de unir tabelas --
select 
S. *
, CA.CITY
from sales.S
inner join campaign CA 
on CA.customer_id = S.customer_id
where S.Order_Date like '2022-04%'





