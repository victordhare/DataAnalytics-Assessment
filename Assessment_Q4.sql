SELECT 
    u.id, 
    CONCAT(u.first_name, ' ', u.last_name) AS name, 
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.confirmed_amount) AS total_transactions,
    (COUNT(s.confirmed_amount) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * AVG(s.confirmed_amount)) AS estimated_clv
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
ORDER BY 
    estimated_clv DESC;
    
    
-- The query returns a list of customers with their customer_id, concatenated name, tenure_months, total_transactions, and estimated_clv, ordered by the highest estimated CLV.

-- Here's a short explanation of the query:

-- SELECT Clause:
-- u.id: Selects the customer ID.
-- CONCAT(u.first_name, ' ', u.last_name) AS name: Concatenates the first and last names into a single name column.
-- TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months: Calculates the number of months since the customer signed up.
-- COUNT(s.confirmed_amount) AS total_transactions: Counts the total number of transactions for each customer.
-- (COUNT(s.confirmed_amoun) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * AVG(s.confirmed_amoun)) AS estimated_clv: Calculates the estimated Customer Lifetime Value (CLV) using the formula:
-- (total transactions / tenure) * 12 * (0.1% of the average transaction amount).
-- FROM and JOIN:
-- Joins the users_customuser table (aliased as u) with the savings_savingsaccount table (aliased as s) based on the customer_id.
-- GROUP BY:
-- Groups the results by customer_id, first_name, last_name, and date_joined to aggregate the data for each customer.
-- ORDER BY:
-- Orders the results by the calculated estimated_clv in descending order, so the customers with the highest CLV appear first.







select *
from savings_savingsaccount;

select *
from users_customuser;
