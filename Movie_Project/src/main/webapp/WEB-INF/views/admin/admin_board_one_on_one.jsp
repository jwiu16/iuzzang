<%-- admin_board_one_on_one.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%-- pageNum 파라미터 가져와서 저장(없을 경우 기본값 1 로 저장) --%>
	<c:set var="pageNum" value="1" />
	<c:if test="${not empty param.pageNum }">
		<c:set var="pageNum" value="${param.pageNum }" />
	</c:if>
	
	
	<div id="wrapper">
		<nav id="navbar">
            <jsp:include page="../inc/menu_nav_admin.jsp"></jsp:include>
        </nav>
		<header>
			<jsp:include page="../inc/top_admin.jsp"></jsp:include>
		</header>
		
		<section id="content">
			<h1 id="h01">1대1문의 관리</h1>
			<hr>
			<div id="admin_main">
				<div id="admin_search">
					<form>
						<select name="searchType">
							<option value=""  <c:if test="${param.searchType eq '' }">selected</c:if>>문의유형</option>
							<option value="영화관" <c:if test="${param.searchType eq '영화관' }">selected</c:if>>영화관</option>
							<option value="영화" <c:if test="${param.searchType eq '영화' }">selected</c:if>>영화</option>
							<option value="예매/결제" <c:if test="${param.searchType eq '예매/결제' }">selected</c:if>>예매/결제</option>
							<option value="관람권/할인권" <c:if test="${param.searchType eq '관람권/할인권' }">selected</c:if>>관람권/할인권</option>
							<option value="개인정보" <c:if test="${param.searchType eq '개인정보' }">selected</c:if>>개인정보</option>
							<option value="칭찬/불만/제안" <c:if test="${param.searchType eq '칭찬/불만/제안' }">selected</c:if>>칭찬/불만/제안</option>
						</select>
						<input type="text" name="searchKeyword" value="${param.searchKeyword }" placeholder="제목, 내용으로 검색">
						<input type="submit" value="검색">
					</form>
				</div>
			
				<table border="1">
					<tr>
						<th width="60">번호</th>
						<th width="150">유형</th>
						<th>제목</th>
						<th width="100">작성자</th>
						<th width="120">등록일</th>
						<th width="95">답변상태</th>
					</tr>
					<c:choose>
						<c:when test="${not empty oneOnOneList }">
							<c:forEach var="oneOnOne" items="${oneOnOneList }">
								<tr>
									<td>${oneOnOne.cs_id }</td>
									<td>${oneOnOne.cs_type_detail }</td>
									<td class="post_name"><a href="OneOnOneDetail?cs_id=${oneOnOne.cs_id }&pageNum=${pageNum }">${oneOnOne.cs_subject }</a></td>
									<td>${oneOnOne.member_id }</td>
									<td>${oneOnOne.cs_date }</td>
									<c:choose>
										<c:when test="${empty oneOnOne.cs_reply }">
											<td><a href="OneOnOneMoveToRegister?cs_id=${oneOnOne.cs_id }&pageNum=${pageNum }"><input type="button" value="답변등록" id="btnOneOnOneresponse"></a></td>
										</c:when>
										<c:otherwise>
											<td><a href="OneOnOneDetail?cs_id=${oneOnOne.cs_id }&pageNum=${pageNum }"><input type="button" value="답변완료" id="ok"></a></td>
										</c:otherwise>
									</c:choose>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="6">검색 조건에 해당하는 1대1문의 내역이 존재하지 않습니다.</td>
							</tr>							
						</c:otherwise>
					</c:choose>					
					
				</table>
				<div class="pagination">
						<%-- '<<' 버튼 클릭 시 현체 페이지보다 한 페이지 앞선 페이지 요청 --%>
						<%-- 다만, 페이지 번호가 1일 경우 비활성화 --%>		
						<c:choose>
							<c:when test="${pageNum eq 1}">
								<a href="" >&laquo;</a>					
							</c:when>
							<c:otherwise>
								<a href="adminOneOnOne?searchType=${param.searchType }&searchKeyword=${param.searchKeyword }&pageNum=${pageNum-1}" >&laquo;</a>
							</c:otherwise>				
						</c:choose>
						<%-- 현재 페이지가 저장된 pageInfo 객체를 통해 페이지 번호 출력 --%>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<%-- 각 페이지마다 하이퍼링크 설정(페이지번호를 pageNum 파라미터로 전달) --%>
							<%-- 단, 현재 페이지는 하이퍼링크 제거하고 굵게 표시 --%>
							<c:choose>
								<%-- 현재 페이지번호와 표시될 페이지번호가 같을 경우 판별 --%>
								<c:when test="${pageNum eq i}">
									<a class="active" href="">${i}</a> <%-- 현재 페이지 번호 --%>
								</c:when>
								<c:otherwise>
									<a href="adminOneOnOne?searchType=${param.searchType }&searchKeyword=${param.searchKeyword }&pageNum=${i}">${i}</a> <%-- 다른 페이지 번호 --%>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						
						<%-- '>>' 버튼 클릭 시 현체 페이지보다 한 페이지 다음 페이지 요청 --%>
						<%-- 다만, 페이지 번호가 마지막 경우 비활성화 --%>		
						<c:choose>
							<c:when test="${pageNum eq pageInfo.maxPage}">
								<a href="" >&raquo;</a>					
							</c:when>
							<c:otherwise>
								<a href="adminOneOnOne?searchType=${param.searchType }&searchKeyword=${param.searchKeyword }&pageNum=${pageNum+1}" >&raquo;</a>
							</c:otherwise>				
						</c:choose>
					</div>
				</div>
		</section>
	</div>
</body>
</html>