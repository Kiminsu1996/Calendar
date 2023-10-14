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


ArrayList idxList = new ArrayList<String>();
ArrayList idList = new ArrayList<String>();
ArrayList pwList = new ArrayList<String>();


if(!idValue.isEmpty() && !pwValue.isEmpty()){
    Class.forName("com.mysql.jdbc.Driver"); 
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

    String sql ="SELECT * FROM users WHERE id=? AND password=?;"; 
    PreparedStatement query = connect.prepareStatement(sql);   
    query.setString(1,idValue); 
    query.setString(2,pwValue); 
    ResultSet result = query.executeQuery();

    while(result.next()){
        String userIdxData = result.getString(1);
        String userIdData ="\"" + result.getString(2)+ "\"";     
        String userPwData = "\"" + result.getString(3) + "\""; 
        String userName = "\"" + result.getString(4) + "\""; 
        String userDepartmentData = result.getString(5); 
        String userPositionData = result.getString(6); 
        String userPhoneNumberData = "\"" + result.getString(7) + "\""; 
       
        idxList.add(userIdxData);
        idList.add(userIdData);
        pwList.add(userPwData);

        session.setAttribute("idx", userIdxData);
        session.setAttribute("id", userIdData);
        session.setAttribute("name", userName);
        session.setAttribute("department", userDepartmentData);
        session.setAttribute("position", userPositionData);
        session.setAttribute("phonenumber", userPhoneNumberData);
    }
}

%>

<script>
  
    var idValue = "<%=idValue%>"
    var pwValue = "<%=pwValue%>"
    var idList = <%=idList%>
    var pwList = <%=pwList%>  
    
    if(idValue == idList[0] && pwValue == pwList[0]){
        var nowDate = new Date()
        var year = nowDate.getFullYear()
        var month = nowDate.getMonth() + 1
        location.href = `../viewPage/main.jsp?year=` + year + `&month=` + month
    }else{
        alert("아이디와 비밀번호를 다시 확인해 주세요.")
        location.href="../../login.jsp"
    }

</script>