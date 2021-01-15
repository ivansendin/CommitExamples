pragma solidity >=0.4.25 <0.6.0;


import "./CoinFlippingPool.sol";

contract TestFlippingPool {

using CoinFlippingPool for CoinFlippingPool.CoinFlippingPoolType;

bool ok;
CoinFlippingPool.CoinFlippingPoolType pool;

constructor () public {
  ok = false;
}



function doTest(address other, bytes32 mycommit, bytes32 othercommit) public {

  pool.initFlipping(mycommit,other);
  pool.joinFlipping(othercommit,other);

}


function getResult() public returns (bool) {
return ok;
}

}
