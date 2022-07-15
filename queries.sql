--Some fraudsters hack a credit card by making several small transactions (generally less than $2.00), which are typically ignored by cardholders.

--How can you isolate (or group) the transactions of each cardholder?

--Count the transactions that are less than $2.00 per cardholder.
--Create a view for each of your queries.

CREATE VIEW vw_fradulent_transactions AS
select CC.cardholder_id, count(*) as num_small_transactions
from public.transaction T
join public.credit_card CC on T.card=CC.card
where T.amount::numeric < 2.00
group by CC.cardholder_id
order by 2 desc

select * from vw_fradulent_transactions
----Q-) Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
-- There are potentially some cardholders that have 20-26 transactions with less than $2.00. These are possible candidates for fraud. In reality, there are uses cases like buying coffee and small expenses that are explained by the small amount
--Take your investigation a step futher by considering the time period in which potentially fraudulent transactions are made.

-- What are the top 100 highest transactions made between 7:00 a.m. and 9:00 a.m.?

--Do you see any anomalous transactions that could be fraudulent?

--Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
CREATE VIEW vw_highesttransaction_7to9 AS
select T.amount
from public.transaction T
where DATE_PART('hour',T.date) between 7 and 8
order by 1 desc
limit 100;

select * from vw_highesttransaction_7to9

CREATE VIEW vw_highesttransaction_not7to9 AS
select T.amount
from public.transaction T
where DATE_PART('hour',T.date) not between 7 and 8
order by 1 desc
limit 100;

select * from vw_highesttransaction_not7to9

-- We can definitely see larger amounts with greater frequency at other times in the day indicating that larger transactions are less likely in the early morning. Based on this we can assume that fraud is not necessarily more common in the morning.

--If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.

--What are the top 5 merchants prone to being hacked using small transactions?
-- Merchants that have typically small transaction sizes are more vulnerable to fraud:
CREATE VIEW vw_merchantswithfraud AS
select M.id, max(M.name) as merchant_name, count(*) as num_small_transactions
from public.transaction T
join public.merchant M on T.id_merchant=M.id
where T.amount::numeric < 2.00
group by M.id
order by 3 desc
limit 5;
select * from vw_merchantswithfraud
"merchant_name"
"Wood-Ramirez"
"Hood-Phillips"
"Baker Inc"
"Clark and Sons"
"Greene-Wood"



select T.amount
from public.transaction T
where DATE_PART('hour',T.date) between 7 and 8
order by 1 desc
limit 100
-- The top 8 transactions are over 10x the amount (ranging from $748 - $1894) that are occuring as the others in the same time frame. This could be an indication of fraud as the size of the transactions is higher than the norm and they contain no decimals, which is unsusual for transactions

--What difference do you observe between the consumption patterns? Does the difference suggest a fraudulent transaction? Explain your rationale.
--Higher than normal patterns indicate a higher chance of fraud since the fraudster may be seeking to extract maximum value from their victims before they are caught and the cards are deactivated.