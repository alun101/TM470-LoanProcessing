
using Support;
using BankSystem;
using Dafny;
using System.Runtime.Serialization;
using System.ComponentModel.DataAnnotations;

class Program
{
  static void Main(string[] args)
  {
    Console.WriteLine($"{Environment.NewLine}Enter bank capital fund value of 500000 or above or blank to exit:");
    string? input = Console.ReadLine();
    if (string.IsNullOrEmpty(input)) {return;}
    int value = int.Parse(input);
    if (value < 500000) {return;}
    (Bank b, CreditReferenceAgency c) = UserInterface.SetupBankingSystem(value);
    if (b != null && c != null){
      UserInterface.BeginLoanApplicationSubmissionInterface(b, c);
    } else {
      Console.WriteLine($"{Environment.NewLine}Setup Error: Program terminating");
    }
    return;
  }
}

class UserInterface
{
  public static (Bank b, CreditReferenceAgency c) SetupBankingSystem(int value)
  {
    var cra = new CreditReferenceAgency();
    //var bank = new Bank(value, cra);
    var bank = new Bank();
    bank.__ctor(value, cra);
    return (bank, cra);
  }

  public static async void BeginLoanApplicationSubmissionInterface(Bank bank, CreditReferenceAgency creditReferenceAgency)
  {
    while(true)
    {

      var input = await UserInterface.GetUserInput();
      // add customer to the Credit Reference Agency
      var added = await creditReferenceAgency.addPerson(input.name, input.creditScore);
      // if customer successfully added start a new application
      if (added) {
      bank.newApplication(input.name, input.age, input.accNo, input.sortCode, input.monthlyIncome, input.monthlyOutgoings, input.requiredAmount, input.repaymentPeriod);
      } else {
        Console.WriteLine($"{Environment.NewLine}Setup Error: Program terminating");
        break;
      }
    }
  }

  public static async Task<UserInput> GetUserInput()
  {
      bool exit = false;
      string name = "";
      int age = 0;
      string accNo = "";
      string sortCode = "";
      float monthlyIncome = 0.0F;
      float monthlyOutgoings = 0.0F;
      int creditScore = 0;
      int requiredAmount = 0;
      int repaymentPeriod = 0;

      Console.WriteLine($"{Environment.NewLine}Enter 'y' and press <Enter> to begin a loan application or any other key to exit:");
      string? input = Console.ReadLine();
      if (string.IsNullOrEmpty(input) || !(input.Equals("y") || input.Equals("Y"))) {exit = true;} 
      if (exit) {System.Environment.Exit(1);}
      // get customer personal details
      Console.WriteLine($"{Environment.NewLine}Please enter customer personal details");
      // get customer name
      Console.WriteLine($"{Environment.NewLine}Enter name or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        name = input;
      }
      if (exit) {System.Environment.Exit(1);}
      // get customer age
      Console.WriteLine($"{Environment.NewLine}Enter an age between 18 and 65 (inclusive) or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        age = int.Parse(input);
        if (age < 18 || age > 65) {
          exit = true;
        }
      }
      if (exit) {System.Environment.Exit(1);}
      // get customer account number
      Console.WriteLine($"{Environment.NewLine}Enter customer account number or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        accNo = input;
      }
      if (exit) {System.Environment.Exit(1);}
      // get customer sort code
      Console.WriteLine($"{Environment.NewLine}Enter customer sort code or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        sortCode = input;
      }
      if (exit) {System.Environment.Exit(1);}
      // get customer monthly income
      Console.WriteLine($"{Environment.NewLine}Enter customer monthly income or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        monthlyIncome = float.Parse(input);
      }
      if (exit) {System.Environment.Exit(1);}
      // get customer monthly outgoings
      Console.WriteLine($"{Environment.NewLine}Enter customer monthly outgoings or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        monthlyOutgoings = float.Parse(input);
      }
      if (exit) {System.Environment.Exit(1);}
      // get customer credit score setup
      Console.WriteLine($"{Environment.NewLine}Enter customer credit score setup, 0-880 for 'fail' or 881-999 for 'pass' or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        creditScore = int.Parse(input);
        if (creditScore < 0 || creditScore > 999) {
          exit = true;
        }
      }
      if (exit) {System.Environment.Exit(1);}
      // get loan requirement details
      Console.WriteLine($"{Environment.NewLine}Please enter customer loan requirements");
      // get required amount
      Console.WriteLine($"{Environment.NewLine}Enter required amount to borrow, £5000 - £10000 (inclusive) or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        requiredAmount = int.Parse(input);
        if (requiredAmount < 5000 || requiredAmount > 10000 || ((requiredAmount % 100) != 0)) {
          exit = true;
        }
      }
      if (exit) {System.Environment.Exit(1);}
      // get repayment period
      Console.WriteLine($"{Environment.NewLine}Enter repayment period, 24, 36, 48 or 60 months or blank to exit:");
      input = Console.ReadLine();
      if (string.IsNullOrEmpty(input)) {
        exit = true;
      } else {
        repaymentPeriod = int.Parse(input);
        if (!(repaymentPeriod == 24 || repaymentPeriod == 36 || repaymentPeriod == 48 || repaymentPeriod == 60)) {
          exit = true;
        }
      }
      if (exit) {System.Environment.Exit(1);}
      
      // convert c# types to equivalent Dafny types
      // required for string -> ISequence<Rune>
      // required for float -> BigRational
      // not required for int -> BigInteger
      var dafnyName = Dafny.Sequence<Dafny.Rune>.UnicodeFromString(name);
      var dafnyAccNo = Dafny.Sequence<Dafny.Rune>.UnicodeFromString(accNo);
      var dafnySortCode = Dafny.Sequence<Dafny.Rune>.UnicodeFromString(sortCode);
      var dafnyMonthlyIncome = new Dafny.BigRational(monthlyIncome);
      var dafnyMonthlyOutgoings = new Dafny.BigRational(monthlyOutgoings);

      UserInput finalInput;
      finalInput.name = dafnyName;
      finalInput.age = age;
      finalInput.accNo = dafnyAccNo;
      finalInput.sortCode = dafnySortCode;
      finalInput.monthlyIncome = dafnyMonthlyIncome;
      finalInput.monthlyOutgoings = dafnyMonthlyOutgoings;
      finalInput.creditScore = creditScore;
      finalInput.requiredAmount = requiredAmount;
      finalInput.repaymentPeriod = repaymentPeriod;

      return finalInput;
  }

  public struct UserInput
  {
      public Dafny.ISequence<Dafny.Rune> name;
      public int age;
      public Dafny.ISequence<Dafny.Rune> accNo;
      public Dafny.ISequence<Dafny.Rune> sortCode;
      public Dafny.BigRational monthlyIncome;
      public Dafny.BigRational monthlyOutgoings;
      public int creditScore;
      public int requiredAmount;
      public int repaymentPeriod;
  }


}
