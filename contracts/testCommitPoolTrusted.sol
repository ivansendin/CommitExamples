pragma solidity >=0.4.25 <0.6.0;


import "./CommitPoolTrusted.sol";

contract testCommitPoolTrusted {

using CommitPoolTrusted for CommitPoolTrusted.CommitPoolTrustedType;

bool ok;

CommitPoolTrusted.CommitPoolTrustedType pool;

constructor () public {
  ok = false;
}


function sendCommit(bytes32 commitValue) public {
  pool.sendCommitCommiter(commitValue);
}

function sendCommitTrusted(bytes32 commitValue) public {
  pool.sendCommitTrusted(commitValue);
}

function doBiding(address user,bytes32 commitValue) public {
  pool.doBiding(user,commitValue);
}


function revealCommiter(bytes32 commit, bytes32 nonce, byte v) public {
  pool.revealCommiter(commit,nonce,v);
}

function revealTrusted(bytes32 commit, bytes32 nonce, bytes32 v) public {
  pool.revealTrusted(commit,nonce,v);
}


/*
function isCorrect(address o) public returns (bool) {
  return pool.isCorrect(o);
}
*/

function getValue(address o) public returns (byte) {
  return pool.getValue(o);
}

}
