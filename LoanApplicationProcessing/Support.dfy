module {:extern "Support"} Support
{
  export reveals *
  class CreditReferenceAgency {
    
    // class constants

    static const creditScoreMin: nat := 0
    static const creditScoreMax: nat := 999
    static const creditScoreGood: nat := 881
    
    // class variables -- not available in Dafny
    
    // class methods -- N/A
    
    // instance constants -- N/A
    
    // instance variables -- N/A

    var creditScores: map<string, nat> 
    
    // constructor
    
    constructor () {}
    
    // instance methods

    method addPerson(name: string, creditScoreSetup: string) returns ()
    requires creditScoreSetup == "pass" || creditScoreSetup == "fail"
    modifies this`creditScores
    ensures name in creditScores
    ensures CreditReferenceAgency.creditScoreMin <= creditScores[name] <= CreditReferenceAgency.creditScoreMax 
    {
      var aCreditScore: nat := 0;
      if {
        case creditScoreSetup == "pass" => aCreditScore :| CreditReferenceAgency.creditScoreGood <= aCreditScore <= CreditReferenceAgency.creditScoreMax;
        case creditScoreSetup == "fail" => aCreditScore :| CreditReferenceAgency.creditScoreMin <= aCreditScore < CreditReferenceAgency.creditScoreGood;
      }
      this.creditScores := map[name := aCreditScore];
    }

    method getCreditScore(name: string) returns (creditScore: nat)
    requires name in creditScores
    ensures creditScore == this.creditScores[name]
    {
      return this.creditScores[name];
    }
  }
}