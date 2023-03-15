def MontMul(X, Y, N):
    Np = -1*pow(N, -1) % 2
    A = 0
    i = 0
    while i < N.bit_length():
        print((X & (1 << i)))
        z = ((A & (1 << 0))+((X & (1 << i) != 0)*(Y & (1 << 0)))) % 2
        A = int((A+((X & (1 << i) != 0)*Y)+z*N)/2)
        i += 1
    return A

# MontMul(13, 17, 41)
# algo()

# def ModExp(M, e, N, wsize):
#     R = pow(2, M.bit_length())
#     RR = pow(R, 2) % N
#     W1 = MontMul(M, RR, N)
#     j = pow(2, wsize-1)
#     Wj = W1
#     for i in range(1, wsize-1):
#         Wj = MontMul(Wj, Wj, N)
#     for i in range(j+1, pow(2,wsize)-1):
#         Wi = MontMul(W)


def myMod(a, b):
    while a >= 0:
        a -= b
    return a+b


def fastExpMod(base, expo, n):
    lenExp = expo.bit_length()-2
    res = base
    resl = [res]
    while lenExp >= 0:
        bit = (expo & (1 << lenExp)) != 0
        if bit:
            res = base * res * res
            resl.append([res, n])
            res = myMod(res, n)
            # resl.append(res)
            lenExp -= 1
        else:
            res = res * res
            resl.append([res, n])
            res = myMod(res, n)
            # resl.append(res)
            lenExp -= 1
    print(resl)
    return res


fastExpMod(2600, 1631, 5963)
# print(myMod(2600, 500))
