<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 

String idx = (String)session.getAttribute("idx");
String department = (String)session.getAttribute("department");
String position = (String)session.getAttribute("position");

String lastMonthValue = request.getParameter("lastMonth"); 


if(idx == null){
    response.sendRedirect("../../login.jsp");
}

//같은 부서, 직책이 팀원인 사람들을 찾는 쿼리문 / 팀장일때만 
String findUserSql = "SELECT * FROM users WHERE department=? AND position=?;";
PreparedStatement findUserQuery = connect.prepareStatement(findUserSql);
findUserQuery.setString(1,department);
findUserQuery.setString(2,"1");
ResultSet findUserResult = findUserQuery.executeQuery();

ArrayList findUserInfo = new ArrayList<String>();
ArrayList findUserDepartment = new ArrayList<String>();

while(findUserResult.next()){
    String userNameData = "\"" + findUserResult.getString(4) + "\""; 
    String userDepartmentData = "\"" + findUserResult.getString(5) + "\""; 
    findUserInfo.add(userNameData);
    findUserDepartment.add(userDepartmentData);
}

// 로그인한 회원의 이름, 직책을 찾는 쿼리문 // 세션에 저장된 내용으로 사용가능하다. 지우기 
String userInfoSql = "SELECT * FROM users WHERE idx=?;";
PreparedStatement userInfoQuery = connect.prepareStatement(userInfoSql);
userInfoQuery.setString(1,idx);
ResultSet userInfoResult = userInfoQuery.executeQuery();

ArrayList userInfo = new ArrayList<String>();

while(userInfoResult.next()){
    String userNameData = "\"" + userInfoResult.getString(4) + "\""; 
    String userPositionData = userInfoResult.getString(6); 
    userInfo.add(userNameData);
    userInfo.add(userPositionData);
}

// 일정 내용, date , 시간을 찾는 쿼리문
String myContentSql = "SELECT * FROM events WHERE users_idx=?;";
PreparedStatement myContentQuery = connect.prepareStatement(myContentSql);
myContentQuery.setString(1,idx);
ResultSet myContentSqlResult = myContentQuery.executeQuery();

ArrayList eventInfo = new ArrayList<String>();
ArrayList eventIdxEvent = new ArrayList<String>();
ArrayList dateEvent = new ArrayList<String>();
ArrayList timeEvent = new ArrayList<String>();
ArrayList contentEvnet = new ArrayList<String>();

while(myContentSqlResult.next()){
        String eventIdxData = "\"" + myContentSqlResult.getString(1) + "\""; 
        String userContentData = "\"" + myContentSqlResult.getString(3) + "\""; 
        String dateData = "\"" + myContentSqlResult.getString(4)+ "\""; 
        String timeData= "\"" + myContentSqlResult.getString(5) + "\""; 

        contentEvnet.add(userContentData);
        dateEvent.add(dateData); 
        timeEvent.add(timeData);
        eventIdxEvent.add(eventIdxData);

        eventInfo.add(contentEvnet);
        eventInfo.add(dateEvent);
        eventInfo.add(timeEvent);
        eventInfo.add(eventIdxEvent);
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
                <form id="goLastMonth" action="main.jsp">
                    <!-- 버튼이 클릭 됐을 때 submuit으로 했으니깐 웹페이지가 바뀌면서 월이 바뀌어야된다.  -->
                    <button class="go lastMonth" type="button" name="lastMonth" onclick="changeMonthEvent(-1)"><</button>
                </form>
                <form id="goNextMonth" action="main.jsp">
                    <button class="go nextMonth" type="button" name="nextMonth" onclick="changeMonthEvent(1)">></button>
                </form>
                <p id="yearMonth"></p> 
            </div>

            <div id="headerRight">
                <button class="user logout" onclick="logoutEvent()">로그아웃</button>
                <button class="user info" onclick="goUserInfoPageEvent()">개인정보 보기</button>
            </div>
        </div>
    </header>

    <main>
        <div id="calendar">
            <div id="checkUser">
                <div id="userList"></div>
            </div>
            <div id="day"></div>
        </div>
    </main>

    <!-- 일정 입력 폼 -->
    <form id="inputMySchedule" action="../actionPage/makeContentResult.jsp">
        <div id="modalHeader">
            <p id="modalDate"></p>
            <button class="modalCloseBtn" type="submit" onclick="closeModalEvent()">X</button>
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
        <button id="saveModalBtn" class="modalBtn" type="submit">확인</button>
    </form>

    <div id="contentDetailModal">
        <div id="detailModalHeader">
        <p id="detailModalDate"></p>
        <button class="modalCloseBtn" id="detailModalHeaderCloseBtn" type="button" onclick="detailMoadCloseEvent()">X</button>
        </div>
    </div>

    <script>
       var lastMonthValue =  <%=lastMonthValue%>

        var nowDate = new Date()
     
        function checkLogin(){
            var idx = <%=idx%>
            if(!(idx > 1)) return location.href = "../../login.jsp"
        }

        function create(){
           
        }

        //팀장일 때 팀원들을 보여주는 함수  
        function createTeamUsers(){
            var userInfo = <%=userInfo%>
            var findUserInfo = <%=findUserInfo%>
            var findUserDepartment = <%=findUserDepartment%>
            var department = <%=department%>
            var userList = document.getElementById("userList")
           
            for (var i = 0; i < findUserInfo.length; i++) {
                //***************************** 이 부분은 백엔드에서 처리해주기 즉 세션으로 가져오기*****************************
                if (userInfo[1] > 1 && findUserDepartment[i] == department) {
                    var user = document.createElement("div")
                    user.className = "checkUserName"

                    var checkBox = document.createElement("input")
                    checkBox.type = "checkbox"
            
                    var userName = document.createElement("p")
                    userName.className = "userNameList"
                    userName.innerHTML = findUserInfo[i]

                    checkBox.addEventListener("change", showTeamMomverEvents)

                    user.append(checkBox, userName)
                    userList.appendChild(user)
                }
            }
        }

        function createDayBox() { 
            var day = document.getElementById("day")
            var columns = 7
            var rows = 5
            var widthValue = 100 / columns + "%"
            var heightValue = 100 / rows + "%"
            
            for (var i = 0; i < columns * rows; i++) {
                var firstDiv = document.createElement("div")
                var date = i + 1
                var year = nowDate.getFullYear()
                var formattedMonth = (nowDate.getMonth() + 1 < 10 ? "0" : "") + (nowDate.getMonth() + 1);
                var formattedDate = (date < 10 ? "0" : "") + date;

                firstDiv.className = "firstDiv"
                firstDiv.style.width = widthValue
                firstDiv.style.height = heightValue
                firstDiv.style.border = "1px solid black"
                firstDiv.style.display = "flex"
                firstDiv.style.flexDirection = "column"
                firstDiv.style.justifyContent = "space-between"
                firstDiv.style.alignItems = "center"
                firstDiv.style.backgroundColor = "#8FAADC"
                firstDiv.setAttribute("data-date", year + "-" + formattedMonth + "-" + formattedDate)
                firstDiv.setAttribute("data-month", formattedMonth)
                firstDiv.setAttribute("data-day", formattedDate)
                
                if (date <= getDatesInMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)) {
                    var dateBtn = document.createElement("button")
                    
                    dateBtn.innerHTML = date
                    dateBtn.className = "dateBtn"
                    dateBtn.setAttribute("data-month", nowDate.getMonth()+1)
                    dateBtn.setAttribute("data-day", date)
                    dateBtn.addEventListener("click", openInputModalEvent)
                    firstDiv.appendChild(dateBtn)
                }
                
                day.appendChild(firstDiv)
            }
        }

        // 해당 월의 일 수를 가져오는 함수
        function getDatesInMonth(year, month) {
            return new Date(year, month, 0).getDate()
        }

        // 년도와 월을 업데이트하는 함수
        function updateYearMonth(year, month) {
            var yearMonth = document.getElementById("yearMonth")
            yearMonth.innerHTML = year + "년 " + month + "월"
        }

        // 일자 업데이트
        function updateCalendar() {
            var day = document.getElementById("day")
            day.innerHTML = ""
            createDayBox()
        }

         //일정을 캘린더에 보여주는 함수
         function showContent(year, month) {
            var firstDivs = document.querySelectorAll(".firstDiv")
            var eventInfo = <%=eventInfo%>
            var userInfo = <%=userInfo%>

            for (var i = 0; i < firstDivs.length; i++) {
                var firstDivDate = firstDivs[i].getAttribute("data-date") 
                var firstDivMonth = firstDivs[i].getAttribute("data-month") 
                var firstDivDay = firstDivs[i].getAttribute("data-day") 
              
                // 해당 날짜에 대한 일정 정보를 저장할 배열
                var eventsOnDate = []
                
                if(!eventInfo[1]) return

                // 내용 정제
                for (var j = 0; j < eventInfo[1].length; j++) {
                    if (firstDivDate === eventInfo[1][j]) {
                        var eventContent = eventInfo[0][j] //내용
                        var eventTime = eventInfo[2][j] // 시간
                        var processEventTime = eventTime.split(":", 2)

                        // 해당 날짜에 대한 일정 정보를 객체로 저장
                        var eventInfoObj = {
                            content: eventContent,
                            time: processEventTime[0] + ":" + processEventTime[1]
                        }
                        eventsOnDate.push(eventInfoObj)
                    }
                }
                
                //내용 뿌려줌
                if (!eventsOnDate.length) continue

                    var firstDiv = firstDivs[i]
                    var infoBtn = document.createElement("button")

                    infoBtn.className = "infoBtn"
                    infoBtn.setAttribute("data-month", firstDivMonth)
                    infoBtn.setAttribute("data-day", firstDivDay)

                    // 여러 개의 일정이 있을 경우 일정 개수로 표시
                    if (eventsOnDate.length > 1) {
                        infoBtn.innerHTML = eventsOnDate.length
                        firstDiv.appendChild(infoBtn)
                        
                     // 한 개의 일정만 있을 경우 일정 정보 표시
                    } else { 
                        var eventInfoObj = eventsOnDate[0]

                        var eventContent = eventInfoObj.content
                        var eventTime = eventInfoObj.time
                        var userName = userInfo[0]

                        //이름
                        var nameDiv = document.createElement("div")
                        nameDiv.innerHTML = userName

                        //내용
                        var contentDiv = document.createElement("div")
                        contentDiv.innerHTML = eventContent

                        //시간
                        var timeDiv = document.createElement("div")
                        timeDiv.innerHTML = eventTime

                        infoBtn.append(nameDiv, timeDiv, contentDiv)
                    }
                    
                    firstDiv.appendChild(infoBtn)
                    infoBtn.addEventListener("click", infoBtnClickEvent)
                
            }
        }

          //모달창 열기
          function showInputModal(month,day) {
            var modal = document.getElementById("inputMySchedule")
            var modalDate = document.getElementById("modalDate")
            var content = document.getElementById("content")
            var time = document.getElementById("time")

            modalDate.innerHTML = month + "월" + day + "일"
            modal.style.display = "flex"
            modal.style.justifyContent = "center"
            modal.style.alignItems = "center"
            modal.style.flexDirection = "column"

            content.value = ""
            time.value = ""

            var modalDates = document.getElementById("modalDates")
            var year = nowDate.getFullYear()
            var formattedDate = year + "-" + (month < 10 ? "0" : "") + month + "-" + (day < 10 ? "0" : "") + day
            modalDates.value = formattedDate
        }

        //모달창에 빈값 확인 
        function checkEmpty(){
            var saveModalBtn = document.getElementById("saveModalBtn")
            saveModalBtn.addEventListener("click",saveModalBtnEvent)
        }

        //일정 자세히 보기  
        function infoBtnClickEvent(event) {
            var eventInfo = <%=eventInfo%>
            var userInfo = <%=userInfo%>
    
            var infoBtnMonth = event.currentTarget.getAttribute("data-month")
            var infoBtnDay = event.currentTarget.getAttribute("data-day")
    
            var month = parseInt(infoBtnMonth)
            var day = parseInt(infoBtnDay)

            var contentDetailModal = document.getElementById("contentDetailModal")
            contentDetailModal.style.display = "flex"
            contentDetailModal.style.justifyContent = "center"
            contentDetailModal.style.alignItems = "center"
            contentDetailModal.style.flexDirection = "column"

            var detailModalHeader = document.getElementById("detailModalHeader")
    
            var detailModalDate = document.getElementById("detailModalDate")
            detailModalDate.innerHTML = month + "월 " + day + '일'

            var modalCloseBtn = document.getElementById("detailModalHeaderCloseBtn")
            
    
            var contentDetails = document.createElement("div")
            contentDetails.id = "contentDetails"

            for (var i = 0; i < eventInfo[1].length; i++) {

                if (eventInfo[1][i] === nowDate.getFullYear() + '-' + infoBtnMonth + '-' + infoBtnDay) {
                    var eventTime = eventInfo[2][i] //시간
                    var userName = userInfo[0] //이름
                    var eventContent = eventInfo[0][i] //내용
                    var processEventTime = eventTime.split(":", 2) // 시간 데이터 가공
           
                    var eventElements = document.createElement("div")
                    eventElements.className = "eventElements"
                    
                    var eventInfos = document.createElement("div")
                    eventInfos.id="eventInfos"
                    eventInfos.innerHTML = processEventTime[0] + ":" + processEventTime[1] + " " + userName + " " + eventContent;

                    var modifyContentATag = document.createElement("a")
                    modifyContentATag.innerHTML = "수정"
                    modifyContentATag.className = "detailModalATag"
                    modifyContentATag.href = "changeContent.jsp?idx=" + eventInfo[3][i]
                    
                    var deleteContentATag = document.createElement("a")
                    deleteContentATag.innerHTML = "삭제"
                    deleteContentATag.className = "detailModalATag"
                    deleteContentATag.href ="../actionPage/deleteContent.jsp?idx=" + eventInfo[3][i]

                    var btnDiv = document.createElement("div")
                    btnDiv.id = "btnDiv"

                    btnDiv.append(modifyContentATag, deleteContentATag)
                    eventElements.append(eventInfos, btnDiv)
                    contentDetails.appendChild(eventElements)
                }
            }

            contentDetailModal.innerHTML = ''
            detailModalHeader.append(detailModalDate, modalCloseBtn)
            contentDetailModal.append(detailModalHeader, contentDetails)
        }
        
         // 월을 변경하고 일자 업데이트
        function changeMonthEvent(month) {
            nowDate.setMonth(nowDate.getMonth() + month)
            updateYearMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)
            updateCalendar()
            showContent(nowDate.getFullYear(), nowDate.getMonth() + 1)

        }

        
       //일정 자세히 보기 모달창 닫기 이벤트
        function detailMoadCloseEvent() {
            var contentDetailModal = document.getElementById("contentDetailModal")
            contentDetailModal.style.display ="none"
        }

         // 모달 창 닫기 이벤트
         function closeModalEvent() {
            var inputMySchedule = document.getElementById("inputMySchedule")
            inputMySchedule.style.display = "none"
        }

        //모달창에 월, 일을 찾는 이벤트
        function openInputModalEvent(event) { 
            var clickedDate = event.target.getAttribute("data-day")
            var clickedMonth = event.target.getAttribute("data-month")
            showInputModal(clickedMonth, clickedDate)
        }
        
        //모달창 내용을 저장하는 이벤트
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
        
        //개인정보 보기 이벤트
        function goUserInfoPageEvent(){
            location.href = "userInfo.jsp"
        }

        function showTeamMomverEvents(){
            //여기에 같은 부서의 팀원들의 정보를 fistDiv에 보여주는 코드 작성하기
            
        }

        window.onload = function(){
            createTeamUsers()
            checkLogin()
            createDayBox()
            updateYearMonth(nowDate.getFullYear(), nowDate.getMonth() + 1)
            checkEmpty()
            showContent()
           
        }
    </script>
</body>


