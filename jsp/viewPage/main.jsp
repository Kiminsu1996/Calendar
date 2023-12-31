<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>


<%

Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 

String idx = (String)session.getAttribute("idx");
String userName = (String)session.getAttribute("name");
String department = (String)session.getAttribute("department");
String position = (String)session.getAttribute("position");
int positionInt = Integer.parseInt(position);

String yearUrl = request.getParameter("year");
String monthUrl = request.getParameter("month");
String selectedUsersValue = request.getParameter("selectedUserIdx_value");

//비로그인으로 일정 페이지 접속 시 예외처리 
if(idx == null || idx.isEmpty()){
    response.sendRedirect("../../login.jsp");
}


ArrayList usersContentInfoEvent = new ArrayList<String>();
ArrayList usersContentEvent = new ArrayList<String>();
ArrayList usersDateEvent = new ArrayList<String>();
ArrayList usersTimeEvent = new ArrayList<String>();
ArrayList usersIdxEvent = new ArrayList<String>();
ArrayList usersNameEvent = new ArrayList<String>();


//선택된 팀원의 일정과 이름을 찾기
if (selectedUsersValue != null && !selectedUsersValue.isEmpty()) {
    String[] selectedUsers = selectedUsersValue.split(",");

    for (String checkedUser : selectedUsers) {

        //선택된 팀원의 일정을 찾는 쿼리문
        String checkUserSql = "SELECT * FROM events WHERE users_idx=? AND YEAR(date) = ? AND MONTH(date) = ? ORDER BY time;";
        PreparedStatement checkUserQuery = connect.prepareStatement(checkUserSql);
        checkUserQuery.setString(1,checkedUser);
        checkUserQuery.setString(2,yearUrl);
        checkUserQuery.setString(3,monthUrl);
        ResultSet checkUserResult = checkUserQuery.executeQuery();
    
    
        while(checkUserResult.next()){
            String usersContent = "\"" + checkUserResult.getString(3)+ "\""; 
            String usersDate = "\"" + checkUserResult.getString(4) + "\""; 
            String usersTime = "\"" + checkUserResult.getString(5) + "\""; 
            String usersIdx = checkUserResult.getString(2); 
            String eventsIdx = checkUserResult.getString(1); 

            usersContentEvent.add(usersContent);
            usersDateEvent.add(usersDate);
            usersTimeEvent.add(usersTime);
            usersIdxEvent.add(eventsIdx);

            usersContentInfoEvent.add(usersContentEvent);
            usersContentInfoEvent.add(usersDateEvent);
            usersContentInfoEvent.add(usersTimeEvent);
            usersContentInfoEvent.add(usersIdxEvent);

            //선택된 팀원의 이름을 찾는 쿼리문
            String checkUserNameSql = "SELECT * FROM users WHERE idx=?;";
            PreparedStatement checkUserNameQuery = connect.prepareStatement(checkUserNameSql);
            checkUserNameQuery.setString(1,usersIdx);
            ResultSet checkUserNameResult = checkUserNameQuery.executeQuery();

            while(checkUserNameResult.next()){
                String userNameData = "\"" + checkUserNameResult.getString(4) + "\""; 
                    usersNameEvent.add(userNameData);
            }
        }
    }
}



ArrayList findUserInfo = new ArrayList<String>();
ArrayList findUserDepartment = new ArrayList<String>();
ArrayList findUserIdx = new ArrayList<String>();

if(positionInt > 1){
    //같은 부서, 직책이 팀원인 사람들을 찾는 쿼리문
    String findUserSql = "SELECT * FROM users WHERE department=? AND position=?;";
    PreparedStatement findUserQuery = connect.prepareStatement(findUserSql);
    findUserQuery.setString(1,department);
    findUserQuery.setString(2,"1");
    ResultSet findUserResult = findUserQuery.executeQuery();
    
    
    while(findUserResult.next()){
        String userIdxData = findUserResult.getString(1); 
        String userNameData = "\"" + findUserResult.getString(4) + "\""; 
        String userDepartmentData = "\"" + findUserResult.getString(5) + "\""; 
        findUserInfo.add(userNameData);
        findUserDepartment.add(userDepartmentData);
        findUserIdx.add(userIdxData);
    }
}


// 로그인 한 사람의 일정에 관한 정보를 찾는 쿼리문(한달기준)
String myContentSql = "SELECT * FROM events WHERE users_idx=? AND YEAR(date) = ? AND MONTH(date) = ? ORDER BY time;";
PreparedStatement myContentQuery = connect.prepareStatement(myContentSql);
myContentQuery.setString(1, idx);
myContentQuery.setString(2, yearUrl);
myContentQuery.setString(3, monthUrl);
ResultSet myContentSqlResult = myContentQuery.executeQuery();

ArrayList eventInfo = new ArrayList<String>();
ArrayList eventIdxEvent = new ArrayList<String>();
ArrayList dateEvent = new ArrayList<String>();
ArrayList timeEvent = new ArrayList<String>();
ArrayList contentEvnet = new ArrayList<String>();

while(myContentSqlResult.next()){
        String eventIdxData = myContentSqlResult.getString(1); 
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
                <div id="userList">
                    <form id="checkBoxForm" action="main.jsp">
                        <button class="checkBtn" type="button" onclick="showTeamMomverEvent()">확인</button>
                    </form>
                </div>
            </div>
            <div id="day"></div>
        </div>
    </main>

    <!-- 일정 입력 폼 -->
    <form id="inputMySchedule" action="../actionPage/makeContentResult.jsp">
        <div id="modalHeader">
            <p id="modalDate"></p>
            <button class="modalCloseBtn" type="button" onclick="closeModalEvent()">X</button>
        </div>

        <div class="modal content">
            <label>내용:</label>
            <input class="modalInput" id="content" type="text" placeholder="내용을 입력해 주세요" name="content_value">
        </div>
        <div class="modal time">
            <label>시간:</label>
            <input class="modalInput" id="time" type="time" name="time_value">            
            <input type="date" id="modalDates" style="display: none" name="date_value">
            <input type="hidden" id="eventIdx" name="eventIdx"> 
        </div>
        <button id="saveModalBtn" class="modalBtn" type="button" onclick="saveModalBtnEvent()">확인</button>
    </form>

    <!-- 일정 자세히 보기 -->
    <div id="contentDetailModal">
        <div id="detailModalHeader">
            <p id="detailModalDate"></p>
            <button class="modalCloseBtn" id="detailModalHeaderCloseBtn" type="button" onclick="detailMoadCloseEvent()">X</button>
        </div>
    </div>

    <script>
        var nowDate = new Date()

        //팀장일 때 팀원들을 보여주는 함수  
        function createTeamUsers(year, month){
            var position = <%=position%>
            var department = <%=department%>
            var findUserInfo = <%=findUserInfo%>
            var findUserDepartment = <%=findUserDepartment%>
            var findUserIdx = <%=findUserIdx%>
            var checkBoxForm = document.getElementById("checkBoxForm")
            var userList = document.getElementById("userList")
            var year = year
            var month = month + 1

            var yearInput = document.createElement('input')
            yearInput.value = year
            yearInput.id = 'yearInput'
            yearInput.name = 'year'
            yearInput.style.display = "none"

            var monthInput = document.createElement('input')
            monthInput.value = month
            monthInput.id = 'monthInput'
            monthInput.name = 'month'
            monthInput.style.display = "none" 

            checkBoxForm.append(yearInput, monthInput)

            for (var i = 0; i < findUserInfo.length; i++) {
                if (position > 1 && findUserDepartment[i] == department) {
                    var usersCheckDiv = document.createElement("div")
                    usersCheckDiv.className = "usersCheckDiv"

                    var checkBox = document.createElement("input")
                    checkBox.className ="checkBox"
                    checkBox.name = "checkBox_value"
                    checkBox.type = "checkbox"
                    checkBox.value = findUserIdx[i]
                    
                    var userName = document.createElement("label")
                    userName.className = "userNameList"
                    userName.innerHTML = findUserInfo[i]
                    
                    usersCheckDiv.append(checkBox, userName)
                    checkBoxForm.appendChild(usersCheckDiv)
                }
            }
        }

        //달력을 만드는 함수 
        function createDayBox() { 
            var day = document.getElementById("day")
            var columns = 7
            var rows = 5
            var widthValue = 100 / columns + "%"
            var heightValue = 100 / rows + "%"
            
            var url = new URLSearchParams(window.location.search);
            var yearUrl = url.get('year');
            var monthUrl = url.get('month');

            for (var i = 0; i < columns * rows; i++) {
                var firstDiv = document.createElement("div")
                var date = i + 1
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
                firstDiv.setAttribute("data-date", yearUrl + "-" + monthUrl + "-" + formattedDate)
                firstDiv.setAttribute("data-month", monthUrl)
                firstDiv.setAttribute("data-day", formattedDate)
                
                if (date <= getDatesInMonth(yearUrl, monthUrl)) {
                    var dateBtn = document.createElement("button")
                    
                    dateBtn.innerHTML = date
                    dateBtn.className = "dateBtn"
                    dateBtn.setAttribute("data-month", monthUrl)
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

         //form 데이터를 보내는 함수 
        function sendForm(method, url, sendData){
            var year = document.getElementById('yearInput').value;
            var month = document.getElementById('monthInput').value;

            var form = document.createElement("form")
            form.method = method
            form.action = url
                
            var keyArray = Object.keys(sendData); 
            for(var i = 0; i < keyArray.length ; i++){  
                var keyValue = keyArray[i];
                var realValue = sendData[keyValue];
                
                var input = document.createElement('input') ;
                input.name = keyValue;
                input.value = realValue;

                form.append(input);
            }
            
            document.body.appendChild(form)

            form.submit()
        }

         //일정을 캘린더에 보여주는 함수
        function showContent(year, month) { 
            var firstDivs = document.querySelectorAll(".firstDiv")

            //로그인한 사람의 이름과 일정
            var eventInfo = <%=eventInfo%> 
            var userNames = <%=userName%> 

            //체크된 사람들의 이름과 일정 (팀장일때만)
            var usersContentInfoEvent = <%=usersContentInfoEvent%>
            var usersNameEvent = <%=usersNameEvent%> 
           
        
            for (var i = 0; i < firstDivs.length; i++) {
                var firstDivDate = firstDivs[i].getAttribute("data-date") 
                var firstDivMonth = firstDivs[i].getAttribute("data-month") 
                var firstDivDay = firstDivs[i].getAttribute("data-day") 
              
                // 해당 날짜에 대한 일정 정보, 이름을 저장할 배열
                var eventsOnDate = []
                
                // 로그인한 사람의 일정 정제
                if(eventInfo[1]){ 
                    for (var j = 0; j < eventInfo[1].length; j++) {
                        if (firstDivDate === eventInfo[1][j]) {
                            var eventContent = eventInfo[0][j] //내용
                            var eventTime = eventInfo[2][j] // 시간
                            var processEventTime = eventTime.split(":", 2)
                            var userName = userNames
                            // 해당 날짜에 대한 일정 정보를 객체로 저장
                            var eventInfoObj = {
                                content : eventContent,
                                time : processEventTime[0] + ":" + processEventTime[1],
                                name : userName
                            }

                            eventsOnDate.push(eventInfoObj)
                        }
                    }
                }
        
                // 체크된 팀원에 대한 일정 정제 
                if (usersContentInfoEvent[1]) {
                    for (var j = 0; j < usersContentInfoEvent[1].length; j++) {
                        if (firstDivDate === usersContentInfoEvent[1][j]) {
                            var eventContent = usersContentInfoEvent[0][j]; 
                            var eventTime = usersContentInfoEvent[2][j]
                            var processEventTime = eventTime.split(":", 2)
                            var userName = usersNameEvent[j]
                            
                            var eventInfoObj = {
                                content : eventContent,
                                time : processEventTime[0] + ":" + processEventTime[1],
                                name : userName
                            }

                            eventsOnDate.push(eventInfoObj)
                        }
                    }
                }
            
                //내용 뿌려주기
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
                    var userName = eventInfoObj.name

                    //이름
                    var nameDiv = document.createElement("div")
                    nameDiv.className = "contentUserName"
                    nameDiv.innerHTML = userName

                    //시간
                    var timeDiv = document.createElement("div")
                    timeDiv.className = "contentUserTime"
                    timeDiv.innerHTML = eventTime

                    //내용
                    var contentDiv = document.createElement("div")
                    contentDiv.className = 'contentUserDetail'
                    contentDiv.innerHTML = eventContent

                    infoBtn.append(nameDiv, timeDiv, contentDiv)
                }
                
                firstDiv.appendChild(infoBtn)
                infoBtn.addEventListener("click", infoBtnClickEvent)
            }
        }

          //일정을 입력하는 모달창 열기
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

        //일정 자세히 보기  
        function infoBtnClickEvent() {
            var position = <%=position%>
            //로그인한 사람의 이름과 일정
            var eventInfo = <%=eventInfo%>
            var userName = <%=userName%>

            //체크된 사람들의 이름과 일정 (팀장일때만)
            var usersContentInfoEvent = <%=usersContentInfoEvent%>
            var usersNameEvent = <%=usersNameEvent%>

            var firstDivs = document.querySelectorAll(".firstDiv")

            var infoBtnMonth = event.currentTarget.getAttribute("data-month")
            var infoBtnDay = event.currentTarget.getAttribute("data-day")
    
            var month = parseInt(infoBtnMonth)
            var day = parseInt(infoBtnDay)

            // 일정 자세히 보기 부모 모달창
            var contentDetailModal = document.getElementById("contentDetailModal")
            contentDetailModal.style.display = "flex"
            contentDetailModal.style.justifyContent = "center"
            contentDetailModal.style.alignItems = "center"
            contentDetailModal.style.flexDirection = "column"
            contentDetailModal.setAttribute("data-month", infoBtnMonth)
            contentDetailModal.setAttribute("data-day", infoBtnDay)

            // 일정 자세히 보기 date 표시 div
            var detailModalHeader = document.getElementById("detailModalHeader")
    
            // 일정 자세히 보기 date 표시
            var detailModalDate = document.getElementById("detailModalDate")
            detailModalDate.innerHTML = month + "월 " + day + '일'

            // 일정 자세히 보기 X (나가기) 버튼
            var modalCloseBtn = document.getElementById("detailModalHeaderCloseBtn")
            
            // 일정이 표시되는 부모 div 
            var contentDetails = document.createElement("div")
            contentDetails.id = "contentDetails"

            for (var i = 0; i < firstDivs.length; i++) {

                //팀원이 일정을 볼 때 
                if (eventInfo[1] && eventInfo[1][i] === nowDate.getFullYear() + '-' + infoBtnMonth + '-' + infoBtnDay) {
                    var eventTime = eventInfo[2][i] //시간
                    var loginUserName = userName //이름 
                    var eventContent = eventInfo[0][i] //내용
                    var processEventTime = eventTime.split(":", 2) // 시간 데이터 가공
                    var eventIdx = eventInfo[3][i]
                  
                    console.log("userName1 =" + loginUserName)
                    // 유저의 일정이 표시되는 자식 div 
                    var eventElements = document.createElement("div")
                    eventElements.className = "eventElements"
                    
                    // 자세한 유저의 일정이 표시되는 div
                    var eventInfos = document.createElement("div")
                    eventInfos.id= "eventInfos"
                    eventInfos.setAttribute("data-time", processEventTime)
                    eventInfos.innerHTML = processEventTime[0] + ":" + processEventTime[1] + " " + loginUserName + "<br>" + eventContent;

                    //팀장은 테두리 색이 빨강색 
                    if(position >1){
                        eventInfos.style.border = "1px solid red"
                    }
                
                    //일정 수정버튼
                    var modifyContentATag = document.createElement("button")
                    modifyContentATag.innerHTML = "수정"
                    modifyContentATag.id = "detailModalBtnTag"
                    modifyContentATag.type = "button"
                    modifyContentATag.setAttribute("eventContent",eventContent)
                    modifyContentATag.setAttribute("eventTime",eventTime)
                    modifyContentATag.setAttribute("eventIdx",eventIdx)
                    modifyContentATag.addEventListener("click",changeContentEvent)
                    
                    //일정 삭제버튼
                    var deleteContentATag = document.createElement("a")
                    deleteContentATag.innerHTML = "삭제"
                    deleteContentATag.className = "detailModalATag"
                    deleteContentATag.href ="../actionPage/deleteContent.jsp?idx=" + eventInfo[3][i]
                    

                    var btnDiv = document.createElement("div")
                    btnDiv.id = "btnDiv"

                    var eventIdxInput = document.getElementById("eventIdx")
                    eventIdxInput.value = eventIdx

                    btnDiv.append(modifyContentATag, deleteContentATag)
                    eventElements.append(eventInfos, btnDiv)
                    contentDetails.appendChild(eventElements)
                }

                //팀장이 팀원의 일정을 볼때 
                if (usersContentInfoEvent[1] && usersContentInfoEvent[1][i] === nowDate.getFullYear() + '-' + infoBtnMonth + '-' + infoBtnDay) {
                    var eventTime = usersContentInfoEvent[2][i] //시간
                    var teamMembersName = usersNameEvent[i] //이름 
                    var eventContent = usersContentInfoEvent[0][i] //내용
                    var processEventTime = eventTime.split(":", 2) // 시간 데이터 가공
                    var eventIdx = usersContentInfoEvent[3][i]

                    // 유저의 일정이 표시되는 자식 div 
                    var eventElements = document.createElement("div")
                    eventElements.className = "eventElements"
                    
                    // 자세한 유저의 일정이 표시되는 div
                    var eventInfos = document.createElement("div")
                    eventInfos.id= "eventInfos"
                    eventInfos.setAttribute("data-time", processEventTime)
                    eventInfos.innerHTML = processEventTime[0] + ":" + processEventTime[1] + " " + teamMembersName + "<br>" + eventContent;

                    var eventIdxInput = document.getElementById("eventIdx")
                    eventIdxInput.value = eventIdx

                    eventElements.appendChild(eventInfos)
                    contentDetails.appendChild(eventElements)
                }
            }

            contentDetailModal.innerHTML = ''
            detailModalHeader.append(detailModalDate, modalCloseBtn)
            contentDetailModal.append(detailModalHeader, contentDetails)
        }

         // 월을 변경하고 일자 업데이트
        function changeMonthEvent(month) {
            var year = nowDate.getFullYear()
            var currentMonth = nowDate.getMonth() + 1
            var newMonth = currentMonth + month

            if (newMonth > 12) {
                year++
                newMonth -= 12
            } else if (newMonth < 1) {
                year--;
                newMonth += 12
            }

            nowDate.setFullYear(year)
            nowDate.setMonth(newMonth - 1)

            updateYearMonth(year, newMonth)
            updateCalendar()
            showContent(year, newMonth)

            var formattedMonth = (newMonth < 10 ? "0" : "") + newMonth
            location.href = 'main.jsp?year=' + year + '&month=' + formattedMonth

        }

        
       //일정 자세히 보기 모달창 닫기 이벤트
        function detailMoadCloseEvent() {
            //일정 자세히 보기 form 
            var contentDetailModal = document.getElementById("contentDetailModal")
            contentDetailModal.style.display ="none"
        }

         // 모달 창 닫기 이벤트
         function closeModalEvent() {
            //일정 입력 form 
            var inputMySchedule = document.getElementById("inputMySchedule")
            inputMySchedule.style.display = "none"
        }

        //모달창에 월, 일을 찾는 이벤트
        function openInputModalEvent(event) { 
            var clickedMonth = event.target.getAttribute("data-month")
            var clickedDate = event.target.getAttribute("data-day")
            showInputModal(clickedMonth, clickedDate)
        }
        
        //모달창 내용을 저장하는 이벤트
        function saveModalBtnEvent(){
            var content = document.getElementById("content")
            var time = document.getElementById("time")
            var empty= time.value
            var formTime = empty + ":00"
            time.value = formTime

            if(content.value === "" || time.value === ""){
                alert("빈칸 없이 다 적어주세요.")
            }else{
                document.getElementById("inputMySchedule").submit()
            }

        }
    
        //모달창의 내용을 수정하는 이벤트
        function changeContentEvent(e){
            var eventInfo = <%=eventInfo%>
            var eventIdxInput = document.getElementById("eventIdx");

            //일정 자세히 보기 모달창
            var contentDetailModal = document.getElementById("contentDetailModal")
            contentDetailModal.style.display="none"

            //form태그 만들기
            var inputMySchedule = document.getElementById("inputMySchedule")
            inputMySchedule.style.display = "flex"
            inputMySchedule.style.justifyContent = "center"
            inputMySchedule.style.alignItems = "center"
            inputMySchedule.style.flexDirection = "column"
            inputMySchedule.action = '../actionPage/changeContentResult.jsp' 

            //일정 자세히 모달창에서 월,일 데이터 가져오기
            var contentDetailMonth = contentDetailModal.getAttribute("data-month")
            var contentDetailDay = contentDetailModal.getAttribute("data-day")

            //선택된 일정의 유저 idx의 가져오기
            var eventIdx = e.target.getAttribute("eventIdx")
            eventIdxInput.value = eventIdx

            var content = document.getElementById("content")
            content.name = "contents_value"

            var time = document.getElementById("time")
            time.name = "times_value"

            var modalDates = document.getElementById("modalDates")
            modalDates.name = "dates_value"

            //모달창의 일정 입력
            var modalDate = document.getElementById("modalDate")
            modalDate.innerHTML = contentDetailMonth + "월" + contentDetailDay + "일"

            var year = nowDate.getFullYear()
            var formattedDate = year + "-" + (contentDetailMonth < 10 ? "0" : "") + contentDetailMonth + "-" + (contentDetailDay < 10 ? "0" : "") + contentDetailDay
            modalDates.value = formattedDate

            var firstDivs = document.querySelectorAll(".firstDiv")
            
            var contents = e.target.getAttribute("eventContent")
            var times = e.target.getAttribute("eventTime")
            var realTimes = times.split(":", 2)
           
            for (var i = 0; i < firstDivs.length; i++) {
                if (eventInfo[1][i] === nowDate.getFullYear() + '-' + contentDetailMonth + '-' + contentDetailDay) {
                    var content = document.getElementById("content")
                    var time = document.getElementById("time")

                    content.value = contents
                    time.value = realTimes[0] + ":" +realTimes[1]
                }
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

        //팀원들의 이름을 보여주는 이벤트
        function showTeamMomverEvent(){
            var userCheckBoxes = document.querySelectorAll('.checkBox')
            var year = document.getElementById('yearInput').value;
            var month = document.getElementById('monthInput').value;
            
            var checkBox = []
            for (var i = 0; i < userCheckBoxes.length; i++) {
                if (userCheckBoxes[i].checked) {
                    checkBox.push(userCheckBoxes[i].value)
                }
                
                if (checkBox.length > 0) {
                    const sendData = {
                            year : year,
                            month : month,
                            selectedUserIdx_value : checkBox
                        }

                    sendForm('GET', '/test3/jsp/viewPage/main.jsp', sendData)

                }else{
                    location.href = "main.jsp?year=" + year + "&month=" + month
                }
            }
            
            localStorage.setItem('checkBoxState', JSON.stringify(checkBox))
        }


        window.onload = function(){
            // URL에서 연도와 월을 읽어오기
            var url = new URLSearchParams(window.location.search)
            var yearUrl = url.get('year')
            var monthUrl = url.get('month')
 
            var year = parseInt(yearUrl)
            var month = parseInt(monthUrl) - 1

            createTeamUsers(year, month)
            createDayBox()

            nowDate = new Date(year, month, 1)
            updateYearMonth(year, month + 1)
            showContent(year, month + 1)

            //팀장일 때만 확인버튼이 보이게 하기 
            var position = <%=position%>

            if(position < 2){
                var checkBtn = document.querySelector(".checkBtn")
                checkBtn.style.display = "none"
            }

            //체크박스 상태 유지하기
            var checkBoxState = localStorage.getItem('checkBoxState')

            if (checkBoxState) {
                var checkBoxState = JSON.parse(checkBoxState)
                var userCheckBoxes = document.querySelectorAll('.checkBox')

                for (var i = 0; i < userCheckBoxes.length; i++) {
                    if (checkBoxState.includes(userCheckBoxes[i].value)) {
                        userCheckBoxes[i].checked = true;
                    }
                }
            }

            //스토리지 초기화
            localStorage.clear()
        }

    </script>
</body>


