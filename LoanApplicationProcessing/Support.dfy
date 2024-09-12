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

    method addPerson(name: string, creditScoreSetup: nat) returns ()
    requires CreditReferenceAgency.creditScoreMin <= creditScoreSetup <= CreditReferenceAgency.creditScoreMax
    modifies this`creditScores
    ensures name in creditScores
    ensures CreditReferenceAgency.creditScoreMin <= creditScores[name] <= CreditReferenceAgency.creditScoreMax 
    {
      this.creditScores := map[name := creditScoreSetup];
    }

    method getCreditScore(name: string) returns (creditScore: nat)
    requires name in creditScores
    ensures creditScore == this.creditScores[name]
    {
      return this.creditScores[name];
    }
  }
}