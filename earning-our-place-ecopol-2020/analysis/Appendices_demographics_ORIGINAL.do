* SocialSci Survey demographics

tab race if race == 0
tab race if race == 1
tab race if race == 2
tab race if race == 4
tab race if race == 3 | race == 5 | race == 6

tab income if income <= 6
tab income if income > 6 & income < 11
tab income if income > 10 & income < 13
tab income if income > 12 & income < 15
tab income if income > 14 & income < 17
tab income if income > 16

tab education
* tab education if education < 3
* tab education if education > 2 & education < 5
* tab education if education == 5
* tab education if education == 6

tab gender

tab party if party < -1
tab party if party == -1
tab party if party == 0
tab party if party == 1
tab party if party > 1




* DEMOGRAPHICS

tab race if condition == 1
tab race if condition == float(2.1)
tab race if condition == 2
tab race if condition == float(2.2)
tab race if condition == float(3.1)
tab race if condition == 3
tab race if condition == float(3.2)
tab race if condition == 4
tab race if condition == 5
tab race if condition == 6

tab education if condition == 1
tab education if condition == float(2.1)
tab education if condition == 2
tab education if condition == float(2.2)
tab education if condition == float(3.1)
tab education if condition == 3
tab education if condition == float(3.2)
tab education if condition == 4
tab education if condition == 5
tab education if condition == 6

tab incomehousehold if condition == 1 & incomehousehold <= 6
tab incomehousehold if condition == float(2.1) & incomehousehold <= 6
tab incomehousehold if condition == 2 & incomehousehold <= 6
tab incomehousehold if condition == float(2.2) & incomehousehold <= 6
tab incomehousehold if condition == float(3.1) & incomehousehold <= 6
tab incomehousehold if condition == 3 & incomehousehold <= 6
tab incomehousehold if condition == float(3.2) & incomehousehold <= 6
tab incomehousehold if condition == 4 & incomehousehold <= 6
tab incomehousehold if condition == 5 & incomehousehold <= 6
tab incomehousehold if condition == 6 & incomehousehold <= 6

tab incomehousehold if condition == 1 & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == float(2.1) & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == 2 & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == float(2.2) & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == float(3.1) & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == 3 & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == float(3.2) & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == 4 & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == 5 & incomehousehold > 6 & incomehousehold < 11
tab incomehousehold if condition == 6 & incomehousehold > 6 & incomehousehold < 11

tab incomehousehold if condition == 1 & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == float(2.1) & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == 2 & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == float(2.2) & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == float(3.1) & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == 3 & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == float(3.2) & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == 4 & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == 5 & incomehousehold > 10 & incomehousehold < 13
tab incomehousehold if condition == 6 & incomehousehold > 10 & incomehousehold < 13

tab incomehousehold if condition == 1 & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == float(2.1) & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == 2 & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == float(2.2) & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == float(3.1) & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == 3 & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == float(3.2) & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == 4 & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == 5 & incomehousehold > 12 & incomehousehold < 15
tab incomehousehold if condition == 6 & incomehousehold > 12 & incomehousehold < 15

tab incomehousehold if condition == 1 & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == float(2.1) & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == 2 & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == float(2.2) & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == float(3.1) & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == 3 & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == float(3.2) & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == 4 & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == 5 & incomehousehold > 14 & incomehousehold < 17
tab incomehousehold if condition == 6 & incomehousehold > 14 & incomehousehold < 17

tab incomehousehold if condition == 1 & incomehousehold > 16
tab incomehousehold if condition == float(2.1) & incomehousehold > 16
tab incomehousehold if condition == 2 & incomehousehold > 16
tab incomehousehold if condition == float(2.2) & incomehousehold > 16
tab incomehousehold if condition == float(3.1) & incomehousehold > 16
tab incomehousehold if condition == 3 & incomehousehold > 16
tab incomehousehold if condition == float(3.2) & incomehousehold > 16
tab incomehousehold if condition == 4 & incomehousehold > 16
tab incomehousehold if condition == 5 & incomehousehold > 16
tab incomehousehold if condition == 6 & incomehousehold > 16

tab education if condition == 1 & education < 3
tab education if condition == float(2.1) & education < 3
tab education if condition == 2 & education < 3
tab education if condition == float(2.2) & education < 3
tab education if condition == float(3.1) & education < 3
tab education if condition == 3 & education < 3
tab education if condition == float(3.2) & education < 3
tab education if condition == 4 & education < 3
tab education if condition == 5 & education < 3
tab education if condition == 6 & education < 3

tab education if condition == 1 & education > 2 & education < 5
tab education if condition == float(2.1) & education > 2 & education < 5
tab education if condition == 2 & education > 2 & education < 5
tab education if condition == float(2.2) & education > 2 & education < 5
tab education if condition == float(3.1) & education > 2 & education < 5
tab education if condition == 3 & education > 2 & education < 5
tab education if condition == float(3.2) & education > 2 & education < 5
tab education if condition == 4 & education > 2 & education < 5
tab education if condition == 5 & education > 2 & education < 5
tab education if condition == 6 & education > 2 & education < 5

tab education if condition == 1 & education == 5
tab education if condition == float(2.1) & education == 5
tab education if condition == 2 & education == 5
tab education if condition == float(2.2) & education == 5
tab education if condition == float(3.1) & education == 5
tab education if condition == 3 & education == 5
tab education if condition == float(3.2) & education == 5
tab education if condition == 4 & education == 5
tab education if condition == 5 & education == 5
tab education if condition == 6 & education == 5

tab education if condition == 1 & education == 6
tab education if condition == float(2.1) & education == 6
tab education if condition == 2 & education == 6
tab education if condition == float(2.2) & education == 6
tab education if condition == float(3.1) & education == 6
tab education if condition == 3 & education == 6
tab education if condition == float(3.2) & education == 6
tab education if condition == 4 & education == 6
tab education if condition == 5 & education == 6
tab education if condition == 6 & education == 6

tab gender if condition == 1
tab gender if condition == float(2.1)
tab gender if condition == 2
tab gender if condition == float(2.2)
tab gender if condition == float(3.1)
tab gender if condition == 3
tab gender if condition == float(3.2)
tab gender if condition == 4
tab gender if condition == 5
tab gender if condition == 6

tab party if condition == float(2.2)
