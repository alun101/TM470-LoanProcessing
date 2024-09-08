module {:extern "User"} User
{
  export reveals *
  class Customer {
    
    // class constants -- N/A

    // class variables -- not available in Dafny
    
    // class methods -- N/A
    
    // instance constants

    const	name: string 								
    const	age: nat
    const	accountNumber: string
    const	sortCode: string
    const	monthlyIncome: real
    const	monthlyOutgoings: real
    const referenceGenerator: Reference
    
    // instance variables

    var customerReference: nat

    // constructor
    
    constructor(aName: string, anAge: nat, anAccountNumber: string, aSortCode: string, aMonthlyIncome: real, aMonthlyOutgoing: real)
    ensures this.name == aName
    ensures this.age == anAge
    ensures this.accountNumber == anAccountNumber
    ensures this.sortCode == aSortCode
    ensures this.monthlyIncome == aMonthlyIncome
    ensures this.monthlyOutgoings == aMonthlyOutgoing
    {
	    this.name := aName;
	    this.age := anAge;
	    this.accountNumber := anAccountNumber;
	    this.sortCode := aSortCode;
	    this.monthlyIncome := aMonthlyIncome;
	    this.monthlyOutgoings := aMonthlyOutgoing;
      this.referenceGenerator := new Reference();
      new;
      this.customerReference := this.referenceGenerator.getReferenceNumber();
    }
    
    // instance methods
    
    method getName() returns (customerName: string)
    ensures customerName == this.name
    {
	    return this.name;
    }

    method getAge() returns (customerAge: nat)
    ensures customerAge == this.age
    {
      return this.age;  
    }

    method getPaymentDetails() returns (accountNumber: string, sortCode: string)
    ensures accountNumber == this.accountNumber
    ensures sortCode == this.sortCode
    {
      return this.accountNumber, this.sortCode;
    }

    method getMonthlyIncome() returns (income: real)
    ensures income == this.monthlyIncome
    {
      return this.monthlyIncome;
    }

    method getMonthlyOutgoings() returns (outgoings: real)
    ensures outgoings == this.monthlyOutgoings
    {
      return this.monthlyOutgoings;
    }

    method getCustomerReference() returns (reference: nat)
    ensures reference == this.customerReference
    {
      return this.customerReference;
    }
  }

  class Reference {
    var reference: nat
    constructor ()
    {
      reference := 1_000_000;
    }
    method getReferenceNumber() returns (ref: nat)
    modifies this`reference
    ensures ref == old(this.reference)
    ensures this.reference == old(this.reference) + 1
    {
      var ref_old: nat := this.reference;
      this.reference := this.reference + 1;
      return ref_old;
    }
  }
}