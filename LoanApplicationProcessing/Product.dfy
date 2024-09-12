module {:extern "Product"} Product
{
  export reveals * 
  
  class PersonalLoan {
    
    // class constants
    
    static const monthLoan24: map<nat, real> := map[5000 := 5694.72, 5100 := 5808.72, 5200 := 5922.72, 5300 := 6036.48, 5400 := 6150.48, 
                                                    5500 := 6264.24, 5600 := 6378.24, 5700 := 6492.00, 5800 := 6606.00, 5900 := 6720.00,
                                                    6000 := 6833.76, 6100 := 6947.76, 6200 := 7061.52, 6300 := 7175.52, 6400 := 7289.28,
                                                    6500 := 7403.28, 6600 := 7517.28, 6700 := 7631.04, 6800 := 7745.04, 6900 := 7858.80,
                                                    7000 := 7972.80, 7100 := 8086.56, 7200 := 8200.56, 7300 := 8314.56, 7400 := 8428.32,
                                                    7500 := 7987.92, 7600 := 8094.24, 7700 := 8200.80, 7800 := 8307.36, 7900 := 8413.92,
                                                    8000 := 8520.48, 8100 := 8626.80, 8200 := 8733.36, 8300 := 8839.92, 8400 := 8946.48,
                                                    8500 := 9052.80, 8600 := 9159.36, 8700 := 9265.92, 8800 := 9372.48, 8900 := 9478.80,
                                                    9000 := 9585.36, 9100 := 9691.92, 9200 := 9798.48, 9300 := 9905.04, 9400 := 10011.36,
                                                    9500 := 10117.92, 9600 := 10224.48, 9700 := 10331.04, 9800 := 10437.36, 9900 := 10543.92, 10000 := 10650.48]
    static const monthLoan36: map<nat, real> := map[5000 := 6049.08, 5100 := 6170.04, 5200 := 6291.36, 5300 := 6412.32, 5400 := 6533.28, 
                                                    5500 := 6654.24, 5600 := 6775.20, 5700 := 6896.16, 5800 := 7017.12, 5900 := 7138.08,
                                                    6000 := 7259.04, 6100 := 7380.00, 6200 := 7500.96, 6300 := 7621.92, 6400 := 7742.88,
                                                    6500 := 7863.84, 6600 := 7985.16, 6700 := 8106.12, 6800 := 8227.08, 6900 := 8348.04,
                                                    7000 := 8469.00, 7100 := 8589.96, 7200 := 8710.92, 7300 := 8831.88, 7400 := 8952.84,
                                                    7500 := 8229.24, 7600 := 8339.04, 7700 := 8448.84, 7800 := 8558.28, 7900 := 8668.08,
                                                    8000 := 8777.88, 8100 := 8887.68, 8200 := 8997.12, 8300 := 9106.92, 8400 := 9216.72,
                                                    8500 := 9326.52, 8600 := 9436.32, 8700 := 9545.76, 8800 := 9655.56, 8900 := 9765.36,
                                                    9000 := 9875.16, 9100 := 9984.96, 9200 := 10094.40, 9300 := 10204.20, 9400 := 10314.00,
                                                    9500 := 10423.80, 9600 := 10533.24, 9700 := 10643.04, 9800 := 10752.84, 9900 := 10862.64, 10000 := 10972.44]
    static const monthLoan48: map<nat, real> := map[5000 := 6417.12, 5100 := 6545.28, 5200 := 6673.92, 5300 := 6802.08, 5400 := 6930.24, 
                                                    5500 := 7058.88, 5600 := 7187.04, 5700 := 7315.68, 5800 := 7443.84, 5900 := 7572.00,
                                                    6000 := 7700.64, 6100 := 7828.80, 6200 := 7956.96, 6300 := 8085.60, 6400 := 8213.76,
                                                    6500 := 8342.40, 6600 := 8470.56, 6700 := 8598.72, 6800 := 8727.36, 6900 := 8855.52,
                                                    7000 := 8983.68, 7100 := 9112.32, 7200 := 9240.48, 7300 := 9369.12, 7400 := 9497.28,
                                                    7500 := 8475.36, 7600 := 8588.16, 7700 := 8701.44, 7800 := 8814.24, 7900 := 8927.04,
                                                    8000 := 9040.32, 8100 := 9153.12, 8200 := 9266.40, 8300 := 9379.20, 8400 := 9492.48,
                                                    8500 := 9605.28, 8600 := 9718.08, 8700 := 9831.36, 8800 := 9944.16, 8900 := 10057.44,
                                                    9000 := 10170.24, 9100 := 10283.52, 9200 := 10396.32, 9300 := 10509.12, 9400 := 10622.40,
                                                    9500 := 10735.20, 9600 := 10848.48, 9700 := 10961.28, 9800 := 11074.56, 9900 := 11187.36, 10000 := 11300.16]
    static const monthLoan60: map<nat, real> := map[5000 := 6798.00, 5100 := 6934.20, 5200 := 7069.80, 5300 := 7206.00, 5400 := 7342.20, 
                                                    5500 := 7477.80, 5600 := 7614.00, 5700 := 7749.60, 5800 := 7885.80, 5900 := 8022.00,
                                                    6000 := 8157.60, 6100 := 8293.80, 6200 := 8430.00, 6300 := 8565.60, 6400 := 8701.80,
                                                    6500 := 8837.40, 6600 := 8973.60, 6700 := 9109.80, 6800 := 9245.40, 6900 := 9381.60,
                                                    7000 := 9517.20, 7100 := 9653.40, 7200 := 9789.60, 7300 := 9925.20, 7400 := 10061.40,
                                                    7500 := 8725.80, 7600 := 8842.20, 7700 := 8958.60, 7800 := 9075.00, 7900 := 9191.40,
                                                    8000 := 9307.80, 8100 := 9424.20, 8200 := 9540.60, 8300 := 9657.00, 8400 := 9772.80,
                                                    8500 := 9889.20, 8600 := 10005.60, 8700 := 10112.00, 8800 := 10238.40, 8900 := 10354.80,
                                                    9000 := 10471.20, 9100 := 10587.60, 9200 := 10704.00, 9300 := 10820.40, 9400 := 10936.80,
                                                    9500 := 11052.60, 9600 := 11169.00, 9700 := 11285.40, 9800 := 11401.80, 9900 := 11518.20, 10000 := 11634.60] 
    static const maxAge: nat := (67 * 12)
    static const incomeAffordabilityThreshold: real := 0.8
    static const goodCreditScoreThreshold: nat := 881
    static const highInterestRate: real := 13.6
    static const lowInterestRate: real := 6.3
    
    // class variables -- not available in Dafny
    
    // class methods
    static method calculateRepayment(anAmount: nat, repaymentPeriod: nat) returns (totalAmountRepayable: real, monthlyRepaymentAmount: real)
    requires anAmount in PersonalLoan.monthLoan24 || anAmount in PersonalLoan.monthLoan36 || anAmount in PersonalLoan.monthLoan48 || anAmount in PersonalLoan.monthLoan60
    requires repaymentPeriod == 24 || repaymentPeriod == 36 || repaymentPeriod == 48 || repaymentPeriod == 60
    ensures totalAmountRepayable == PersonalLoan.monthLoan24[anAmount] || totalAmountRepayable == PersonalLoan.monthLoan36[anAmount] || 
            totalAmountRepayable == PersonalLoan.monthLoan48[anAmount] || totalAmountRepayable == PersonalLoan.monthLoan60[anAmount]
    ensures monthlyRepaymentAmount == PersonalLoan.monthLoan24[anAmount] / 24 as real || monthlyRepaymentAmount == PersonalLoan.monthLoan36[anAmount] / 36 as real || 
            monthlyRepaymentAmount == PersonalLoan.monthLoan48[anAmount] / 48 as real || monthlyRepaymentAmount == PersonalLoan.monthLoan60[anAmount] / 60 as real
    {
      var totalAmount: real;
      if {
        case repaymentPeriod == 24 => totalAmount := PersonalLoan.monthLoan24[anAmount];
        case repaymentPeriod == 36 => totalAmount := PersonalLoan.monthLoan36[anAmount];
        case repaymentPeriod == 48 => totalAmount := PersonalLoan.monthLoan48[anAmount];
        case repaymentPeriod == 60 => totalAmount := PersonalLoan.monthLoan60[anAmount];
      }
      var monthlyAmount: real := totalAmount / (repaymentPeriod as real);
      return totalAmount, monthlyAmount;
    }
    
    // instance constants
    
    const referenceNumber: nat
    const requiredAmount: nat
    const repaymentPeriod: nat
	  const interestRate: real
	  const totalAmountRepayable: real
	  const monthlyRepaymentAmount: real
    
    // instance variables
    
    var statusPending: bool	
	  var statusRejected: bool
    var statusApproved: bool
    
    // constructor
    
    constructor (aRequiredAmount: nat, aRepaymentPeriod: nat, anInterestRate: real, aReferenceNumber: nat)
    requires aRequiredAmount in PersonalLoan.monthLoan24 || aRequiredAmount in PersonalLoan.monthLoan36 || 
             aRequiredAmount in PersonalLoan.monthLoan48 || aRequiredAmount in PersonalLoan.monthLoan60
    requires aRepaymentPeriod == 24 || aRepaymentPeriod == 36 || aRepaymentPeriod == 48 || aRepaymentPeriod == 60
    requires anInterestRate == PersonalLoan.lowInterestRate || anInterestRate == PersonalLoan.highInterestRate
    ensures this.requiredAmount == aRequiredAmount
    ensures this.repaymentPeriod == aRepaymentPeriod
    ensures this.interestRate == anInterestRate
    ensures this.totalAmountRepayable == PersonalLoan.monthLoan24[aRequiredAmount] || this.totalAmountRepayable == PersonalLoan.monthLoan36[aRequiredAmount] || 
            this.totalAmountRepayable == PersonalLoan.monthLoan48[aRequiredAmount] || this.totalAmountRepayable == PersonalLoan.monthLoan60[aRequiredAmount]
    //ensures this.monthlyRepaymentAmount == this.totalAmountRepayable / aRepaymentPeriod as real
    ensures this.statusPending == true
    ensures this.statusRejected == this.statusApproved
    ensures this.statusPending != (this.statusRejected || this.statusApproved)
    {
      this.referenceNumber := aReferenceNumber;
      this.requiredAmount := aRequiredAmount;
      this.repaymentPeriod := aRepaymentPeriod;
      this.interestRate := anInterestRate;
      var total, monthly: real := PersonalLoan.calculateRepayment(aRequiredAmount, aRepaymentPeriod);
      this.totalAmountRepayable := total;
      this.monthlyRepaymentAmount := monthly;
      this.statusPending := true;
      this.statusRejected := false;
      this.statusApproved := false;
    }
    
    // instance methods
    
    method setStatus(status: string) returns ()
    requires status == "pending" || status == "rejected" || status == "approved"
    modifies this`statusPending
    modifies this`statusRejected
    modifies this`statusApproved
    {
      if {
      case status == "pending" => setStatusPending();
      case status == "rejected" => setStatusRejected();
      case status == "approved" => setStatusApproved();
      }
    }

    method setStatusPending() returns ()
    modifies this`statusRejected
    modifies this`statusApproved
    modifies this`statusPending
    ensures this.statusPending == true
    ensures this.statusRejected == false
    ensures this.statusApproved == false
    ensures !(this.statusPending == this.statusRejected == this.statusApproved)
    {
      this.statusRejected := false;
      this.statusApproved := false;
      this.statusPending := true;
    }

    method setStatusRejected() returns ()
    modifies this`statusPending
    modifies this`statusApproved
    modifies this`statusRejected
    ensures this.statusRejected == true
    ensures this.statusPending == false
    ensures this.statusApproved == false
    ensures !(this.statusPending == this.statusRejected == this.statusApproved)
    {
      this.statusPending := false;
      this.statusApproved := false;
      this.statusRejected := true;
    }

    method setStatusApproved() returns ()
    modifies this`statusPending
    modifies this`statusRejected
    modifies this`statusApproved
    ensures this.statusApproved == true
    ensures this.statusPending == false
    ensures this.statusRejected == false
    ensures !(this.statusPending == this.statusRejected == this.statusApproved)
    {
      this.statusPending := false;
      this.statusRejected := false;
      this.statusApproved := true;
    }

    method getStatus() returns (status: string)
    requires !(this.statusPending == this.statusRejected == this.statusApproved)
    ensures status == "pending" || status == "rejected" || status == "approved"
    {
      if {
        case this.statusPending == true => return "pending";
        case this.statusRejected == true => return "rejected";
        case this.statusApproved == true => return "approved";
      }
    }

    method verifyAgeCriteria(customerAge: nat) returns (isVerified: bool)
    ensures isVerified == (((customerAge * 12) + this.repaymentPeriod) <= PersonalLoan.maxAge)
    ensures !isVerified == (((customerAge * 12) + this.repaymentPeriod) > PersonalLoan.maxAge)
    {
      var ageWhenLoanComplete: nat := (customerAge * 12) + this.repaymentPeriod;
      return ageWhenLoanComplete <= PersonalLoan.maxAge;
    }

    method verifyIncomeCriteria(customerMonthlyIncome: real, customerMonthlyOutgoings: real) returns (isVerified: bool)
    ensures isVerified == ((customerMonthlyIncome * 0.8) >= (customerMonthlyOutgoings + this.monthlyRepaymentAmount))
    ensures !isVerified == ((customerMonthlyIncome * 0.8) < (customerMonthlyOutgoings + this.monthlyRepaymentAmount))
    {
      var totalOutgoings: real := customerMonthlyOutgoings + this.monthlyRepaymentAmount;
      var adjustedIncommings: real := customerMonthlyIncome * PersonalLoan.incomeAffordabilityThreshold;
      return adjustedIncommings >= totalOutgoings; 
    }

    method verifyCreditScore(customerCreditScore: nat) returns (isVerified: bool)
    ensures isVerified == (customerCreditScore >= PersonalLoan.goodCreditScoreThreshold)
    ensures !isVerified == (customerCreditScore < PersonalLoan.goodCreditScoreThreshold)
    {
      return customerCreditScore >= PersonalLoan.goodCreditScoreThreshold;
    }

    method getLoanReference() returns (reference: nat)
    ensures reference == this.referenceNumber
    {
      return this.referenceNumber;
    }

    method getRequiredAmount () returns (amount: nat)
    ensures amount == this.requiredAmount
    {
      return this.requiredAmount;
    }

    method printLoanDetails () returns ()
    requires !(this.statusPending == this.statusRejected == this.statusApproved)
    {
      var ref: string := "Loan reference number: ";
      var amount: string := "Required amount: £";
      var period: string := "Required repayment period: ";
      var rate: string := "Interest rate ";
      var total: string := "Total repayable amount: £";
      var monthly: string := "Monthly repayable amount: £";
      var status: string := "Current loan status: ";
      var currentStatus: string := this.getStatus();
      print ref, this.referenceNumber, "\n",
            amount, this.requiredAmount, ".00", "\n",
            period, this.repaymentPeriod, " months", "\n",
            rate, this.interestRate, "%", "\n",
            total, this.totalAmountRepayable, "\n",
            monthly, this.monthlyRepaymentAmount, "\n",
            status, currentStatus, "\n";
    }
  }
}
