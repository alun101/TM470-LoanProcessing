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
    const customerReference: nat
    
    // instance variables -- N/A

    // constructor
    
    constructor(aName: string, anAge: nat, anAccountNumber: string, aSortCode: string, aMonthlyIncome: real, aMonthlyOutgoing: real, aReference: nat)
    ensures this.name == aName
    ensures this.age == anAge
    ensures this.accountNumber == anAccountNumber
    ensures this.sortCode == aSortCode
    ensures this.monthlyIncome == aMonthlyIncome
    ensures this.monthlyOutgoings == aMonthlyOutgoing
    ensures this.customerReference == aReference
    {
	    this.name := aName;
	    this.age := anAge;
	    this.accountNumber := anAccountNumber;
	    this.sortCode := aSortCode;
	    this.monthlyIncome := aMonthlyIncome;
	    this.monthlyOutgoings := aMonthlyOutgoing;
      this.customerReference := aReference;
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

    method printCustomerDetails() returns ()
    {
      var ref: string := "Customer reference number: ";
      var name: string := "Customer name: ";
      var age: string := "Customer age: ";
      var acc: string := "Customer account number: ";
      var sort: string := "Customer sort code: ";
      var income: string := "Customer monthly income: £";
      var outgoings: string := "Customer monthly expenditure: £";
      print ref, this.customerReference, "\n",
            name, this.name, "\n", 
            age, this.age, "\n",
            acc, this.accountNumber, "\n",
            sort, this.sortCode, "\n",
            income, this.monthlyIncome, "\n",
            outgoings, this.monthlyOutgoings, "\n"; 
    }
  }
}
