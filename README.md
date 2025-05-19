# DataAnalytics-Assessment

**My approach to each question**


## For Assessment\_Q1:

**Query Breakdown**

* **CONCAT(...) AS name**: I use this to combine the first and last names into a full name. It makes the output easier to read and understand.

* **COUNT(DISTINCT ...)**: This helps me count how many unique savings accounts and plans each user has, ensuring I get distinct values rather than duplicates.

* **SUM(...)**: I use this to add up all savings and plan contributions to compute the total deposits for each user.

* **Filters**: I make sure to filter out users who don’t have both savings and plan contributions greater than zero. This helps in focusing on active users with meaningful data.

* **GROUP BY**: I group the results by user so that the aggregate functions (like `SUM` and `COUNT`) are applied per user, ensuring accurate totals.

* **ORDER BY**: To get the most valuable users at the top, I order the results by total deposits in descending order.

---

## For Assessment\_Q2:

**Step 1: Monthly transaction count per user**

* **Purpose**: For each user (identified by `owner_id`) and each month (identified by `txn_month`), I count how many transactions they made.

* **DATE\_FORMAT(transaction\_date, '%Y-%m')**: This extracts the year and month from the transaction date. I use this to group transactions by month.

* **COUNT(\*)**: I use this to count how many transactions each user made during that month.

* **Result**: I get a table that shows the number of transactions each user made per month.

**Step 2: Average transactions per user across months**

* **Purpose**: For each user, I calculate the average number of transactions they made per month across all months.

* **AVG(txns\_in\_month)**: This function gives me the average of the monthly transaction counts, helping me understand user behavior over time.

**Step 3: Categorize users by frequency**

* **Purpose**: I categorize users based on their average monthly transactions, giving me insight into how often users engage.

* **Categories**:

  * **High Frequency**: 10 or more transactions per month
  * **Medium Frequency**: 3 to 9 transactions per month
  * **Low Frequency**: Less than 3 transactions per month

**Step 4: Final aggregation**

* **COUNT(\*)**: This counts how many users fall into each frequency category.

* **AVG(avg\_txns\_per\_month)**: I calculate the average number of transactions within each category.

* **ROUND(..., 1)**: To make the result cleaner, I round the average transactions to one decimal place.

* **ORDER BY FIELD(...)**: I order the categories logically (High → Medium → Low) instead of alphabetically, ensuring that the more engaged users are at the top.

---

## For Assessment\_Q3:

This query helps me identify inactive accounts from two different sources—Savings accounts and Investment plans—where the last transaction or charge occurred over a year ago (i.e., more than 365 days).

I combine both sources into one unified result using `UNION ALL`, and I sort the result by the length of time since each account became inactive.

 **Query Breakdown**:

* **Filters**: I only include records where a transaction has occurred (`transaction_date IS NOT NULL`) and where the transaction happened over 365 days ago.

* **Savings Accounts**:

  * I select the `savings_id`, `owner_id`, and `transaction_date`.
  * I calculate the inactivity days using `DATEDIFF(CURDATE(), transaction_date)`.

* **Investment Plans**:

  * I apply similar logic as in the savings query.
  * The only difference is that the field names change slightly (e.g., `id` becomes `plan_id`).

* **`UNION ALL`**: I use `UNION ALL` to combine both result sets without eliminating duplicates. This is important because I’m working with data from two different sources (savings vs. investments).

* **Sorting**: Finally, I sort the result so the most inactive accounts (those with the longest inactivity period) come first.

---

## For Assessment\_Q4:

**Step 1**

* **`TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months`**: I calculate how long the user has been on the platform by finding the difference between their join date and the current date. The result is in months, which helps me understand the user’s tenure.

* **`COUNT(s.confirmed_amount) AS total_transactions`**: I count how many transactions the user has made, using the `confirmed_amount` in the `savings_savingsaccount` table. This gives me the total number of non-null transactions for each user.

* **`(COUNT(s.confirmed_amount) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * (0.001 * AVG(s.confirmed_amount)) AS estimated_clv`**: To estimate the customer lifetime value (CLV), I:

  * Calculate the average number of transactions per month.
  * Scale this to transactions per year.
  * Multiply by the average value of transactions (scaled by 0.001, which might represent the dollar value of a transaction).

  This formula gives me an estimated annual value for each user, adjusting for both transaction volume and value.

**Step 2: Join Tables**

* **`FROM users_customuser u`**: I pull data from the `users_customuser` table, which contains user information like join date and ID.

* **`JOIN savings_savingsaccount s ON u.id = s.owner_id`**: I join the `users_customuser` table with the `savings_savingsaccount` table, which contains the savings account transaction data. This join brings all transactions tied to each user.

**Step 3: Grouping Data by User**

* **`GROUP BY`**: I group the data by user (`u.id`) so that calculations like transaction count and average transaction value are done for each user individually.

**Step 4: Ordering Results by Estimated CLV**

* **`ORDER BY estimated_clv DESC`**: After calculating the estimated CLV for each user, I order the results in descending order. This way, users with the highest lifetime value appear at the top of the list.


## The Challenges and Resolutions for SQL Queries

1. **Date Handling**: For me, one of the most common issues I’ve faced is making sure date columns are formatted properly. I make sure to use `DATEDIFF()` and `DATE_FORMAT()` correctly, and if dates are stored as text, I always convert them with `STR_TO_DATE()` to avoid future headaches.

2. **Performance**: When I’m working with large datasets, especially with `UNION ALL`, I’ve noticed that performance can slow down. To fix this, I typically create indexes on columns like `transaction_date` and `owner_id` to speed things up. If needed, I break the query into smaller pieces or use temporary tables to improve performance.

3. **NULL Handling**: I always pay extra attention to NULL values in date columns, as they can cause issues with inactivity days calculations. I use `COALESCE()` or similar functions to handle NULLs and ensure that my calculations are accurate and error-free.

4. **Frequency Categorization**: I’ve found that frequency categorization sometimes needs adjustments to handle edge cases correctly. I make sure to double-check the logic to ensure users are categorized as "High," "Medium," or "Low" in the most accurate way.

5. **Query Optimization**: Whenever I’m facing performance issues, I rely on `EXPLAIN` to analyze how the query is being executed. It helps me pinpoint areas that need optimization. I also try to simplify the query, removing unnecessary `UNION` operations that might be slowing things down.

6. **Readability**: I always prioritize making my queries easy to read and maintain. Breaking up complex queries into smaller, manageable parts and adding comments makes a huge difference for both myself and anyone else who might need to work with the code later.

By following these strategies, I’ve been able to improve both the accuracy and performance of my queries, making my work smoother and more efficient.



