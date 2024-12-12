import json

def add_d1203_to_json(json_path, name_list_string):
    # 이름 리스트 생성
    name_list = [name.strip() for name in name_list_string.split(" ")]

    try:
        # JSON 파일 읽기
        with open(json_path, 'r', encoding='utf-8') as file:
            data = json.load(file)

        # 데이터 수정
        for entry in data:
            entry_name = entry.get("name", "")
            entry["d1203"] = not ( entry_name in name_list )

        # 수정된 데이터 저장
        with open(json_path, 'w', encoding='utf-8') as file:
            json.dump(data, file, ensure_ascii=False, indent=4)

        print(f"파일 '{json_path}'에 'd1203' 값이 성공적으로 추가되었습니다.")

    except Exception as e:
        print(f"오류 발생: {e}")

# 사용 예시
if __name__ == "__main__":
    # JSON 파일 경로와 이름 리스트 입력
    json_file_path = "fruit.json"  # JSON 파일 경로
    names = "김민석 김정호 박범계 박수현 박용갑 안규백 양문석 이광희 이개호 이기헌 이병진 이춘석 장종태 전재수 정동영 추미애 황정아 강대식 강명구 강민국 강선영 강승규 고동진 구자근 권성동 권영세 권영진 김건 김기웅 김기현 김대식 김도읍 김미애 김민전 김상훈 김석기 김선교 김소희 김승수 김예지 김위상 김은혜 김장겸 김정재 김종양 김태호 김희정 나경원 박대출 박덕흠 박상웅 박성민 박성훈 박수영 박준태 박충권 박형수 배준영 배현진 백종헌 서명옥 서일준 서지영 서천호 성일종 송석준 송언석 신동욱 안상훈 안철수 엄태영 유상범 유영하 유용원 윤상현 윤영석 윤재옥 윤종오 윤한홍 이달희 이만희 이상휘 이성권 이양수 이인선 이종배 이종욱 이철규 이헌승 인요한 임이자 임종득 정동만 정점식 정희용 조배숙 조승환 조은희 조정훈 조지연 주호영 진종오 최보윤 최수진 최은석 최형두 추경호 한기호 이준석 이주영"

    add_d1203_to_json(json_file_path, names)