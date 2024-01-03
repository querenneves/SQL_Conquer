select 
--  agrupando informações com case when (funciona nas consultas que utilizam colunas originais) --
case when upper(product_name) like '%GRAY%' 
then 'SIM' 
else 'NÃO' 
end validador
,count (distinct category) qtde_Categorias
from product
group by

-- treino de case --
select 
case 
when upper(category) = 'OFFICE SUPPLIES' then category
when upper(category) = 'FURNITURE' then category
else 'Other'
end tipo_categoria
,sum (case when upper(product_name) like '%GRAY%' then 1 else 0 and) valida_cinza
from product
group by
case 
when upper(category) = 'OFFICE SUPPLIES' then category
when upper(category) = 'FURNITURE' then category
else 'Other'
end

-- having e where (funcoes de agregacao / filtro com group by) --
select
C.sales
, count (distinct S.Order_ID) QTDE
from sales S
left join costumer C
	on S.customer_id = C.customer_id
group by C.State
-- where: quando quiser filtrar primeiro e agrupar depois -- 
-- having: quando quiser agrupar primeiro e filtrar depois -- 
having QTDE between 30 and 100


-- Otimizando consultas ( filtragens ) --
-- criando temporary table --
create temporary table p as 
	select * 
	  from product
	  where category = 'technology'
  ;
  create temporary table C as 
	  select * 
		  from customer
		  where state = 'California'
   ;       
   -- temporary table --
   
   select
c.city
, count (distinct s.Order_ID) QTDE
from sales S
-- filtragem com subquery --
inner join P

-- subquery subtituido por temporary table --
   ( select * 
  from product
  where category = 'technology'
) P 
-- subquery subtituido por temporary table --

on S.Product_ID = P.product_id
inner join C on c.customer_id = s.Customer_ID

-- subquery subtituido por temporary table --
  ( select * 
  from customer
  where state = 'California'
) c 
-- subquery subtituido por temporary table --

on c.customer_id = s.Customer_ID

select  
c.city
, count (distinct s.Order_ID) QTDE
from sales S
inner join P
	on S.Product_ID = P.product_id
inner join C on c.customer_id = s.Customer_ID
group by 
c.city
-- desc para ficar do maior para o menor --
order by 2 desc 
limit 3

-- case de treinamento (Não presisamos de uma subquery, a diferença é colocar categorias e produtos do problema acima anterior)--
-- dez produtos mais vendidos -- 
select  
P.category
, P.product_name
, count (distinct s.Order_ID) QTDE
from sales S
inner join P
	on S.Product_ID = P.product_id
inner join c
-- subquery subtituido por temporary table --
    on c.customer_id = s.Custumer_ID
group by 
P.category
, P.product_name
order by 2 desc
-- testar tempo de execução com um limit para escolher entre subquery e temporary table --
limit 10

-- analisando dados (date & substr) --

select distinct
-- extrai um pedaço do meu texto, primeira informação é o nome da coluna e a segunda é o caracter da informação contando traços --
 SUBSTR(order_date, 1,7) recorte_data
from sales  
-- diferença é que ao invés de começar pelo nome da coluna, começa pelo formato --
-- pode usar tanto para data quanto para hora, sendo que o 'm' e o 'd' em especfico precisa ser minusculo --
 select 
count (distinct order_id) QTDE_VENDAS
from sales  
-- começando de dentro para fora --
where 
	order_date between STRFTIME('%Y-%m-%d',date(current_date, 'start of month', '-1 month'))
    and STRFTIME('%Y-%m-%d',date(current_date, 'start of month', '-1 day'))
-- busca informação do periodo / busca primeiro dia do mês / para voltar um mês -- 
	date(current_date, 'start of month', '-1 month', )
    
    -- use variáveis --
    
    -- caso para treino --
select 
STRFTIME('%Y-%m-%d',order_date) ANO_MES
,count (distinct order_id) QTDE_VENDAS
from sales  
-- como é uma função de agregação usamos o group by --
group by STRFTIME('%Y-%m',order_date)
-- extrair do mais rescente ao mais antigo --
order by ANO_MES desc
