import os
from PIL import Image


def create_output_folder(input_folder):
    """출력 폴더를 생성하고 경로를 반환."""
    output_folder = os.path.join(input_folder, "out")
    os.makedirs(output_folder, exist_ok=True)
    return output_folder


def is_valid_image(file_path, valid_extensions):
    """파일이 유효한 이미지인지 확인."""
    _, ext = os.path.splitext(file_path)
    return ext.lower() in valid_extensions


def resize_image(img, max_size=1024):
    """이미지를 크기 조정."""
    width, height = img.size
    max_side = max(width, height)
    if max_side > max_size:
        scale_factor = max_size / max_side
        new_width = int(width * scale_factor)
        new_height = int(height * scale_factor)
        return img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    return img


def process_image(file_path, output_path, max_size=1024):
    """이미지를 열고 크기를 조정한 후 저장."""
    with Image.open(file_path) as img:
        # RGBA 모드를 RGB로 변환
        if img.mode == "RGBA":
            img = img.convert("RGB")

        resized_img = resize_image(img, max_size)
        resized_img.save(output_path)
        print(f"Resized and saved: {output_path}")


def resize_images(input_folder, max_size=1024):
    """폴더 내의 이미지를 크기 조정."""
    valid_extensions = {".png", ".jpeg", ".jpg"}
    output_folder = create_output_folder(input_folder)

    for filename in os.listdir(input_folder):
        file_path = os.path.join(input_folder, filename)
        if os.path.isfile(file_path) and is_valid_image(file_path, valid_extensions):
            output_path = os.path.join(output_folder, filename)
            try:
                process_image(file_path, output_path, max_size)
            except Exception as e:
                print(f"Failed to process {file_path}: {e}")
        else:
            print(f"Skipped (not a valid image): {file_path}")


if __name__ == "__main__":
    folder_path = 'images/portrait'
    if os.path.isdir(folder_path):
        resize_images(folder_path)
    else:
        print("Invalid folder path.")