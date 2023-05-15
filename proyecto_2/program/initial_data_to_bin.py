import sys
import matplotlib.pyplot as plt
import matplotlib.image as mpimg



# def fileReader(path):
#     file = open(path, 'r')
#     data = file.read(path)
#     file.close()
#     return data

def fileReader(path):
    img = mpimg.imread(path)
    return img


def toList(data):
    listedData = []    
    temp = ''
    for i in data:
        if((i!=' ') & (i!='\t') & (i!='\n')):
            temp += i
        elif(len(temp) > 0):
            listedData.append(temp)
            temp = ''
    listedData.append(temp)
    return listedData

def toList_and_cast(data):
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

def search(listed_text):
    res = []
    x=0
    for i in listed_text:        
        if(i[0:2]=="0x"):
            res.append(i[2:])
            x=0
    return res[1::2]

def word_to_byte_list(w):
    w = w[::-1]
    res = []
    x=0
    byteStr=''
    for h in w:
        byteStr=h+byteStr
        x+=1
        if(x>=2):
            res.append(byteStr)
            byteStr=''
            x=0
    return res

def hex_str_to_decimal_int(hexStr):
    hexStr=hexStr[::-1]
    res=0
    exp=0
    decimal=0
    for i in hexStr:
        match i:
            case '0': decimal=0
            case '1': decimal=1
            case '2': decimal=2
            case '3': decimal=3
            case '4': decimal=4
            case '5': decimal=5
            case '6': decimal=6
            case '7': decimal=7
            case '8': decimal=8
            case '9': decimal=9
            case 'a': decimal=10
            case 'A': decimal=10
            case 'b': decimal=11
            case 'B': decimal=11
            case 'c': decimal=12
            case 'C': decimal=12
            case 'd': decimal=13
            case 'D': decimal=13
            case 'e': decimal=14
            case 'E': decimal=14
            case 'f': decimal=15
            case 'F': decimal=15
        res+=decimal*pow(16, exp)
        exp+=1
    return res

def byteStr_list_to_int_list(bl):
    res=[]
    for i in bl:
        res.append(hex_str_to_decimal_int(i))
    return res

def join_lists(l1, l2):
    res = l1
    for i in l2:
        res.append(i)
    return list(res)

def getBytes(instructions):
    bytes = []
    for i in instructions:
        #print("i: ", i)
        a = word_to_byte_list(i)
        #print("a: ", a)

        b = byteStr_list_to_int_list(a)
        #print("b: ", b)

        bytes = join_lists(bytes, b)
        #print()
    return bytes

def format(l):
    res = []
    for i in range(1, len(l), 2):
        res.append(l[i])
        res.append(l[i-1])
    return res

def hex_str_list_to_decimal_int_list(l):
    res = []
    for i in l:
        res.append(hex_str_to_decimal_int(i))
    return res

def writeBytes(data):
    newFile = open("initial_data.bin", "wb")
    newFileByteArray = bytearray(data)
    newFile.write(newFileByteArray)

def int_to_byte_list(value):
    bytesStr="{0:x}".format(value)

    listedBytes = []
    for i in bytesStr:
        listedBytes.append(i)
    listedBytes.reverse()
  
    if(len(listedBytes)%2!=0):
        #impar
        listedBytes.append('0')

    res=[]
    temp = ''
    p=0
    for i in listedBytes:
        if(p<=1):
            temp=i+temp
            p+=1
        if(p==2):
            res.insert(0, temp)
            temp=''
            p=0
    return res

def intToByteListInInts(value):
    return byteStr_list_to_int_list(int_to_byte_list(value))

def int_list_to_byte_list_in_ints(L):
    res = []
    for i in L:
        aux = intToByteListInInts(i)
        if(len(aux) == 1):
            aux = [0, aux[0]]
        for j in aux:
            res.append(j)
    return res

def resize_byte_list(l):
    res = list(l)
    while(len(res)<400):
        res.append(0)
    return res

def get_greater(L):
    if(L == []):
        return "Error in get_greater"
    if(len(L) == 1):
        return L[0]
    
    greater = L[0]
    for i in L[1:]:
        if(i > greater):
            greater = i
    return greater

# def rgb_pixel_unit_vectorize(L):
#     if(L == []):
#         return "Error [1] in: rgb_pixel_unit_vectorize"
#     if(len(L) <= 2):
#         return "Error [2] in: rgb_pixel_unit_vectorize"
    
#     res = 0
#     res = L[0]
#     return greater


def rgb_cube_img_to_grayscale(pic):
    grayscale_pic = []
    for row in pic:
        for pix in row:
            grayscale_pic.append(get_greater(pix))
    return grayscale_pic

def nada(pic):
    _pic = []
    for row in pic:
        for pix in row:
            _pic.append(int(pix))
    return _pic

def view_words(L, limit):
    if(limit!=-1):
        limit *= 4
    word = []
    line = 1
    for i in range(len(L)):
        if(limit > 0 or limit == -1):
            hex = int_to_byte_list(L[i])[0]
            word.append(hex)
            if(len(word)==4):
                print("line: ", line, '\t' , word[3], ' ' , word[2], ' ' , word[1], ' ' , word[0], ' ' , end='\n')
                line+=1
                word=[]
            if(limit != -1):
                limit-=1
    
    for i in word:
        print("###########: ", i)

    




def main():
    sin_table = [0,100,200,300,400,500,600,699,799,899,998,1098,1197,1296,1395,1494,1593,1692,1790,1889,1987,2085,2182,2280,2377,2474,2571,2667,2764,2860,2955,3051,3146,3240,3335,3429,3523,3616,3709,3802,3894,3986,4078,4169,4259,4350,4439,4529,4618,4706,4794,4882,4969,5055,5141,5227,5312,5396,5480,5564,5646,5729,5810,5891,5972,6052,6131,6210,6288,6365,6442,6518,6594,6669,6743,6816,6889,6961,7033,7104,7174,7243,7311,7379,7446,7513,7578,7643,7707,7771,7833,7895,7956,8016,8076,8134,8192,8249,8305,8360,8415,8468,8521,8573,8624,8674,8724,8772,8820,8866,8912,8957,9001,9044,9086,9128,9168,9208,9246,9284,9320,9356,9391,9425,9458,9490,9521,9551,9580,9608,9636,9662,9687,9711,9735,9757,9779,9799,9819,9837,9854,9871,9887,9901,9915,9927,9939,9949,9959,9967,9975,9982,9987,9992,9995,9998,9999,10000]
    sin_table_bytes = int_list_to_byte_list_in_ints(sin_table)

    pic = fileReader('emil.jpg')
    pic = rgb_cube_img_to_grayscale(pic)

    m = 300
    n = 300
    t_4 = 15708
    pad=0

    bytes = sin_table_bytes
    bytes = join_lists(bytes, intToByteListInInts(m))
    bytes = join_lists(bytes, intToByteListInInts(n))
    bytes = join_lists(bytes, intToByteListInInts(t_4))
    bytes = join_lists(bytes, intToByteListInInts(pad))
    bytes = join_lists(bytes, intToByteListInInts(pad))
    bytes = join_lists(bytes, pic)
    bytes = format(bytes)

    # print("len(bytes): ", len(bytes))
    # view_words(bytes, -1)
    # print(len(bytes))
    
    writeBytes(bytes)

if __name__ == "__main__":
    main()
