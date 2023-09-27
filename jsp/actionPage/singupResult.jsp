<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>


<% 
request.setCharacterEncoding("UTF-8");
String idValue=request.getParameter("id_value"); 
String pwValue=request.getParameter("pw_value"); 
String nameValue=request.getParameter("name_value");
String departmentValue=request.getParameter("department_value"); 
String positionValue=request.getParameter("position_value"); 
String phoneValue=request.getParameter("phone_value"); 

boolean isDuplicate = false;

if(!idValue.isEmpty() && !pwValue.isEmpty() && !nameValue.isEmpty() && !departmentValue.isEmpty() && !positionValue.isEmpty() && !phoneValue.isEmpty()){
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

    String userInfo = "SELECT id FROM users WHERE id=?;";
    PreparedStatement userInfoQuery = connect.prepareStatement(userInfo);
    userInfoQuery.setString(1,idValue); 
    ResultSet userInfoResult = userInfoQuery.executeQuery();
  
    if(userInfoResult.next()){
        isDuplicate = true;
    }else{
        String sql ="INSERT INTO users (id, password,name,department,position,phoneNumber) VALUES(?,?,?,?,?,?);";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1,idValue);
        query.setString(2,pwValue);
        query.setString(3,nameValue);
        query.setString(4,departmentValue);
        query.setString(5,positionValue);
        query.setString(6,phoneValue);
        query.executeUpdate();
    }
}

%>

<script>
    var isDuplicate = <%=isDuplicate%>

    function checkId(){
        if(isDuplicate){
            alert("중복된 아이디 입니다. 변경해주세요.")
            location.href = "../viewPage/singup.jsp"
        }else{
            location.href="../../login.jsp"
        }
    }
        
    window.onload = function(){
        checkId()
    }

</script>
