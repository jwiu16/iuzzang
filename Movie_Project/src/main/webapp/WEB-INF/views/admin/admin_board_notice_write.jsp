<%-- admin_board_notice_write.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>iTicket</title>
<%-- 글씨체 --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources//js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	
	$(function() {		
		// 지점명 불러오기
		$(function() {
			$.ajax({
				type: "GET",
				url: "getTheater",
				success: function(result) {
					for(let theater of result) {
					$("#theater_id").append("<option value='" + theater.theater_id + "'>" + theater.theater_name + "</option>");
					}
				},
				error: function(request,status,error) {
					alert("지점명 로딩 오류입니다:", error);
				}
				
			});
		});
	
		$("form").submit(function() {
			if(confirm("문의를 등록하시겠습니까?")) {
				if($("#subject").val() == "") { 
					alert("제목을 입력해주세요");
					$("#subject").focus();
					return false;
				} else if($("#textarea").val() == "") { 
					alert("내용을 입력해주세요");
					$("#textarea").focus();
					return false;
				}
				return true;
				
			} else {
				return false;
			}	
		});
	
		$("#cancel").on("click", function() {
			if(confirm("작성을 취소하시겠습니까?")) {
				location.href="adminNotice";
			} else {
				return false;
			}
		});
		
	});
		
</script>
</head>
<body>
	<div id="wrapper">
		<nav id="navbar">
			<jsp:include page="../inc/menu_nav_admin.jsp"></jsp:include>
		</nav>
	
		<header>
			<jsp:include page="../inc/top_admin.jsp"></jsp:include>
		</header>
		
		<section id="content">
			<h1 id="h01">공지사항 관리</h1>
			<hr>		
			<div id="admin_sub">
				<form action="adminNoticeWritePro" method="post" enctype="multipart/form-data">
					<table border="1">
						<tr>
							<th width="90px">지점</th>
							<td>
								<select name="theater_id" id="theater_id">
									<option value="0">전체</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td><input type="text" id="id" name="member_id" value="${sessionScope.sId}" readonly> </td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input type="text" id="subject" name="cs_subject"></td>
						</tr>
						<tr>
							<th>내용</th>
							<td><textarea id="textarea" name="cs_content"></textarea></td>
							<input type="hidden" name="cs_type" value="공지사항">
						</tr>
					</table>
					<div id="admin_writer"> 
						<input type="submit" value="등록">
						<input type="button" value="돌아가기" id="cancel">
					</div>
				</form>			
			</div>
		</section>
	</div>		
</body>
</html>