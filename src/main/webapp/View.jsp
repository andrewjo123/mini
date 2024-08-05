<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h2 style="margin:50px 0;">상세보기</h2>
		<div class="form-check form-switch"  style="float: right; margin: 0; padding:0;">
     	<input
        class="form-check-input"
        type="checkbox"
        id="mySwitch"
        name="darkmode"
        value="yes"
     	 />
      	<label class="form-check-label" for="mySwitch">Dark Mode</label>
   		</div>
	    <%
    	String darkMode = request.getParameter("darkmode");
   		 if (darkMode != null) {
        Cookie darkModeCookie = new Cookie("darkMode", darkMode); //쿠키 생성!
        darkModeCookie.setPath(request.getContextPath());
        darkModeCookie.setMaxAge(60 * 60); // 쿠키 1시간
        response.addCookie(darkModeCookie);
   		 }
		%>
		<%
    	Cookie[] cookies = request.getCookies();
    	if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("darkMode")) {
                darkMode = cookie.getValue();
                break;
           		 }
       		 }
  		  }
		%>
		<script>
		  document.addEventListener("DOMContentLoaded", function () {
		    const darkSwitch = document.querySelector("#mySwitch");
		    const cookies = document.cookie.split("; ");
		    let darkMode = "false";
		
		    // 다크 모드 쿠키값 확인
		    for (let cookie of cookies) {
		      const [name, value] = cookie.split("=");
		      if (name == "darkMode") {
		        darkMode = value;
		      }
		    }
		
		    if (darkMode == "true") {
		      document.querySelector("html").setAttribute("data-bs-theme", "dark");
		      darkSwitch.checked = true;
		    } else {
		      document.querySelector("html").setAttribute("data-bs-theme", "");
		      darkSwitch.checked = false;
		    }
		
		    // 쿠키 업데이트
		    darkSwitch.onclick = function () {
		      if (darkSwitch.checked) {
		        document.querySelector("html").setAttribute("data-bs-theme", "dark");
		        document.cookie = "darkMode=true; path=/; max-age=" + (60 * 60); // 한시간
		      } else {
		        document.querySelector("html").setAttribute("data-bs-theme", "");
		        document.cookie = "darkMode=false; path=/; max-age=" + (60 * 60);
		      }
		    };
		  });
		</script>
		<table class="table" border="1" width="90%">
			    <colgroup>
			        <col width="15%"/><col width="35%"/>
			        <col width="15%"/><col width="*"/>
			    </colgroup>
			    <tr>
			        <td>번호</td><td>${dto.idx}</td>
			        <td>작성자</td><td>${dto.name}</td>
			    </tr>
			    <tr>
			        <td>작성일</td><td>${dto.postdate}</td>
			        <td>조회수</td><td>${dto.visitcount}</td>
			    </tr>
			    <tr>
			        <td>제목</td>
			        <td colspan="3">${dto.title}</td>
			    </tr>
			    <tr>
			        <td>내용</td>
			        <td colspan="3" height="100">${dto.content}</td>
			    </tr>
			
			    <!-- 첨부파일 -->
			    <tr>
			        <td>첨부파일</td>
			        <td>
			            <c:if test="${not empty dto.ofile}">
			            ${dto.ofile}
			            <a href="/download.do?ofile=${dto.ofile}&sfile=${dto.sfile}&idx=${dto.idx}">
			                [다운로드]
			            </a>
			            </c:if>
			        </td>
			         <td>다운로드수</td>
			        <td>${dto.downcount}</td>
			    </tr>
			    
			
			    <!-- 하단 메뉴(버튼) -->
			    <tr>
			        <td colspan="4" align="center">
			            <button type="button" class="btn btn-primary btn-sm" onclick="location.href='/pass.do?mode=edit&idx=${param.idx}';">
			                수정하기
			            </button>
			            <button type="button" class="btn btn-danger btn-sm" onclick="location.href='/pass.do?mode=delete&idx=${param.idx}';">
			                삭제하기
			            </button>
			            <button type="button" class="btn btn-secondary btn-sm" onclick="location.href='/list.do';">
			                목록 바로가기
			            </button>
			        </td>
			    </tr>
		</table>
	</div>
</body>
</html>