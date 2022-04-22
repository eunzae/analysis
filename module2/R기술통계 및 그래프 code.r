
# package ��ġ�ϱ�
 install.packages("survival")
 install.packages("descr")
 install.packages("gdata")
 install.packages("tableone")
 install.packages("ggplot2")
 install.packages("lawstat")

# package �ҷ�����
 library(survival) # �������� survival �м� �� �ǽ� ������ ���
 library(descr) # CrossTable ����
 library(gdata) # drop.level �Լ� ���
 library(tableone) # CreateTableOne �Լ� ���
 library(ggplot2) # graph
 library(lawstat) # ��л꼺 ����

# package�� ����� data Ȯ��
 data(package="survival")  

# Use survival package 

# 1. ������

# ������ ���� �� ���� Ȯ��
 head(colon) 
 str(colon) 
 summary(colon)

# �м��� ����� ������ 

# event type=����̸鼭, treatment�� Lev, Obs�� �����͸� ����
 data<-colon[(colon$etype==2) & (colon$rx=="Lev"|colon$rx=="Obs"),] 

# differ�� ������ �����Ͽ� complete data �� �����ϰ� �ʿ��� ������ ������
 data<-data[-which(is.na(data$differ)),c("id","rx","sex","age","obstruct","perfor","adhere","nodes","status","differ")] 
 dim(data) # 608 ��

# unique�� ȯ�ڹ�ȣ ���� Ȯ��
 length(unique(data$id))  # 608

# ������ ���� Ȯ��
 str(data)

# ������ ���� factor ����
 cat<-c("sex","obstruct","perfor","adhere","status","differ")
 data[,cat]<-lapply(data[,cat], factor) # vector ������ factorȭ
 data$rx<-drop.levels(data$rx) # unused level ����
 str(data)
 head(data)


# ������) ������ ����
 summary(data$age)
 sd(data$age)
 mean(data$age) 
 median(data$age)
 min(data$age)
 max(data$age)
 quantile(data$age)

# cf) ������ �ִ� ���
 a<-c(1,3,4,6,NA,7,8)
 mean(a)
 mean(a, na.rm=T)
 median(a, na.rm=T)

# summary by group
 summary(data[data$status==0,"age"]) # ������ ȯ���� ���̿� ���� ����
 summary(data[data$status==1,"age"]) # ����� ȯ���� ���̿� ���� ����

 tapply(data$age, data$status, summary) 
 aggregate(data$age, list(data$status), summary) 

# ������) ������ ����
 table(data$sex) # ��ǥ
 round(prop.table(table(data$sex)),3) # ����� 
 
 table(data$rx, data$status) # 2*2 ��ǥ
 prop.table(table(data$rx, data$status)) # overall percent
 prop.table(table(data$rx, data$status), margin=2) # col percent

# 2. ���� ����
# 1) t-test
 table(data$obstruct)

 shapiro.test(data$age) # ���Լ� �������� ���� 
 shapiro.test(data[data$obstruct==0,"age"])
 shapiro.test(data[data$obstruct==1,"age"])

 summary(data[data$obstruct==0,"age"])
 sd(data[data$obstruct==0,"age"])

 summary(data[data$obstruct==1,"age"])
 sd(data[data$obstruct==1,"age"])

 hist(data$age, main="Histogram of Age", xlab="Age")
 hist(data[data$obstruct==0,"age"], main="Histogram of Age without obstruct", xlab="Age")
 hist(data[data$obstruct==1,"age"], main="Histogram of Age with obstruct ", xlab="Age")

 var.test(age~obstruct, data=data) # ��л꼺 ����
 t.test(data[data$obstruct==0,"age"], data[data$obstruct==1,"age"], var.equal=FALSE) # t-test

# 2) wilcoxon rank sum test
 wilcox.test(data[data$obstruct==0,"age"], data[data$obstruct==1,"age"])

# 3) Anova
 table(data$differ)
 levene.test(data$age,data$differ) # ��л꼺 ����
 mod<-aov(lm(data$age ~ data$differ)) # ANOVA
 summary(mod)

 kruskal.test(data$age,data$differ) # ����) kruskal-wallis test 
  
# 4) Chisq.test
# method 1. �󵵸� �˰� ���� ��
 data_1<-matrix(c(1509,184,1772,49), ncol=2, byrow=T)
 colnames(data_1)<-c("no","yes")
 rownames(data_1)<-c("A","B")
 data_1
 chisq.test(data_1) # cf) correct=F (���Ӽ� ���� ���� ������)

# method 2. �����Ͱ� ���� ��
 table(data$adhere, data$sex)
 chisq.test(data$adhere, data$sex)
 CrossTable(data$adhere, data$sex, expected=T, chisq=T)

# 5) Fisher's test
 matrix(c(4,15,1,10),ncol=2,byrow=T)
 chisq.test(matrix(c(4,15,1,10),ncol=2,byrow=T))
 fisher.test(matrix(c(4,15,1,10),ncol=2,byrow=T))


############## SUMMARY ##############

# ��ü ������ ���� ���
 tab<- CreateTableOne(data=data) 
 tab # ī�װ� 2���� ������ ū������ ������ ��츸 ������
 print(tab, showAllLevels=TRUE) 

# �׷� �� ���
 tab2<-CreateTableOne(data=data,  strata="rx", vars=c("age","sex","obstruct","perfor","adhere","nodes","differ"))

 print(tab2, showAllLevels=TRUE) # default�� ������ ������ mean, sd �����ϰ� t-test ����, ������ ������ chi-squared test ����
 print(tab2, showAllLevels=TRUE, nonnormal="age", exact="differ") # median (IQR) �����ϰ� wilcoxon rank sum test, fisher's exact test ���� 
 summary(tab2)

# ���� ���
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

# 3. �׷���
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
 scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal() # default=����
 ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(alpha=0.5, position="identity")+
 scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal() # ��ġ���� ���� (���� ��ġ)
 ggplot(data=data, aes(x=age, fill=sex))+geom_histogram(position="dodge")+
 scale_fill_manual(values=c("#69b3a2", "#404080"))+theme_minimal() # ������ 

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
 scale_x_discrete('differ',labels=c("well","moderate","poor"))+theme_minimal() # x�� �� ����

 sum(is.na(data$nodes)) # miss

# outlier ����, y�� ����
 ggplot(data, aes(x=differ, y=nodes))+geom_boxplot(fill="pink", outlier.shape=NA)+
 scale_y_continuous(limits=c(0,15))+scale_x_discrete('differ',labels=c("well","moderate","poor"))+
 theme_minimal()

# group �� color ����
 ggplot(data, aes(x=differ, y=nodes, fill=differ))+geom_boxplot(outlier.shape=NA)+
 scale_y_continuous(limits=c(0,15))+scale_x_discrete('differ',labels=c("well","moderate","poor"))+
 scale_fill_discrete(labels=c("well","moderate","poor"))+theme_minimal()

# boxplot ȸ��
 ggplot(data, aes(x=differ, y=nodes, fill=differ))+geom_boxplot(outlier.shape=NA)+
 scale_y_continuous(limits=c(0,15))+scale_x_discrete('differ',labels=c("well","moderate","poor"))+
 scale_fill_discrete(labels=c("well","moderate","poor"))+theme_minimal()+coord_flip()

# 3) bar chart
 barplot(table(data$differ))  # R base function
 ggplot(data=data,aes(x=differ))+geom_bar(fill="steelblue")+theme_minimal()

# by group
 ggplot(data=data,aes(x=differ,fill=sex))+geom_bar(position="dodge")+
 scale_fill_manual(values=c("gray","steelblue"), name="Sex",labels=c("Female","Male"))+
 theme_minimal()+theme(legend.position="bottom") # ������
 
 ggplot(data=data,aes(x=differ,fill=sex))+geom_bar(position="fill")+
 scale_fill_manual(values=c("gray","steelblue"), name="Sex",labels=c("Female","Male"))+
 theme_minimal()+theme(legend.position="bottom") # ���� 100%�� �ǰ�




