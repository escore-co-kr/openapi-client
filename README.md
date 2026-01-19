## Docker Client
### 준비
- Docker
- OpenAPI Account
---
### Docker Image
- Image: `public.ecr.aws/a451j818/escore/openapi`
- Registry: AWS Public ECR
---
### 실행 방법

#### 1. docker-compose.yml 다운로드 
- [openapi-client git 링크](https://github.com/escore-co-kr/openapi-client)
![docker-compose 다운로드](https://escore.co.kr/image/0c12c620-e4ce-4db0-80a1-2ead4b51a13b.png)
![docker-compose 다운로드2](https://escore.co.kr/image/7c98dbc4-74ef-4979-a870-aa24c782fd1c.png)
  - docker-compose.yml을 위 이미지와 같이 다운로드 진행


- [docker-compose.yml 링크](https://github.com/escore-co-kr/openapi-client/blob/master/docker-compose.yml?raw=1)
  - docker-compose.yml으로 저장

#### 2. 별도의 workspace로 저장
- 폴더 기준으로 volume을 잡기 때문에 별도 관리 권고
  ![폴더예시](https://escore.co.kr/image/8582017b-3fea-40df-b169-2210f0d32419.png)

#### 3. OPENAPI API KEY 발급
- https://openapi.escore.co.kr 로그인
  - 계정이 없다면 문의 후 생성, 생성 후 비밀번호 재설정 후 로그인
- API KEY 생성 후 나오는 값 보관![키 발급 예시](https://escore.co.kr/image/f6d2f3a7-abb2-467d-b0b6-b7ea38cfa744.png)
  - 분실시 삭제 후 재발급

#### 4. API KEY 설정 후 실행

##### mac / linux
```bash 
API_KEY=생성한_KEY docker compose up --pull always
```

##### windows
```bash
set API_KEY=생성한_KEY
docker compose up --pull always
```

##### 수동 키 설정
![수동 키 설정](https://escore.co.kr/image/b39f90ec-1d91-443a-b4e6-2ddf0e4f9856.png)
- 생성한_KEY를 코드에 직접 기입

##### 백그라운드 실행 mac / linux 예
```bash 
API_KEY=발급받은_KEY docker compose up --pull always -d
```

---
### 내부 DB 접속 정보
```
HOST:127.0.0.1
PORT:3306
USER:root
PASSWORD:password
```


