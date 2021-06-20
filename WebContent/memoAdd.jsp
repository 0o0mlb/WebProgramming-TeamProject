<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import ="java.sql.*" %>
<%@page import="java.text.*" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>
</head>
<body>
  <center>
    <h2> 일정이 등록되었습니다. </h2>
      <a href="plan.jsp" value="submit"> 돌아가기 </a>
    </center>
       </body>     
</html> 



<%
	int year =Integer.parseInt(request.getParameter("memoYear"));
	int month =Integer.parseInt(request.getParameter("memoMonth"));
	int day =Integer.parseInt(request.getParameter("memoDay"));
	String content=request.getParameter("memoContents");
	
	int startHour =Integer.parseInt(request.getParameter("startHour"));
	int startMinute =Integer.parseInt(request.getParameter("startMinute"));
	int endHour =Integer.parseInt(request.getParameter("endHour"));
	int endMinute =Integer.parseInt(request.getParameter("endMinute"));

   Connection conn = null;
   Statement stmt = null;
   ResultSet rs = null;
   PreparedStatement ps = null;
   
   try{
      Class.forName("com.mysql.jdbc.Driver"); //mysql의 jdbc 드라이버를 로드
      String jdbcurl = "jdbc:mysql://localhost:3306/cal?serverTimezone=UTC"; //jsp페이지에서 사용할 데이터베이스이름을 포함하는 url을 변수에 저장
      conn = DriverManager.getConnection(jdbcurl,"10team", "0000"); //connection객체를 생성하여 데이터베이스를 연결, 경로/사용자계정/패스워드를 통해 접속
      stmt = conn.createStatement(); //sql문을 실행하기위한 statement객체 생성
      String sql_number = "select count(*) from memo";
      
      String sql = "insert into memo (year, month, day, startHour, startMinute, endHour, endMinute, content) values(?, ?, ?, ?,?,?,?,?)"; //테이블의 모든 열을 검색하는 sql문을 sql변수에 배정
      rs = stmt.executeQuery(sql_number); //sql 검색문을 실행하고 결과를 resultset객체 변수에 저장
      ps = conn.prepareStatement(sql);
      ps.setInt(1, year);
      ps.setInt(2, month);
      ps.setInt(3, day);
      ps.setInt(4, startHour);
      ps.setInt(5, startMinute);
      ps.setInt(6, endHour);
      ps.setInt(7, endMinute);
      ps.setString(8, content);
      ps.executeUpdate();
      
   }
   catch(Exception e) {
      out.println("DB 연동 오류입니다.: " + e.getMessage()); //예외가 발생하면 오류메시지 출력
      }

   stmt.close();
   conn.close();
%>
