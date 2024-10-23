from PIL import Image
import tkinter as tk
from tkinter import filedialog, messagebox

# Definir una paleta manual basada en la tabla de colores
palette = [
    0, 0, 0,        # 0 - Negro
    0, 0, 255,      # 1 - Azul
    0, 255, 0,      # 2 - Verde
    0, 255, 255,    # 3 - Cian
    255, 0, 0,      # 4 - Rojo
    255, 0, 255,    # 5 - Púrpura
    165, 42, 42,    # 6 - Marrón
    192, 192, 192,  # 7 - Blanco opaco
    128, 128, 128,  # 8 - Gris
    173, 216, 230,  # 9 - Azul claro
    144, 238, 144,  # A - Verde claro
    135, 206, 250,  # B - Celeste claro
    240, 128, 128,  # C - Rojo claro
    255, 182, 193,  # D - Rosado
    255, 255, 0,    # E - Amarillo
    255, 255, 255   # F - Blanco brillante
]

# Convertir una imagen a un archivo de texto con la paleta de colores
def convert_to_custom_format(input_image_path, output_text_path):
    try:
        # Abrir la imagen
        img = Image.open(input_image_path)

        # Aplicar la paleta personalizada
        img = apply_custom_palette(img)

        # Abrir el archivo de salida en modo de escritura
        with open(output_text_path, 'w') as f:
            width, height = img.size

            # Recorrer cada píxel de la imagen
            for y in range(height):
                for x in range(width):
                    pixel_value = img.getpixel((x, y))
                    hex_value = format(pixel_value, 'X')  # Convertir a hexadecimal
                    f.write(hex_value)  # Escribir el valor hexadecimal
                f.write('@\n')  # Agregar el símbolo de fin de fila '@'

            f.write('%\n')  # Agregar el símbolo de fin de imagen '%'

        messagebox.showinfo("Conversión Exitosa", f"Imagen convertida a texto y guardada en: {output_text_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

# Aplicar la paleta personalizada a la imagen
def apply_custom_palette(img):
    # Convertir la imagen a modo RGB si no lo está
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    # Crear una imagen de paleta y aplicar la paleta manual
    palette_img = Image.new('P', (1, 1), 0)
    palette_img.putpalette(palette * 16)  # Aplicar la paleta 16 veces para llenar los 256 valores posibles
    return img.quantize(palette=palette_img)

# Convertir un archivo de texto a una imagen BMP
def convert_text_to_image(input_text_path, output_image_path):
    try:
        # Leer el archivo de texto
        with open(input_text_path, 'r') as f:
            lines = f.readlines()

        # Eliminar el símbolo de fin de imagen (%) de la última línea
        lines = [line.strip() for line in lines if line.strip() != '%']

        # Determinar las dimensiones de la imagen
        height = len(lines)
        width = len(lines[0].replace('@', ''))

        # Crear una nueva imagen en modo 'P' (paleta)
        img = Image.new('P', (width, height))

        # Aplicar la paleta personalizada a la imagen
        img.putpalette(palette * 16)

        # Rellenar la imagen con los valores del archivo de texto
        for y, line in enumerate(lines):
            line = line.replace('@', '')  # Eliminar los símbolos '@'
            for x, hex_value in enumerate(line):
                img.putpixel((x, y), int(hex_value, 16))  # Convertir el valor hexadecimal a un entero

        # Guardar la imagen como BMP
        img.save(output_image_path, format='BMP')

        messagebox.showinfo("Conversión Exitosa", f"Archivo de texto convertido a imagen BMP y guardado en: {output_image_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

# Seleccionar un archivo de imagen
def select_file():
    file_path = filedialog.askopenfilename(
        title="Selecciona una imagen",
        filetypes=[("Imágenes PNG y JPG", "*.png;*.jpg"), ("Todos los archivos", "*.*")]
    )
    return file_path

# Guardar el archivo de texto
def save_text_file():
    text_path = filedialog.asksaveasfilename(
        defaultextension=".txt",
        filetypes=[("Texto", "*.txt")],
        title="Guardar archivo de texto"
    )
    return text_path

# Guardar la imagen BMP
def save_image_file():
    image_path = filedialog.asksaveasfilename(
        defaultextension=".bmp",
        filetypes=[("Bitmap (BMP)", "*.bmp")],
        title="Guardar imagen"
    )
    return image_path

def main():
    # Crear ventana raíz oculta
    root = tk.Tk()
    root.withdraw()

    # Seleccionar archivo de imagen
    input_image_path = select_file()
    if not input_image_path:
        return  # Si el usuario cancela la selección, se sale del programa

    # Seleccionar ubicación de guardado del archivo de texto
    output_text_path = save_text_file()
    if not output_text_path:
        return  # Si el usuario cancela el guardado, se sale del programa

    # Convertir la imagen al formato especificado en el archivo de texto
    convert_to_custom_format(input_image_path, output_text_path)

    # Seleccionar ubicación de guardado de la imagen BMP
    output_image_path = save_image_file()
    if not output_image_path:
        return  # Si el usuario cancela el guardado, se sale del programa

    # Convertir el archivo de texto a imagen BMP
    convert_text_to_image(output_text_path, output_image_path)

if __name__ == "__main__":
    main()
 