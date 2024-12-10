import requests
import os
from bs4 import BeautifulSoup

# 파일 설정
input_file = "member.txt"
output_dir = "./images/"  # 이미지를 저장할 디렉토리
error_log_file = "error_log.txt"

# 헤더 설정
headers = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
    )
}

# 이미지 저장 함수
def save_image(image_url, output_path):
    try:
        img_response = requests.get(image_url, headers=headers)
        img_response.raise_for_status()  # 이미지 다운로드 에러 처리
        with open(output_path, "wb") as file:
            file.write(img_response.content)
        print(f"이미지 저장 완료: {output_path}")
    except Exception as e:
        print(f"이미지 저장 실패: {e}")

# 에러 로그 기록 함수
def log_error(index, name, error):
    with open(error_log_file, "a") as log_file:
        log_file.write(f"Index {index}: {name} - {error}\n")
    print(f"에러 기록: Index {index}, Name {name}, Error {error}")

# main 함수
def main():
    with open(input_file, "r", encoding="utf-8") as file:
        names = file.readlines()  # 모든 라인을 읽음

    index = 1  # 인덱스 시작값
    for name in names:
        name = name.strip()  # 이름의 공백 제거
        url = f"https://www.assembly.go.kr/members/22nd/{name}"  # URL 구성
        output_path = f"{output_dir}fruit_{index:03d}.jpg"

        if os.path.exists(output_path):
            print(f"이미지 이미 존재: {output_path}")
            index += 1
            continue
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()  # HTTP 요청 에러 처리

            # HTML 파싱 및 이미지 URL 추출
            soup = BeautifulSoup(response.text, "html.parser")
            selector = "#containers > div.info_content.info_content_st2 > div > div.info-set > div.info-con.present > span > span"
            element = soup.select_one(selector)

            if element and "style" in element.attrs:
                style_content = element["style"]
                start = style_content.find("url('") + len("url('")
                end = style_content.find("')", start)
                image_url = style_content[start:end]
                full_image_url = f"https://www.assembly.go.kr{image_url}" if image_url.startswith("/") else image_url

                # 이미지 저장

                save_image(full_image_url, output_path)
            else:
                log_error(index, name, "이미지 URL 추출 실패")
        except Exception as e:
            log_error(index, name, str(e))  # 에러 기록
        finally:
            index += 1  # 인덱스 증가

if __name__ == "__main__":
    main()