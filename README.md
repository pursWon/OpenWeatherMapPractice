# OpenWeatherMapPractice

여러 나라 도시의 현재 날씨와 앞으로의 4일 동안의 날씨 예보를 볼 수 있는 앱

<div align="center">

https://github.com/pursWon/OpenWeatherMapPractice/assets/99719661/fe01667c-da81-47ef-ac4e-0f32a64acd71

</div>

## 배운 점 

- `OpenWeather API`를 사용하는 법
- `Escaping Closure` 사용하여 값을 외부에서 저장하고 사용하는 방법
- 받아온 데이터를 고차함수 `filter`를 통해 원하는 데이터만 추출하여 보여주는 법
- `MVVM` 패턴을 사용하는 법

## 사용한 API 

- `OpenWeatherMap`

## 사용한 라이브러리 

- `Alamofire`

## 업데이트 사항 

- 도시 이름을 검색해서 다른 나라의 현재 날씨를 보여주게끔 설정
- `tableView`를 터치했을 때, 움직이지 않도록 설정

## 트러블 슈팅

- 문제점 : `ViewModel`내의 현재 날씨 데이터를 가져오는 함수안에서 값으로 밖으로 꺼내서 반환하는 방법을 찾지 못했음

- 문제 해결 시도 : 처음에는 반환을 통해서 값을 추출하려했으나,
  `Alamofire`의 데이터 실행 함수안에서 값을 밖으로 꺼내서, 반환시키는 방법을 찾지 못했음. 
  외부의 변수에 값을 저장한 후, 반환시키는 방법도 시도해봤으나 잘못된 값을 반환시켰음.    

- 문제 해결 방법 : 그래서, 찾아낸 방법이 탈출 클로저(`Escaping Closure`)였음
    - 탈출 클로저를 사용해서 날씨 데이터를 `ViewModel`내의 함수에서 처리한 후에 `Controller`에서 해당 함수를 실행시키고 함수가 반환된 후에
    탈출 클로저를 사용하여 안정적으로 값을 받아올 수 있었음
    - 탈출 클로저를 이용하여 받아온 데이터를 홈 화면에서 보여지게끔 설정
