include "Support.dfy"
include "Product.dfy"
include "User.dfy"

module {:extern "BankSystem"} BankSystem
{
  import opened Support
  import opened Product
  import opened User

  class Bank {
    
    // class constants -- N/A
    
    // class variables -- not available in Dafny
    
    // class methods -- N/A
    
    // instance constants

    const capitalFundMinimumThreshold: nat := 500_000
    const referenceAgency: CreditReferenceAgency 
    
    // instance variables

    var capitalFundValue: nat
    var reservedFunds: nat 
    var loans: set<PersonalLoan>                       //    set<Loan>: loans (empty)
    var customers: set<Customer>                   //    set<Customer>: customers (empty)
    var customerLoans: map<nat, nat> 
    
    // constructor

    constructor(aValue: nat, aReferenceAgency: CreditReferenceAgency)
    ensures this.capitalFundValue == aValue
    ensures this.referenceAgency == aReferenceAgency
    {
      this.capitalFundValue := aValue;
      this.referenceAgency := aReferenceAgency;
    }
    
    // instance methods

    method newApplication(name: string, age: nat, accountNumber: string, sortCode: string, monthlyIncome: real, monthlyOutgoings: real,
                          requiredAmount: nat, repaymentPeriod: nat) returns ()
    requires requiredAmount in PersonalLoan.monthLoan24 || requiredAmount in PersonalLoan.monthLoan36 ||
             requiredAmount in PersonalLoan.monthLoan48 || requiredAmount in PersonalLoan.monthLoan60
    requires repaymentPeriod == 24 || repaymentPeriod == 36 || repaymentPeriod == 48 || repaymentPeriod == 60                    
    
    modifies this`customers
    modifies this`loans
    modifies this`customerLoans
    modifies this`capitalFundValue
    modifies this`reservedFunds
    {
      var interest: real := 0.0;
      if {
        case (5_000 <= requiredAmount <= 7_499) => interest := 13.6;
        case (7_500 <= requiredAmount <= 10_000) => interest := 6.3;
      }
      var loan: PersonalLoan? := new PersonalLoan(requiredAmount, repaymentPeriod, interest);
      var customer: Customer?, applicationStatus: bool := this.registerApplication(name, age, accountNumber, sortCode, monthlyIncome, 
                                                                                  monthlyOutgoings, loan);
      if (customer == null || loan == null) {return;}
      if (customer != null && loan != null) {
        applicationStatus := this.processApplication(customer, loan);
      }
      if {  
        case applicationStatus == false => loan.setStatus("rejected");
        case applicationStatus == true => loan.setStatus("approved");
      }
      assume !(loan.statusPending == loan.statusRejected == loan.statusApproved);
      this.completeApplication(customer, loan); 
    }

    method registerApplication(name: string, age: nat, accountNumber: string, sortCode: string, monthlyIncome: real, monthlyOutgoings: real, 
                               aLoan: PersonalLoan) returns (aCustomer: Customer, isLoanRegistered: bool)
    modifies this`customers
    modifies this`loans
    modifies this`customerLoans
    modifies aLoan`statusPending
    modifies aLoan`statusRejected
    modifies aLoan`statusApproved
    modifies this`capitalFundValue
    modifies this`reservedFunds
    {
      var customer: Customer? := this.registerCustomer(name, age, accountNumber, sortCode, monthlyIncome, monthlyOutgoings); 
      var loanRegistered: bool := this.registerLoan(aLoan);
      if (customer != null) {
        var customerRef: nat := customer.getCustomerReference();
        var loanRef: nat := aLoan.getLoanReference();
        this.associateCustomerLoan(loanRef, customerRef);
        var message: string := "Your application has been recieved and will be processed";
        this.informCustomer(customer, message);
      } 
      return customer, loanRegistered;
    }

    method registerCustomer(name: string, age: nat, accountNumber: string, sortCode: string, monthlyIncome: real, monthlyOutgoings: real) returns (newCustomer: Customer)
    modifies this`customers
    {
      var aCustomer: Customer? := new Customer(name, age, accountNumber, sortCode, monthlyIncome, monthlyOutgoings);
      if (aCustomer != null) {this.addCustomer(aCustomer);}
      return aCustomer;
    }
    
    method registerLoan(aLoan: PersonalLoan) returns (success: bool)
    modifies this`capitalFundValue
    modifies this`reservedFunds
    modifies this`loans
    modifies aLoan`statusPending
    modifies aLoan`statusRejected
    modifies aLoan`statusApproved
    {
      var verified: bool := false;
      var loanAmount: nat := aLoan.getRequiredAmount();
      verified := this.verifyCapitalAmount(this.capitalFundValue, this.capitalFundMinimumThreshold, loanAmount); // verify capital fund
        // insert logging message cpital amount
      if (verified) {verified := this.reserveLoanFunds(aLoan);} // capital amount has been verified so reserve loan funds
      // insert logging message reserved loan funds
      if (verified) {this.addLoan(aLoan);} // loan funds have been reserved so add loan to collection of loans
      if (!verified) {
        aLoan.setStatus("rejected"); // capital fund or reserve loan fund verification has failed
        // customer is informed in this.completeApplication()
      }
      return verified;
    }

    method associateCustomerLoan(loanReferenceNumber: nat, customerReferenceNumber: nat) returns ()
    modifies this`customerLoans
    ensures loanReferenceNumber in customerLoans
    ensures customerLoans[loanReferenceNumber] == customerReferenceNumber
    {
      this.customerLoans := map[loanReferenceNumber := customerReferenceNumber];
    }

    method processApplication(aCustomer: Customer, aLoan: PersonalLoan) returns (isSuccessful: bool)
    {
      var verified: bool := false;
      var customerAge: nat := aCustomer.getAge();
      verified := aLoan.verifyAgeCriteria(customerAge);
      if (!verified) {
        var message: string := "Your application has failed the loan age criteria process";
        this.informCustomer(aCustomer, message);
        return verified;
      }
      var customerMonthlyIncome: real := aCustomer.getMonthlyIncome();
      var customerMonthlyOutgoings : real := aCustomer.getMonthlyOutgoings();
      verified := aLoan.verifyIncomeCriteria(customerMonthlyIncome, customerMonthlyOutgoings);
      if (!verified) {
        var message: string := "Your application has failed the loan income criteria process";
        this.informCustomer(aCustomer, message);
        return verified;
      }
      var customerCreditScore: nat := this.obtainCustomerCreditScore(this.referenceAgency, aCustomer);
      verified := aLoan.verifyCreditScore(customerCreditScore);
      if (!verified) {
        var message: string := "Your application has failed the credit score criteria process";
        this.informCustomer(aCustomer, message);
        return verified;
      }
      return verified;
    }

    method addLoan(aLoan: PersonalLoan) returns ()
    modifies this`loans
    ensures aLoan in this.loans
    {
      this.loans := this.loans + {aLoan};      // union of the two sets
    }

    method addCustomer(aCustomer: Customer) returns ()
    modifies this`customers
    ensures aCustomer in this.customers
    {
      this.customers := this.customers + {aCustomer};
    }

    method informCustomer(aCustomer: Customer, message: string) returns ()
    {
      var customerName := aCustomer.getName();
      var customerMessage := "Customer Message: " + customerName + " :: " + message;
      print customerMessage, "\n"; 
    }

    method obtainCustomerCreditScore(referenceAgency: CreditReferenceAgency, aCustomer: Customer) returns (score: nat)
    {
      var customerName: string := aCustomer.getName();
      assume customerName in referenceAgency.creditScores;
      var aScore: nat := referenceAgency.getCreditScore(customerName); 
      return aScore;
    }

    method verifyCapitalAmount(fundValue: nat, fundMinimum: nat, loanAmount: nat) returns (isVerified: bool)
    ensures isVerified == ((fundValue - loanAmount) >= fundMinimum)
    ensures !isVerified == ((fundValue - loanAmount) < fundMinimum) 
    {
      return ((fundValue - loanAmount) >= fundMinimum);
    }

    method reserveLoanFunds(theLoan: PersonalLoan) returns (success: bool)
    modifies this`capitalFundValue
    modifies this`reservedFunds
    ensures (this.capitalFundValue + this.reservedFunds) == (old(capitalFundValue) + old(reservedFunds)) 
    {
      var loanAmount: nat := theLoan.getRequiredAmount();
      var startingCapitalfund: nat := this.capitalFundValue;
      var startingReserveFund: nat := this.reservedFunds;
      assume (this.capitalFundValue - loanAmount) > 0;  
      this.capitalFundValue := this.capitalFundValue - loanAmount;
      this.reservedFunds := this.reservedFunds + loanAmount;
      var finishingCapitalFund: nat := this.capitalFundValue;
      var finishingReservedFund: nat := this.reservedFunds;
      var both: bool := (finishingCapitalFund == (startingCapitalfund - loanAmount)) && 
                        (finishingReservedFund == (startingReserveFund + loanAmount));
      return both;
    }

    method completeApplication(theCustomer: Customer, theLoan: PersonalLoan) returns ()
    requires !(theLoan.statusPending == theLoan.statusRejected == theLoan.statusApproved)
    modifies this`capitalFundValue
    modifies this`reservedFunds
    {
      var loanStatus: string := theLoan.getStatus();
      if (loanStatus == "rejected") {
        var message: string := "We are sorry that your application cannot be processed at this time.";
        var fundsReleased: bool := this.releaseLoanFunds(theLoan);
        if (fundsReleased) {
          // add logging
          var message: string := "Loan funds released";
          this.logEvent(message);
        }
      }
      if (loanStatus == "approved") {
        var success: bool := transferLoanToCustomer(theLoan, theCustomer);
        var accNo: string, sortCode: string := theCustomer.getPaymentDetails();
        var message: string := "Your application has been successful. The required loan amount has been transferred to account number: " + 
                                accNo + " sort code: " + sortCode;
        this.informCustomer(theCustomer, message);
      }
    }

    method releaseLoanFunds(theLoan: PersonalLoan) returns (success: bool)
    modifies this`capitalFundValue
    modifies this`reservedFunds
    ensures (this.capitalFundValue + this.reservedFunds) == (old(capitalFundValue) + old(reservedFunds))
    {
      var loanAmount: nat := theLoan.getRequiredAmount();
      var startingCapitalfund: nat := this.capitalFundValue;
      var startingReserveFund: nat := this.reservedFunds;
      this.capitalFundValue := this.capitalFundValue + loanAmount;
      assume (this.reservedFunds - loanAmount) > 0;
      this.reservedFunds := this.reservedFunds - loanAmount;
      var finishingCapitalFund: nat := this.capitalFundValue;
      var finishingReservedFund: nat := this.reservedFunds;
      var both: bool := (finishingCapitalFund == (startingCapitalfund + loanAmount)) && 
                        (finishingReservedFund == (startingReserveFund - loanAmount));
      return both;
    }

    method transferLoanToCustomer(theLoan: PersonalLoan, theCustomer: Customer) returns (success: bool)
    modifies this`reservedFunds
    ensures ((this.reservedFunds + theLoan.requiredAmount) == old(reservedFunds))
    {
      var accNo: string, sortCode: string := theCustomer.getPaymentDetails();
      var message: string := "Transfer funds: account number:" + accNo + " sort code: " + sortCode;
      var loanAmount: nat := theLoan.getRequiredAmount();
      var startingReserveFund: nat := this.reservedFunds;
      assume (this.reservedFunds - loanAmount) > 0;
      this.reservedFunds := this.reservedFunds - loanAmount;
      var finishingReservedFund: nat := this.reservedFunds;
      var transferred: bool := (finishingReservedFund == (startingReserveFund - loanAmount));
      return transferred;
    }

    method logEvent(eventMessage: string) returns ()
    {
      var message: string := "System Log: Event :: " + eventMessage;
      print message, "\n"; 
    }
  }
}