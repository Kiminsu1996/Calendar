<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
  request.setCharacterEncoding("UTF-8");
  
  String Idx = request.getParameter("idx");

  Class.forName("com.mysql.jdbc.Driver"); 
  Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 
  
  String sql ="DELETE FROM events WHERE idx=?;";
  PreparedStatement query = connect.prepareStatement(sql);   
  query.setString(1,Idx);
  query.executeUpdate();

%>

<script>
    location.href="../viewPage/main.jsp"
</script>