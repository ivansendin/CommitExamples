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

    c = CommitPool.deploy({'from':user})


    v1 = b'\x0A'
    nonce1 = createNonce(b'nonce1')
    commit1 = doCommit(nonce1,v1)

    c.sendCommit(commit1)
    c.reveal(nonce1,v1)

    if c.isCorrect.call(user,{'from':user}):
        print('commit 1 OK')


    v2 = b'\xAA'
    nonce2 = createNonce(b'nonce2')
    commit2 = doCommit(nonce2,v2)

    c.sendCommit(commit2,{'from':accounts[1]})
    c.reveal(nonce2,v2,{'from':accounts[1]})

    if c.isCorrect.call(accounts[1],{'from':user}):
        print('commit 2 OK')
        print(c.getValue.call(accounts[1],{'from':user}))
