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
<script type="text/javascript">
	function validateForm(form){
		if(form.name.value==""){
			alert("작성자를 입력하세요");
			form.name.focus();
			return false;
		}
		if(form.title.value==""){
			alert("제목을 입력하세요");
			form.title.focus();
			return false;
		}
		if(form.content.value==""){
			alert("내용을 입력하세요");
			form.content.focus();
			return false;
		}
		if(form.pass.value==""){
			alert("비밀번호를 입력하세요");
			form.pass.focus();
			return false;
		}
	}
</script>
</head>
<body>
	<div class="container">
		<h2 style="margin:50px 0;">글쓰기</h2>
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
		<form name="writeFrm" method="post" enctype="multipart/form-data" action="/write.do" onsubmit="return validateForm(this);">
			<table class="table" border="1" width="90%">
				<tr>
					<td align="center">작성자</td>
					<td>
						<input type="text" name="name" style="width:150px;">
					</td>
				</tr>
				<tr>
					<td align="center">제목</td>
					<td>
						<input type="text" name="title" style="width:90%;">
					</td>
				</tr>
				<tr>
					<td align="center">내용</td>
					<td>
						<textarea type="text" name="content" rows="20" style="width:90%;"></textarea>
					</td>
				</tr>
				<tr>
					<td align="center">첨부파일</td>
					<td>
						<input type="file" name="ofile" id="file">
					</td>
				</tr>
				<tr>
					<td align="center">비밀번호</td>
					<td>
						<input type="password" name="pass" style="width:100px;">
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<button class="btn btn-primary btn-sm" type="submit">등록</button>
						<button class="btn btn-danger btn-sm" type="reset">취소</button>
						<button class="btn btn-secondary btn-sm" type="button" onclick="location.href='/list.do'">목록</button>
					</td>
					
				</tr>
			</table>
		</form>
	</div>
</body>
</html>