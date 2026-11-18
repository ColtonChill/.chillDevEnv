# Lecture 3, Monday Sep 21, 23  

Serialization and Cryptographic hashing

* Serialization
* Hashing 
*

## Serialization
object -> bytes

endianness:
* Most significant byte is largest value contributor

SEC bytes == Elliptic Curve Point

02 is even
03 is odd

    x=A1B2
    y is odd
    then SEC = 0312B2

## Hashing
a hash function maps an input of arbitrary size to an output of fixed size

* Checksum, bitshifting, etc

### Avalanche / buffer fly effect
Small changes in input should have large changes in the output

### SHA256: Secure Hash Algorithm (256 bit / 32 byte output)

Flow: message, padding, 512 bit blocks, compression rounds, 256-bit digest

* Padding:
  * Append 1 bit, enough 0 bits, the original mesage length L, encoded in 64 bits

Small-Sigma:

    sigma_0(x) = ROTR^7(x) * ROTR^18(x) * SHR^3(x)
    sigma_1(x) = ROTR^17(x) * ROTR^19(x) * SHR^10(x)


