<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
request.setCharacterEncoding("UTF-8");
  
String idx = request.getParameter("idx");

Class.forName("com.mysql.jdbc.Driver"); 
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 

//로그인한 사람의 정보를 찾는 쿼리문 date를 가져오기 위해서 사용
String myContentSql = "SELECT * FROM events WHERE idx=?;";
PreparedStatement myContentQuery = connect.prepareStatement(myContentSql);
myContentQuery.setString(1,idx);
ResultSet myContentSqlResult = myContentQuery.executeQuery();

ArrayList dateEvent = new ArrayList<String>();

while(myContentSqlResult.next()){
    String dateData = "\"" + myContentSqlResult.getString(4) + "\"";
    dateEvent.add(dateData); 
}

//로그인 한 사람의 일정을 삭제하는 쿼리문
String sql ="DELETE FROM events WHERE idx=?;";
PreparedStatement query = connect.prepareStatement(sql);   
query.setString(1,idx);
query.executeUpdate();

%>

<script>
    var dateEvent = <%=dateEvent%>
    var dateToString = dateEvent.toString()
    var sliceDateEvent = dateToString.split('-')

    var year = parseInt(sliceDateEvent[0])
    var month = parseInt(sliceDateEvent[1])

    location.href="../viewPage/main.jsp?year=" + year + "&month=" + month
</script>