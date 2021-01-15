pragma solidity >=0.4.25 <0.6.0;


import "./CommitPool.sol";

contract testCommitPool {

using CommitPool for CommitPool.CommitPoolType;

bool ok;
CommitPool.CommitPoolType pool;

constructor () public {
  ok = false;
}


function sendCommit(bytes32 commitValue) public {
  pool.sendCommit(commitValue);
}

function reveal(bytes32 nonce, byte v) public {
  pool.reveal(nonce,v);
}

function isCorrect(address o) public returns (bool) {
  return pool.isCorrect(o);
}

function getValue(address o) public returns (byte) {
  return pool.getValue(o);
}

}
