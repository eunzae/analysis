##----------------------------------------------------------
# library 설치 예시
##----------------------------------------------------------

install.packages('openxlsx')  # excel파일을 위한 library 설치

##----------------------------------------------------------
# library 이용하기
##----------------------------------------------------------

library (openxlsx)   # openxlsx library 이용


##----------------------------------------------------------
# Object 값 할당 
##----------------------------------------------------------

i <- 2
i
I = "Hello"
I

##----------------------------------------------------------
# Object Type - Scalar type
# Scalar (스칼라) : 단일 차원의 값으로, 데이터의 길이는 1인 벡터
# 1) 숫자 - 정수, 부동 소수 등을 숫자형 (numeric) Type으로 지원 
##----------------------------------------------------------

a <- 3
b <- 4.3
c = a + b

a
b
c

##----------------------------------------------------------
# Object Type - Scalar type
# 2) NA 
# -  R과 다른 언어의 가장 큰 차이점 중 하나가 NA (Not Available) 상수
#   → 데이터 값이 없음을 의미
# - 변수에 NA값이 저장되었는지 is.na()함수를 이용하여 확인
##----------------------------------------------------------

one <- 160
two <- NA
one
two
is.na (one)
is.na (two)

##----------------------------------------------------------
# Object Type - Scalar type
# 3 ) NULL
# NULL은 변수가 초기화 되지 않은 경우 사용
# ****** NA와 구분하여 사용하여야 함 ! 
# NULL과 NA 의 차이 * NA 는 결측치 즉, 값이 부재한 경우
#                   * NULL 은 프로그램의 편의를 위해 미정(undefined) 값을 표현하는 데 사용 
##----------------------------------------------------------

x <- NULL
x
is.null (x)

##----------------------------------------------------------
# Object Type - Scalar type
# 4) 문자열 - 한 개의 문자에 대해서가 아닌 문자열로 표현
#             따옴표 (‘ ‘ 또는 “ “)로 묶음
##----------------------------------------------------------

char <- "Hello"
char
number =  "100"
number

##----------------------------------------------------------
# Object Type - Scalar type
# 5) 논리형 (Logical) - TRUE (참) 또는 FALSE (거짓) 값을 가짐
#                       논리 연산자 & (AND), | (OR) , ! (NOT) 등 이용 가능
##----------------------------------------------------------

logic <- 8 > 10
logic

Logic <- 2==2 # == : 서로 같다 (논리연산자)
Logic

logic & Logic  # And 연산자 : 두 피연산자 모두 TRUE일때만 TRUE값 반환 
logic | Logic  # OR 연산자 : 두 피연산자 중 하나만 TRUE 여도 TRUE값 반환
! logic        # Not 연산자 : 반대 논리값 반환 


##----------------------------------------------------------
# Object Type - Scalar type
# 6 ) Factor - 범주형 데이터를 표현 하기 위한 데이터 type
#    범주형 데이터는 명목형 (Nominal: 값들 간에 비교 불가능한 경우) 과 
#                    순서형(Ordinal: 값에 순서를 둘 수 있는 경우) 으로 구분
##----------------------------------------------------------

gender <- factor ("M", levels = c("M","F"))
gender 
nlevels (gender)
levels (gender)
levels (gender) <- c("Male","Female")
gender
is.factor(gender)

##----------------------------------------------------------
## Object Type - Vector
# 벡터(Vector) : 한가지 스칼라 Object Type의 데이터를 저장 할 수 있음
##----------------------------------------------------------

x <- c(1,2,3)
x
mode (x)   # mode 함수 : vector 의 type확인

y <- c(1,"2",3,4)   # 문자형이 혼합된 경우 벡터 전체가 문자형으로 변경됨 
y
mode (y)

z <- 1:3
z

a <- rep (z, times = 3)   # rep 함수 반복하고자 할때 사용됨 , times 옵션 : 반복 횟수 지정 
a

b <- rep (2, times = 5)
b

c <- rep (2:4 , each = 3)   # each 옵션 : 각각 동일한 횟수로 반복
c

# 벡터에 저장된 요소들의 색인을 이용하여 접근 또는 이름을 지정하여 접근 가능

vector1 <- c (10, 20, 100, 200, 1000)
vector1 [1]           # vector1 의 첫번째 요소
vector1 [-3]          # vector1 의 3번째 요소 제외
vector1 [3:5]         # vector1의 3번째 요소 부터 5번째 요소까지 
vector1 [c (2,5)]     # vector1의 2번째 5번째 요소 
length (vector1)      # length 함수 : vector의 길이 확인

##----------------------------------------------------------
# Object Type -  Matrix
# 행렬 (Matrix) : 2차원으로 구성 되어 있으며, 1가지의 Type으로 구성 
##----------------------------------------------------------

matrix0 <- matrix( 1:9 ,            # 1~9 사이 숫자로 구성된 행렬 
                   nrow = 3,        # nrow 옵션 :행의 수 
                   ncol = 3,        # ncol 옵션 : 열의 수 
                   byrow = TRUE )   # byrow 옵션 : 행 기준으로 값 채우기 

matrix0
dim (matrix0)  # dim 함수 : 함수의 행, 열의 수 확인 
matrix0 [1,]   # matrix0 의 첫 행
matrix0 [,3]   # matrix0 의 3번째 열
matrix0 [2,2]  # matrix0의 2행 2열의 값 


##----------------------------------------------------------
# Object Type - Data frame
# 데이터프레임 (data frame)
# - 2차원 으로 구성 되어 있으며, 여러 가지의 Type으로 구성 가능
#   자연스럽게 데이터를 표현할 수 있어, R 에서 가장 중요한 데이터 타입으로 사용
##----------------------------------------------------------

height = c(165, 155, 170, 180)
sex <- c('F','F', 'M','M')
people <- data.frame( height , sex )  

people $ height   # people 데이터의 height 값들 확인 
people [,1]       # people 데이터의 1번째 열의 값들 확인 
people [, "height"]  # people 데이터의 height 값들 확인 
people [1,]         # people 데이터의 1번째 행의 값들 확인 
names (people)      #  names 함수 : 데이터의 변수 이름 확인

##----------------------------------------------------------
# Object Type - tibble (참고용)
##----------------------------------------------------------
# 외부 데이터를 불러오거나 R 라이브러리 데이터 중 최근 생성된 데이터 타입으로
# 앞서 설명된 데이터프레임과 같은 2차원 구조의 데이터 
install.packages('readxl')
library (readxl)
remission_xlsx = read_excel("remission.xlsx")
remission_xlsx
# 데이터 구조 n*p : 몇행  몇열로 구성되었는지
# 각 변수의 이름 아래에 <dbl>, <chr>, <int> 라는 라벨로 변수의 형태 확인 가능 

##----------------------------------------------------------
# 데이터 불러 오기 
# 저장된 파일 (CSV, TXT, XLSX 등) 을 이용하고자 하는 경우 
#  확인사항 
# 1. 파일 디렉토리 확인 
# 2. 파일 확장자명 확인 (=> 파일 형태에 따라 사용되는 함수 상이함 ; CSV, TXT, XLSX 등)

##----------------------------------------------------------
# 1) CSV 파일 불러오기
# csv 파일 : csv 파일(comma-separated values) - 몇 가지 필드를 쉼표(,)로 구분한 텍스트 데이터 및 텍스트 파일
# read.csv 함수 : csv확장자를 가지는 경우의 데이터를 불러오기위해 사용됨
##----------------------------------------------------------

# 디렉토리 저장 없이 데이터 불러오기 
remission  <- read.csv ('C:\\2022_Rdata\\remission.csv', header = TRUE)

# header = TRUE 옵션은 첫행에 변수명이 존재 하는 경우 
#                      첫행은 데이터가 아닌 변수명임을 지정 하기 위한 옵션


### 주의 사항 ###################################################
# * Directory 지정 시 유의 사항
#   R프로그램은 Unix/Linux와 동일하게 “/”으로 directory를 구분
##################################################################

## getwd 함수 : working directory 확인 
getwd ()  # working directory를 지정 하지 않았다면 Default 값을 출력

## setwd 함수 :  working directory 지정 
setwd ('C:/2022_Rdata/')
getwd () # 지정된 디렉토리 확인 

# 이미 working directory  지정 되어 파일 명과 확장자만 기재
remission_csv <- read.csv('remission.csv', header = T)

##----------------------------------------------------------
# 2) Excel 파일 불러오기
# xlsx 와 같이 EXCEL파일들의 경우 
# R에서 기본 함수로는 사용이 불가하여 ‘openxlsx’ package의 설치 필수
##----------------------------------------------------------

install.packages('openxlsx') # excel 파일 불러오기 위한 library 설치 (처음 1번만 설치)

library (openxlsx)   # 설치한 openxlsx package이용

remission_xlsx = read.xlsx("remission.xlsx", sheet =1)


##----------------------------------------------------------
# 데이터 확인 하기 
# 파일을 이용하여 불러들여온 데이터 파일의 구성 확인
##----------------------------------------------------------

# 1) 데이터의 앞/뒤 확인
head ( remission_csv  ) # 데이터의 1행~6행 확인  
tail ( remission_csv )  # 데이터 맨 끝의 6행 확인

# 2) 데이터의 차원(행 또는 열의 수) 와 변수이름 확인
dim (remission_csv )    #  데이터의 차원 확인 
names (remission_csv )  #   데이터 내 변수이름 확인 

# 3 ) 데이터 구조 확인
str (remission_csv)

# 4 ) 변수 형태 변경 
# str함수를 이용하여 변수의 형태를 확인
# 데이터 코딩시 숫자로 되어 있던 값들에 label을 지정하여 범주형 변수로 지정하고자 할때 사용

remission_csv $ gender_new <- factor(remission_csv $ gender , labels = c("M","F"))
str (remission_csv)


##----------------------------------------------------------
# 데이터 요약 하기 
# summary 함수 :  데이터에 포함된 변수들의 기술 통계량으로 변수의 결측 치와 분포 확인 
# summary 함수 이용 
# summary (데이터명)	⇒ 데이터의 모든 변수들의 요약 값들을 출력
# summary (변수명)	⇒  변수 하나의 요약 값을 출력
# summary (모델)	⇒  모델의 결과를 출력
##--------------------------------------------------------

summary (remission_csv)


##----------------------------------------------------------
# 데이터 병합
##----------------------------------------------------------

# remission_csv 데이터에 merge 함수를 이용하여 데이터 병합

# 데이터 아래와 같이 생성
hospital_data <- data.frame( ID = c(1,5,9,28,37),
                             center = c("liver","breast","lung","blood","Thyriod"))
hospital_data

# merge 함수 이용하여 데이터 병합 : 동일 Key값을 이용 
remission_merge <- merge( remission_csv , hospital_data, by='ID' ) # 동일 Key인 ID 이용 병합

remission_merge

# merge 함수 이용하여 left join: 동일 Key값을 이용 
remission_left <- merge( x= remission_csv , y= hospital_data, by='ID', # 동일 Key인 ID 이용 병합
                          all.x = TRUE )  # x데이터는 모두 포함되도록 !

remission_left

##----------------------------------------------------------
# 데이터 정렬하기 
##----------------------------------------------------------
remission_merge

remission_order <- remission_merge [order(remission_merge$time) , ]  # remission_merge$time 오름 차순
remission_order

remission_merge
remission_order1 <- remission_merge [order(-remission_merge$lWBC) , ]  # remission_merge$lWBC 내림 차순
remission_order1


##----------------------------------------------------------
# 데이터 내보내기 
##----------------------------------------------------------
# csv 파일로 내보내기
write.csv(remission_left,                     # 내보내고자 하는 데이터 이름 
          'C:/2022_Rdata/remission_left.csv', # 파일 명 (디렉토리지정 하지 않았으면 디렉토리 포함)
          row.names = FALSE)                  # row.names = FALSE: R 데이터의 경우 행의 이름이 숫자로 지정됨
                                              #                    행 번호를 제외 하여 파일 생성

# xlsx 파일로 내보내기
write.xlsx(remission_left,                      #내보내고자 하는 데이터 이름
           'C:/2022_Rdata/remission_left.xlsx', # xlsx file name 
           rowNames= FALSE  )                   # 저장시 row 명 포함 여부(TRUE or FALSE)
