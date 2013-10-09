-- CHECK WITH Nancy Kail; InteliSpend Finance (funding??) Group before changing
-- CHECK WITH pricingrequests@intelispend.com TO OBTAIN APPROVAL prior to adding a payment method.

SELECT aqm.*, cl.description as payment_method 
-- UPDATE AEIS_QUOTE_PAYMETHOD SET PAYMENT_METHOD = 20 
-- UPDATE aqm SET ACTIVE_FLAG = 'N'
FROM AEIS_QUOTE_PAYMETHOD aqm
INNER JOIN CMGT_LOOKUPS cl ON cl.locale = 'en_US' and cl.lookup_type = 'PaymentType' AND cl.lookup_code = aqm.PAYMENT_METHOD
WHERE quote_number IN 
(
71038402
)
-- and aqm.ACTIVE_FLAG = 'Y'


/*
	-- Add a payment type
	INSERT INTO AEIS_QUOTE_PAYMETHOD(QUOTE_NUMBER, PAYMENT_METHOD, ACTIVE_FLAG) 
	VALUES (71038402, 10, 'Y')
*/	
/*
	-- Suspend an existing payment type:
	SELECT * FROM AEIS_QUOTE_PAYMETHOD
	--UPDATE AEIS_QUOTE_PAYMETHOD set ACTIVE_FLAG = 'Y'
	WHERE 
	QUOTE_NUMBER = 71038402
	AND PAYMENT_METHOD = 10
	
*/
-- check the status of the quote; does it need to change when the payment method changes?
select cl.lookup_code as quoteStatusId, cl.description as quoteStatus, pe.*
--update pe set rfq_status_code = 10
from cmgt_proposal_extn pe
	inner join cmgt_oil o
	on pe.cart_key = o.cart_key
	and o.aeis_quote_number in (71038402)
	and o.cart_status_code = 40
	and o.active_flag = 'Y'
	INNER JOIN cmgt_lookups cl ON cl.lookup_type = 'RFQStatus' AND cl.locale = 'en_US' and cl.lookup_code = pe.RFQ_STATUS_CODE

/*
LOOKUP_CODE	DESCRIPTION
10	Credit Card
20	ACH Debit
30	Wire Transfer
40	Business Check
50	Dummy Val
60	Dummy Val - 2
70	Money Order
80	ACH Credit
90	Cashier's Cheque
100	Post-pay
110	Draw Down
*/
