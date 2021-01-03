pragma solidity >=0.4.25 <0.6.0;

contract CommitPool {

  enum CommitStatesType {Waiting,Revealed}

  struct OneCommit {
    bytes32 commit;
    byte value;
    bool verified;
    CommitStatesType myState;
    }

    mapping(address => OneCommit) myCommits;



  constructor() public {
  }

  function sendCommit(bytes32 commitValue) public {
    OneCommit memory c;
    c.commit = commitValue;
    c.verified = false;
    c.myState = CommitStatesType.Waiting;
    myCommits[msg.sender] = c;
  }


  function reveal(bytes32 nonce, byte v) public {
    require (myCommits[msg.sender].myState == CommitStatesType.Waiting);
    bytes32 ver = sha256(abi.encodePacked(nonce,v));
    myCommits[msg.sender].myState = CommitStatesType.Revealed;
    if (ver==myCommits[msg.sender].commit) {
      myCommits[msg.sender].verified = true;
      myCommits[msg.sender].value =v;
    }
  }


  function isCorrect(address other) public returns (bool) {
    require (myCommits[other].myState == CommitStatesType.Revealed);
    return myCommits[other].verified;
  }

  function getValue(address other) public returns(byte) {
    require (myCommits[other].myState == CommitStatesType.Revealed);
    require (myCommits[other].verified==true);
    return myCommits[other].value;
  }


}
