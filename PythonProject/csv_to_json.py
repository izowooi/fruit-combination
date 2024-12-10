import csv
import json


def csv_to_json(csv_file_path, json_file_path):
    # JSON 데이터를 담을 리스트
    json_data = []

    # CSV 파일 읽기
    with open(csv_file_path, mode='r', encoding='utf-8') as csv_file:
        csv_reader = csv.DictReader(csv_file)  # CSV를 딕셔너리로 읽음

        for row in csv_reader:
            # 필요한 데이터만 딕셔너리에 추가
            do_it = row["party"] != "국민의힘"

            json_data.append({
                "index": int(row["index"]),
                "22nd": row["22nd"],
                "name": row["name"],
                "party": row["party"],
                "committee": row["committee"],  # 따옴표로 묶인 값도 자동 처리됨
                "region": row["region"],
                "gender": row["gender"],
                "times": row["times"],
                "election": row["election"],
                "en_name": row["en_name"],
                "1207": do_it,
            })

    # JSON 파일로 저장
    with open(json_file_path, mode='w', encoding='utf-8') as json_file:
        json.dump(json_data, json_file, ensure_ascii=False, indent=4)
    print(f"JSON 파일로 변환 완료: {json_file_path}")


# CSV -> JSON 변환 실행
csv_file_path = "member.csv"  # CSV 파일 경로
json_file_path = "member.json"  # 저장할 JSON 파일 경로
csv_to_json(csv_file_path, json_file_path)