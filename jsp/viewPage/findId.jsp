<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/loginShare.css">
    <title>Document</title>
</head>
<body>
    <main>
        <form id="formShare" action="findIdResult.jsp">
            <h1>아이디 찾기</h1>
            <div class="user name">
                <label>이름</label>
                <input id="userName" type="text" name="name_value" placeholder="이름을 입력해 주세요" maxlength="20">
            </div>
            <div class="user phone">
                <label>전화번호</label>
                <input id="userPhone" type="text" name="phone_value" placeholder="전화번호를 입력해 주세요">
            </div>
            <div id="loginBtnDiv">
                <button class="btn" type="button" onclick="goLoginPageEvent()">뒤로가기</button>
                <button class="emptyCheck btn " type="submit">확인</button>
            </div>
        </form>
    </main>
    <script>

        //빈값 체크 함수
        function checkEmpty(){
            var checkPwBtn = document.querySelector(".emptyCheck")
            checkPwBtn.addEventListener("click",checkIdBtnEvent)
        }

         //정보를 제대로 입력했는지 체크하는 함수
        function checkIdBtnEvent(e){
            var userName = document.getElementById("userName")
            var userPhone = document.getElementById("userPhone")
            var phonePattern = /^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$/;

            if(userName.value === "" || userPhone.value === ""){
                e.preventDefault();
                alert("빈칸 없이 다 적어주세요.")
            }else if(!phonePattern.test(userPhone.value)){
                e.preventDefault();
                alert("핸드폰 번호 사이에 - 입력해주세요.")
            }
        }

        function goLoginPageEvent(){
            location.href="../../login.jsp"
        }

        window.onload = function(){
            checkEmpty()
        }
    </script>
</body>
