<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>


<%
request.setCharacterEncoding("UTF-8");
String contentValue=request.getParameter("content_value"); 
String dateValue=request.getParameter("date_value"); 
String timeValue=request.getParameter("time_value"); 

if(!contentValue.isEmpty() && !timeValue.isEmpty() && !dateValue.isEmpty()){
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

    String userIdx = (String)session.getAttribute("idx");

    String sql ="INSERT INTO events (users_idx,content,date,time) VALUES(?,?,?,?);";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1,userIdx);
    query.setString(2,contentValue);
    query.setString(3,dateValue);
    query.setString(4,timeValue);
    query.executeUpdate();
}

%>

<script>
    location.href="main.jsp"
</script>


