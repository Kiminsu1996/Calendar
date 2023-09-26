<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>



<script>
    function checkId(){
        if(isDuplicate){
            alert("중복된 아이디 입니다. 변경해주세요.")
            location.href = "../viewPage/signup.jsp"
        }else{
            location.href="../login.jsp"
        }
    }
        
    window.onload = function(){
        checkId()
    }

</script>
