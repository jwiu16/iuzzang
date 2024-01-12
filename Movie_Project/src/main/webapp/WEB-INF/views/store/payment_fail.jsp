<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<link href="${pageContext.request.contextPath }/resources/css/store.css" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
	#sec01{
		height: 400px;
		position: relative;
	}
	.store_pay_table{
		width: 700px!important;
	}
	.cnt{
		height: 50px;
		position:absolute;
		left: 50%;
		top:30%;
		transform:translate(-50%,-50%);
		text-align: center;
		line-height: 50px;
	}
	#orderTable{
		width: 300px;
	}
	.effect{
		color: green;
		animation-name: example;
		animation-duration: 5s;
	}
	
	@keyframes example {
		from {color: black;}
		to {color: green;}
	}
	
</style>
<script>
</script>
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
						
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>	
		
			<div class="store_progress">
				<div id="prog_img"><img src="${pageContext.request.contextPath}/resources/img/pay1.png"></div><div><span class="step">STEP 01</span><br>결제하기</div>
				<div> <span class="bracket"> > </span> </div>
				<div id="prog_img"><img src="${pageContext.request.contextPath}/resources/img/finish2.png"></div><div id="progress_red"><span class="step">STEP 02</span><br>결제완료</div>
			</div>
			<section id="sec01">
			<div class ="cnt">
				<table class="store_pay_table">
					<tr class="store_table_box01">
						<%-- 추후 꾸밀 예정 --%>
						<h1>상품 결제가 실패되었습니다</h1>
					</tr>
				</table>
				<div class="paybtn">
					<a href="store"><input type="button" value="구매하러 가기"></a>
					<a href="./" ><input type="button" value="  홈으로  "></a>
				</div>
			</div>
			</section>
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>
		</footer>
	</div>
</body>
</html>