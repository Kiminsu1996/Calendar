<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
request.setCharacterEncoding("UTF-8");
String contentValue = request.getParameter("content_value"); 
String timeValue = request.getParameter("time_value"); 


if(!contentValue.isEmpty() && !timeValue.isEmpty()){
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");
    
    String eventIdx = (String)session.getAttribute("eventIdx");

    String sql =" UPDATE events SET content=? , time=? WHERE idx=?;";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1,contentValue);
    query.setString(2,timeValue);
    query.setString(3,eventIdx);
    query.executeUpdate();
}

%>

<script>
    location.href = "../viewPage/main.jsp"
</script>