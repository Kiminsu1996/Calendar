<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>


<script>
    
    function checkLogin(){
        if(true){
            location.href = "../viewPage/main.jsp"
        }else{
            alert("아이디와 비밀번호를 다시 확인해 주세요.")
            location.href="../login.jsp"
        }
    }
    window.onload = function(){
        checkLogin()
    }
</script>