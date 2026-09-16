# Lecture 2, Monday Sep 09, 14, 16 
## Lecture 2 (ECC)

* Finite Fields
* Elliptic Curves
* Point Addition
* Scalar Multiplication

## Finite Fields

A field is a set equipped with 2 operations (+,*)
* addition and mult produce elements
* there is a additive identity 0 and multiplicative identity
* all element have addative and multi inverses (-a, 1/a)
* Associative, commutative, and distributive law apply


## Elliptic Curves

ECC lets your get away with smaller int to get the same security as RSA

    y^2 === x^3 + ax + b

y^2 === x^3 + 2x + 2 (mod 17)

## Point Addition

Points: P & Q

m = (y2-y1)(x2-x1)^-1 (mod 17)

## Scalar Multiplication

y^2 

## Hasse's Theorem

Let E be an elliptic curve of field F_p
Suppose E container N point including the point at infinity

    |N - (p+1)|<=2*sqrt(P)


## Public and private keys in ECC

private key (int): d
public key:

    Q = dG

Where G is a generator point

ECDSA (Elliptic curve )
