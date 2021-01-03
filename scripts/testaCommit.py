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

    v = b'\x0A'
    #v = np.uint16(10)
    nonce1 = createNonce(b'nonce1')
    commit1 = doCommit(nonce1,v)

    c1 = SimpleCommit.deploy(commit1,{'from':user})
    c1.reveal(nonce1,v)

    isOK = c1.isCorrect.call({'from':user})

    print(isOK)
