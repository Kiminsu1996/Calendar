<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<% 
ArrayList idxList = new ArrayList<String>();
String idx = (String)session.getAttribute("idx");

if(idx != null){
    Class.forName("com.mysql.jdbc.Driver");
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 

    String sql ="SELECT * FROM users WHERE idx=?;"; 
    PreparedStatement query = connect.prepareStatement(sql); 
    query.setString(1, idx); 
    ResultSet result = query.executeQuery(); 

    while(result.next()){
        String idData ="\"" + result.getString(2)+ "\"";
        String pwData = "\"" +  result.getString(3) + "\"";
        String nameData = "\"" +  result.getString(4) + "\"";
        String departmentData = "\"" +  result.getString(5)+ "\"";
        String positionData = "\"" +  result.getString(6)+ "\"";
        String phonenumberData = "\"" +  result.getString(7)+ "\"";
        idxList.add(idData);
        idxList.add(pwData);
        idxList.add(nameData);
        idxList.add(departmentData);
        idxList.add(positionData);
        idxList.add(phonenumberData);
    }
}else{
    response.sendRedirect("../../login.jsp");
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
        <form id="formShare" action="../actionPage/changeUserInfo.jsp">
            <h1>개인정보 보기</h1>

            <div class="user id">
                <label>아이디</label>
                <input id="userId" type="text" placeholder="5~20글자 사이의 ID입력" name="id_value"/>
            </div>

            <div class="user pw">
                <label>비밀번호</label>
                <input id="userPw" type="password" placeholder="5~20글자 사이의 PW입력" name="pw_value" />
            </div>

            <div class="user findpw">
                <label>비밀번호 확인</label>
                <input id="userFindPw" type="password" placeholder="비밀번호 확인"/>
            </div>

            <div class="user name">
                <label>이름</label>
                <input id="userName" type="text" name="name_value" placeholder="최대 20글자 제한" maxlength="20" />
            </div>

            <div class="user department">
                <label>부서</label>
                <select name="department_value" id="userDepartment">
                    <option value="">부서를 선택해주세요.</option>
                    <option value="1">개발팀</option>
                    <option value="2">기획팀</option>
                    <option value="3">디자인팀</option>
                </select>
            </div>

            <div class="user position">
                <label>직급</label>
                <select name="position_value" id="userPosition">
                    <option value="">직급을 선택해주세요.</option>
                    <option value="1">팀원</option>
                    <option value="2">팀장</option>
                </select>
            </div>

            <div class="user phoneNumber">
                <label>전화번호</label>
                <input id="userPhone" type="text"  placeholder="010-XXXX-XXXX"  name="phone_value" />
            </div>
        
            <div id="loginBtnDiv">
                <button class="btn" type="button" onclick="goMainPageEvent()">뒤로가기</button>
                <button id="emptyCheck" class="btn"  type="button" onclick="checkUserInfoEvent()">수정</button>
                <button class="btn" type="button" onclick="deleteUserEvent()">탈퇴</button>
            </div>
        </form>
    </main>
    <script>

        function showUserInfo(){
            var idxList = <%=idxList%>;
            var userInfos = ["userId", "userPw", "userName", "userDepartment", "userPosition", "userPhone"];

            for (var i = 0; i < userInfos.length; i++) {
                var userInfo = userInfos[i];
                var dataBaseValue = idxList[i];
                var inputUserInfo = document.getElementById(userInfo);

                if (inputUserInfo) {
                    inputUserInfo.value = dataBaseValue;
                }
            }
        }

        function checkUserInfoEvent(){
            var userId = document.getElementById("userId")
            var userPw = document.getElementById("userPw")
            var userFindPw = document.getElementById("userFindPw")
            var userName = document.getElementById("userName")
            var userDepartment = document.getElementById("userDepartment")
            var userPosition = document.getElementById("userPosition")
            var userPhone = document.getElementById("userPhone")
            var idPwPattern = /^[a-zA-Z0-9]{5,20}$/;
            var phonePattern = /^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$/;

            if(userId.value === "" || 
                userName.value === "" || 
                userFindPw.value ==="" || 
                userPhone.value  === "" || 
                userPw.value  === "" ||
                userDepartment.value  === "" || 
                userPosition.value  === "" ){
                alert("빈칸 없이 다 적어주세요.")
            }else if(userPw.value !== userFindPw.value ){
                alert("비밀번호가 다릅니다. 확인해 주세요.")
            }else if(!idPwPattern.test(userId.value)){
                alert("아이디는 영어와 숫자를 사용해주세요.")
            }else if(!idPwPattern.test(userPw.value)){
                alert("비밀번호는 영어와 숫자를 사용해주세요.")
            }else if(!phonePattern.test(userPhone.value)){
                alert("전화번호 사이에 - 입력해주세요.")
            }else{
                document.getElementById("formShare").submit()
            }
        }


        function goMainPageEvent(){
            var nowDate = new Date()
            // main.jsp?year=2023&month=10
            location.href="main.jsp?year=" + nowDate.getFullYear() + "&month=" + nowDate.getMonth()
            
        }

        function deleteUserEvent(){
            if(confirm("정말 탈퇴 하시겠습니까?")){
                location.href ="../actionPage/deleteInfo.jsp"
            }
            else{
                location.href ="../viewPage/userInfo.jsp"
            }
        }

        window.onload = function(){
            showUserInfo()
        }


    </script>
</body>