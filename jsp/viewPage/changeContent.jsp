<%@ page language ="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/calendar","stageus","1234"); 

String idx = (String)session.getAttribute("idx");
String eventsIdx = request.getParameter("events_idx");


String eventsInfoSql = "SELECT * FROM events WHERE events_idx=?;";
PreparedStatement eventsInfoQuery = connect.prepareStatement(eventsInfoSql);
eventsInfoQuery.setString(1,eventsIdx);
ResultSet eventsInfoResult = eventsInfoQuery.executeQuery();

ArrayList eventsInfo = new ArrayList<String>();

while(eventsInfoResult.next()){
    String eventsIdxData =  eventsInfoResult.getString(1); 
    String eventContentData =  "\"" + eventsInfoResult.getString(3) + "\""; 
    String eventDateData =  "\"" + eventsInfoResult.getString(4) + "\""; 
    String eventTimeData =  "\"" + eventsInfoResult.getString(5) + "\""; 

    eventsInfo.add(eventContentData);
    eventsInfo.add(eventDateData);
    eventsInfo.add(eventTimeData);
    session.setAttribute("eventIdx", eventsIdxData);
}

%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../../css/mainPageShare.css">
    <title>Document</title>
</head>
<body>
    <main>
        <div id="changeModalInfo">
            <!-- 일정 입력 폼 -->
            <form id="changeMySchedule" action="../actionPage/changeContentResult.jsp">
                <div id="modalHeader">
                    <p id="modalDate"></p>
                </div>

                <div class="modal content">
                    <label>내용:</label>
                    <input class="modalInput" id="content" type="text" placeholder="내용을 입력해 주세요" name="content_value">
                </div>

                <div class="modal time">
                    <label>시간:</label>
                    <input class="modalInput" id="time" type="time" name="time_value">            
                </div>

                <div>
                <button class="modalBtn" type="button" onclick="goMainPageEvent()">뒤로가기</button>
                <button id="saveModalBtn" class="modalBtn" type="submit">확인</button>
                </div>
            </form>
        </div>
    </main>
    

    <script>
        var nowDate = new Date()

        function checkLogin(){
            var idx = <%=idx%>
            if(idx < 1){
                location.href = "../../login.jsp"
            }
        }
        

        //모달창 열기
        function showInputModal() {
            var eventsInfo = <%=eventsInfo%>
            var modal = document.getElementById("changeMySchedule")
            var modalDate = document.getElementById("modalDate")
            var content = document.getElementById("content")
            var time = document.getElementById("time")

            var changeInfo =eventsInfo[1]
            var splitInfo = changeInfo.split('-')

            var month = parseInt(splitInfo[1]);
            var day = parseInt(splitInfo[2]);

            modalDate.innerHTML = month + "월" + day + "일"
            modal.style.display = "flex"
            modal.style.justifyContent = "center"
            modal.style.alignItems = "center"
            modal.style.flexDirection = "column"

            content.value = eventsInfo[0]
            time.value = ""
        }

        //모달창에 일정 입력 빈값 확인 함수 
        function checkEmpty(){
            var saveModalBtn = document.getElementById("saveModalBtn")
            saveModalBtn.addEventListener("click",saveModalBtnEvent)
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

        function goMainPageEvent(){
            location.href = "main.jsp"
        }
        window.onload = function(){
            checkLogin()
            checkEmpty()
            showInputModal()
        }
       
    </script>
</body>


