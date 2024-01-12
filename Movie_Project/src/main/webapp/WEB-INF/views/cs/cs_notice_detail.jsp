<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<link href="${pageContext.request.contextPath}/resources/css/cs.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
						
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>
		
		<section id="content">
			<h1 id="h01">공지사항</h1>
			<hr>
			<div id="cs_nav"> <%-- 사이드 메뉴바 --%>
				<jsp:include page="cs_menubar.jsp"></jsp:include>
			</div>
			
			<div id="notice_content">
				<table id="notice_table">
					<tr>
						<th colspan="4">${csNoticeDetail.cs_subject}</th>
					</tr>
					<tr>
						<td class="notice_info">영화관</td>
						<td>${csNoticeDetail.theater_name}</td>
						<td class="notice_info">등록일</td>
						<td class="notice_info">
							<fmt:parseDate value='${csNoticeDetail.cs_date}' pattern="yyyy-MM-dd" var='cs_date'/>
							<fmt:formatDate value="${cs_date}" pattern="yyyy-MM-dd"/>
						</td>
					</tr>
					<tr>
						<td colspan="4"  class="notice_content"><pre id="content_table">${csNoticeDetail.cs_content}</pre></td>
					</tr>
					<tr>
						<td>이전  ▲</td>
						<c:choose>
							<c:when test="${param.cs_type_list_num > 1}">
								<td colspan="3"><a href="csNoticeDetail?cs_type=${param.cs_type}&cs_type_list_num=${param.cs_type_list_num - 1}&pageNum=${param.pageNum}" id="notice_tit">
									${noticeSubject[0].cs_subject}</a></td>		
							</c:when>
							<c:otherwise>
								<td>이전 공지사항이 없습니다</td>
							</c:otherwise>
						</c:choose>
						
					</tr>
					<tr>
						<td>다음  ▼</td>
						<c:choose>
							<c:when test="${param.cs_type_list_num > 1 && param.cs_type_list_num < maxCount}">
								<td colspan="3"><a href="csNoticeDetail?cs_type=${param.cs_type}&cs_type_list_num=${param.cs_type_list_num + 1}&pageNum=${param.pageNum}" id="notice_tit">
									${noticeSubject[1].cs_subject}</a></td>								
							</c:when>
							<c:when test="${param.cs_type_list_num eq 1}">
								<td colspan="3"><a href="csNoticeDetail?cs_type=${param.cs_type}&cs_type_list_num=${param.cs_type_list_num + 1}&pageNum=${param.pageNum}" id="notice_tit">
									${noticeSubject[0].cs_subject}</a></td>								
							</c:when>
							<c:otherwise>
								<td>다음 공지사항이 없습니다</td>
							</c:otherwise>
						</c:choose>
					</tr>
				</table>
				<div id="button">
					<a href="csNotice?pageNum=${param.pageNum}"><input type="button" value="목록"></a>
					</div>
			</div>
		</section>
		
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>	
		</footer>
	</div>
</body>
</html>