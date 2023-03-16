import PIL.Image as Image


def fileReader(path):
    file = open(path, 'r')
    data = file.read()
    file.close()
    return data


def toList(data):
    listedData = []
    temp = ''
    for i in data:
        if i != ' ':
            temp += i
        else:
            listedData.append(int(temp))
            temp = ''
    listedData.append(int(temp))
    return listedData


def reSizer(binNum):
    while len(binNum) < 8:
        binNum = '0' + binNum
    return binNum


def binaryToDecimal(binary):
    decimal, i = 0, 0
    while (binary != 0):
        dec = binary % 10
        decimal = decimal + dec * pow(2, i)
        binary = binary//10
        i += 1
    return decimal


def denCrypter(pic, d, n):
    i = 0
    dencryptedPic = []
    while i+1 < len(pic):
        a = reSizer("{0:b}".format(pic[i]))
        print(a)
        b = reSizer("{0:b}".format(pic[i+1]))
        print(b)
        c = binaryToDecimal(int(a+b))
        print(a+b)
        print(c)
        dencryptedPic.append(pow(c, d) % n)
        i += 2
    return dencryptedPic


def main():
    # salida 640x480
    d = 1631
    n = 5963
    pic = [20, 104]
    print(denCrypter(pic,d,n))
    # path = "./5.txt"
    # ecryptedPic = fileReader(path)
    # ecryptedPic = toList(ecryptedPic)
    # dencryptedPic = denCrypter(ecryptedPic, d, n)
    # pic = Image.new('L', (320, 320))
    # pic.putdata(dencryptedPic)
    # pic.save("test.png")
    # pic.close()


if __name__ == "__main__":
    main()
