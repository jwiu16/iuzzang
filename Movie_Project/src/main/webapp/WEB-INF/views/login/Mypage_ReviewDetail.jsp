<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>iTicket</title>
<%-- 글씨체 --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath }/resources/css/login.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
$(function() {
	$("#reviewDelete").on("click", function() {
		if(confirm("글을 삭제하시겠습니까?")) {
			return true;
		} else {
			return false;
		}
	}); //on click 끝
}); //function 끝


</script>
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
		
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>
		
		<section id="content">	
			<h1 id="h01">리뷰 상세정보 게시판</h1>
			<hr>
			
			<div id="mypage_nav"> <%-- 사이드 메뉴바 --%>
				<jsp:include page="mypage_menubar.jsp"></jsp:include>
			</div>
			
				
			<!-- 바디부분 시작 -->
			
			<form action="reviewDelete" method="get" name="checkform">
				<div id="my_list">
					<h2>리뷰 상세정보 게시판</h2>
					<table id="MyOneOnOneTable">
						<c:forEach var="myReviewDetail" items="${myReviewDetail}">
						<tr>
							<th>번호</th>
							<td>${myReviewDetail.review_id}</td>
						</tr>
						<tr>
							<th>영화제목</th>
							<td>${myReviewDetail.movie_title }</td>
						</tr>
						<tr>
							<th>평점</th>
							<td>${myReviewDetail.review_rating }</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td>${myReviewDetail.member_id }</td>
						</tr>
						<tr>
							<th>작성일</th>
							<td>${myReviewDetail.review_date }</td>
						</tr>
						<tr>
							<th height="200">영화 리뷰 내용</th>
							<td>${myReviewDetail.review_content }</td>
						</tr>
						</c:forEach>
					</table><br>
								
				</div>
					<input type="submit" id="reviewDelete" value="삭제">
					<input type="hidden" id="reviewDelete" name="review_id" value="${param.review_id}">
			</form>
		</section>
	
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>
		</footer>
	</div>
	
</body>
</html>