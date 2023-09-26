<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>



<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/mainPageShare.css">
    <title>Document</title>
</head>
<body>
    <header>
        <div id="navbar">
            <div id="headerLeft">
                <button class="go lastMonth" onclick="changeMonthEvent(-1)"><</button>
                <button class="go nextMonth" onclick="changeMonthEvent(1)">></button>
                <p id="yearMonth"></p>
            </div>

            <div id="headerRight">
                <button class="user logout">로그아웃</button>
                <button class="user info">개인정보 보기</button>
            </div>
        </div>
    </header>
    <main>
        <div id="calendar">
            <div id="checkUser">
                <!-- <label><input type="checkbox" name="color" value="blue">김인수</label>
                <label><input type="checkbox" name="color" value="red">이병훈</label> -->
            </div>
            <div id="day"></div>
        </div>
    </main>

    <form id="myModal" action="makeContentResult.jsp">
        <div id="modalHeader">
            <p id="modalDate"></p>
            <button id="modalCloseBtn" type="button" onclick="closeModal()">X</button>
        </div>

        <div class="modal content">
            <label>내용:</label>
            <input class="modalInput" id="content" type="text" placeholder="내용을 입력해 주세요" name="content_value">
        </div>
        <div class="modal time">
            <label>시간:</label>
            <input class="modalInput" id="time" type="time" name="time_value">            
        </div>
        <button id="saveModalBtn" type="submit">저장</button>
    </form>

    <script>
        var nowDate = new Date();
    
        // 팀장일 때 팀원들의 일정을 보여주는 함수
        // function createUser(){
        //     var checkUser = document.getElementById("checkUser")
        //     var user = 2
        //     if(user>1){
        //         for(var i=0; i<user; i++){
        //             var checkbox = document.createElement("input")
        //             checkbox.type = "checkbox"
        //             checkbox.style.width ="15px"
        //             checkbox.style.height ="15px"
        //             checkUser.appendChild(checkbox)
        //         }
        //     }
        // }

        //캘린더 박스를 생성하는 함수
        function createDayBox() {
            var day = document.getElementById("day")
            var columns = 7
            var rows = 5
            var widthValue = 100 / columns + "%"
            var heightValue = 100 / rows + "%"
            
            for (var i = 0; i < columns * rows; i++) {
                var firstDiv = document.createElement("div")
                var date = i + 1
                firstDiv.style.width = widthValue
                firstDiv.style.height = heightValue
                firstDiv.style.border = "1px solid black"
                firstDiv.style.display ="flex"
                firstDiv.style.justifyContent ="center"
                firstDiv.style.backgroundColor = "#8FAADC"
            
                if (date <= getDatesInMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)) {
                    var dateTextBtn = document.createElement("button")
                    dateTextBtn.innerHTML = date
                    dateTextBtn.className = "dateTextBtn"
                    dateTextBtn.setAttribute("data-month",nowDate.getMonth()+1)
                    dateTextBtn.setAttribute("data-day",date)
                    dateTextBtn.addEventListener("click",showModalEvent);
                    firstDiv.appendChild(dateTextBtn)
                }
                day.appendChild(firstDiv)
            }
        }

        // 월을 변경하고 일자 업데이트
        function changeMonthEvent(month) {
            nowDate.setMonth(nowDate.getMonth() + month)
            updateYearMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)
            updateCalendar()
        }

        // 해당 월의 일 수를 가져오는 함수
        function getDatesInMonth(year, month) {
            return new Date(year, month, 0).getDate()
        }

        // 년도와 월을 업데이트하는 함수
        function updateYearMonth(year, month) {
            var yearMonth = document.getElementById("yearMonth");
            yearMonth.innerHTML = year + "년 " + month + "월"
        }

        // 일자 업데이트
        function updateCalendar() {
            var day = document.getElementById("day")
            day.innerHTML = ""; // 일자를 업데이트하기 전에 이전 내용을 모두 지움
            createDayBox();
        }

        //모달창 열기
        function openModal(month,day) {
            var modal = document.getElementById("myModal")
            var modalDate = document.getElementById("modalDate")
            var content = document.getElementById("content")
            var time = document.getElementById("time")

            modalDate.innerHTML = month +"월"+day+"일"
            modal.style.display = "flex"
            modal.style.justifyContent = "center"
            modal.style.alignItems = "center"
            modal.style.flexDirection = "column"

            content.value = ""
            time.value = ""
        }

        // 모달 창 닫기
        function closeModal() {
            var modal = document.getElementById("myModal")
            modal.style.display = "none"
        }


        //모달창에 클릭한 날짜를 생성하는 함수
        function showModalEvent(event) {
            var clickedDate = event.target.getAttribute("data-day");
            var clickedMonth = event.target.getAttribute("data-month");
            openModal(clickedMonth,clickedDate);
        }

        function saveModalBtnEvent(e){
            var content = document.getElementById("content")
            var time = document.getElementById("time")
            
            if(content.value === "" || time.value === ""){
                e.preventDefault()
                alert("빈칸 없이 다 적어주세요.")
            }
        }
        
        function checkEmpty(){
            var saveModalBtn = document.getElementById("saveModalBtn")
            saveModalBtn.addEventListener("click",saveModalBtnEvent)
        }


        window.onload = function(){
            createDayBox()
            updateYearMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)
            checkEmpty()
        }
    </script>
</body>
