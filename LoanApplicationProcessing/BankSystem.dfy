include "Support.dfy"
include "Product.dfy"
include "User.dfy"

module {:extern "BankSystem"} BankSystem
{
  import opened Support
  import opened Product
  import opened User

  export reveals *

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
    var loans: set<PersonalLoan>         
    var customers: set<Customer>         
    var customerLoans: map<nat, nat>
    var nextCustomerReference: nat
    var nextLoanReference: nat
    
    // constructor

    constructor(aValue: nat, aReferenceAgency: CreditReferenceAgency)
    ensures this.capitalFundValue == aValue
    ensures this.referenceAgency == aReferenceAgency
    {
      this.capitalFundValue := aValue;
      this.referenceAgency := aReferenceAgency;
      this.nextCustomerReference := 1_000_000;
      this.nextLoanReference := 1_000_000;
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
    modifies this`nextLoanReference
    modifies this`nextCustomerReference
    {
      logEvent("BEGINNING LOAN APPLICATION PROCESS");
      var interest: real := 0.0;
      if {
        case (5_000 <= requiredAmount <= 7_499) => interest := 13.6;
        case (7_500 <= requiredAmount <= 10_000) => interest := 6.3;
      }
      var ref: nat := getNextLoanReference();
      var loan: PersonalLoan? := new PersonalLoan(requiredAmount, repaymentPeriod, interest, ref);
      if (loan == null) {
        logEvent("ERROR: UNABLE TO CREATE LOAN");
        }
      var customer: Customer?, applicationStatus: bool := this.registerApplication(name, age, accountNumber, sortCode, monthlyIncome, 
                                                                                   monthlyOutgoings, loan);
      // if capital fund verification fails
      if (!applicationStatus) {
        logEvent("LOAN APPLICATION PROCESS COMPLETE");
        return;  
      }
      if (customer == null) {
        logEvent("ERROR: UNABLE TO CREATE CUSTOMER");
        return;
        }
      if (applicationStatus) {
        applicationStatus := this.processApplication(customer, loan);
      }
      if {  
        case applicationStatus == false => loan.setStatus("rejected");
        case applicationStatus == true => loan.setStatus("approved");
      }
      assume {:axiom} !(loan.statusPending == loan.statusRejected == loan.statusApproved);
      this.completeApplication(customer, loan);
      logEvent("LOAN APPLICATION PROCESS COMPLETE"); 
    }

    method registerApplication(name: string, age: nat, accountNumber: string, sortCode: string, monthlyIncome: real, monthlyOutgoings: real, 
                               aLoan: PersonalLoan) returns (aCustomer: Customer?, isLoanRegistered: bool)
    modifies this`customers
    modifies this`loans
    modifies this`customerLoans
    modifies aLoan`statusPending
    modifies aLoan`statusRejected
    modifies aLoan`statusApproved
    modifies this`capitalFundValue
    modifies this`reservedFunds
    modifies this`nextCustomerReference
    {
      logEvent("BEGINNING APPLICATION REGISTRATION");
      var loanRegistered :bool := false;
      var customer: Customer? := this.registerCustomer(name, age, accountNumber, sortCode, monthlyIncome, monthlyOutgoings);
      if (customer == null) {return customer, loanRegistered;}
      loanRegistered := this.registerLoan(aLoan);
      var customerRef: nat := customer.getCustomerReference();
      var loanRef: nat := aLoan.getLoanReference();
      this.associateCustomerLoan(loanRef, customerRef);
      var message: string;
      if (loanRegistered) {
        message := "Your application has been recieved and will be processed";
      } else {
        message := "We are sorry that your application cannot be processed at this time.";
      }
      this.informCustomer(customer, message);
      logEvent("APPLICATION REGISTRATION COMPLETE"); 
      return customer, loanRegistered;
    }

    method registerCustomer(name: string, age: nat, accountNumber: string, sortCode: string, monthlyIncome: real, monthlyOutgoings: real) returns (newCustomer: Customer?)
    modifies this`customers
    modifies this`nextCustomerReference
    {
      logEvent("BEGINNING CUSTOMER REGISTRATION");
      var ref: nat := getNextCustomerReference();
      var aCustomer: Customer? := new Customer(name, age, accountNumber, sortCode, monthlyIncome, monthlyOutgoings, ref); 
      if (aCustomer == null) {return aCustomer;}
      this.addCustomer(aCustomer);
      aCustomer.printCustomerDetails();
      logEvent("CUSTOMER REGISTRATION COMPLETE");
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
      logEvent("BEGINNING LOAN REGISTRATION");
      var verified: bool := false;
      var loanAmount: nat := aLoan.getRequiredAmount();
      verified := this.verifyCapitalAmount(this.capitalFundValue, this.capitalFundMinimumThreshold, loanAmount); // verify capital fund
      if (verified) {
        logEvent("CAPITAL FUND VERIFICATION PASSED");
        verified := this.reserveLoanFunds(aLoan);     // capital amount has been verified so reserve loan funds
      } else {
        logEvent("CAPITAL FUND VERIFICATION FAILED");
      }
      if (verified) {
        // loan funds reserved message in reserveLoanFunds()
        this.addLoan(aLoan);                          // loan funds have been reserved so add loan to collection of loans
      }
      if (!verified) {
        aLoan.setStatus("rejected");                  // capital fund or reserve loan fund verification has failed
      }                                               // customer will be informed in registerApplication()
      assume {:axiom} !(aLoan.statusPending == aLoan.statusRejected == aLoan.statusApproved);
      aLoan.printLoanDetails();
      logEvent("LOAN REGISTRATION COMPLETE");
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
      logEvent("BEGINNING PROCESSING APPLICATION");
      var verified: bool := false;
      var customerAge: nat := aCustomer.getAge();
      verified := aLoan.verifyAgeCriteria(customerAge);
      if (!verified) {
        logEvent("AGE CRITERIA VERIFICATION FAILED");
        var message: string := "Your application has failed the loan age criteria process";
        this.informCustomer(aCustomer, message);
        return verified;
      } else {
        logEvent("AGE CRITERIA VERIFICATION PASSED");
      }
      var customerMonthlyIncome: real := aCustomer.getMonthlyIncome();
      var customerMonthlyOutgoings : real := aCustomer.getMonthlyOutgoings();
      verified := aLoan.verifyIncomeCriteria(customerMonthlyIncome, customerMonthlyOutgoings);
      if (!verified) {
        logEvent("INCOME CRITERIA VERIFICATION FAILED");
        var message: string := "Your application has failed the loan income criteria process";
        this.informCustomer(aCustomer, message);
        return verified;
      } else {
        logEvent("AGE CRITERIA VERIFICATION PASSED");
      }
      var customerCreditScore: nat := this.obtainCustomerCreditScore(this.referenceAgency, aCustomer);
      verified := aLoan.verifyCreditScore(customerCreditScore);
      if (!verified) {
        logEvent("CREDIT SCORE CRITERIA VERIFICATION FAILED");
        var message: string := "Your application has failed the credit score criteria process";
        this.informCustomer(aCustomer, message);
        return verified;
      } else {
        logEvent("CREDIT SCORE CRITERIA VERIFICATION PASSED");
      }
      logEvent("PROCESSING APPLICATION COMPLETE");
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
      print "\n", customerMessage, "\n\n"; 
    }

    method obtainCustomerCreditScore(referenceAgency: CreditReferenceAgency, aCustomer: Customer) returns (score: nat)
    {
      logEvent("CUSTOMER CREDIT SCORE REQUESTED");
      var customerName: string := aCustomer.getName();
      assume {:axiom} customerName in referenceAgency.creditScores;
      var aScore: nat := referenceAgency.getCreditScore(customerName);
      logEvent("CUSTOMER CREDIT SCORE OBTAINED");
      var scoreMessage: string := "Customer credit score: " + customerName + ": ";
      print scoreMessage, aScore, "\n"; 
      return aScore;
    }

    method verifyCapitalAmount(fundValue: nat, fundMinimum: nat, loanAmount: nat) returns (isVerified: bool)
    ensures isVerified == ((fundValue - loanAmount) >= fundMinimum)
    ensures !isVerified == ((fundValue - loanAmount) < fundMinimum)
    {
      logEvent("CAPITAL FUND VERIFICATION COMPLETE");
      return ((fundValue - loanAmount) >= fundMinimum);
    }

    method reserveLoanFunds(theLoan: PersonalLoan) returns (success: bool)
    modifies this`capitalFundValue
    modifies this`reservedFunds
    ensures (this.capitalFundValue + this.reservedFunds) == (old(capitalFundValue) + old(reservedFunds)) 
    {
      this.printFundValues();
      var loanAmount: nat := theLoan.getRequiredAmount();
      var startingCapitalfund: nat := this.capitalFundValue;
      var startingReserveFund: nat := this.reservedFunds;
      assume {:axiom} (this.capitalFundValue - loanAmount) > 0;  
      this.capitalFundValue := this.capitalFundValue - loanAmount;
      this.reservedFunds := this.reservedFunds + loanAmount;
      var finishingCapitalFund: nat := this.capitalFundValue;
      var finishingReservedFund: nat := this.reservedFunds;
      var both: bool := (finishingCapitalFund == (startingCapitalfund - loanAmount)) && 
                        (finishingReservedFund == (startingReserveFund + loanAmount));
      logEvent("LOAN FUNDS RESERVED");
      this.printFundValues();
      return both;
    }

    method completeApplication(theCustomer: Customer, theLoan: PersonalLoan) returns ()
    requires !(theLoan.statusPending == theLoan.statusRejected == theLoan.statusApproved)
    modifies this`capitalFundValue
    modifies this`reservedFunds
    {
      logEvent("BEGINNING APPLICATION COMPLETION PROCESS");
      theLoan.printLoanDetails();
      var loanStatus: string := theLoan.getStatus();
      if (loanStatus == "rejected") {
        var message1: string := "We are sorry that your application cannot be processed at this time.";
        var fundsReleased: bool := this.releaseLoanFunds(theLoan);
        if (fundsReleased) {
          var message2: string := "LOAN FUNDS RELEASED";
          this.logEvent(message2);
          this.informCustomer(theCustomer, message1);
        }
      }
      if (loanStatus == "approved") {
        var success: bool := transferLoanToCustomer(theLoan, theCustomer);
        var accNo: string, sortCode: string := theCustomer.getPaymentDetails();
        var message: string := "Your application has been successful. The required loan amount will be transferred to account number: " + 
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
      assume {:axiom} (this.reservedFunds - loanAmount) > 0;
      this.reservedFunds := this.reservedFunds - loanAmount;
      var finishingCapitalFund: nat := this.capitalFundValue;
      var finishingReservedFund: nat := this.reservedFunds;
      var both: bool := (finishingCapitalFund == (startingCapitalfund + loanAmount)) && 
                        (finishingReservedFund == (startingReserveFund - loanAmount));
      logEvent("RESERVED LOAN FUNDS RELEASED");
      this.printFundValues();
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
      assume {:axiom} (this.reservedFunds - loanAmount) > 0;
      this.reservedFunds := this.reservedFunds - loanAmount;
      var finishingReservedFund: nat := this.reservedFunds;
      var transferred: bool := (finishingReservedFund == (startingReserveFund - loanAmount));
      logEvent("LOAN FUNDS TRANSFERRED");
      this.printFundValues();
      return transferred;
    }

    method logEvent(eventMessage: string) returns ()
    {
      var message: string := "System Log: Event :: " + eventMessage;
      print message, "\n"; 
    }

    method printFundValues() returns ()
    {
      var cfv: string := "CAPITAL FUND VALUE :: £";
      var rfv: string := "RESERVED FUND VALUE :: £";
      print cfv, this.capitalFundValue, "\n", 
            rfv, this.reservedFunds, "\n";
    }

    method getNextLoanReference() returns (ref: nat)
    modifies this`nextLoanReference
    ensures ref == old(this.nextLoanReference)
    ensures this.nextLoanReference == old(this.nextLoanReference) + 1 
    {
      var oldRef: nat := this.nextLoanReference;
      this.nextLoanReference := this.nextLoanReference + 1;
      return oldRef;
    }

    method getNextCustomerReference() returns (ref: nat)
    modifies this`nextCustomerReference
    ensures ref == old(this.nextCustomerReference)
    ensures this.nextCustomerReference == old(this.nextCustomerReference) + 1 
    {
      var oldRef: nat := this.nextCustomerReference;
      this.nextCustomerReference := this.nextCustomerReference + 1;
      return oldRef;
    }
  }
}