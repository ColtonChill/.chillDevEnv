# Lecture 1, Monday Aug 31
## Outline of the class

* RAS
* ECC (Elliptical curves)
* Euler's Totient
* Key Generation
* RSA Signatures
* Responsible Use of AI
  * AI-0
  * AI-1: (You are here)
  * AI-2
  * AI-3
  * AI-4
  * AI-5: 100% AI, No Student needed


Modules of the class
1. Foundations (RSA, basics needed to build a block change)
  * Public key (RSA, ECC)
  * Serialization
  * Cryptohashing
  * Maerkele Tree
  * Proof of work
  * Networking
2. Bitcoin implementation from scratch
  * Transactions
  * UTXO
  * Block
  * Mempool
  * Blockchain
  * Ledger
  * Mining
  * Consensus
  * Fork resolution
3. Alternative crypto-coins
  * Fadona
  * Etherieum
  * Stablecoin
  * Hashgraph


## Lecture (Public-keys Crypto-currencies)

### Public and Secret Keys

Fundamental equation of public-key cryptography

P_a = Public key of Alice
S_a = Secret key of Alice
P_b = Public key of Bob
S_b = Secret key of Bob
M = Some serialized message

    M = S_a(P_a(M)); M = P_a(S_a(M))


### Encryption and Decryption:

1. Obtain public key
2. Encrypt
    C = P_a(M)
3. Decrypt
    M = S_a(M)

### RSA

Based on prime factorization for 2 large prime numbers.
Can be cracked, just not easily

Key Features:
* Extrended Euclid's Algorithm
* Multiplicative Inverse Modulo N
* Modular Exponentiation
* Euler's totient
* Key Generation

#### Extended Euclid Algo:

```
def EUCLID(a,b):
  if b==0:
    return a
  else:
    return EUCLID(b, a%b)


def EXTENDED_EUCLID(a,b):
  prevx, x = 1, 0
  prevy, y = 0, 1
  aa, bb = a, b
  WHILE bb != 0:
    q = aa // bb
    x, prevx = prevx -q*x, x
    ...
  if b==0:
    return a
  else:
    return EUCLID(b, a%b)
```

#### Extended GCD:
If g = gcd(b,c), bla, bla, bla, get from the notes


#### Multiplicative Inverse Modulo N

if gcd(a,n) == 1,
  then ax==b(mod n)


#### Euler's totient

Equivalent class modulo n:

    [a]_n = { a+kn | k is int }

Properties of equivalent classes:

    [a]_n +_n[b]n = [a + b]_n

Euler's

    phi(n) = n * prod(1-1/p) p|n
           = (p-1)(q-1)

where p is the list of primes that evenly divide n
and n=p*q

### RSA encryuption and Decrytion

Encrypt:  P(M) = M^e (mod n)
DEncrypt: P(C) = M^e (mod n)




##### Fermat's little theorem

    a^(p-1) == 1 (mod p)


##### Chinese remainder theorem

    
#### Digital signatures with RSA




