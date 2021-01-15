pragma solidity >=0.4.25 <0.6.0;

library CoinFlipping {


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



  function initFlipping(OneFlip storage flip,bytes32 commitValue) public {
    flip.commit1 = commitValue;
    flip.verified1 = false;
    flip.verified2 = false;
    flip.myState = CommitStatesType.WaitingCommit;
  }

  function join(OneFlip storage flip, bytes32 commitValue) public {
    require( flip.myState == CommitStatesType.WaitingCommit);
    flip.commit2 = commitValue;
    flip.myState = CommitStatesType.WaitingReveal;
  }


  function revealOwner(OneFlip storage flip, bytes32 nonce, byte v) public {
    require (flip.myState == CommitStatesType.WaitingReveal);
    bytes32 ver = sha256(abi.encodePacked(nonce,v));

    if (ver==flip.commit1) {
      flip.verified1 = true;
      flip.value1 =v;
    }

    if (flip.verified2 == true) {
      flip.myState = CommitStatesType.Revealed;
    }
  }



  function revealOther(OneFlip storage flip,bytes32 nonce, byte v) public {
    require (flip.myState == CommitStatesType.WaitingReveal);
    bytes32 ver = sha256(abi.encodePacked(nonce,v));

    if (ver==flip.commit2) {
      flip.verified2 = true;
      flip.value2 =v;
    }

    if (flip.verified1 == true) {
      flip.myState = CommitStatesType.Revealed;
    }
  }


  function isCorrect(OneFlip storage flip) public returns (bool) {
    require (flip.myState == CommitStatesType.Revealed);
    return (flip.verified1 && flip.verified2);
  }





  function getValue(OneFlip storage flip) public returns(byte) {
    require (isCorrect(flip));
    return flip.value1 ^  flip.value2;
  }


}
