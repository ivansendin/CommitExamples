pragma solidity >=0.4.25 <0.6.0;

contract CoinFlippingPool {


 modifier onlyOwner {
     //require(msg.sender == owner);
     _;
  }

  enum CommitStatesType {WaitingCommit,WaitingReveal,Revealed}


  struct OneFlip {
    bytes32 commit1;
    bytes32 commit2;
    byte value1;
    byte value2;
    bool verified1;
    bool verified2;
    CommitStatesType myState;
    }

    mapping(address => OneFlip) myCommits;



  constructor() public {
  }

  function initFlipping(bytes32 commitValue, address other) public onlyOwner{
    OneFlip memory flip;
    flip.commit1 = commitValue;
    flip.verified1 = false;
    flip.verified2 = false;
    flip.myState = CommitStatesType.WaitingCommit;
    myCommits[other] = flip;
  }

  function joinFlipping(bytes32 commitValue) public {
    require( myCommits[msg.sender].myState == CommitStatesType.WaitingCommit);
    myCommits[msg.sender].commit2 = commitValue;
    myCommits[msg.sender].myState = CommitStatesType.WaitingReveal;
  }


  function revealOwner(bytes32 nonce, byte v,address other) public onlyOwner {
    require (myCommits[other].myState == CommitStatesType.WaitingReveal);
    bytes32 ver = sha256(abi.encodePacked(nonce,v));

    if (ver==myCommits[other].commit1) {
      myCommits[other].verified1 = true;
      myCommits[other].value1 =v;
    }

    if (myCommits[other].verified2 == true) {
      myCommits[other].myState = CommitStatesType.Revealed;
    }
  }



  function revealOther(bytes32 nonce, byte v) public {
    require (myCommits[msg.sender].myState == CommitStatesType.WaitingReveal);
    bytes32 ver = sha256(abi.encodePacked(nonce,v));

    if (ver==myCommits[msg.sender].commit2) {
      myCommits[msg.sender].verified2 = true;
      myCommits[msg.sender].value2 =v;
    }

    if (myCommits[msg.sender].verified1 == true) {
      myCommits[msg.sender].myState = CommitStatesType.Revealed;
    }
  }



  function isCorrect(address other) public returns (bool) {
    //require (myCommits[other].myState == CommitStatesType.Revealed);
    return (myCommits[other].verified1 && myCommits[other].verified2);
  }

  function getValue(address other) public returns(byte) {
    require (isCorrect(other));
    return myCommits[other].value1 ^  myCommits[other].value2;
  }


}
