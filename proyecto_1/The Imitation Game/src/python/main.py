"""
; Proyecto #1 Arquitectura de Computadores
;   The Imitation Game:
;   Diseno e Implementacion de un ASIP de desencriptacion mediante RSA
;
; Author: Jose Alejandro Chavarria Madriz
; Email: joalchama@gmail.com
"""

import tkinter as tk
from PIL import ImageTk, Image
from tkinter import filedialog, messagebox, ttk
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
    global result, tic
    input_path = os.path.join(script_dir, 'build/')
    tic = timeit.default_timer()
    result = subprocess.Popen("./rsa_decrypt",cwd=input_path)


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

def update_progressbar():
    """
    It checks if the process is still running, if it is, it waits for 600ms and then calls itself again.
    If it's not, it checks if the process finished successfully, if it did, it displays the decrypted
    image and the time it took to decrypt it, if it didn't, it displays an error message
    :return: the output of the process.
    """
    global tk_img_decrypt
    if result.poll() is None:  # If process is still running
        root.after(600, update_progressbar)
    else:  # If process has finished
        toc = timeit.default_timer()
        output, errors = result.communicate()
        progressbar['value'] = 100
        if result.returncode == 0:
            lbl_time.pack(side=tk.TOP)
            output_path = os.path.join(script_dir, 'build/output.txt')
            txt_to_png(output_path, output_w, output_h, 'output.png')
            input_path = os.path.join(script_dir, 'build/output.png')
            image = Image.open(input_path)
            image = image.resize((480, 320))
            tk_img_decrypt = ImageTk.PhotoImage(image)
            lbl_decrypted.config(image=tk_img_decrypt)
            toc = timeit.default_timer()
            rsa_time = toc - tic
            time_text = f"Decryption done in: {rsa_time:.4f}s"
            lbl_time.config(text=time_text)
            progressbar.pack_forget()
            progressbar['value'] = 0
            print("Program finished successfully")
            print("Program output:", output)
        else:
            progressbar.pack_forget()
            messagebox.showerror("An error occured during the process")
            print("Program error:", errors)
        return
    # Update progressbar value based on process output
    progressbar['value'] += 10


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
    txt_to_png(file, input_w, input_h, "input.png")
    input_path = os.path.join(script_dir, 'build/input.png')
    image = Image.open(input_path)
    image = image.resize((480, 640))
    tk_img_encrypt = ImageTk.PhotoImage(image)
    modify_ui()


def decode_image():
    """
    It takes the values of the d and n entry boxes, generates a key, runs the program, and then displays
    the output image
    """
    d = ent_d.get()
    n = ent_n.get()
    generate_key(d, n)
    run_program()
    progressbar.pack(side=tk.BOTTOM)
    update_progressbar()


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
        lbl_d, ent_d, lbl_n, ent_n, lbl_key, btn_change, lbl_time, progressbar, \
        time_text, script_dir, input_w, input_h, output_w, output_h, root

    # Define some important varibles
    time_text = ""
    script_dir = os.path.dirname(__file__)

    #320x320
    # input_w = 480
    # input_h = 640
    # output_w = 320
    # output_h = 320

    #640x480
    input_w = 640
    input_h = 960
    output_w = 640
    output_h = 480

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
        frm_top, text="The Imitation Game: The ASIP RSA Decoder", font='Arial 17 bold')
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

    #Progressbar
    progressbar = ttk.Progressbar(frm_last_bottom, orient=tk.HORIZONTAL, length=280, mode='determinate')

    # Root mainloop
    root.mainloop()


if __name__ == "__main__":
    main()
