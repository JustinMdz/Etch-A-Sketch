from PIL import Image
import tkinter as tk
from tkinter import filedialog, messagebox

def convert_to_16_color_bitmap(input_image_path, output_image_path):
    try:
        # Abrir la imagen
        img = Image.open(input_image_path)
        
        # Convertir la imagen a 16 colores
        img = img.convert('P', palette=Image.ADAPTIVE, colors=16)
        
        # Guardar la imagen en formato BMP
        img.save(output_image_path, format='BMP')

        messagebox.showinfo("Conversión Exitosa", f"Imagen convertida a 16 colores y guardada en: {output_image_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

def select_file():
    # Abrir explorador de archivos para seleccionar una imagen
    file_path = filedialog.askopenfilename(
        title="Selecciona una imagen",
        filetypes=[("Imágenes PNG y JPG", "*.png;*.jpg"), ("Todos los archivos", "*.*")]
    )
    return file_path

def save_file():
    # Abrir explorador de archivos para guardar la imagen convertida
    save_path = filedialog.asksaveasfilename(
        defaultextension=".bmp",
        filetypes=[("Bitmap (BMP)", "*.bmp")],
        title="Guardar como"
    )
    return save_path

def main():
    # Crear ventana raíz oculta
    root = tk.Tk()
    root.withdraw()

    # Seleccionar archivo de imagen
    input_image_path = select_file()
    if not input_image_path:
        return  # Si el usuario cancela la selección, se sale del programa

    # Seleccionar ubicación de guardado
    output_image_path = save_file()
    if not output_image_path:
        return  # Si el usuario cancela el guardado, se sale del programa

    # Convertir la imagen
    convert_to_16_color_bitmap(input_image_path, output_image_path)

if __name__ == "__main__":
    main()
