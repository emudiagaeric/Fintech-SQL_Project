
-- Emudiaga Rukevwe Ericson

-- Exploring the data
select * from transactions;
SELECT * FROM transactions WHERE amount > 10000;

SELECT DISTINCT
    merchant_category
FROM
    transactions;
    

-- Customers within a given period
SELECT 
    *
FROM
    customers
WHERE
    registration_date > '2022-01-01';


-- Extracting customers whose name contain 'ek'
SELECT 
    *
FROM
    accounts a
    left join customers c on a.customer_id = c.customer_id
WHERE
    first_name like ('%ek%');
 
 
 -- Evaluating customers tranactions and account types
SELECT 
    t.transaction_id,
    a.account_type,
    a.balance,
    t.amount as transaction_amount,
    t.transaction_type,
    t.merchant_category
FROM
    transactions t
        JOIN
    accounts a ON t.account_id = a.account_id
        
ORDER BY transaction_date DESC
LIMIT 20;

SELECT 
    c.first_name, c.last_name, c.monthly_income, a.balance
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.account_id
WHERE
    balance is null;
    
-- Extracting customers residing in Lagos and Abuja    
SELECT 
    *
FROM
    customers
WHERE
    state IN ('lagos' , 'abuja')
ORDER BY first_name;


-- Evaluating customers with highest account balances
SELECT 
    c.first_name, c.last_name, a.balance
FROM
    customers c
        JOIN
    accounts a ON a.customer_id = c.customer_id
ORDER BY a.balance DESC
LIMIT 5;

 
 -- Transactions with customer full name and merchant_category.
SELECT 
    t.amount AS transaction_amount,
    c.first_name,
    c.last_name,
    t.merchant_category
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
    join transactions t on t.account_id = a.account_id;
    
-- avergae transactions by merchant categpory
SELECT 
    merchant_category, AVG(amount)
FROM
    transactions
GROUP BY merchant_category;

--  customer full name with no Transactions .
SELECT 
    c.first_name, c.last_name, t.amount
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
        LEFT jOIN
    transactions t ON t.account_id = a.account_id is null;
    
    select * from accounts;
   select * from customers; 
-- . Accounts with multiple owners
SELECT 
    c.first_name,
    c.last_name,
    COUNT(c.customer_id) as accounts_owned
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
    group by c.first_name,
    c.last_name having accounts_owned >1;
    
    -- Find accounts where account_type is NULL but customer exists.
    SELECT 
    c.first_name, c.last_name, a.account_type
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
    where account_type is not null;
    select * from accounts;
    
    -- sum transaction amount per customer in each merchant category
SELECT 
    a.account_id, SUM(amount) AS total_transaction_amount,
    c.first_name,
    c.last_name,
    t.merchant_category
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
    join transactions t on t.account_id = a.account_id
GROUP BY account_id, c.first_name,
    c.last_name,
    t.merchant_category;
    
    -- sum transaction amount per customer
SELECT 
    a.account_id, SUM(amount) AS total_transaction_amount,
    c.first_name,
    c.last_name
   
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
    join transactions t on t.account_id = a.account_id
GROUP BY account_id, c.first_name,
    c.last_name
    ;
    
    -- Average balance per account_type
SELECT 
    account_type, AVG(balance) AS avg_bal
FROM
    accounts
GROUP BY account_type
ORDER BY avg_bal DESC;

-- Total deposits per customer
SELECT 
    t.transaction_type,
    c.first_name,
    c.last_name,
    SUM(t.amount) AS total_deposits
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
        JOIN
    transactions t ON t.account_id = a.account_id
WHERE
    t.transaction_type = 'deposit'
GROUP BY c.first_name , c.last_name 
;

-- Departments with >2 customers (adapted to accounts per customer).
SELECT 
    c.first_name,
    c.last_name,
    COUNT(c.customer_id) AS accounts_owned
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
GROUP BY c.first_name , c.last_name
HAVING accounts_owned > 2;

--  Count transactions per merchant.
SELECT 
    merchant_category, COUNT(transaction_id) AS trans_freq
FROM
    transactions
GROUP BY merchant_category;

-- Top 3 cities by total deposits
SELECT 
    c.state, SUM(t.amount) AS total_deposits, t.transaction_type
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
        JOIN
    transactions t ON t.account_id = a.account_id
WHERE
    transaction_type = 'deposit'
GROUP BY c.state
ORDER BY total_deposits DESC;

-- Find cities where the average account balance exceeds ₦200,000.
SELECT 
    c.state, AVG(a.balance) AS balance
FROM
    customers c
        JOIN
    accounts a ON c.customer_id = a.customer_id
GROUP BY c.state
HAVING balance > 200000
ORDER BY balance DESC;