<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
request.setCharacterEncoding("UTF-8");
String idValue = request.getParameter("id_value"); 
String pwValue = request.getParameter("pw_value"); 
String nameValue = request.getParameter("name_value"); 
String departmentValue = request.getParameter("department_value"); 
String positionValue = request.getParameter("position_value"); 
String phoneValue = request.getParameter("phone_value"); 

boolean isDuplicate = false;

if(!idValue.isEmpty() && !pwValue.isEmpty() && !nameValue.isEmpty() && !departmentValue.isEmpty() && !positionValue.isEmpty() && !phoneValue.isEmpty()){

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

    String idx= (String)session.getAttribute("idx");

    String userInfo = "SELECT id FROM users WHERE id=?;"; 
    PreparedStatement userInfoQuery = connect.prepareStatement(userInfo);
    userInfoQuery.setString(1,idValue); 
    ResultSet userInfoResult = userInfoQuery.executeQuery();

    if(!userInfoResult.next()){
        String sql =" UPDATE users SET id=? , password=? , name=? , department=? , position=? , phonenumber=?  WHERE idx=?;"; // 여기에 NOT id=? 이런식으로 수정해줘야 된다.
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1,idValue);
        query.setString(2,pwValue);
        query.setString(3,nameValue);
        query.setString(4,departmentValue);
        query.setString(5,positionValue);
        query.setString(6,phoneValue);
        query.setString(7,idx);
        query.executeUpdate();
    }else{
        isDuplicate = true;
    } 
    // 본인의 아이디는 포함되지 않게 체크하기 쿼리문 수정 
}

%>

<script>
    var isDuplicate = <%=isDuplicate%>
        
    if(isDuplicate) {
        alert("중복된 아이디 입니다.")
        location.href = "../viewPage/userInfo.jsp"
    }else {
        location.href = "../../login.jsp"
    }
</script>
