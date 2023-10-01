<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
  request.setCharacterEncoding("UTF-8");
  
  String eventsIdx = request.getParameter("events_idx");

  Class.forName("com.mysql.jdbc.Driver"); 
  Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 
  
  String sql ="DELETE FROM events WHERE events_idx=?;";
  PreparedStatement query = connect.prepareStatement(sql);   
  query.setString(1,eventsIdx);
  query.executeUpdate();

%>

<script>
    location.href="../viewPage/main.jsp"
</script>