## 데이터분석응용통계 과제

### 팀원

**2조**

- 201904008 곽재원

- 202004029 송영우

- 202104216 백종민

<br>

### 주제

공공자전거 이용량과 날씨 간의 상관분석

> Correlation analysis between public bicycle usage and weather

<br>

### 사용 데이터

본 분석에서는 두 가지의 데이터셋을 사용합니다. 두 데이터 모두 2022년 7월 ~ 2022년 12월 자료를 사용합니다.

##### 1. "서울시 공공자전거 대여 이력"

공공자전거 이용률을 알아보기 위해 "서울시 공공자전거 대여 이력" 정보를 사용합니다.

본 데이터 세트의 https://data.seoul.go.kr/dataList/OA-15182/F/1/datasetView.do 홈페이지에서 CSV 파일을 다운로드 후 사용할 수 있습니다.

##### 2. "종관기상관측(ASOS)" 자료 수집

날씨 데이터를 사용하기 위해 본 데이터셋을 사용합니다.

본 데이터 세트의 https://data.kma.go.kr/data/grnd/selectAsosRltmList.do?pgmNo=36&tabNo=1 홈페이지에서 CSV 파일을 내려받은 후 사용할 수 있습니다.

<br>

### 파일 설명

##### 데이터 전처리

- **date_by_rent.R** : 각 날짜에 따른 대여 횟수 측정.

- **station_by_rent.R** : 각 대여소에 따른 대여 횟수 측정.

- **trans_rent_info.R** : 각 날짜와 대여소에 따른 대여 횟수 측정(설명 주석 제거)

- **weather_extract.R** : 날씨 데이터 전처리 및 변수 추출.

##### 모델 생성

- **Ir.R** : 선형 모델 생성.

##### 데이터 시각화

- **rent_by_age.R** : 각 나이에 따른 대여 횟수 시각화.

- **rent_by_hour.R** : 각 시간대에 따른 대여 횟수 시각화.

- **rent_by_week.R** : 각 주차에 따른 대여 횟수 시각화

##### 기타(본 발표에서 사용되지 않았음)

- **pls_selected.R** : PLS 모델 생성
