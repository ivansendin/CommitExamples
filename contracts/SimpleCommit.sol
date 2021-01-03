pragma solidity >=0.4.25 <0.6.0;

contract SimpleCommit {

  enum CommitStatesType {Waiting,Revealed}


  bytes32 commit;
  byte value;
  bool verified;
  CommitStatesType myState;



  constructor(bytes32 _commit) public {
    commit = _commit;
    verified = false;
    myState =  CommitStatesType.Waiting;
  }

  function reveal(bytes32 nonce, byte v) public {
    require (myState == CommitStatesType.Waiting);
    bytes32 ver = sha256(abi.encodePacked(nonce,v));
    myState = CommitStatesType.Revealed;
    if (ver==commit) {
      verified = true;
      value =v;
    }
  }

  function isCorrect() public returns (bool) {
    require (myState == CommitStatesType.Revealed);
    return verified;
  }

  function getValue() public returns(byte) {
    require (myState == CommitStatesType.Revealed);
    require (verified==true);
    return value;
  }


}
