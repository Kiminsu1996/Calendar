<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/loginShare.css">
    <title>Document</title>
</head>
<body>
    <main>
        <form id="formShare" action="../actionPage/singupResult.jsp">
            <h1>회원가입</h1>

            <div class="user id">
                <label>아이디</label>
                <input id="userId" type="text" placeholder="5~20글자 사이의 ID입력" name="id_value"/>
            </div>

            <div class="user pw">
                <label>비밀번호</label>
                <input id="userPw" type="password" placeholder="5~20글자 사이의 PW입력" name="pw_value" />
            </div>

            <div class="user name">
                <label>이름</label>
                <input id="userName" type="text" name="name_value" placeholder="최대 20글자 제한" maxlength="20" />
            </div>

            <div class="user department">
                <label>부서</label>
                <select name="department_value" id="userDepartment">
                    <option value="">부서를 선택해주세요.</option>
                    <option value="개발팀">개발팀</option>
                    <option value="기획팀">기획팀</option>
                    <option value="디자인팀">디자인팀</option>
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
                <button class="btn" type="button" onclick="goLoginPageEvent()">뒤로가기</button>
                <button class="emptyCheck btn " type="submit">확인</button>
            </div>
        </form>
    </main>
    <script>
        function checkEmpty(){
            var checkPwBtn = document.querySelector(".emptyCheck")
            checkPwBtn.addEventListener("click",checkSingupEvent)
        }

        function checkSingupEvent(e){
            var userId = document.getElementById("userId")
            var userPw = document.getElementById("userPw")
            var userName = document.getElementById("userName")
            var userDepartment = document.getElementById("userDepartment")
            var userPosition = document.getElementById("userPosition")
            var userPhone = document.getElementById("userPhone")
            var idPwPattern = /^[a-zA-Z0-9]{5,20}$/;
            var phonePattern = /^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$/;

            if(userId.value === "" || userName.value === "" || userPhone.value  === "" || userPw.value  === "" ||
            userDepartment.value  === "" || userPosition.value  === "" ){
                e.preventDefault();
                alert("빈칸 없이 다 적어주세요.")
            }else if(!idPwPattern.test(userId.value)){
                e.preventDefault();
                alert("아이디는 영어와 숫자를 사용해주세요.")
            }else if(!idPwPattern.test(userPw.value)){
                e.preventDefault();
                alert("비밀번호는 영어와 숫자를 사용해주세요.")
            }else if(!phonePattern.test(userPhone.value)){
                e.preventDefault();
                alert("전화번호 사이에 - 입력해주세요.")
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