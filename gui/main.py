import tkinter as tk
from PIL import ImageTk, Image
from tkinter import filedialog, messagebox
import subprocess
import timeit

def run_program():
    tic=timeit.default_timer()
    result = subprocess.run("./x86", capture_output=True)
    toc=timeit.default_timer()
    rsa_time = toc - tic
    if result.returncode == 0:
        print("Program finished successfully")
        print("Program output:", result.stdout)
    else:
        print("Program failed with error code", result.returncode)
        print("Program error message:", result.stderr)

def txt_to_png(txt_file, width, height, output_file):
    # Open the text file and read the grayscale values
    with open(txt_file, 'r') as f:
        grayscale_values = f.read().split(" ")
        if (f.name == "output.txt"):
            grayscale_values = grayscale_values[1:]

    # Create a new image with the specified width and height
    img = Image.new('L', (width, height))

    # # Set the pixel values for the image
    for y in range(height):
        for x in range(width):
            pixel_value = int(grayscale_values[y*width + x])
            img.putpixel((x, y), pixel_value)

    # Save the image as a PNG file
    img.save(output_file)

def modify_ui():
    lbl_encrypted.config(image=tk_img_encrypt)  # Update the label image
    btn_open.pack_forget()  # Hide the "Open image" button
    btn_decode.pack(side=tk.BOTTOM,pady=20)  # Show the "Decode" button
    lbl_key.pack(side=tk.TOP)
    lbl_equation.pack(side=tk.TOP)
    lbl_d.pack(side=tk.LEFT)
    ent_d.pack(side=tk.LEFT)
    lbl_n.pack(side=tk.RIGHT)
    ent_n.pack(side=tk.RIGHT)
    btn_change.pack(side=tk.BOTTOM,pady=40)


def open_image():
    global tk_img_encrypt
    file = filedialog.askopenfilename(title="Select txt")
    txt_to_png(file, 320, 640, 'input.png')
    image = Image.open('input.png')
    # image = image.resize((400, 400))  # Resize the image
    # Convert to Tkinter-compatible object
    tk_img_encrypt = ImageTk.PhotoImage(image)
    modify_ui()


def make_key_txt(num1, num2, filename):
    with open(filename, 'w') as file:
        file.write(f"{num1} {num2}")

def generate_key(d,n):

    try: 
        d = int(d)
        n = int(n)
    except:
        messagebox.showerror('Private key error', 'Error: A valid number key must be provided')
        raise ValueError

    if(d == 0):
        messagebox.showerror('Private key error', 'Error: d cannot be 0')
        raise ValueError
    
    elif( not (256 < n < 65536)):
        messagebox.showerror('Private key error', 'Error: n must be a value between 257 65535')
        raise ValueError
    
    make_key_txt(d,n,"key.txt")




# Function to open an image file using a file dialog
def decode_image():
    global tk_img_decrypt

    d = ent_d.get()
    n = ent_n.get()

    generate_key(d,n)


    run_program()

    txt_to_png('output.txt', 320, 320, 'output.png')
    image = Image.open('output.png')
    # image = image.resize((400, 400))  # Resize the image
    # Convert to Tkinter-compatible object
    tk_img_decrypt = ImageTk.PhotoImage(image)
    lbl_decrypted.config(image=tk_img_decrypt)  # Update the label image
    # open_button.pack_forget()  # Hide the "Open image" button
    # decode_button.pack_()  # Show the "Decode" button

def main():

    global lbl_encrypted,lbl_decrypted, btn_open, btn_decode,lbl_equation, \
        lbl_d, ent_d,lbl_n,ent_n, lbl_key, btn_change

    # Create a Tkinter window
    root = tk.Tk()
    root.minsize(320, 320)

    root.columnconfigure(1, weight=1, minsize=320)
    root.rowconfigure(4,weight=1, minsize=90)

    frm_top = tk.Frame(root)
    frm_top.grid(row=0, column=1)

    frm_mid = tk.Frame(root)
    frm_mid.grid(row=1, column=1)

    frm_bottom = tk.Frame(root)
    frm_bottom.grid(row=2, column=1)

    frm_last_bottom = tk.Frame(root)
    frm_last_bottom.grid(row=3, column=1)

    lbl_tittle = tk.Label(frm_top, text="The Imitation Game: The ASIP RSV Decoder", font='Arial 17 bold')
    lbl_tittle.pack()

    # Create a label to display the image
    lbl_encrypted = tk.Label(frm_top)
    lbl_encrypted.pack(side=tk.LEFT)

    # Create a label to display the image
    lbl_decrypted = tk.Label(frm_top)
    lbl_decrypted.pack(side=tk.RIGHT)

    # Create a button to open the txt file
    btn_open = tk.Button(frm_bottom, text="Select .txt", command=open_image)
    btn_open.pack(side=tk.TOP)

    # Create a button to start decoding
    btn_decode = tk.Button(frm_bottom, text="Decode image", command=decode_image)
    btn_decode.pack_forget()  # Hide the "Decode image" button initially


    btn_change = tk.Button(frm_last_bottom, text="Change .txt", command=open_image)
    btn_change.pack_forget()

    #
    lbl_key = tk.Label(frm_mid, text="Please enter the RSA key values")
    lbl_equation = tk.Label(frm_mid)
    lbl_equation.pack_forget()
    image = Image.open('equation.png')
    image = image.resize((200, 70))  # Resize the image
    image = ImageTk.PhotoImage(image)
    lbl_equation.config(image=image)  # Update the label image

    lbl_d = tk.Label(frm_mid, text="Enter d value")
    lbl_d.pack_forget()
    ent_d = tk.Entry(frm_bottom)
    ent_d.pack_forget()
    lbl_n = tk.Label(frm_mid, text="Enter n value")
    lbl_n.pack_forget()
    ent_n = tk.Entry(frm_bottom)
    ent_n.pack_forget()

    # Run the Tkinter event loop
    root.mainloop()


if __name__ == "__main__":
    main()
