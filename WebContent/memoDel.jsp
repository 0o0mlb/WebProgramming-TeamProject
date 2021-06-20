<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.time.*"%>
<%@ page import = "java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

<% 
String year = request.getParameter("year");
String month = request.getParameter("month");
String day = request.getParameter("day");

Connection conn= null;
PreparedStatement pstmt = null;
String jdbcurl = "jdbc:mysql://localhost:3306/cal?serverTimezone=UTC";
Class.forName("com.mysql.jdbc.Driver");
conn= DriverManager.getConnection(jdbcurl,"10team", "0000"); 
ResultSet rs = null;

pstmt = conn.prepareStatement("DELETE FROM memo WHERE year= ? and month = ? and day = ?");
pstmt.setString(1, year);
pstmt.setString(2, month);
pstmt.setString(3, day);
pstmt.executeUpdate();

response.sendRedirect("monthly.jsp");
%>
</body>
</html>