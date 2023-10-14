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
                <button class="btn" type="button" onclick="goLoginPageEvent()">뒤로가기</button>
                <button id="emptyCheck" class="btn" type="button" onclick="checkSingupEvent()">확인</button>
            </div>
        </form>
    </main>
    <script>
        //회원가입에 관한 정보를 확인하는 이벤트
         function checkSingupEvent(){
            var userId = document.getElementById("userId")
            var userPw = document.getElementById("userPw")
            var userFindPw = document.getElementById("userFindPw")
            var userName = document.getElementById("userName")
            var userDepartment = document.getElementById("userDepartment")
            var userPosition = document.getElementById("userPosition")
            var userPhone = document.getElementById("userPhone")
            var idPwPattern = /^[a-zA-Z0-9]{5,20}$/
            var phonePattern = /^01[0-9]{1}-[0-9]{3,4}-[0-9]{4}$/

            var userIdValue = userId.value
            var userPwValue = userPw.value
            var userFindPwValue = userFindPw.value
            var userNameValue = userName.value
            var userDepartmentValue = userDepartment.value
            var userPositionValue = userPosition.value
            var userPhoneValue = userPhone.value

            //로컬스토리지에 데이터 보내기 
            localStorage.setItem('userId', userIdValue)
            localStorage.setItem('userPw', userPwValue)
            localStorage.setItem('userFindPw', userFindPwValue)
            localStorage.setItem('userName', userNameValue)
            localStorage.setItem('userDepartment', userDepartmentValue)
            localStorage.setItem('userPosition', userPositionValue)
            localStorage.setItem('userPhone', userPhoneValue)

            if (userIdValue === "" || 
                userPwValue === "" || 
                userFindPwValue === "" || 
                userNameValue === "" || 
                userDepartmentValue === "" ||
                userPositionValue === "" || 
                userPhoneValue === "" ){
                alert("빈칸 없이 다 적어주세요.")
            }else if (userPwValue !== userFindPwValue ){
                alert("비밀번호가 다릅니다. 확인해 주세요.")
            }else if (!idPwPattern.test(userIdValue)){
                alert("아이디는 영어와 숫자를 사용해주세요.")
            }else if (!idPwPattern.test(userPwValue)){
                alert("비밀번호는 영어와 숫자를 사용해주세요.")
            }else if (!phonePattern.test(userPhoneValue)){
                alert("전화번호 사이에 - 입력해주세요.")
            }else{
                document.getElementById("formShare").submit()
            }
        }

        //회원가입 실패 시 기존 데이터 가져오는 함수 
        function restoreInputValues() {
            var userId = document.getElementById("userId");
            var userPw = document.getElementById("userPw");
            var userFindPw = document.getElementById("userFindPw");
            var userName = document.getElementById("userName");
            var userDepartment = document.getElementById("userDepartment");
            var userPosition = document.getElementById("userPosition");
            var userPhone = document.getElementById("userPhone");

            // 로컬 스토리지에서 데이터 가져오기
            var saveUserId = localStorage.getItem('userId');
            var saveUserPw = localStorage.getItem('userPw');
            var saveUserFindPw = localStorage.getItem('userFindPw');
            var saveUserName = localStorage.getItem('userName');
            var saveUserDepartment = localStorage.getItem('userDepartment');
            var saveUserPosition = localStorage.getItem('userPosition');
            var saveUserPhone = localStorage.getItem('userPhone');

             // 내가 적었던 데이터 불러오기
            if (saveUserId && 
                saveUserPw && 
                saveUserFindPw && 
                saveUserName && 
                saveUserDepartment && 
                saveUserPosition && 
                saveUserPhone) {
                userId.value = saveUserId;
                userPw.value = saveUserPw;
                userFindPw.value = saveUserFindPw;
                userName.value = saveUserName;
                userDepartment.value = saveUserDepartment;
                userPosition.value = saveUserPosition;
                userPhone.value = saveUserPhone;
            }
        }

        function goLoginPageEvent(){
            location.href="../../login.jsp"
        }

        window.onload = function() {
            restoreInputValues()
            localStorage.clear()
        }
    </script>
</body>