<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
request.setCharacterEncoding("UTF-8"); 
String nameValue=request.getParameter("name_value");
String phoneValue=request.getParameter("phone_value");
ArrayList idList = new ArrayList<String>();
ArrayList userInfo = new ArrayList<String>();

if(!nameValue.isEmpty() && !phoneValue.isEmpty()){
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234");

    //아이디를 찾는 쿼리문
    String sql ="SELECT * FROM users WHERE name=? AND phonenumber=?;"; 
    PreparedStatement query = connect.prepareStatement(sql);   
    query.setString(1,nameValue); 
    query.setString(2,phoneValue); 
    ResultSet result = query.executeQuery();

    while(result.next()){
        String idData =  "\"" + result.getString(2) + "\"";
        String nameData =  "\"" + result.getString(4) + "\"";
        String phoneData =  "\"" + result.getString(7) + "\"";
        idList.add(idData);
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
            <p id="showUserId"></p>
            <div id="loginBtnDiv">
                <button class="btn" type="button" onclick="goLoginPageEvent()">확인</button>
            </div>
        </div>
    </main>
    <script>

        //아이디를 보여주는 함수
        function showUserId(){
            var showUserId = document.getElementById("showUserId")
            showUserId.style.marginBottom = "10%"
            var nameValue ="<%=nameValue%>"
            var phoneValue = "<%=phoneValue%>"
            var idList = <%=idList%>
            var userInfo = <%=userInfo%>

            if(nameValue == userInfo[0] && phoneValue == userInfo[1]){
                showUserId.innerHTML = "당신의 아이디는 \"" + idList + "\"입니다."
            }else{
                alert("회원정보를 확인해 주세요.")
                location.href = "findId.jsp"
            }
        }

        function goLoginPageEvent(){
            location.href="../../login.jsp"
        }

        window.onload = function(){
            showUserId()
        }

    </script>
</body>