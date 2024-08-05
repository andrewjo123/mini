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
<style>
	a{
		text-decoration:none; /* 링크 밑줄 없애기 */
	}
</style>
</head>
<body>
	<div class="container">
		<h2 style="margin:50px 0;">목록</h2>
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
		<!-- 검색 폼 -->
	    <form method="get">  
		    <table width="100%">
			    <tr>
			        <td align="center">
				        <div class="input-group mb-3" style="width:50%;">
				            <select name="searchField" class="form-select" style="max-width:150px">
				                <option value="title">제목</option>
                                <option value="content">내용</option>
				            </select>
			            	<input type="text" name="searchWord" class="form-control">
				            <input class="btn btn-primary btn-sm" type="submit" value="검색">
				        </div>
			        </td>
			    </tr>
		    </table>
	    </form>
	  	<!-- 검색폼 End -->
		
		<table class="table" border="1" width="90%">
			<tr align="center">
	            <th width="10%">번호</th>
	            <th width="*">제목</th>
	            <th width="15%">작성자</th>
	            <th width="10%">조회수</th>
	            <th width="15%">작성일</th>
	            <th width="8%">첨부</th>
	        </tr>
		<c:choose>
	  	<c:when test="${empty boardLists}">
	  		<tr>
			  	<td colspan="6" align="center">
			  		등록된 게시물이 없습니다.
			  	</td>
			</tr>
	  	</c:when>
	   	<c:otherwise>
		    <c:forEach items="${boardLists}" var="row" varStatus="loop">
		    <tr align="center">
	            <td>  <!-- 번호 -->
	                ${ map.totalCount - (((map.pageNum-1) * map.pageSize) + loop.index)}   
	            </td>
	            <td align="left">  <!-- 제목(링크) -->
	                <a href="/view.do?idx=${row.idx}" style="color: inherit;">${row.title}</a> 
	            </td> 
		    	<td>${row.name}</td>
		    	<td>${row.visitcount}</td>
		    	<td>${row.postdate}</td>
		    	<td>  <!-- 첨부 파일 -->
		            <c:if test="${not empty row.ofile}">
		                <a href="/download.do?ofile=${row.ofile}&sfile=${row.sfile}&idx=${row.idx}">[Down]</a>
		            </c:if>
	            </td>
		    </tr>	    
		    </c:forEach>
		</c:otherwise>
	    </c:choose>
		</table>
		<!-- 페이지번호. 글쓰기 -->
		<table width="100%">
			<tr align="center">
				<td>
					${map.pagingImg}
				</td>
				<td width="100">
					<button type="button" class="btn btn-outline-primary btn-sm" onclick="location.href='/write.do'">글쓰기</button>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>