######## 자습서 3

print("Hellow Python")

#. 주석은 '#'으로 시작하면 주석


#. 문자열 앞에 r을 붙이면 \ 특수기호를 무시할 수 있음. 
print("C:\some\name")
print(r"C:\some\name")

#. 다음과같이 멀티라인 입력도 가능하고 이때 엔터는 개행으로 인식된다. 
print("""
      이런식으로 여러줄 입력 가능
      문자열 여러줄 입력 
      테스트
      """)

#. 문자열 연산에서 *를 사용하면 문자열이 반복되고 +를 사용하면 문자열을 결합 할 수 있다. 
print("test" * 3 + "number")

#. 다음처럼 + 생략해도 문자열이 결합된다. 
print("test" "number")

#. 변수안에 텍스트가 있고 이를 배열형태로 접근가능 +영억은 first부터 시작, -범위는 last부터 시작
text = "Array Idx Test"
print(text[0])      #. First
print(text[-1])     #. Last

#. 배열 인덱스 안에 :을 사용하면 Range표현이 가능
print(text[0:2])    #. Idx 0 <= result < 2 
print(text[-3:])    #. Idx ~ Last -3지점부터 끝까지
print(text[:-3])    #. First ~ Idx
print(text[2:500])  #. 범위 넘어서는건 알아서 처리됨. (에러x)

#. 범위 접근 사용해서 문자열 치환 가능 
# text[5:] = "TTT"
# print(text)       #. JavaScript처럼 인터프리터 언어라서 그런지 도중에 에러 발생시 바로 중단됨. 아래 처리문 실행 안됨.

#. 문자열 길이 
print(len(text))

#. + 연산을 통해서 배열 결합 가능
numberArray = [1, 5, 20, 500]
print([5, 5, 5] + numberArray)

#. append함수를 활용해서 뒤에 추가
numberArray.append(2000)
print(numberArray)

#. ** 연산은 제곱 연산
addingNumber = 5 ** 3 #. 5 * 5 * 5 
numberArray.append(addingNumber)
print(numberArray)

#. 파이썬은 타입 고정 배열이 아님. 문자열도 들어가는걸 볼 수 있다. 
numberArray.append("test")
print(numberArray)

#. 범위를 활용해서 replace 또는 제거 가능
numberArray[0:2] = []
print(numberArray)

#. 0:2 하면 0~1까지의 인덱싱이지만 다음처럼 4개의 배열도 집어넣을수 있게된다. 
numberArray[0:2] =[1, 2, 3, 4]
print(numberArray)

#. 배열 전체 초기화
numberArray[:] = []
print(numberArray)

#. 2차원 배열 
dimensionArray = []
dimensionArray.append(numberArray)
dimensionArray.append([1, 2, 3])
print(dimensionArray)

#. 2차원 배열에서 내부에 배열이 아닌 일반 값이 들어갈때는?
dimensionArray.append(5)
print(dimensionArray)

#. ,로 구분해서 넣으면 뒤에 띄어쓰기로 구분되어서 출력된다.
print(dimensionArray, 0, 5)

######## 자습서 4
