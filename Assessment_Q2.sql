-- Step 1: Monthly transaction count per user
WITH monthly_txns AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS txn_month,
        COUNT(*) AS txns_in_month
    FROM savings_savingsaccount
    GROUP BY owner_id, txn_month
),

-- Step 2: Average transactions per user across months
avg_txns_per_user AS (
    SELECT 
        owner_id,
        AVG(txns_in_month) AS avg_txns_per_month
    FROM monthly_txns
    GROUP BY owner_id
),

-- Step 3: Categorize users by frequency
categorized_users AS (
    SELECT 
        owner_id,
        avg_txns_per_month,
        CASE 
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txns_per_user
)

-- Step 4: Final aggregation
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
    
    
    
    
    select *
from users_customuser;

select *
from plans_plan;

select *
from savings_savingsaccount;
    
    
    
    
    
