<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>


<%

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
            <p>당신의 비밀번호는 "" 입니다.</p>
            <div id="loginBtnDiv">
                <button class="btn" type="button" onclick="goLoginPageEvent()">확인</button>
            </div>
        </div>
    </main>
    <script>
        function goLoginPageEvent(){
            location.href="../../login.jsp"
        }

    </script>
</body>