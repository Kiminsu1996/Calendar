<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
request.setCharacterEncoding("UTF-8"); 
String idValue=request.getParameter("id_value");
String nameValue=request.getParameter("name_value");
String phoneValue=request.getParameter("phone_value");

ArrayList userInfo = new ArrayList<String>();
ArrayList pwList = new ArrayList<String>();

if(!idValue.isEmpty() && !nameValue.isEmpty() && !phoneValue.isEmpty()){
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

    String sql ="SELECT * FROM users WHERE id=? AND name=? AND phonenumber=?;"; 
    PreparedStatement query = connect.prepareStatement(sql);   
    query.setString(1,idValue); 
    query.setString(2,nameValue); 
    query.setString(3,phoneValue); 
    ResultSet result = query.executeQuery();

    while(result.next()){
        String idData =  "\"" + result.getString(2) + "\"";
        String pwData =  "\"" + result.getString(3) + "\"";
        String nameData =  "\"" + result.getString(4) + "\"";
        String phoneData =  "\"" + result.getString(7) + "\"";
        pwList.add(pwData);
        userInfo.add(idData);
        userInfo.add(nameData);
        userInfo.add(phoneData);
    }
}

%>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/loginShare.css">
    <title>Document</title>
</head>
<body>
    <main>
        <div id="formShare">
            <p id="showUserPw"></p>
            <div id="loginBtnDiv">
                <button class="btn" type="button" onclick="goLoginPageEvent()">확인</button>
            </div>
        </div>
    </main>
    <script>

        function showUserPw(){
            var showUserPw = document.getElementById("showUserPw")
            showUserPw.style.marginBottom ="10%"
            var idValue = "<%=idValue%>"
            var nameValue = "<%=nameValue%>"
            var phoneValue = "<%=phoneValue%>"            
            var pwList = <%=pwList%>
            var userInfo = <%=userInfo%>

            if(idValue == userInfo[0] && nameValue == userInfo[1] && phoneValue == userInfo[2]){
                showUserPw.innerHTML = "당신의 비밀번호는 \"" + pwList + "\"입니다."
            }else{
                alert("회원정보를 확인해 주세요.")
                location.href = "findPw.jsp"
            }

        }

        function goLoginPageEvent(){
            location.href="../../login.jsp"
        }

        window.onload = function(){
            showUserPw()
        }

    </script>
</body>