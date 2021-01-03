#!/usr/bin/python3

from brownie import *
import brownie
import hashlib
import numpy as np

def createNonce(s):
    n = hashlib.sha256()
    n.update(s)
    return n.digest()

def doCommit(n,v):
    c = hashlib.sha256()
    c.update(n)
    c.update(v)
    return c.digest()


def main():
    user = accounts[0]

    coin = CoinFlippingPool.deploy({'from':user})

    v = b'\xF0'
    nonce1 = createNonce(b'nonce1')
    commit1 = doCommit(nonce1,v)

    coin.initFlipping(commit1,accounts[1])

    v2 = b'\x0A'
    nonce2 = createNonce(b'nonce2')
    commit2 = doCommit(nonce2,v2)

    coin.joinFlipping(commit2,{'from':accounts[1]})

    coin.revealOwner(nonce1,v,accounts[1],{'from':user})
    coin.revealOther(nonce2,v2,{'from':accounts[1]})

    if coin.isCorrect.call(accounts[1],{'from':user}):
        coinValue = coin.getValue.call(accounts[1],{'from':user})
        print(coinValue)
    else:
        print('Error!')
