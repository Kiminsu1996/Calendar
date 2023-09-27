<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 
String idx = (String)session.getAttribute("idx");

// 일정 내용, 시간을 찾는 쿼리문
String myContentSql = "SELECT * FROM events WHERE users_idx=?;";
PreparedStatement myContentQuery = connect.prepareStatement(myContentSql);
myContentQuery.setString(1,idx);
ResultSet myContentSqlResult = myContentQuery.executeQuery();

ArrayList eventInfo = new ArrayList<String>();

while(myContentSqlResult.next()){
    String userContentData = "\"" + myContentSqlResult.getString(3) + "\""; 
    String dateData = "\"" + myContentSqlResult.getString(4) + "\""; 
    String timeData= "\"" + myContentSqlResult.getString(5) + "\""; 
    eventInfo.add(userContentData);
    eventInfo.add(dateData);
    eventInfo.add(timeData);
}

// 회원의 이름을 찾는 쿼리문
String userInfoSql = "SELECT * FROM users WHERE idx=?;";
PreparedStatement userInfoQuery = connect.prepareStatement(userInfoSql);
userInfoQuery.setString(1,idx);
ResultSet userInfoResult = userInfoQuery.executeQuery();

ArrayList userInfo = new ArrayList<String>();

while(userInfoResult.next()){
    String userNameData = "\"" + userInfoResult.getString(4) + "\""; 
    userInfo.add(userNameData);
}

%>

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
                <button class="user logout" onclick="logoutEvent()">로그아웃</button>
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
            <input type="date" id="modalDates" style="display: none" name="date_value">
        </div>
        <button id="saveModalBtn" type="submit">저장</button>
    </form>

    <script>
        var nowDate = new Date();
    
        function checkLogin(){
            var idx = <%=idx%>
            if(idx < 1){
                location.href = "../../login.jsp"
            }
        }
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
                firstDiv.className ="firstDiv"
                firstDiv.style.width = widthValue
                firstDiv.style.height = heightValue
                firstDiv.style.border = "1px solid black"
                firstDiv.style.display ="flex"
                firstDiv.style.flexDirection = "column"
                firstDiv.style.justifyContent ="space-between"
                firstDiv.style.alignItems ="center"
                firstDiv.style.backgroundColor = "#8FAADC"
                firstDiv.setAttribute("data-day",date)
                
                if (date <= getDatesInMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)) {
                    var dateTextBtn = document.createElement("button")
                    var formattedMonth = (nowDate.getMonth() + 1 < 10 ? "0" : "") + (nowDate.getMonth() + 1);
                    var formattedDate = (date < 10 ? "0" : "") + date;

                    dateTextBtn.innerHTML = date
                    dateTextBtn.className = "dateTextBtn"
                    dateTextBtn.setAttribute("data-month",nowDate.getMonth()+1)
                    dateTextBtn.setAttribute("data-day",date)
                    dateTextBtn.setAttribute("data-date",formattedMonth + "-" + formattedDate)
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
            day.innerHTML = ""; 
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

            var modalDates = document.getElementById("modalDates")
            var year = nowDate.getFullYear()
            var formattedDate = year + "-" + (month < 10 ? "0" : "") + month + "-" + (day < 10 ? "0" : "") + day;
            modalDates.value = formattedDate;
        }

        // 모달 창 닫기
        function closeModal() {
            var modal = document.getElementById("myModal")
            modal.style.display = "none"
        }


        //모달창에 클릭한 날짜를 찾는 함수
        function showModalEvent(event) {
            var clickedDate = event.target.getAttribute("data-day");
            var clickedMonth = event.target.getAttribute("data-month");
    
            openModal(clickedMonth,clickedDate);
        }
        
        //일정을 캘린더에 보여주는 함수
        // function makeContent(event){
        //     내가 선택한 날짜가 필요하고 //작성자의 idx가 필요함

        //

        //     var firstDiv = document.querySelector(".firstDiv")
        //     var infoBtn = document.createElement("button")
        //     var nameDiv = document.createElement("div")
        //     var timeDiv = document.createElement("div")
        //     var contentDiv = document.createElement("div")
        //     var userName = <%=userInfo%>
        //     var eventInfo = <%=eventInfo%>

                
        //     infoBtn.id = "infoBtn"
        //     nameDiv.innerHTML = userName
        //     contentDiv.innerHTML = eventInfo[0]
        //     timeDiv.innerHTML = eventInfo[2]

        //     infoBtn.append(nameDiv,timeDiv,contentDiv)
        //     firstDiv.appendChild(infoBtn)
            
        // }

        function checkEmpty(){
            var saveModalBtn = document.getElementById("saveModalBtn")
            saveModalBtn.addEventListener("click",saveModalBtnEvent)
        }

        //일정 저장 이벤트
        function saveModalBtnEvent(e){
            var content = document.getElementById("content")
            var time = document.getElementById("time")
            var empty= time.value
            var formTime = empty + ":00"
            time.value = formTime

            if(content.value === "" || time.value === ""){
                e.preventDefault()
                alert("빈칸 없이 다 적어주세요.")
            }
        }

        //로그아웃 이벤트
        function logoutEvent(){
            location.href = "../actionPage/logout.jsp"
        }
        
        window.onload = function(){
            checkLogin()
            createDayBox()
            updateYearMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)
            checkEmpty()
           
        }
    </script>
</body>
