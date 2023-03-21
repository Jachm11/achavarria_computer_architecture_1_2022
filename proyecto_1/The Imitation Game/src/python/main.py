import tkinter as tk
from PIL import ImageTk, Image
from tkinter import filedialog, messagebox
import subprocess
import timeit
import os
from shutil import copy2

#       ________________
# _____/ Logic functions


def run_program():
    """
    It runs the x86 program, captures the output, and prints it to the console
    """
    tic = timeit.default_timer()
    input_path = os.path.join(script_dir, 'build/')
    result = subprocess.run("./rsa_decrypt",cwd=input_path, capture_output=True)
    toc = timeit.default_timer()
    rsa_time = toc - tic
    time_text = f"Decryption done in: {rsa_time:.4f}s"
    lbl_time.config(text=time_text)
    if result.returncode == 0:
        print("Program finished successfully")
        print("Program output:", result.stdout)
    else:
        print("Program failed with error code", result.returncode)
        print("Program error message:", result.stderr)


def txt_to_png(txt_file, width, height, output_file):
    """
    It reads the grayscale values from the text file, creates a new image, and then sets the pixel
    values of the image to the grayscale values

    :param txt_file: the path to the text file containing the grayscale values
    :param width: the width of the image
    :param height: the height of the image in pixels
    :param output_file: The name of the output file
    """
    with open(txt_file, "r") as f:
        grayscale_values = f.read().split(" ")
        if f.name == os.path.join(script_dir, 'build/output.txt'):
            grayscale_values = grayscale_values[1:]
    img = Image.new("L", (width, height))
    for y in range(height):
        for x in range(width):
            pixel_value = int(grayscale_values[y * width + x])
            img.putpixel((x, y), pixel_value)
    save_at = os.path.join(script_dir, 'build/' + output_file)
    img.save(save_at)


def make_key_txt(num1, num2, filename):
    """
    It takes two numbers and a filename, and writes the two numbers to the file

    :param num1: The first number in the key
    :param num2: the number of characters in the key
    :param filename: the name of the file to be build
    """
    with open(filename, "w") as file:
        file.write(f"{num1} {num2}")

# _____________________________________________________________

#       _______________
# _____/ GUI functions


def modify_ui():
    """
    It changes the UI to show the user that the file has been encrypted
    """
    lbl_encrypted.config(image=tk_img_encrypt)
    btn_open.pack_forget()
    btn_decode.pack(side=tk.BOTTOM, pady=20)
    lbl_key.pack(side=tk.TOP)
    lbl_equation.pack(side=tk.TOP)
    lbl_d.pack(side=tk.LEFT)
    ent_d.pack(side=tk.LEFT)
    lbl_n.pack(side=tk.RIGHT)
    ent_n.pack(side=tk.RIGHT)
    btn_change.pack(side=tk.BOTTOM, pady=40)


def open_txt():
    """
    It opens a file dialog, converts the file to a png, and then displays it in the GUI
    """
    global tk_img_encrypt
    file = filedialog.askopenfilename(title="Select txt")
    target_dir = os.path.join(script_dir, 'build/')
    copy2(file, target_dir+"input.txt")
    txt_to_png(file, 320, 640, "input.png")
    input_path = os.path.join(script_dir, 'build/input.png')
    image = Image.open(input_path)
    tk_img_encrypt = ImageTk.PhotoImage(image)
    modify_ui()


def decode_image():
    """
    It takes the values of the d and n entry boxes, generates a key, runs the program, and then displays
    the output image
    """
    global tk_img_decrypt
    d = ent_d.get()
    n = ent_n.get()
    generate_key(d, n)
    run_program()
    lbl_time.pack(side=tk.TOP)
    output_path = os.path.join(script_dir, 'build/output.txt')
    txt_to_png(output_path, output_w, output_h, 'output.png')
    input_path = os.path.join(script_dir, 'build/output.png')
    image = Image.open(input_path)
    tk_img_decrypt = ImageTk.PhotoImage(image)
    lbl_decrypted.config(image=tk_img_decrypt)


def generate_key(d, n):
    """
    It takes in two numbers, d and n, and creates a key.txt file with the numbers in it

    :param d: The private key
    :param n: The modulus for both the public and private keys. It must be a positive integer, and is
    typically a large number
    """
    try:
        d = int(d)
        n = int(n)
    except:
        messagebox.showerror("Private key error",
                             "Error: A valid number key must be provided")
        raise ValueError

    if d == 0:
        messagebox.showerror("Private key error", "Error: d cannot be 0")
        raise ValueError

    elif not (256 < n < 65536):
        messagebox.showerror("Private key error",
                             "Error: n must be a value between 257 65535")
        raise ValueError
    output_path = os.path.join(script_dir, 'build/key.txt')
    make_key_txt(d, n, output_path)

# _____________________________________________________________


def main():
    global lbl_encrypted, lbl_decrypted, btn_open, btn_decode, lbl_equation, \
        lbl_d, ent_d, lbl_n, ent_n, lbl_key, btn_change, lbl_time, \
        time_text, script_dir, input_w, input_h, output_w,output_h

    # Define some important varibles
    time_text = ""
    script_dir = os.path.dirname(__file__)

    #320x320
    input_w = 480
    input_h = 640
    output_w = 320
    output_h = 320

    #640x480
    # input_w = 640
    # input_h = 960
    # output_w = 640
    # output_h = 480

    # Configure root
    root = tk.Tk()
    root.minsize(320, 320)
    root.columnconfigure(1, weight=1, minsize=320)
    root.rowconfigure(4, weight=1, minsize=90)
    root.title("The Imitation Game")

    # Configure frames
    frm_top = tk.Frame(root)
    frm_top.grid(row=0, column=1)
    frm_mid = tk.Frame(root)
    frm_mid.grid(row=1, column=1)
    frm_bottom = tk.Frame(root)
    frm_bottom.grid(row=2, column=1)
    frm_last_bottom = tk.Frame(root)
    frm_last_bottom.grid(row=3, column=1)

    # Show tittle
    lbl_tittle = tk.Label(
        frm_top, text="The Imitation Game: The ASIP RSV Decoder", font='Arial 17 bold')
    lbl_tittle.pack()

    # Image labels
    lbl_encrypted = tk.Label(frm_top)
    lbl_encrypted.pack(side=tk.LEFT)
    lbl_decrypted = tk.Label(frm_top)
    lbl_decrypted.pack(side=tk.RIGHT)

    # Load equation image
    img_path = os.path.join(script_dir, 'assets/equation.png')
    equation_img = Image.open(img_path)
    equation_img = equation_img.resize((200, 70))
    equation_img = ImageTk.PhotoImage(equation_img)

    # Buttons
    btn_open = tk.Button(frm_bottom, text="Select .txt", command=open_txt)
    btn_open.pack(side=tk.TOP)
    btn_decode = tk.Button(
        frm_bottom, text="Decode image", command=decode_image)
    btn_change = tk.Button(
        frm_last_bottom, text="Change .txt", command=open_txt)

    # Labels
    lbl_key = tk.Label(frm_mid, text="Please enter the RSA key values")
    lbl_equation = tk.Label(frm_mid)
    lbl_equation.config(image=equation_img)
    lbl_d = tk.Label(frm_mid, text="Enter d value")
    lbl_n = tk.Label(frm_mid, text="Enter n value")
    lbl_time = tk.Label(frm_last_bottom, text=time_text)

    # Entries
    ent_d = tk.Entry(frm_bottom)
    ent_n = tk.Entry(frm_bottom)

    # Root mainloop
    root.mainloop()


if __name__ == "__main__":
    main()
