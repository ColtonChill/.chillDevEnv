# Lecture 4, Monday Oct  5, 7 

Proof of work


## Pre-bitcoin: Pricing vs. Processing

Dwork and Naor called the required companion a "price function"
* Expensive to produce, cheap to verify
* Same as bitcoin mining

Takeaways:
* computation is required before granting access to...
* price is manageable
* price accumulate


## History
Dwork-Naor --> Hashcash --> Bitcoin (hash based work)


## Proof of work

Given a message `m`
    m = b"..."
We add nonces until we find a valid SHA256

    h_n = int(d_n)

Therefore:
    
    0 <= h_n <=256-1

    0 <= ... <= MAX_TARGET

A valid proof of work is achived when:

    h_n < T

Recall:
    
    h_n = int(SHA256(m||encode(n)))

## Mining





