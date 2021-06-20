<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.PreparedStatement" %>
<%@page import ="java.util.Date" %>
<%@page import ="java.util.Calendar" %>
<%@page import ="java.text.*" %>
<!DOCTYPE html>
<html>
<head>
<script>
function current_time(){
	var day = new Date();
	var h = day.getHours();
	var m = day.getMinutes();
	var s = day.getSeconds();
	m = setting(m);
	s = setting(s);
	document.getElementById('clock').innerHTML = h+":"+m+":"+s;
	var t = setTimeout(function(){current_time()},1000);
}

function setting(i){
	if(i<10) {i = "0" + i};
	return i;
}
</script>
<meta charset="utf-8">
	<title>  </title>
<link rel="stylesheet" type="text/css" href="navigation.css">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<%
String selyear = request.getParameter("year");
String selmonth = request.getParameter("month");
String selday = request.getParameter("day");
int year, month, day;

String seldate = request.getParameter("date");
String date;

if(selyear==null&&selmonth==null&&selday==null){
	year = 2020;
	month = 11;
	day = 6;
}
else{
    year=Integer.parseInt(selyear);
    month=Integer.parseInt(selmonth);
    day=Integer.parseInt(selday);
    if(day>31 && (month==0||month==2||month==4||month==6||month==7||month==9||month==11)){
    	day=day-31;
    	month++;
    }
    if(day>30 && (month==3||month==5||month==8||month==10)){
    	day=day-30;
    	month++;
    }
    if(day>28 && month==1){
    	day=day-28;
    	month++;
    }
    if(day<0 && (month==4||month==6||month==9||month==11)){
    	day=day+30;
    	month--;
    }
    if(day<0 && (month==0||month==1||month==3||month==5||month==7||month==8||month==10)){
    	day=day+31;
    	month--;
    }
    if(day<0 && month==2){
    	day=day+29;
    	month--;
    }
    if(month<0){
       month=11;
       year=year-1;
    }
    if(month>11){
       month=0;
       year=year+1;
    }
}

Date now = new Date(year, month, day);
Date next = new Date(year-1900, month, day);
Calendar cal = Calendar.getInstance();

if(seldate==null)
	date = "20201206";
else
	date = seldate;

year = now.getYear();
month = now.getMonth() + 1;
day = now.getDate();

SimpleDateFormat format = new SimpleDateFormat("yyyy년 MM월 dd일");
cal.setTime(next);

cal.add(Calendar.DATE, 6);

int nyear = next.getYear();
int nmonth = next.getMonth() + 1;
int nday = next.getDate();

date = format.format(cal.getTime());

%>
</head>
<body onload="current_time()">
<nav>
	<ul>
		<li><a href="monthly.jsp">월별 관리</a></li>
		<li><a href="weekly.jsp">주별 관리</a></li>
		<li><a href="plan.jsp">일정 추가</a></li>
	</ul>
</nav>
<nav background-color:red>
</nav>
<center>
<p>
<table> 
	<tr>
		<td align=center width=420>
		<a href="weekly.jsp?year=<%out.print(year);%>&month=<%out.print(month-1);%>&day=<%out.print(day-7);%>">＜</a>
		<%
		if(month<10 && day>9)
			out.print(year + "년 0" + month + "월 " + day + "일 - " + date);
		else if(day<10 && month>9)
			out.print(year + "년 " + month + "월 0" + day + "일 - " + date);
		else if(month<10 && day<10)
			out.print(year + "년 0" + month + "월 0" + day + "일 - " + date);
		else
			out.print(year + "년 " + month + "월 " + day + "일 - " + date);
		%>
		<a href="weekly.jsp?year=<%out.print(year);%>&month=<%out.print(month-1);%>&day=<%out.print(day+7);%>">＞</a>
		</td>
		<td align=right width=240>
		<%
		  java.util.Calendar cal2=java.util.Calendar.getInstance();            //실제 시간값을 가져온다
		  int thisyear=cal2.get(java.util.Calendar.YEAR);                     //현재 몇년도인지를 가져온다
		  int thismonth=cal2.get(java.util.Calendar.MONTH)+1;                  //현재 몇월인지 가져온다 0~11까지로 표현되므로 1을 더한다.
		  int thisday=cal2.get(java.util.Calendar.DATE); 
		%>
		<%out.print("현재 "+thisyear+"년 "+thismonth+"월 "+thisday+"일 <div id='clock' style='display:inline'></div>"); %>	<!--현재 시간을 출력하는 부분-->
		</td>
</table>
</p>
<table border="0" cellspacing="1" cellpadding="1">
<tr bgcolor=gray>
	<td width=110 align="center">구분</td>
	<td width=110 align="center">일</td>
	<td width=110 align="center">월 </td>
	<td width=110 align="center">화 </td>
	<td width=110 align="center">수 </td>
	<td width=110 align="center">목 </td>
	<td width=110 align="center">금 </td>
	<td width=110 align="center">토 </td>
<tr>
<%													//구분 쪽 시간을 30분간격으로 입력하기 위한 부분
String half;										//**:00인지 **:30인지를 판단하여 입력하기 위한 문자열

int sun=0, mon=0, tue=0, wed=0, thu=0, fri=0, sat=0;
for(int i = 0; i < 48; i++){
	out.print("<tr bgcolor='#c9c9c9'>");
	for(int j = 0; j < 8; j++){
		if(i % 2 == 1)
			half = "30";
		else
			half = "00";
		
		if(j == 0){							//구분 쪽 테이블에는 시간을 출력한다.
			if(i/2 < 10)
				out.print("<td width=110 align='center'>0"+i/2+":"+half+"</td>");
			else
				out.print("<td width=110 align='center'>"+i/2+":"+half+"</td>");
		}									
		else{
			if(sun>1 && j==1){
				sun--;
				continue;
			}
			else if(mon>1 && j==2){
				mon--;
				continue;
			}
			else if(tue>1 && j==3){
				tue--;
				continue;
			}
			else if(wed>1 && j==4){
				wed--;
				continue;
			}
			else if(thu>1 && j==5){
				thu--;
				continue;
			}
			else if(fri>1 && j==6){
				fri--;
				continue;
			}
			else if(sat>1 && j==7){
				sat--;
				continue;
			}
			else{
			out.println("<td");
			 Connection conn= null;
			  PreparedStatement pstmt = null;
			  String jdbcurl = "jdbc:mysql://localhost:3306/cal?serverTimezone=UTC";
			  Class.forName("com.mysql.jdbc.Driver");
			  conn= DriverManager.getConnection(jdbcurl,"10team", "0000");
			  
			  int memoyear = 0, memomonth = 0, memoday = 0, memostartHour = 0, memostartMinute = 0, memoendHour = 0, memoendMinute = 0;
			  
			 try{
				  
			       String sql = "SELECT year, month, day, startHour, startMinute, endHour, endMinute, content FROM memo";
			       pstmt= conn.prepareStatement(sql);
			       ResultSet rs= pstmt.executeQuery();
			       while (rs.next()) {
			        memoyear=rs.getInt("year");
			        memomonth=rs.getInt("month");
			        memoday=rs.getInt("day");
			        memostartHour=rs.getInt("startHour");
			        memostartMinute=rs.getInt("startMinute");
			        memoendHour=rs.getInt("endHour");
			        memoendMinute=rs.getInt("endMinute");
			        
			        if((month == memomonth) && (memoday-day+1 == j) && (memostartHour*2 == i) && (memostartMinute == Integer.parseInt(half))){
			        	int col;
			        	col = (memoendHour-memostartHour)*2;
			        	if(memoendMinute-memostartMinute>0)
			        		col++;
			        	if(memoendMinute-memostartMinute<0)
			        		col--;
			        		
			        	out.println(" rowspan=" + col + " bgcolor=#ffff00>"+rs.getString("content"));
			        	
			        	if(j == 1)
			        		sun = col;
			        	else if(j == 2)
			        		mon = col;
			        	else if(j == 3)
			        		tue = col;
			        	else if(j == 4)
			        		wed = col;
			        	else if(j == 5)
			        		thu = col;
			        	else if(j == 6)
			        		fri = col;
			        	else
			        		sat = col;
			        }
			        else if((month == memomonth) && (memoday-day+1 == j) && (memostartHour*2+1 == i) && (memostartMinute == Integer.parseInt(half))){
			        	int col;
			        	col = (memoendHour-memostartHour)*2;
			        	if(memoendMinute-memostartMinute>0)
			        		col++;
			        	if(memoendMinute-memostartMinute<0)
			        		col--;
			        		
			        	out.println(" rowspan=" + col + ">"+rs.getString("content"));
			        	
			        	if(j == 1)
			        		sun = col;
			        	else if(j == 2)
			        		mon = col;
			        	else if(j == 3)
			        		tue = col;
			        	else if(j == 4)
			        		wed = col;
			        	else if(j == 5)
			        		thu = col;
			        	else if(j == 6)
			        		fri = col;
			        	else
			        		sat = col;
			        }
			        else{
			        	
			        }
			        	
			       }
			       out.println("</td>");
			       
			       rs.close();
			       pstmt.close();
			       conn.close();
			      }
			      catch(Exception e) {
			       System.out.println(e);
			      };
			}
			
		}
	}
	

}
%>
</table>
</body>
</html>