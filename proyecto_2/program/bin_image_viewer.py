import PIL.Image as Image
import matplotlib.pyplot as plt


def fileReader(path):
    file = open(path, 'rb')
    data = file.read()
    file.close()
    return data

def format(l):
    res = []
    for i in range(1, len(l), 2):
        res.append(l[i])
        res.append(l[i-1])
    return res


def main():
    #path = "initial_data.bin"
    path = "image_out.bin"
    pic = fileReader(path)
    pic = format(pic)
    #pic = pic[325:] # removes metadata

    pic_out = Image.new('L', (300, 300))
    pic_out.putdata(pic)
    pic_out.save("image_out.jpg")
    # pic_out.save("image_out.jpg", dpi=(76))

    images = [pic_out]

    rows = 1
    cols = 1
    fig = plt.figure(figsize=(8,8))
    for i in range(rows*cols):
        fig.add_subplot(rows, cols, i+1)
        plt.imshow(images[i], cmap='gray')
    fig.show()
    #input()

    pic_out.close()


if __name__ == "__main__":
    main()
