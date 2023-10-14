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

String idx = (String)session.getAttribute("idx");

boolean isDuplicateId = false;
boolean isDuplicatePh = false;

if(idx == null || idx.isEmpty()){
    response.sendRedirect("../../login.jsp");
}

if(!idValue.isEmpty() && !pwValue.isEmpty() && !nameValue.isEmpty() && !departmentValue.isEmpty() && !positionValue.isEmpty() && !phoneValue.isEmpty()){

    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

   
    String userInfo = "SELECT * FROM users WHERE idx=?;"; 
    PreparedStatement userInfoQuery = connect.prepareStatement(userInfo);
    userInfoQuery.setString(1,idx); 
    ResultSet userInfoResult = userInfoQuery.executeQuery();

    while(userInfoResult.next()){  
        String userIdData = userInfoResult.getString(2); 
        String userPhonenumberData = userInfoResult.getString(7); 

        //아이디와, 전화번호 수정하지 않고 이외의 것을 수정하면   
        if(phoneValue.equals(userPhonenumberData) && idValue.equals(userIdData)){
            String sql =" UPDATE users SET password=? , name=? , department=? , position=? WHERE idx=?;"; 
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1,pwValue);
            query.setString(2,nameValue);
            query.setString(3,departmentValue);
            query.setString(4,positionValue);
            query.setString(5,idx);
            query.executeUpdate();

        }

        //전화번호를 수정하려고 하면 
        if(!phoneValue.equals(userPhonenumberData)){
            
            String userInfos = "SELECT phonenumber FROM users WHERE phonenumber=?;"; 
            PreparedStatement userInfosQuery = connect.prepareStatement(userInfos); 
            userInfosQuery.setString(1,phoneValue);
            ResultSet userInfosResult = userInfosQuery.executeQuery();

            //중복된 번호가 없으면 
            if(!userInfosResult.next()){
                String sqls =" UPDATE users SET id=? , password=? , name=? , department=? , position=? , phonenumber=?  WHERE idx=?;";
                PreparedStatement querys = connect.prepareStatement(sqls);
                querys.setString(1,idValue);
                querys.setString(2,pwValue);
                querys.setString(3,nameValue);
                querys.setString(4,departmentValue);
                querys.setString(5,positionValue);
                querys.setString(6,phoneValue);
                querys.setString(7,idx);
                querys.executeUpdate();
            }else{
                isDuplicatePh = true;
            }
        }

        //아이디를 수정하려고 하면
        if(!idValue.equals(userIdData)){
            
            String userInfos = "SELECT id FROM users WHERE id=?;"; 
            PreparedStatement userInfosQuery = connect.prepareStatement(userInfos); 
            userInfosQuery.setString(1,idValue);
            ResultSet userInfosResult = userInfosQuery.executeQuery();

            //중복된 아이디가 없으면 
            if(!userInfosResult.next()){
                String sqls =" UPDATE users SET id=? , password=? , name=? , department=? , position=? , phonenumber=?  WHERE idx=?;";
                PreparedStatement querys = connect.prepareStatement(sqls);
                querys.setString(1,idValue);
                querys.setString(2,pwValue);
                querys.setString(3,nameValue);
                querys.setString(4,departmentValue);
                querys.setString(5,positionValue);
                querys.setString(6,phoneValue);
                querys.setString(7,idx);
                querys.executeUpdate();
            }else{
                isDuplicateId = true;
            }
        }

    }
}

%>

<script>

    var isDuplicateId = <%=isDuplicateId%>
    var isDuplicatePh = <%=isDuplicatePh%>
        
    if(isDuplicateId) {
        alert("중복된 아이디 입니다.")
        location.href = "../viewPage/userInfo.jsp"
    }else if(isDuplicatePh){
        alert("중복된 전화번호 입니다.")
        location.href = "../viewPage/userInfo.jsp"
    }else {
        location.href = "../../login.jsp"
    }
</script>
