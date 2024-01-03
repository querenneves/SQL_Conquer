select * 
from product 
-- pesquisando por categorias --
where lower (category) = 'technology'
-- pesquisa em setenças limitantes --
and lower (sub_category) = '´phones'
and price < 300
-- pesquisa por categoria ou preço  (pesquisa em duas setenças)-- 
or price < 10 

select * 
from product 
-- pesquisa categorias ou que preço seja maior que 10 --
where lower category = 'technology'
and price > 10 or sub_category = 'Accessories'
-- estabelecendo ordem e limite nos comandos -- 
order by price 
limit 15