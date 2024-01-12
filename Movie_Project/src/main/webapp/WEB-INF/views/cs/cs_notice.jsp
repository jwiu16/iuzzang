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
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/cs.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script>
	
	// 지점명 불러오기
	$(function() {
		let urlParams = new URL(location.href).searchParams;
		let theater_id = urlParams.get('theater_id');
// 		console.log(theater_id);
		$.ajax({
			type: "GET",
			url: "getTheater",
			success: function(result) {
				for(let theater of result) {
					if(theater_id != 0 && theater.theater_id == theater_id) {
	                    $("#theater_id").append("<option value='" + theater.theater_id + "' selected>" + theater.theater_name + "</option>");
	                } else {
	                    $("#theater_id").append("<option value='" + theater.theater_id + "'>" + theater.theater_name + "</option>");
	                }
				}
			},
			error: function(request,status,error) {
				alert("지점명 로딩 오류입니다.");
			}
			
		});
	});
	
</script>		
</head>
<body>
	<%-- pageNum 파라미터 가져와서 저장(없을 경우 기본값 1로 설정) --%>
	<c:set var="pageNum" value="1"/>
	<c:if test="${not empty param.pageNum}">
		<c:set var="pageNum" value="${param.pageNum}"/>
	</c:if>

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
			
			<section id="notice_main">
				<form action="csNotice" id="search">
					<select id="theater_id" name="theater_id">
						<option value="0">전체</option> <%-- 전체 지점 공지사항 보기 --%>
					</select>
					<input type="search" placeholder="제목으로 검색하기" id="searchValue" name="searchValue" value="${param.searchValue}"> <%-- 검색어 입력창 --%>
					<input type="submit" value="검색" id="noticeSearch">
				</form>
				<br>
				<section>
					<table id="cs_table1">
						<thead>
							<tr>
								<th width="40">번호</th>
								<th width="120">지점</th>
								<th>제목</th>
								<th width="100">등록일</th>
							</tr>
						</thead>
							
						<tbody>
							<c:choose>
								<c:when test="${empty noticeList}">
									<tr>
										<td colspan="4">검색 결과가 없습니다</td>
									</tr>
								</c:when>
								<c:otherwise>
									<%-- 공지사항 리스트 List<CsVO> 객체(noticeList) 활용하여 목록 출력 --%>
									<c:forEach var="notice" items="${noticeList}">
										<tr>
											<td>${notice.cs_type_list_num}</td> <%-- 내용 넣기 --%>
											<c:choose>
												<c:when test="${notice.theater_id == null}">
													<td>전체</td>
												</c:when>
												<c:otherwise>												
													<td>${notice.theater_name}</td>
												</c:otherwise>
											</c:choose>
											<%-- 제목 클릭 시 해당 게시물로 이동 --%>
											<td id="td_left"><a href="csNoticeDetail?cs_type=${notice.cs_type}&cs_type_list_num=${notice.cs_type_list_num}&pageNum=${pageNum}" id="notice_tit">${notice.cs_subject}</a></td>
											<td>
												<fmt:parseDate value='${notice.cs_date}' pattern="yyyy-MM-dd" var='cs_date'/>
												<fmt:formatDate value="${cs_date}" pattern="yyyy-MM-dd"/>
											</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</section>
				<div class="pagination">
					<%-- '<<' 버튼 클릭 시 현체 페이지보다 한 페이지 앞선 페이지 요청 --%>
					<%-- 다만, 페이지 번호가 1일 경우 비활성화 --%>		
					<c:choose>
						<c:when test="${pageNum eq 1}">
							<a href="" >&laquo;</a>					
						</c:when>
						<c:otherwise>
							<a href="csNotice?pageNum=${pageNum-1}" >&laquo;</a>
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
								<a href="csNotice?pageNum=${i}">${i}</a> <%-- 다른 페이지 번호 --%>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					
					<%-- '>>' 버튼 클릭 시 현체 페이지보다 한 페이지 다음 페이지 요청 --%>
					<%-- 다만, 페이지 번호가 마지막 경우 비활성화 --%>		
					<c:choose>
						<c:when test="${pageNum eq pageInfo.endPage}">
							<a href="" >&raquo;</a>					
						</c:when>
						<c:otherwise>
							<a href="csNotice?pageNum=${pageNum+1}" >&raquo;</a>
						</c:otherwise>				
					</c:choose>
				</div>
			</section>
		</section>
		
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>	
		</footer>
	</div>
</body>
</html>