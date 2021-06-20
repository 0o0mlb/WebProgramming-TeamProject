<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.time.*"%>
<%@ page import = "java.time.format.DateTimeFormatter"%>
<%
request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>

  <%
  Connection conn= null;
  PreparedStatement pstmt = null;
  String jdbcurl = "jdbc:mysql://localhost:3306/cal?serverTimezone=UTC";
  Class.forName("com.mysql.jdbc.Driver");
  conn= DriverManager.getConnection(jdbcurl,"10team", "0000");
  
  int memoyear = 0, memomonth = 0, memoday = 0, memostartHour = 0, memostartMinute = 0, memoendHour = 0, memoendMinute = 0;
   String memocontent = null;
  if (conn== null) {
   out.println("No connection is made!");
  }
  %>
<html>
<head>
<meta charset="utf-8">
   <title>  </title>
<link rel="stylesheet" type="text/css" href="navigation.css">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<script>
function current_time(){
   var day = new Date();
   var h = day.getHours();
   var m = day.getMinutes();
   var s = day.getSeconds();
   m = setting(m);
   s = setting(s);
   document.getElementById('test').innerHTML = h+":"+m+":"+s;
   var t = setTimeout(function(){current_time()},1000);
}

function setting(i){
   if(i<10) {i = "0" + i};
   return i;
}
</script>
</head>
 <body onload="current_time()">
  <%
  java.util.Calendar cal=java.util.Calendar.getInstance();            //실제 시간값을 가져온다
  int thisyear=cal.get(java.util.Calendar.YEAR);                     //현재 몇년도인지를 가져온다
  int thismonth=cal.get(java.util.Calendar.MONTH);                  //현재 몇월인지 가져온다 0~11까지로 표현되므로 1을 더한다.
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
<table> 
   <tr>
      <td align=left width=190>
      <a href="monthly.jsp?year=<%out.print(year-1);%>&month=<%out.print(month);%>">＜</a>
      <%out.print(year); %>년
      <a href="monthly.jsp?year=<%out.print(year+1);%>&month=<%out.print(month);%>">＞</a>
      </td>
      <td align=center width=420>
      <a href="monthly.jsp?year=<%out.print(year);%>&month=<%out.print(month-1);%>">＜</a>
      <%out.print(month+1); %>월
      <a href="monthly.jsp?year=<%out.print(year);%>&month=<%out.print(month+1);%>">＞</a>
      </td>
      <td align=right width=240>
      <%out.print("현재 "+thisyear+"년 "+(thismonth+1)+"월 "+thisday+"일 <div id='test'></div>"); %>            <!--현재 시간을 출력하는 부분-->
      </td>
</table>
<table border="0" cellspacing="1" cellpadding="1">
<tr bgcolor=gray>
   <td width=110><div align=center><font color=red>일</font></div></td>               <!-- 달력에서 맨위 요일을 표현하는 부분 -->
   <td width=110><div align=center>월</div></td>
   <td width=110><div align=center>화</div></td>
   <td width=110><div align=center>수</div></td>
   <td width=110><div align=center>목</div></td>
   <td width=110><div align=center>금</div></td>
   <td width=110><div align=center>토</div></td>
</tr>
<tr height=100 bgcolor=#c9c9c9>
   <%
   cal.set(year, month, 1); //날짜를 설정한다. 위에서 설정한 값들이 들어간다.
   int startDay=cal.get(java.util.Calendar.DAY_OF_WEEK); //현재 요일을 가져온다.(일요일은 1 토요일은 7)
   int end=cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH); //현재 월의 마지막 일을 가져온다.
   int br=0;
   for(int i=0; i<(startDay-1); i++) {
    out.println("<td>&nbsp;</td>");
    br++;
    if((br%7)==0) {
     out.println("<br>");
    }
   }
   for(int i=1; i<=end; i++) {
    out.println("<td>" + i + "<br>");
     // int memoyear, memomonth, memoday;
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
        memocontent=rs.getString("content");
        
        if(year==memoyear && month+1==memomonth && i==memoday) {
         out.println(rs.getString("content")+"<br>"); %>
         
         <button type ="button" onclick="location.href='memoDel.jsp?year=<%=memoyear%>&month=<%=memomonth%>&day=<%=memoday%>'">
         </button>
        
         <% 
        }
       }
       rs.close();
      }
      catch(Exception e) {
       System.out.println(e);
      };
    out.println("</td>");
    br++;
    if((br%7)==0 && i!=end) {
     out.println("</tr><tr height=100 bgcolor=#c9c9c9>");
    }
   }
   while((br++)%7!=0)
    out.println("<td>&nbsp;</td>");
   %>
   </tr>
  </table>
  </center>  
  

  
  <%  
  
  if(memoyear != 0 ){
  LocalDate date = LocalDate.now();
  LocalDateTime dateTime = LocalDateTime.now();
  LocalDate date2 = date.plusDays(3);    //2일 이내에 일정이 있으면 표시
  
  String ys = Integer.toString(memoyear);
  String ms = Integer.toString(memomonth);
  String ds = Integer.toString(memoday);
  
  if(ds.length() == 1)
  {ds = 0 + ds;}
  String result = ys+"-"+ms+"-"+ds;   
  LocalDate memod = LocalDate.parse(result, DateTimeFormatter.ISO_DATE);  
  
  if(memod.isBefore(date2)) {
  
  %>

<div id="sidebar" class="w3-card w3-display-right">
예약하신 일정 <%= memocontent %>이  <%= memod %>에 시작됩니다. 
</div>

<%}}%>
  
 </body>
</html>
   <%
       pstmt.close();
       conn.close();
   %>