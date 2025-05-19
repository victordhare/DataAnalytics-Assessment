
SELECT 
    u.id AS owner_id,                      
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.savings_id) AS savings_count,
    COUNT(DISTINCT p.id) AS plan_count,
    SUM(s.amount) + SUM(p.amount) AS total_deposits
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
JOIN plans_plan p ON u.id = p.owner_id
WHERE 
    s.amount > 0 
    AND p.amount > 0
GROUP BY u.id, u.first_name, u.last_name
order by total_deposits DESC;

-- For each user who has positive savings and plan amounts:

-- Gets user ID and full name.

-- Counts distinct savings accounts and plans they have.

-- Sums their total deposits (savings + plan amounts).

-- Orders the result by total deposits in descending order (highest first).

-- Grouping: Ensures aggregation is done per user.

select *
from users_customuser;

select *
from plans_plan;

select *
from savings_savingsaccount;



