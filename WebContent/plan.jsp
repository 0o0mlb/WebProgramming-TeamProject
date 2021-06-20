<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.PreparedStatement" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
   <title>  </title>
   <link rel="stylesheet" type="text/css" href="navigation.css">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
</head>
<body>
<body onload="current_time()">
<%
java.util.Calendar cal=java.util.Calendar.getInstance();            //실제 시간값을 가져온다
int thisyear=cal.get(java.util.Calendar.YEAR);                     //현재 몇년도인지를 가져온다
int thismonth=cal.get(java.util.Calendar.MONTH)+1;                  //현재 몇월인지 가져온다 0~11까지로 표현되므로 1을 더한다.
int thisday=cal.get(java.util.Calendar.DATE);                     //현재 며칠인지 가져온다.
String selyear=request.getParameter("year");
String selmonth=request.getParameter("month");
int year, month;
if(selyear==null&&selmonth==null){
   year=thisyear;
   month=thismonth;
}
else{
   year=Integer.parseInt(selyear);
   month=Integer.parseInt(selmonth);
   if(month<0){
      month=11;
      year=year-1;
   }
   if(month>11){
      month=0;
      year=year+1;
   }
}
%>
<nav>
   <ul>
      <li><a href="monthly.jsp">월별 관리</a></li>
      <li><a href="weekly.jsp">주별 관리</a></li>
      <li><a href="plan.jsp">일정 추가</a></li>
   </ul>
</nav>
<center>
<p align="right"> <%out.print("현재 "+thisyear+"년 "+thismonth+"월 "+thisday+"일 <div id='test'></div>"); %></p>            <!--현재 시간을 출력하는 부분-->
 <form action="memoAdd.jsp" method="post"> 
   내용 : <input type=text size = "50" name=memoContents>
   <input type=submit value="추가"> <p>
   <input type=text name=memoYear size=4>년
   <input type=text name=memoMonth size=2>월
   <input type=text name=memoDay size=2>일
   <br>
   <input type=text name=startHour size=2>시
   <input type=text name=startMinute size=2>분~
   <input type=text name=endHour size=2>시
   <input type=text name=endMinute size=2>분
   </form>
</center>
</body>
</html>