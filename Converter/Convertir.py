from PIL import Image
import tkinter as tk
from tkinter import filedialog, messagebox
import numpy as np

# Definir una paleta manual basada en la tabla de colores
palette = [
    (0, 0, 0),        # 0 - Negro
    (0, 0, 255),      # 1 - Azul
    (0, 255, 0),      # 2 - Verde
    (0, 255, 255),    # 3 - Cian
    (255, 0, 0),      # 4 - Rojo
    (255, 0, 255),    # 5 - Púrpura
    (165, 42, 42),    # 6 - Marrón
    (192, 192, 192),  # 7 - Blanco opaco
    (128, 128, 128),  # 8 - Gris
    (173, 216, 230),  # 9 - Azul claro
    (144, 238, 144),  # A - Verde claro
    (135, 206, 250),  # B - Celeste claro
    (240, 128, 128),  # C - Rojo claro
    (255, 182, 193),  # D - Rosado
    (255, 255, 0),    # E - Amarillo
    (255, 255, 255)   # F - Blanco brillante
]

# Obtener el color más cercano de la paleta
def closest_color(rgb):
    r, g, b = rgb
    color_diffs = []
    for color in palette:
        cr, cg, cb = color
        color_diff = np.sqrt((r - cr)**2 + (g - cg)**2 + (b - cb)**2)
        color_diffs.append((color_diff, palette.index(color)))
    return min(color_diffs, key=lambda x: x[0])[1]  # Devuelve el índice del color más cercano

# Convertir BMP a texto
def convert_bmp_to_text(input_image_path, output_text_path):
    try:
        img = Image.open(input_image_path).convert('RGB')  # Convertir la imagen a RGB

        width, height = img.size

        with open(output_text_path, 'w') as f:
            # Recorrer cada píxel de la imagen
            for y in range(height):
                for x in range(width):
                    pixel_value = img.getpixel((x, y))  # Obtener el valor RGB del píxel
                    closest_color_idx = closest_color(pixel_value)  # Obtener el índice del color más cercano
                    hex_value = format(closest_color_idx, 'X')  # Convertir el índice a hexadecimal
                    f.write(hex_value)  # Escribir el valor hexadecimal
                f.write('@\n')  # Fin de la fila

            f.write('%\n')  # Fin de la imagen
        messagebox.showinfo("Conversión Exitosa", f"Imagen convertida y guardada en: {output_text_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

# Convertir texto a BMP
def convert_text_to_bmp(input_text_path, output_image_path, width, height):
    try:
        img = Image.new('RGB', (width, height))  # Crear una nueva imagen
        with open(input_text_path, 'r') as f:
            y = 0
            for line in f:
                if line.strip() == '%':  # Fin de la imagen
                    break
                x = 0
                for char in line.strip().split('@')[0]:
                    if char in '0123456789ABCDEF':  # Si es un valor hexadecimal
                        color_idx = int(char, 16)  # Convertir de hexadecimal a índice
                        img.putpixel((x, y), palette[color_idx])  # Aplicar el color correspondiente
                    x += 1
                y += 1
        img.save(output_image_path)
        messagebox.showinfo("Restauración Exitosa", f"Imagen restaurada y guardada en: {output_image_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

# Seleccionar archivo
def select_file():
    file_path = filedialog.askopenfilename(
        title="Selecciona una imagen BMP",
        filetypes=[("Imágenes BMP", "*.bmp"), ("Todos los archivos", "*.*")]
    )
    return file_path

# Guardar archivo de texto
def save_text_file():
    text_path = filedialog.asksaveasfilename(
        defaultextension=".txt",
        filetypes=[("Texto", "*.txt")],
        title="Guardar archivo de texto"
    )
    return text_path

# Guardar archivo de imagen BMP
def save_image_file():
    image_path = filedialog.asksaveasfilename(
        defaultextension=".bmp",
        filetypes=[("Imágenes BMP", "*.bmp")],
        title="Guardar imagen BMP"
    )
    return image_path

# Función principal
def main():
    root = tk.Tk()
    root.withdraw()

    # Paso 1: Seleccionar archivo BMP
    input_image_path = select_file()
    if not input_image_path:
        return

    # Paso 2: Guardar el archivo de texto convertido
    output_text_path = save_text_file()
    if not output_text_path:
        return

    # Convertir BMP a texto
    convert_bmp_to_text(input_image_path, output_text_path)

    # Paso 3: Restaurar la imagen desde el texto
    output_image_path = save_image_file()
    if not output_image_path:
        return

    # Restaurar texto a BMP
    convert_text_to_bmp(output_text_path, output_image_path, 64, 64)  # Ajusta el tamaño según la imagen original

if __name__ == "__main__":
    main()
