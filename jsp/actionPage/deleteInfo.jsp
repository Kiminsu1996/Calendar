<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
Class.forName("com.mysql.jdbc.Driver");
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

String idx = (String)session.getAttribute("idx");

//나의 모든 일정 게시물 지우는 쿼리문
String deleteMySchedule ="DELETE FROM events WHERE users_idx=?;"; 
PreparedStatement deleteMyScheduleQuery = connect.prepareStatement(deleteMySchedule); 
deleteMyScheduleQuery.setString(1,idx);
deleteMyScheduleQuery.executeUpdate();

// 나의 정보 지우는 쿼리문
String deleteMyInfo ="DELETE FROM users WHERE idx=?;"; 
PreparedStatement deleteMyInfoQuery = connect.prepareStatement(deleteMyInfo); 
deleteMyInfoQuery.setString(1,idx);
deleteMyInfoQuery.executeUpdate();

session.invalidate();
%>


<script>
    location.href ="../../login.jsp"
</script>