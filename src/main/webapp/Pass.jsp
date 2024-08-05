<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    function validateForm(form) {
        if (form.pass.value == "") {
            alert("비밀번호를 입력하세요.");
            form.pass.focus();
            return false;
        }
    }
</script>
</head>
<body>
<div class="container">
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
	<h2 style="margin:50px 0;">비밀번호 검증</h2>
	<form name="writeFrm" method="post" action="/pass.do" onsubmit="return validateForm(this);">
	<input type="hidden" name="idx" value="${param.idx}"/>
	<input type="hidden" name="mode" value="${param.mode}"/>
	<table border="1" width="90%">
	    <tr>
	        <td align="center">비밀번호</td>
	        <td>
	        	<div lass="input-group mb-4">
	            	<input type="password" name="pass" class="form-control" style="width:100px;"/>
	            </div>
	        </td>
	    </tr>
	    <tr>
	        <td colspan="2" align="center">
	        <!-- 기본 값이 submit -->
	            <button class="btn btn-primary btn-sm">확인</button>
	            <button class="btn btn-danger btn-sm" type="reset">취소</button>
	            <button class="btn btn-secondary btn-sm" type="button" onclick="location.href='/list.do';">
	                목록 바로가기
	            </button>
	        </td>
	    </tr>
	</table>    
	</form>
</div>
</body>
</html>