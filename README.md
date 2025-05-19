# DataAnalytics-Assessment
My approach to each question


 for Assessment_Q1:
 
 Query Breakdown
 
CONCAT(...) AS name: Combines first and last names into a full name for readability.

COUNT(DISTINCT ...): Counts how many unique savings accounts and plans the user has.

SUM(...): Adds up all savings and plan contributions to compute total deposits.

Filters out any users who do not have both savings and plan contributions greater than zero.

Groups the results by user so that aggregates (like SUM and COUNT) apply per user.

Orders the results to show the users with the highest total deposits first.

  for assessment_Q2:
  
 Step 1: Monthly transaction count per user

Purpose: For each user (owner_id) and each month (txn_month), count how many transactions they made.

DATE_FORMAT(transaction_date, '%Y-%m'): Extracts the year and month part of the transaction date.

COUNT(*): Counts how many transactions the user made in that month.

Result: A table showing the number of transactions per user per month.

 Step 2: Average transactions per user across months

Purpose: For each user, calculate the average number of transactions per month over the time period covered.

AVG(txns_in_month): Takes the average of their monthly transaction counts.

 Step 3: Categorize users by frequency

Purpose: Assign each user a frequency category based on their average monthly transactions.

Categories:

High Frequency: 10 or more transactions per month

Medium Frequency: 3 to 9 transactions per month

Low Frequency: Less than 3 transactions per month

 Step 4: Final aggregation


COUNT(*): Number of users in each frequency category.

AVG(avg_txns_per_month): The average number of transactions (again) within that category.

ROUND(..., 1): Round to one decimal place.

ORDER BY FIELD(...): Ensures the categories are listed in logical order (High → Medium → Low), not alphabetically.

for Assessment_Q3

This SQL query identifies inactive accounts from two different sources — Savings accounts and Investment plans — where the last transaction or charge happened over a year ago (i.e. more than 365 days).

It combines both sources into one unified result set using UNION ALL and sorts by how long each account has been inactive.

🔍 Query Breakdown

Only include records where there was a transaction (transaction_date IS NOT NULL).

The transaction happened over 365 days ago.

savings_id: Unique ID of the savings plan.

owner_id: User who owns the account.

'Savings': A literal label to identify this row as a "Savings" type.

transaction_date: Last transaction date.

inactivity_days: Number of days since the last transaction, calculated using DATEDIFF(CURDATE(), transaction_date).

 Second SELECT block (Investment plans)

Only include plans with a valid last_charge_date.

Must be inactive for more than 365 days.

Returns similar columns to the first block for consistency:

id becomes plan_id

Other fields map the same way as in the savings query.

Combines the two result sets without eliminating duplicates (useful when working across different domains like savings vs. investments).

Sorts the final list so that the most inactive accounts (i.e. those with the longest inactivity period) come first.

For Assessment_Q4
Step One

TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months: Calculate how long the user has been on the platform by finding the difference between their join date (u.date_joined) and the current date (CURDATE()). The result is in months.

COUNT(s.confirmed_amount) AS total_transactions: Count the total number of transactions the user has made. This is done by counting the number of non-null confirmed_amount entries in the savings_savingsaccount table (s.confirmed_amount).

(COUNT(s.confirmed_amount) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * AVG(s.confirmed_amount)) AS estimated_clv: This calculates the estimated customer lifetime value (CLV):

COUNT(s.confirmed_amount) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) gives the average number of transactions per month.

Multiplying by 12 scales this number to transactions per year.

AVG(s.confirmed_amount) calculates the average value of transactions.

0.001 * AVG(s.confirmed_amount) seems to be a scaling factor to adjust the impact of transaction values on the CLV calculation. It likely represents the dollar value (or another currency unit) per transaction.

The final formula estimates how much each user is worth per year, adjusting for both the number of transactions and their average value.

Step 2: Join Tables

FROM users_customuser u: The data is pulled from the users_customuser table, which presumably holds user information like name, join date, etc.

JOIN savings_savingsaccount s ON u.id = s.owner_id: The query joins the users_customuser table with the savings_savingsaccount table. The savings_savingsaccount table holds data about the user's savings accounts, such as the amount and transaction details.

The join is done by matching u.id (user ID) with s.owner_id (the owner of the savings account).

This means that for every user, all their transactions in the savings account will be brought together.

Step 3: Grouping Data by User

GROUP BY: The query groups the data by the user (identified by u.id), so that calculations like transaction count and average transaction value are done for each individual user.

This is important because we need the total transactions and average transaction value for each user, not globally across all users.

Step 4: Ordering Results by Estimated CLV
ORDER BY estimated_clv DESC: After calculating the estimated customer lifetime value (CLV) for each user, the results are sorted in descending order. This means users with the highest CLV will be listed at the top of the result set.
