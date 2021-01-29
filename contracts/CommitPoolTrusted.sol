pragma solidity >=0.4.25 <0.6.0;

library CommitPoolTrusted {

  enum CommitStatesType {Waiting,Revealed}

  struct OneCommit {
    byte value;
    bool verified;
    CommitStatesType myState;
    }

  struct OneBiding {
    bytes32 value;
    bool verified;
    CommitStatesType myState;
  }


  struct CommitPoolTrustedType {
    mapping(bytes32 => OneCommit) myCommit;
    mapping(bytes32 => OneBiding) myBidings;
    mapping(address => bytes32) address2commit;
    address trusted;
  }

  function sendCommitCommiter(CommitPoolTrustedType storage cp,bytes32 commitValue) public {
    OneCommit memory c;
    c.verified = false;
    c.myState = CommitStatesType.Waiting;
    cp.myCommit[commitValue] = c;
  }


  function sendCommitTrusted(CommitPoolTrustedType storage cp, bytes32 commit) public {
    OneBiding memory b;
    cp.myBidings[commit] = b;
  }

  function doBiding(CommitPoolTrustedType storage cp, address user, bytes32 commit) public {
    //require (myBidings[commit].myState == )
    cp.address2commit[user]=commit;
  }



  function revealCommiter(CommitPoolTrustedType storage cp, bytes32 commit, bytes32 nonce, byte v) public {
    //require (cp.myCommits[commit].myState == CommitStatesType.Waiting);


    bytes32 ver = sha256(abi.encodePacked(nonce,v));

    // errado
    if (commit == ver) {
      cp.myCommit[commit].myState = CommitStatesType.Revealed;
      cp.myCommit[commit].verified = true;
      cp.myCommit[commit].value =v;
    }
  }


  function revealTrusted(CommitPoolTrustedType storage cp, bytes32 commit, bytes32 nonce, bytes32 v) public {


    bytes32 ver = sha256(abi.encodePacked(nonce,v));

    if (commit == ver) {
      cp.myBidings[commit].myState = CommitStatesType.Revealed;
      cp.myBidings[commit].verified = true;
      cp.myBidings[commit].value =v;
    }
  }




  /*
  function isCorrect(CommitPoolType storage cp,address other) public returns (bool) {
    require (cp.myCommits[other].myState == CommitStatesType.Revealed);
    return cp.myCommits[other].verified;
  }

 */

  function getValue(CommitPoolTrustedType storage cp,address other) public returns(byte) {

    return cp.myCommit[cp.myBidings[cp.address2commit[other]].value].value;
  }



}
