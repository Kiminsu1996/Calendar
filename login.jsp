<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/loginShare.css">
    <title>Document</title>
</head>
<body>
    <main>
        <form id="formShare" action="jsp/actionPage/loginResult.jsp">
            <h1>로그인</h1>
            <div class="user id">
                <label>아이디</label>
                <input id="userId" type="text" placeholder="아이디를 입력해 주세요" name="id_value">
            </div>
            <div class="user pw">
                <label>비밀번호</label>
                <input id="userPw" type="password" placeholder="비밀번호를 입력해 주세요" name="pw_value">
            </div>
            <div id="userAction">
                <a href="jsp/viewPage/findId.jsp">아이디 찾기</a>
                <a href="jsp/viewPage/findPw.jsp">비밀번호 찾기</a>
                <a href="jsp/viewPage/singup.jsp">회원가입</a>
            </div>
            <div id="loginBtnDiv">
                <button id="loginBtn" type="button" onclick="loginBtnClickEvent()">확인</button>
            </div>
        </form>
    </main>
    <script>
        
        //로그인 시 id와 pw를 DB에 보내주는 함수
        function loginBtnClickEvent(){
            var userId = document.getElementById("userId")
            var userPw = document.getElementById("userPw")

            if(userId.value === "" || userPw.value === ""){
                alert("빈칸 없이 다 적어주세요.")
            }else{
                document.getElementById("formShare").submit()
            }

        } 

    </script>
</body>
</html>