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
<link href="${pageContext.request.contextPath}/resources/css/cs.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
						
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>
		
		<section id="content">
			
			<h1 id="h01">고객센터</h1>
			<hr>
			<div id="cs_nav"> <%-- 사이드 메뉴바 --%>
				<jsp:include page="cs_menubar.jsp"></jsp:include>
			</div>
			
			<section id="cs_main_div">	
				<div class="main_shortcuts"><%-- 바로가기 --%>
					<b>고객센터 바로가기</b><br>
					<a href="csOneOnOneForm">
						<img src="${pageContext.request.contextPath}/resources/img/1to1.png" alt="1:1 이미지">
						<span>1 : 1 문의</span>
					</a>
					<a href="csLostForm">
						<img src="${pageContext.request.contextPath}/resources/img/lost.png" alt="분실물 이미지">
						<span>분실물 문의</span>
					</a>
					<a href="csFaq">
						<img src="${pageContext.request.contextPath}/resources/img/faq.png" alt="FAQ 이미지">
						<span>자주 묻는 질문</span>
					</a>
				</div>
				<hr>
				<div class="main_shortcuts"><%-- 바로가기 --%>
					<b>자주 찾는 서비스</b><br>
					<a href="idFind">
						<img src="${pageContext.request.contextPath}/resources/img/id-card.png" alt="1:1 이미지">
						<span>아이디/<br>비밀번호 찾기</span>
					</a>
					<a href="MypageReservboardList">
						<img src="${pageContext.request.contextPath}/resources/img/ticket.png" alt="분실물 이미지">
						<span>예매/취소<br>내역 확인</span>
					</a>
					<a href="MypageOneOnOneList">
						<img src="${pageContext.request.contextPath}/resources/img/list.png" alt="FAQ 이미지">
						<span>나의 문의<br>내역 확인</span>
					</a>
				</div>
				
				<hr>
				<section id="cs_best">
					<div id="main_faq"> <%-- 자주묻는질문 바로가기 --%>
						<h2>자주 묻는 질문 BEST5</h2>
						<a href="csFaq">더보기</a>
						<ol class="ol">
							<c:choose>
								<c:when test="${empty faqMainList}">
									자주묻는질문 없음
								</c:when>
								<c:otherwise>
									<c:forEach begin="0" end="4" var="faq" items="${faqMainList}">
										<li><a href="csFaq?cs_type_list_num=${faq.cs_type_list_num}"><span id="cs_type_detail">[${faq.cs_type_detail}]</span> <span id="cs_subject">${faq.cs_subject}</span></a></li> <%-- 자주묻는질문 상위 5개만 보여주기 --%>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</ol>
					</div>
					
					<div id="main_notice"> <%-- 공지사항 바로가기 --%>
						<h2>공지사항</h2>
						<a href="csNotice">더보기</a>
						<ol class="ol">
							<c:choose>
								<c:when test="${empty noticeMainList}">
									공지사항 없음
								</c:when>
								<c:otherwise>
									<c:forEach begin="0" end="4" var="notice" items="${noticeMainList}">
										<li><img src="${pageContext.request.contextPath}/resources/img/megaphone.png">
											<a href="csNoticeDetail?cs_type=${notice.cs_type}&cs_type_list_num=${notice.cs_type_list_num}&pageNum=1"><span id="cs_subject">${notice.cs_subject}</span></a>
										</li> <%-- 자주묻는질문 최신 5개만 보여주기 --%>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</ol>
					</div>
				</section>
				<div id="cs_call">
					<hr>
					iTicket 고객센터 ☎1544-0000 |
					상담가능 시간 : 월 ~ 금 10:00~12:00 |
					* 이 외 시간은 자동 응답 안내 가능 
					<hr>
				</div>
			</section>	
		</section>
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>	
		</footer>
	</div>
</body>
</html>