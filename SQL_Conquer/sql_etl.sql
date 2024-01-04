-- processo de etl (extrair, transformar e carregar) -- 
CREATE TEMPORARY TABLE ANALISE AS 
-- extraindo dados --
SELECT 
P.*
, H.motivo_emp
,H.valor_emp
,H.tx_emp
,H.emp_ativo
from pessoas P 
LEFT JOIN historico_emp H 
ON P.ID = H.ID

-- verificando informações --
SELECT * from ANALISE

-- não realizar alterações diretamente da minha fonte, realizar uma copia, como uma tabela temporaria para fazer transformações que precisam  -- 


-- validando informações --
-- menor_idade e menor_trab_at OK, maior_idade e maior_trab_at tem informações não coerentes --
SELECT 

MIN(idade) AS MENOR_IDADE
, MIN(anos_trabalho_atual) AS MENOR_TRAB_AT
, MAX(idade) AS MAIOR_IDADE
, MAX(anos_trabalho_atual) AS MAIOR_TRAB_AT

FROM ANALISE
-- validando dados --
SELECT * 
FROM ANALISE 

-- buscando clientes ao qual não tenho informações --
WHERE analise.motivo_emp 
is NULL and analise.valor_emp 
is NULL and tx_emp 
is NULL and emp_ativo is NULL

-- contagem de quantidade --
SELECT COUNT(*)
FROM ANALISE
-- 238 clientes sem informações de buscas de emprestimos --
WHERE analise.motivo_emp IS NULL
AND analise.valor_emp IS NULL
AND tx_emp IS NULL
AND emp_ativo IS NULL

-- 25805 cliente sem dados de contato -- 
SELECT COUNT (*) 
FROM ANALISE
WHERE dados_contato = 0 

-- 5520 em potencial com contatos atualizados -- 
SELECT COUNT (*) 
FROM ANALISE
WHERE dados_contato = 1 
and idade BETWEEN 18 and 60

SELECT COUNT(*)
FROM ANALISE
WHERE
-- pessoas com 40% ou menos e que não possui emprestimos ativos (24018) --
(
 valor_emp / renda_ano <= 0.4
 ) and emp_ativo = 0
 or 
 -- pessoas com 20% ou menos e que possui emprestimos ativos ou incertos (6986) --
 (
    valor_emp / renda_ano <= 0.2
 ) and emp_ativo = 1 or emp_ativo is NULL
 
 -- totais de 31004 clientes --
 
 
 -- transformando dados e padronizando baseando-se na análise --
 
 UPDATE ANALISE
-- inserindo a média de idade nos clientes que estão com valor nulo --
SET idade = (SELECT AVG(idade) FROM ANALISE WHERE idade BETWEEN 18 AND 60)
WHERE idade IS NULL;
--------------------------------------------------------------------------------
UPDATE ANALISE
-- inserindo a média de anos de trabalho nos clientes que estão com valor nulo --
SET anos_trabalho_atual = (SELECT AVG(anos_trabalho_atual) 
                           FROM ANALISE 
						   WHERE anos_trabalho_atual >= 30
)
WHERE anos_trabalho_atual is NULL

-- deletando clientes com idade acima de 99 anos e trabalho mais de 40 anos --

DELETE FROM ANALISE
where anos_trabalho_atual > 40
OR idade > 99
-- fazer select antes de fazer se update ou delete --
-- informações padronizadas e limpas -- 

-- retirando duplicações --
-- Clientes ideais para campanha --
SELECT *,
CASE WHEN dados_contato = 1 AND anos_hist_credito >= 2
     THEN 1
     ELSE 0
END AS cliente_ideal
FROM ANALISE;

-- carregando --
SELECT *,
    CASE WHEN dados_contato = 1 AND anos_hist_credito >= 2
         THEN 1
         ELSE 0
    END AS cliente_ideal,
    CASE WHEN (valor_emp / renda_ano <= 0.4 AND emp_ativo = 0)
              OR ((valor_emp / renda_ano <= 0.2) AND (emp_ativo = 1 OR emp_ativo IS NULL))
         THEN 1
         ELSE 0
    END AS IMPACTO_FIN_OK,
    CASE WHEN idade BETWEEN 18 AND 60 AND anos_trabalho_atual >= 3
         THEN 1
         ELSE 0
    END AS IDADE_TEMPO_SERVICO
FROM ANALISE;

-- ----------------- --
SELECT ID, COUNT(*) AS QDTE,
    CASE WHEN dados_contato = 1 AND anos_hist_credito >= 2
         THEN 1
         ELSE 0
    END AS cliente_ideal,
    CASE WHEN (valor_emp / renda_ano <= 0.4 AND emp_ativo = 0)
              OR ((valor_emp / renda_ano <= 0.2) AND (emp_ativo = 1 OR emp_ativo IS NULL))
         THEN 1
         ELSE 0
    END AS IMPACTO_FIN_OK,
    CASE WHEN idade BETWEEN 18 AND 60 AND anos_trabalho_atual >= 3
         THEN 1
         ELSE 0
    END AS IDADE_TEMPO_SERVICO
FROM ANALISE
WHERE cliente_ideal = 1 
    AND IMPACTO_FIN_OK = 1 
    AND IDADE_TEMPO_SERVICO = 1
GROUP BY ID
ORDER BY QDTE DESC;
-----------------------------------------

-- criando tabela da analise final --
CREATE TABLE ANALISE_FINAL AS
SELECT *,
    CASE WHEN dados_contato = 1 AND anos_hist_credito >= 2
         THEN 1
         ELSE 0
    END AS cliente_ideal,
    CASE WHEN (valor_emp / renda_ano <= 0.4 AND emp_ativo = 0)
              OR ((valor_emp / renda_ano <= 0.2) AND (emp_ativo = 1 OR emp_ativo IS NULL))
         THEN 1
         ELSE 0
    END AS IMPACTO_FIN_OK,
    CASE WHEN idade BETWEEN 18 AND 60 AND anos_trabalho_atual >= 3
         THEN 1
         ELSE 0
    END AS IDADE_TEMPO_SERVICO
FROM ANALISE;

