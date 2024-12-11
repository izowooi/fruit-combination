import json

def add_d1203_to_json(json_path, name_list_string):
    # 이름 리스트 생성
    name_list = [name.strip() for name in name_list_string.split(",")]

    try:
        # JSON 파일 읽기
        with open(json_path, 'r', encoding='utf-8') as file:
            data = json.load(file)

        # 데이터 수정
        for entry in data:
            entry_name = entry.get("name", "")
            entry["d1203"] = entry_name in name_list

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
    names = "강경숙, 강득구, 강선우, 강준헌, 강훈식, 곽상언, 권향엽, 김교흠, 김기표, 김남근, 김남희, 김동아, 김병주, 김선민, 김성회, 김영배, 김영진, 김용만, 김우영, 김훈, 김윤덕, 김제원, 김종민, 김주영, 김준형, 김현, 김현정, 남인순, 노종면, 맹성규, 문금주, 문정복, 문진석, 민병덕, 민형배, 민홍척, 박균택, 박민겨, 박상혁, 박선원, 박성준, 박은정, 박정, 박정현, 박주민, 박지혜, 박찬대, 박홍근, 박흠배, 박희승, 백승아, 백혜련, 복기와, 부승찬, 서미화, 서삼석, 서영교, 서영석, 서황진, 소병훈, 손명수, 송기헌, 송재봉, 신장식, 신정훈, 안도걸, 안태준, 양부남, 이기구, 염태염, 오기형, 용혜인, 위성곤, 윤건영, 윤호중, 윤후덕, 이건태, 이상식, 이성윤, 이소영, 이수진, 이언주, 이용선, 이용우, 이원택, 이제강, 이제관, 이재명, 이재정, 이학영, 이혜민, 임광현, 임미애, 임오오경, 장철민, 전용기, 전종덕, 전진숙, 전현희, 정성호, 정을호, 정일영, 정준호, 정진욱, 정청래, 정춘생, 정태호, 정혜경, 조계원, 조국, 조승래, 주철현, 진선미, 진성준, 차규근, 차지호, 채현일, 천준호, 천하람, 최기상, 한민수, 한병도, 한정애, 한준호, 한창민, 허성무, 허영, 허종식, 황명선, 황운하, 황희, 곽규택, 김상욱, 김성원, 김용태, 김재섭, 김형동, 박수민, 박정하, 박정훈, 서범수, 신성범, 우재준, 장동혁, 정성국, 정연욱, 조경태, 주진우, 한지아"  # 이름 리스트

    add_d1203_to_json(json_file_path, names)