<%-- admin_board_lostnfound_detail.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">

</style>
<title>iTicket</title>
<%-- 글씨체 --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- <link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css"> --%>
<link href="${pageContext.request.contextPath }/resources/css/login.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
$(function() {
	$("#myLostDelete").on("click", function() {
		if(confirm("문의 글을 삭제하시겠습니까?")) {
			return true;
		} else {
			return false;
		}
	});
	
});
</script>
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>

		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>
		<section id="content">
			<h1 id="h01">분실물 문의 상세 조회페이지</h1>
			<hr>		

			<div id="mypage_nav"> <%-- 사이드 메뉴바 --%>
				<jsp:include page="mypage_menubar.jsp"></jsp:include>
			</div>
			<div id="admin_sub" align="center">
				<form action="myLostDelete">
					<table id="MyOneOnOneTable">
						<tr>
							<th width="150">번호</th>
							<td>${myLostDetail.cs_id}</td>
						</tr>
						<tr>
							<th>분실장소</th>
							<td>${myLostDetail.theater_name }</td>
						</tr>
						<tr>
							<th>분실일시</th>
							<td>${myLostDetail.cs_date }</td>
						</tr>
						<tr>
							<th>문의 제목</th>
							<td>${myLostDetail.cs_subject }</td>
						</tr>
						<tr>
							<th>문의 작성자</th>
							<td>${myLostDetail.member_id }</td>
						</tr>
						<tr>
							<th height="300">문의 내용</th>
							<td>${myLostDetail.cs_content }</td>
						</tr>
						<tr>
							<th>첨부 사진</th>
							<td>
								<c:choose>
									<c:when test="${not empty myLostDetail.cs_file}">
										<div class = "file">
											<c:set var="original_file_name" value="${fn:substringAfter(myLostDetail.cs_file, '_')}"/>
											${original_file_name}
											<a href="${pageContext.request.contextPath }/resources/upload/${myLostDetail.cs_file}" download="${original_file_name}"><input type="button" value="다운로드"></a>
										</div>
									</c:when>
									<c:otherwise>
										없음
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th height="300">답변 내용</th>
							<c:choose>
								<c:when test="${empty myLostDetail.cs_reply}">
									<td id="oneOnOneReplyArea" align="center"> 
										더 나은 고객 응대를 위해<br>
										고객님의 문의를 꼼꼼히 확인하고 있습니다.<br>
										답변을 조금만 더 기다려주세요.<br>
										- 아이티켓
									</td>
								</c:when>
								<c:otherwise>
									<td>
										${myLostDetail.cs_reply }
									</td>
								</c:otherwise>
							</c:choose>
						</tr>
					</table>
					<div id="admin_writer"> 
						<input type="hidden" name="cs_id" value="${myLostDetail.cs_id }">	
						<input type="hidden" name="pageNum" value="${param.pageNum }">	
<!-- 						<input type="submit" value="답변 삭제" formaction=""> --><br>
						<input type="submit" value="삭제하기" id="myLostDelete">
						<input type="button" value="돌아가기" onclick="history.back();">
					</div>
				</form>
			</div>
			<footer>
				<jsp:include page="../inc/bottom.jsp"></jsp:include>
			</footer>
		</section>
	</div>			
</body>
</html>