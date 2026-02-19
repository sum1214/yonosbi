class Transaction {
  final String category;
  final String description;
  final String fullDescription;
  final String date;
  final String amount;
  final bool isDebit;
  final String balance;

  Transaction({
    required this.category,
    required this.description,
    required this.fullDescription,
    required this.date,
    required this.amount,
    required this.isDebit,
    required this.balance,
  });
}

final List<Transaction> mockTransactions = [
  // FEBRUARY 2026 (25 Entries)
  Transaction(
    category: 'UPI',
    description: 'UPI- TRANSFER TO 4897694...',
    fullDescription: 'UPI- TRANSFER TO 4897694162092 UPI/DR/533960648744/OPTICAL / HDFC/opticalcen/Payme',
    date: '13/02/2026',
    amount: '₹5,000.00',
    isDebit: true,
    balance: 'Balance: ₹434.44'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/REF: 604112345678/TRANSFER TO SAVINGS',
    date: '12/02/2026',
    amount: '₹2,500.00',
    isDebit: true,
    balance: 'Balance: ₹5,434.44'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- TRANSFER TO 4897694...',
    fullDescription: 'UPI- TRANSFER TO 4897694162092 UPI/DR/533960648744/GROCERY / HDFC/supermart/Payme',
    date: '12/02/2026',
    amount: '₹1,100.00',
    isDebit: true,
    balance: 'Balance: ₹7,934.44'
  ),
  Transaction(
    category: 'IMPS',
    description: 'IMPS- TRANSFER FROM 4698...',
    fullDescription: 'IMPS- TRANSFER FROM 469812345678/IMPS/CR/REF: 604198765432/FROM FAMILY FUND',
    date: '11/02/2026',
    amount: '₹850.00',
    isDebit: false,
    balance: 'Balance: ₹9,034.44'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- TRANSFER TO 4897694...',
    fullDescription: 'UPI- TRANSFER TO 4897694162092 UPI/DR/533960648744/CAFE / HDFC/starbucks/Payme',
    date: '11/02/2026',
    amount: '₹838.00',
    isDebit: true,
    balance: 'Balance: ₹8,184.44'
  ),
  // ... Adding more with generic full descriptions for the rest
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/MOBILE BANKING/UTILITY PAYMENT',
    date: '10/02/2026',
    amount: '₹1,200.00',
    isDebit: true,
    balance: 'Balance: ₹9,022.44'
  ),
  Transaction(
    category: 'NEFT',
    description: 'NEFT- TRANSFER FROM 9950...',
    fullDescription: 'NEFT- TRANSFER FROM 995012345678/NEFT/CR/REF: 604155443322/TAX REFUND',
    date: '10/02/2026',
    amount: '₹122.33',
    isDebit: false,
    balance: 'Balance: ₹10,222.44'
  ),
  Transaction(
    category: 'Cash',
    description: 'CASH- ATM CASH 604019939...',
    fullDescription: 'CASH- ATM CASH 604019939 ATM WITHDRAWAL/DR/LOC: SECTOR 62 NOIDA',
    date: '09/02/2026',
    amount: '₹10,000.00',
    isDebit: true,
    balance: 'Balance: ₹10,099.11'
  ),
  Transaction(
    category: 'Cash',
    description: 'CASH- ATM CASH 604019939...',
    fullDescription: 'CASH- ATM CASH 604019939 ATM WITHDRAWAL/DR/LOC: MG ROAD GURUGRAM',
    date: '09/02/2026',
    amount: '₹10,000.00',
    isDebit: true,
    balance: 'Balance: ₹20,099.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- PAY TO ZOMATO...',
    fullDescription: 'UPI- PAY TO ZOMATO UPI/DR/533960648744/FOOD ORDER / HDFC/zomato/Payme',
    date: '08/02/2026',
    amount: '₹450.00',
    isDebit: true,
    balance: 'Balance: ₹30,099.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/PERSONAL TRANSFER',
    date: '08/02/2026',
    amount: '₹500.00',
    isDebit: true,
    balance: 'Balance: ₹30,549.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- PAY TO SWIGGY...',
    fullDescription: 'UPI- PAY TO SWIGGY UPI/DR/533960648744/FOOD DELIVERY / HDFC/swiggy/Payme',
    date: '07/02/2026',
    amount: '₹320.00',
    isDebit: true,
    balance: 'Balance: ₹31,049.11'
  ),
  Transaction(
    category: 'IMPS',
    description: 'IMPS- TRANSFER FROM 1234...',
    fullDescription: 'IMPS- TRANSFER FROM 123456789012/IMPS/CR/REF: 604177889900/GIFT',
    date: '07/02/2026',
    amount: '₹2,000.00',
    isDebit: false,
    balance: 'Balance: ₹31,369.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- TRANSFER TO FRIEND...',
    fullDescription: 'UPI- TRANSFER TO FRIEND UPI/DR/533960648744/RENT SHARE / HDFC/friend/Payme',
    date: '06/02/2026',
    amount: '₹1,000.00',
    isDebit: true,
    balance: 'Balance: ₹29,369.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/UPI/RECHARGE',
    date: '06/02/2026',
    amount: '₹3,000.00',
    isDebit: true,
    balance: 'Balance: ₹30,369.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- RELIANCE SMART...',
    fullDescription: 'UPI- RELIANCE SMART UPI/DR/533960648744/GROCERIES / HDFC/reliance/Payme',
    date: '05/02/2026',
    amount: '₹1,250.00',
    isDebit: true,
    balance: 'Balance: ₹33,369.11'
  ),
  Transaction(
    category: 'NEFT',
    description: 'NEFT- SALARY CREDIT...',
    fullDescription: 'NEFT- SALARY CREDIT NEFT/CR/REF: 604100998877/MONTHLY SALARY',
    date: '01/02/2026',
    amount: '₹45,000.00',
    isDebit: false,
    balance: 'Balance: ₹34,619.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- PETROL PUMP...',
    fullDescription: 'UPI- PETROL PUMP UPI/DR/533960648744/FUEL / HDFC/petrol/Payme',
    date: '04/02/2026',
    amount: '₹500.00',
    isDebit: true,
    balance: 'Balance: ₹79,619.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/LOAN PAYMENT',
    date: '04/02/2026',
    amount: '₹150.00',
    isDebit: true,
    balance: 'Balance: ₹80,119.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- BROADBAND BILL...',
    fullDescription: 'UPI- BROADBAND BILL UPI/DR/533960648744/INTERNET / HDFC/airtel/Payme',
    date: '03/02/2026',
    amount: '₹799.00',
    isDebit: true,
    balance: 'Balance: ₹80,269.11'
  ),
  Transaction(
    category: 'Cash',
    description: 'CASH- DEPOSIT AT BRANCH...',
    fullDescription: 'CASH- DEPOSIT AT BRANCH CASH DEPOSIT/CR/LOC: NOIDA SECTOR 18',
    date: '03/02/2026',
    amount: '₹5,000.00',
    isDebit: false,
    balance: 'Balance: ₹81,068.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- MOBILE RECHARGE...',
    fullDescription: 'UPI- MOBILE RECHARGE UPI/DR/533960648744/MOBILE / HDFC/jio/Payme',
    date: '02/02/2026',
    amount: '₹299.00',
    isDebit: true,
    balance: 'Balance: ₹76,068.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/TRANSFER',
    date: '02/02/2026',
    amount: '₹1,000.00',
    isDebit: true,
    balance: 'Balance: ₹76,367.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- ELECTRICITY BILL...',
    fullDescription: 'UPI- ELECTRICITY BILL UPI/DR/533960648744/UTILITY / HDFC/uppcl/Payme',
    date: '01/02/2026',
    amount: '₹2,100.00',
    isDebit: true,
    balance: 'Balance: ₹77,367.11'
  ),
  Transaction(
    category: 'IMPS',
    description: 'IMPS- TRANSFER TO FAMILY...',
    fullDescription: 'IMPS- TRANSFER TO FAMILY IMPS/DR/REF: 604122334455/HOME MAINTENANCE',
    date: '01/02/2026',
    amount: '₹5,000.00',
    isDebit: true,
    balance: 'Balance: ₹79,467.11'
  ),

  // JANUARY 2026 (5 Entries)
  Transaction(
    category: 'UPI',
    description: 'UPI- AMAZON SHOPPING...',
    fullDescription: 'UPI- AMAZON SHOPPING UPI/DR/533960648744/ONLINE SHOPPING / HDFC/amazon/Payme',
    date: '30/01/2026',
    amount: '₹1,500.00',
    isDebit: true,
    balance: 'Balance: ₹84,467.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/TRANSFER',
    date: '25/01/2026',
    amount: '₹2,000.00',
    isDebit: true,
    balance: 'Balance: ₹85,967.11'
  ),
  Transaction(
    category: 'NEFT',
    description: 'NEFT- UTILITY REFUND...',
    fullDescription: 'NEFT- UTILITY REFUND NEFT/CR/REF: 604166778899/OVERPAYMENT REFUND',
    date: '20/01/2026',
    amount: '₹350.00',
    isDebit: false,
    balance: 'Balance: ₹87,967.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- MOVIE TICKETS...',
    fullDescription: 'UPI- MOVIE TICKETS UPI/DR/533960648744/ENTERTAINMENT / HDFC/pvr/Payme',
    date: '15/01/2026',
    amount: '₹600.00',
    isDebit: true,
    balance: 'Balance: ₹87,617.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/SAVINGS',
    date: '10/01/2026',
    amount: '₹1,000.00',
    isDebit: true,
    balance: 'Balance: ₹88,217.11'
  ),

  // DECEMBER 2025 (5 Entries)
  Transaction(
    category: 'UPI',
    description: 'UPI- NEW YEAR PARTY...',
    fullDescription: 'UPI- NEW YEAR PARTY UPI/DR/533960648744/CELEBRATION / HDFC/party/Payme',
    date: '31/12/2025',
    amount: '₹2,500.00',
    isDebit: true,
    balance: 'Balance: ₹89,217.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/HOLIDAY FUND',
    date: '25/12/2025',
    amount: '₹5,000.00',
    isDebit: true,
    balance: 'Balance: ₹91,717.11'
  ),
  Transaction(
    category: 'IMPS',
    description: 'IMPS- GIFT FROM UNCLE...',
    fullDescription: 'IMPS- GIFT FROM UNCLE IMPS/CR/REF: 604133445566/BIRTHDAY GIFT',
    date: '24/12/2025',
    amount: '₹10,000.00',
    isDebit: false,
    balance: 'Balance: ₹96,717.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- CHRISTMAS DINNER...',
    fullDescription: 'UPI- CHRISTMAS DINNER UPI/DR/533960648744/FOOD / HDFC/dinner/Payme',
    date: '25/12/2025',
    amount: '₹1,200.00',
    isDebit: true,
    balance: 'Balance: ₹86,717.11'
  ),
  Transaction(
    category: 'Cash',
    description: 'CASH- WITHDRAWAL...',
    fullDescription: 'CASH- ATM WITHDRAWAL ATM/DR/LOC: SHOPPING MALL',
    date: '15/12/2025',
    amount: '₹2,000.00',
    isDebit: true,
    balance: 'Balance: ₹87,917.11'
  ),

  // NOVEMBER 2025 (5 Entries)
  Transaction(
    category: 'NEFT',
    description: 'NEFT- MONTHLY RENT...',
    fullDescription: 'NEFT- MONTHLY RENT NEFT/DR/REF: 604144556677/HOUSE RENT',
    date: '01/11/2025',
    amount: '₹15,000.00',
    isDebit: true,
    balance: 'Balance: ₹89,917.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- GROCERY SHOPPING...',
    fullDescription: 'UPI- GROCERY SHOPPING UPI/DR/533960648744/MARKET / HDFC/grocery/Payme',
    date: '10/11/2025',
    amount: '₹2,300.00',
    isDebit: true,
    balance: 'Balance: ₹104,917.11'
  ),
  Transaction(
    category: 'Within SBI',
    description: 'TRANSFER TO 65078999075...',
    fullDescription: 'TRANSFER TO 65078999075 WITHIN SBI/DR/IMPS/EMI',
    date: '15/11/2025',
    amount: '₹3,000.00',
    isDebit: true,
    balance: 'Balance: ₹107,217.11'
  ),
  Transaction(
    category: 'UPI',
    description: 'UPI- INTERNET BILL...',
    fullDescription: 'UPI- INTERNET BILL UPI/DR/533960648744/WIFI / HDFC/isp/Payme',
    date: '20/11/2025',
    amount: '₹999.00',
    isDebit: true,
    balance: 'Balance: ₹110,217.11'
  ),
  Transaction(
    category: 'IMPS',
    description: 'IMPS- REFUND RECEIVED...',
    fullDescription: 'IMPS- REFUND RECEIVED IMPS/CR/REF: 604155667788/CANCELLATION REFUND',
    date: '25/11/2025',
    amount: '₹500.00',
    isDebit: false,
    balance: 'Balance: ₹111,216.11'
  ),
];
