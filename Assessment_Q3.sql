-- SELECT 
--     pp.id AS plan_id,
--     pp.owner_id,
--     MAX(sa.transaction_date) AS last_transaction_date,
--     DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
-- FROM 
--     plans_plan pp
-- JOIN 
--     savings_savingsaccount sa ON pp.id = sa.plan_id
-- WHERE 
--     sa.transaction_date IS NULL
--     OR sa.transaction_date <= CURDATE() - INTERVAL 365 DAY
-- GROUP BY 
--     pp.id, pp.owner_id;

SELECT 
    savings_id AS plan_id,
    owner_id,
    'Savings' AS type,
    transaction_date AS last_transaction_date,
    DATEDIFF(CURDATE(), transaction_date) AS inactivity_days
FROM 
    savings_savingsaccount
WHERE 
    transaction_date IS NOT NULL
    AND DATEDIFF(CURDATE(), transaction_date) > 365

UNION ALL

SELECT 
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    last_charge_date AS last_transaction_date,
    DATEDIFF(CURDATE(), last_charge_date) AS inactivity_days
FROM 
    plans_plan
WHERE 
    last_charge_date IS NOT NULL
    AND DATEDIFF(CURDATE(), last_charge_date) > 365
ORDER BY 
    inactivity_days DESC;



-- ..............
-- Summary of the Query:

-- Joins the plans_plan table with the savings_savingsaccount table by plan_id.

-- Filters for accounts where transaction_date is either:

-- NULL (no transaction ever), or

-- Older than 365 days from today.

-- Groups results by each plan (plan_id and owner_id) to avoid duplicates.

-- For each plan, selects the most recent transaction_date using MAX().

-- Calculates the number of days since the last transaction (inactivity_days).

select *
from plans_plan;

select *
from savings_savingsaccount;