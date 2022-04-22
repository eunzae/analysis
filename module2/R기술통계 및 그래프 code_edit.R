
# package 설치하기
install.packages("survival")
install.packages("descr")
install.packages("gdata")
install.packages("tableone")
install.packages("ggplot2")
install.packages("lawstat")

# package 불러오기
library(survival) # 전반적인 survival 분석 및 실습 데이터 사용
library(descr) # CrossTable 생성
library(gdata) # drop.level 함수 사용
library(tableone) # CreateTableOne 함수 사용
library(ggplot2) # graph
library(lawstat) # 등분산성 검정

# package에 내장된 data 확인
data(package="survival")  

# Use survival package 

# 1. 기술통계

# 데이터 형태 및 구조 확인
head(colon) 
str(colon) 
summary(colon)

# 분석에 사용할 데이터 

# event type=사망이면서, treatment가 Lev, Obs인 데이터만 추출
data<-colon[(colon$etype==2) & (colon$rx=="Lev"|colon$rx=="Obs"),] 

# differ에 결측이 존재하여 complete data 를 생성하고 필요한 변수만 가져옴
data<-data[-which(is.na(data$differ)),c("id","rx","sex","age","obstruct","perfor","adhere","nodes","status","differ")] 
dim(data) # 608 행

# unique한 환자번호 개수 확인
length(unique(data$id))  # 608

# 데이터 구조 확인
str(data)

# 범주형 변수 factor 지정
cat<-c("sex","obstruct","perfor","adhere","status","differ")
data[,cat]<-lapply(data[,cat], factor) # vector 단위로 factor화
data$rx<-drop.levels(data$rx) # unused level 삭제
str(data)
head(data)


# 기술통계) 연속형 변수
summary(data$age)
sd(data$age)
mean(data$age) 
median(data$age)
min(data$age)
max(data$age)
quantile(data$age)

# cf) 결측이 있는 경우
a<-c(1,3,4,6,NA,7,8)
mean(a)
mean(a, na.rm=T)
median(a, na.rm=T)

# summary by group
summary(data[data$status==0,"age"]) # 생존한 환자의 나이에 대한 분포
summary(data[data$status==1,"age"]) # 사망한 환자의 나이에 대한 분포

tapply(data$age, data$status, summary) 
aggregate(data$age, list(data$status), summary) 

# 기술통계) 범주형 변수
table(data$sex) # 빈도표
round(prop.table(table(data$sex)),3) # 백분율 

table(data$rx, data$status) # 2*2 빈도표
prop.table(table(data$rx, data$status)) # overall percent
prop.table(table(data$rx, data$status), margin=2) # col percent

# 2. 가설 검정
# 1) t-test
table(data$obstruct)

shapiro.test(data$age) # 정규성 만족하지 않음 
shapiro.test(data[data$obstruct==0,"age"])
shapiro.test(data[data$obstruct==1,"age"])

summary(data[data$obstruct==0,"age"])
sd(data[data$obstruct==0,"age"])

summary(data[data$obstruct==1,"age"])
sd(data[data$obstruct==1,"age"])

hist(data$age, main="Histogram of Age", xlab="Age")
hist(data[data$obstruct==0,"age"], main="Histogram of Age without obstruct", xlab="Age")
hist(data[data$obstruct==1,"age"], main="Histogram of Age with obstruct ", xlab="Age")

var.test(age~obstruct, data=data) # 등분산성 검정
t.test(data[data$obstruct==0,"age"], data[data$obstruct==1,"age"], var.equal=FALSE) # t-test

# 2) wilcoxon rank sum test
wilcox.test(data[data$obstruct==0,"age"], data[data$obstruct==1,"age"])

# 3) Anova
table(data$differ)
levene.test(data$age,data$differ) # 등분산성 검정
mod<-aov(lm(data$age ~ data$differ)) # ANOVA
summary(mod)

kruskal.test(data$age,data$differ) # 참고) kruskal-wallis test 

# 4) Chisq.test
# method 1. 빈도만 알고 있을 때
data_1<-matrix(c(1509,184,1772,49), ncol=2, byrow=T)
colnames(data_1)<-c("no","yes")
rownames(data_1)<-c("A","B")
data_1
chisq.test(data_1) # cf) correct=F (연속성 수정 하지 않을때)

# method 2. 데이터가 있을 때
table(data$adhere, data$sex)
chisq.test(data$adhere, data$sex)
CrossTable(data$adhere, data$sex, expected=T, chisq=T)

# 5) Fisher's test
matrix(c(4,15,1,10),ncol=2,byrow=T)
chisq.test(matrix(c(4,15,1,10),ncol=2,byrow=T))
fisher.test(matrix(c(4,15,1,10),ncol=2,byrow=T))


############## SUMMARY ##############

# 전체 변수에 대한 요약
tab<- CreateTableOne(data=data) 
tab # 카테고리 2개인 변수는 큰값으로 지정된 경우만 보여줌
print(tab, showAllLevels=TRUE) 

# 그룹 별 요약
tab2<-CreateTableOne(data=data,  strata="rx", vars=c("age","sex","obstruct","perfor","adhere","nodes","differ"))

print(tab2, showAllLevels=TRUE) # default로 연속형 변수는 mean, sd 제시하고 t-test 수행, 범주형 변수는 chi-squared test 수행
print(tab2, showAllLevels=TRUE, nonnormal="age", exact="differ") # median (IQR) 제시하고 wilcoxon rank sum test, fisher's exact test 수행 
summary(tab2)

# 동일 결과
var.test(age~rx, data=data)
t.test(data[data$rx=="Lev","age"],data[data$rx=="Obs","age"], var.equal=TRUE)
wilcox.test(data[data$rx=="Lev","age"],data[data$rx=="Obs","age"])

var.test(nodes~rx, data=data)
t.test(data[data$rx=="Lev","nodes"],data[data$rx=="Obs","nodes"], var.equal=TRUE)

chisq.test(data$sex, data$rx)
chisq.test(data$obstruct, data$rx)
chisq.test(data$perfor, data$rx)
chisq.test(data$adhere, data$rx)
chisq.test(data$differ, data$rx)
fisher.test(data$differ, data$rx)

# 3. 그래프
# 1) histogram

hist(data$age, main="Histogram of Age", xlab="Age") # R base function
ggplot(data=data, aes(x=age))+geom_histogram()
diff(range(data$age))/30

# change the binwidth
ggplot(data=data, aes(x=age))+geom_histogram(binwidth=1)
ggplot(data=data, aes(x=age))+geom_histogram(binwidth=3)

# change color 
ggplot(data=data, aes(x=age))+geom_histogram(color="gray", fill="pink")+theme_minimal()

# histogram by group
ggplot(data=data, aes(x=age, fill=sex))+geom_histogram()+theme_minimal()

# change color 
ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(alpha=0.5, position="stack")+
  scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal() # default=누적
ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(alpha=0.5, position="identity")+
  scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal() # 위치조정 없이 (동일 위치)
ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(position="dodge")+
  scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal() # 나란히 

# chagne the position of legend
ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(alpha=0.5, position="identity")+
  scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal()+
  theme(legend.position="bottom")

# change the label of legend
ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(alpha=0.5, position="identity")+
  scale_fill_manual(values=c("#69b3a2", "#404080"), name="Sex",labels=c("Female","Male"))+theme_minimal()+
  theme(legend.position="bottom")


# 2) boxplot
boxplot(nodes~differ, data=data)  # R base function
ggplot(data, aes(x=differ, y=nodes))+geom_boxplot(fill="pink")+
  scale_x_discrete('differ',labels=c("well","moderate","poor"))+theme_minimal() # x축 라벨 변경

sum(is.na(data$nodes)) # miss

# outlier 제거, y축 조정
ggplot(data, aes(x=differ, y=nodes))+geom_boxplot(fill="pink", outlier.shape=NA)+
  scale_y_continuous(limits=c(0,15))+scale_x_discrete('differ',labels=c("well","moderate","poor"))+
  theme_minimal()

# group 별 color 지정
ggplot(data, aes(x=differ, y=nodes, fill=differ))+geom_boxplot(outlier.shape=NA)+
  scale_y_continuous(limits=c(0,15))+scale_x_discrete('differ',labels=c("well","moderate","poor"))+
  scale_fill_discrete(labels=c("well","moderate","poor"))+theme_minimal()

# boxplot 회전
ggplot(data, aes(x=differ, y=nodes, fill=differ))+geom_boxplot(outlier.shape=NA)+
  scale_y_continuous(limits=c(0,15))+scale_x_discrete('differ',labels=c("well","moderate","poor"))+
  scale_fill_discrete(labels=c("well","moderate","poor"))+theme_minimal()+coord_flip()

# 3) bar chart
barplot(table(data$differ))  # R base function
ggplot(data=data,aes(x=differ))+geom_bar(fill="steelblue")+theme_minimal()

# by group
ggplot(data=data,aes(x=differ,fill=sex))+geom_bar(position="dodge")+
  scale_fill_manual(values=c("gray","steelblue"), name="Sex",labels=c("Female","Male"))+
  theme_minimal()+theme(legend.position="bottom") # 나란히

ggplot(data=data,aes(x=differ,fill=sex))+geom_bar(position="fill")+
  scale_fill_manual(values=c("gray","steelblue"), name="Sex",labels=c("Female","Male"))+
  theme_minimal()+theme(legend.position="bottom") # 합이 100%가 되게