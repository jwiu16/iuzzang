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
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/join.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script>
	$(function() {
		<%-- 뒤로가기 방지 --%>
		if (performance.navigation.type === 2) { <%-- 0 : 처음 로딩/새로고침, 1 : 페이지가 앞/뒤로 이동, 2 : 페이지가 뒤로 이동  --%>
			alert('비정상적인 접근입니다.\n메인페이지로 이동합니다.');
			location.href = './'; //다른 페이지로 이동
		}
		
		let isDuplicateId = false; <%-- 아이디 중복 여부를 저장할 변수 선언 --%>
		let isDuplicateEmail = false; <%-- 이메일 중복 여부를 저장할 변수 선언 --%>
		let isDuplicatePhone = false; <%-- 휴대폰번호 중복 여부를 저장할 변수 선언 --%>
		
		let isSamePasswd = false; <%-- 패스워드 일치 여부를 저장할 변수 선언 --%>
		let isSafePasswd = false; <%-- 패스워드 안전도를 저장하는 변수 --%>
		
		let iscorrectId = false; <%-- 아이디가 정규표현식에 적합한지를 저장할 변수 선언 --%>
		let iscorrectPasswd = false; <%-- 비밀번호가 정규표현식에 적합한지를 저장할 변수 선언 --%>
		let iscorrectName = false; <%-- 이름이 정규표현식에 적합한지를 저장할 변수 선언 --%>
		let iscorrectPhone = false; <%-- 휴대폰번호가 정규표현식에 적합한지를 저장할 변수 선언 --%>
<%-- 		let iscorrectEmail = false; 이메일이 정규표현식에 적합한지를 저장할 변수 선언 --%>
		let iscorrectBirth = false; <%-- 생일이 정규표현식에 적합한지를 저장할 변수 선언 --%>
		
		
		$("#id").blur(function() {
			let member_id = $("#id").val();
			<%-- 아이디 길이, 문자 종류 확인 --%>
			let regId = /^[A-Za-z0-9]{5,20}$/; <%-- 5~20자의 영문(대소문자), 숫자 --%>
			if(!regId.exec(member_id)) {
				$("#checkIdResult").text("5~20자의 영문 대/소문자, 숫자를 입력해주세요").css("color", "red");
				iscorrectId = false;
			} else {
				<%-- AJAX를 통해 아이디 중복값 확인 --%>
				$.ajax({
					url: "checkDup",
					data: {
						"member_id" : member_id
					},
					dataType: "json",
					success: function(checkDupId) {
						if(checkDupId) { // 중복
 							$("#checkIdResult").text("이미 사용중인 아이디입니다").css("color", "red");
 							iscorrectId = false;
 							isDuplicateId = true;
						} else { // 사용가능
							$("#checkIdResult").text("사용 가능한 아이디입니다").css("color", "blue");
							iscorrectId = true;
 							isDuplicateId = false;
						}
							
					},
					error: function(request,status,error) {
					      // 요청이 실패한 경우 처리할 로직
					      console.log("AJAX 요청 실패:", error); // 예시: 에러 메시지 출력
					}
				});
			}
		});	
		
		
		<%-- 패스워드 확인 --%>
		$("#passwd").blur(function() {	
			let member_passwd = $("#passwd").val();
			
			<%-- 비밀번호 길이, 문자종류 검증 --%>
			let regPw = /^[A-Za-z0-9!@#%^&*]{8,16}$/; <%-- 8~16자의 영문 대/소문자, 숫자, 특수문자(!@#%^&*) --%>
			if(!regPw.exec(member_passwd)) { <%-- 비밀번호 길이, 문자종류 위반 --%>
				$("#checkPasswdResult").text("8~16자의 영문 대/소문자, 숫자, 특수문자(!@#%^&*)만 사용 가능합니다").css("color", "red");
				iscorrectPasswd = false;
			} else { <%-- 통과했을 때 복잡도 검증 실행 --%>
				let count = 0; <%-- 복잡도 점수를 저장할 변수 선언 --%>
				
				let regEngUpper = /[A-Z]/; <%-- 대문자 --%>
				let regEngLower = /[a-z]/; <%-- 소문자 --%>
				let regNum = /[0-9]/; <%-- 숫자 --%>
				let regSpec = /[!@#%^&*]/; <%-- 특수문자(!@#%^&*) --%>
			
				if(regEngUpper.exec(member_passwd)) count++; <%-- 대문자가 있으면 +1점 --%>
				if(regEngLower.exec(member_passwd)) count++; <%-- 소문자가 있으면 +1점 --%>
				if(regNum.exec(member_passwd)) count++; <%-- 숫자가 있으면 +1점 --%>
				if(regSpec.exec(member_passwd)) count++; <%-- 특수문자가 있으면 +1점 --%>
				
				switch (count) {
					case 4: 
						$("#checkPasswdResult").text("안전! 사용할 수 있습니다").css("color", "green");
						isSafePasswd = true;
						iscorrectPasswd = true;
						break;
					case 3: 
						$("#checkPasswdResult").text("보통! 사용할 수 있습니다").css("color", "blue");
						isSafePasswd = true;
						iscorrectPasswd = true;
						break;
					case 2: 
						$("#checkPasswdResult").text("주의! 사용할 수 없습니다").css("color", "orange");
						isSafePasswd = false;
						iscorrectPasswd = false;
						break;
					case 1: 
					case 0: 
						$("#checkPasswdResult").text("위험! 사용할 수 없습니다").css("color", "red");
						isSafePasswd = false;
						iscorrectPasswd = false;
						break;
				}
			
			}
			
		});

		<%-- 비밀번호와 비밀번호 확인이 같은지 체크하기 --%>
		$("#passwd").on("keyup", function() {	
		    if(iscorrectPasswd && $("#passwd").val() == $("#passwd2").val()) { // 일치
		    	$("#checkPasswd2Result").text("비밀번호가 일치합니다").css("color", "blue");
		    	isSamePasswd = true;
		    } else if(!iscorrectPasswd && $("#passwd").val() == $("#passwd2").val()) { // 불일치
		    	$("#checkPasswd2Result").text("비밀번호가 올바른지 확인해주세요").css("color", "red");		     	
		    	isSamePasswd = false;
		    } else { // 불일치
		    	$("#checkPasswd2Result").text("비밀번호가 일치하지 않습니다").css("color", "red");		     	
		    	isSamePasswd = false;
		    }
			
		});
		
		$("#passwd2").on("keyup", function() {	
		    if(iscorrectPasswd && $("#passwd").val() == $("#passwd2").val()) { // 일치
		    	$("#checkPasswd2Result").text("비밀번호가 일치합니다").css("color", "blue");
		    	isSamePasswd = true;
		    } else if(!iscorrectPasswd && $("#passwd").val() == $("#passwd2").val()) { // 불일치
		    	$("#checkPasswd2Result").text("비밀번호가 올바른지 확인해주세요").css("color", "red");		     	
		    	isSamePasswd = false;
		    }  else { // 불일치
		    	$("#checkPasswd2Result").text("비밀번호가 일치하지 않습니다").css("color", "red");		     	
		    	isSamePasswd = false;
		    }
			
		});
		
		
		<%-- 이름 확인 --%>
		$("#name").on("blur", function() {		
			let regName = /^[가-힣]{2,5}$/; <%-- 한글 2~5글자 --%>
			if(!regName.test($("#name").val())){
				$("#checkNameResult").text("2~5글자의 한글만 사용 가능합니다").css("color", "red");
				iscorrectName = false;
			} else if(regName.test($("#name").val())){
				$("#checkNameResult").text("사용 가능한 이름입니다").css("color", "blue");
				iscorrectName = true;
	        }
		});		
		
		<%-- 휴대폰번호 확인 --%>
		$("#phone").on("blur", function() {	
			let member_phone = $("#phone").val();
			let regPhone = /^010-\d{4}-\d{4}$/; <%-- 010으로 시작하는 11자리 숫자 --%>
			if(!regPhone.test(member_phone)){
				$("#checkPhoneResult").text("휴대폰번호를 확인해주세요").css("color", "red");
				iscorrectPhone = false;
			} else {
				<%-- AJAX를 통해 휴대폰번호 중복값 확인 --%>
				$.ajax({
					url: "checkDup",
					data: {
						member_phone : member_phone
					},
					dataType: "json",
					success: function(checkDupPhone) {
						console.log("결과 : " + checkDupPhone)
						if(checkDupPhone) { // 중복
 							$("#checkPhoneResult").text("이미 사용중인 휴대폰번호입니다").css("color", "red");
 							iscorrectPhone = false;
 							isDuplicatePhone = true;
						} else { // 사용가능
							$("#checkPhoneResult").text("사용 가능한 휴대폰번호입니다").css("color", "blue");
							iscorrectPhone = true;
							isDuplicatePhone = false;
						}
							
					},
					error: function(request,status,error) {
					      // 요청이 실패한 경우 처리할 로직
					      console.log("AJAX 요청 실패:", error); // 예시: 에러 메시지 출력
					}
				});
	        }
		});			
		
		<%-- 전화번호에 자동 "-" 입력 --%>
		$("#phone").keyup(function(){
			var val = $(this).val().replace(/[^0-9]/g, ''); // 숫자만 입력 가능
			if(val.length > 3 && val.length < 6) {
				$(this).val(val.substring(0,3) + "-" + val.substring(3));
			} else if (val.length > 7) {
				$(this).val(val.substring(0,3) + "-" + val.substring(3, 7) + "-" + val.substring(7));
					
			}
		});
		
		
		<%-- 생년월일 확인 --%>
		let regBirth = /^(19[0-9][0-9]|20[0-2][0-9]).(0[0-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1])$/; <%-- 1920년~2029년까지/01월~12월까지/01일~31일까지의 8자리 숫자 --%>
		$("#birth").on("blur", function() {		
			let inputBirth = $("#birth").val();
			console.log(inputBirth);
			if(!regBirth.test($("#birth").val())) {
				$("#checkBirthResult").text("생년월일을 확인해주세요").css("color", "red");
				iscorrectBirth = false;
			} else if(regBirth.test($("#birth").val())) { // 정규표현식을 통과했을 때 세부적인 확인 필요
				// 입력한 생일을 연도, 월, 일로 나눔
				inputBirth.split(".");
				let year = inputBirth.split(".")[0];
				let month = inputBirth.split(".")[1];
				let day = inputBirth.split(".")[2];
				
				// 입력한 월을 받아 1, 3, 5, 7, 8, 10, 12월의 경우 1~31일
				// 4, 6, 9, 11월의 경우 1~30일
				// 2월의 경우에는 1~28일이고 윤년인 29일까지 입력 가능하도록 판별
				switch(parseInt(month)) {
				case 1 : case 3 : case 5 : case 7 : case 8 : case 10 : case 12 :
					
					if(!(parseInt(day) >= 1 && parseInt(day) <= 31)) {
						iscorrectBirth = false;
						console.log("1~31일 아님");
					} else {
						iscorrectBirth = true;
					}
					break;
				case 4 : case 6 : case 9 : case 11 :
					if(!(parseInt(day) >= 1 && parseInt(day) <= 30)) {
						console.log("1~30일 아님");
						iscorrectBirth = false;
					} else {
						iscorrectBirth = true;
					}
					break;
				case 2 :
					// 윤년의 경우 : 4로 나눠지는 해는 윤년이지만
					//				 그 중 100으로 나눠지는 해는 윤년이 아님
					//				 그러나 400으로 나눠지는 해는 윤년이다!
					if((parseInt(year) % 4 == 0 && parseInt(year) % 100 != 0) || parseInt(year) % 400 == 0) {
						if(!(parseInt(day) >= 1 && parseInt(day) <= 29)) {
							iscorrectBirth = false;
						} else {
							iscorrectBirth = true;
						}
					} else {
						if(!(parseInt(day) >= 1 && parseInt(day) <= 28)) {
							iscorrectBirth = false;
						} else {
							iscorrectBirth = true;
						}
					}
					break;
					default : iscorrectBirth = false;
				}
				
				// 현재 날짜 이전인지 판단하기 위해 현재 날짜 변수에 저장
				// 현재 날짜 객체 생성
				var today = new Date();
				// 연도 가져오기
				var curYear = today.getFullYear();
				// 월 가져오기 (0부터 시작하므로 1을 더해줌)
				var curMonth = today.getMonth() + 1;
				// 일 가져오기
				var curDay = today.getDate();
				
				if(curYear == year && curMonth < month) { // 연도가 같을 때 현재 월보다 이후의 월은 입력못함
					iscorrectBirth = false;
				} else if(curYear == year && curMonth == month && curDay < day) { // 연도와 월이 같을 때 현재 일보다 이후 일은 입력 못함 
					iscorrectBirth = false;
				} else if(curYear < year) { // 현재 연도보다 이후의 연도는 선택하지 못함
					iscorrectBirth = false;
				}
				
				if(!iscorrectBirth) {
					$("#checkBirthResult").text("생년월일을 확인해주세요").css("color", "red");
				} else {
					$("#checkBirthResult").text("사용 가능한 생년월일입니다").css("color", "blue");
					iscorrectBirth = true;
				}
				
				
	        }
		});	
		
		<%-- 생년월일에 자동 "." 입력 --%>
		$("#birth").keyup(function() {
			var val = $(this).val().replace(/[^0-9]/g, ''); // 숫자만 입력 가능
			if(val.length > 4 && val.length < 6) {
				$(this).val(val.substring(0,4) + "." + val.substring(4));
			}else if (val.length > 7) {
				$(this).val(val.substring(0,4) + "." + val.substring(4, 6) + "." + val.substring(6));
			}
		});

	
		<%-- submit 동작을 수행할 때 값을 올바르게 입력했는지 확인 --%>
		$("form").on("submit", function() {
			if(!iscorrectId) { <%-- 아이디가 정규표현식에 적합하지 않을 경우(미입력 포함) --%>
				$("#checkIdResult").text("5~20자의 영문 대/소문자, 숫자를 입력해주세요").css("color", "red");
				$("#id").focus();
				return false; // submit 동작 취소
			} else if(isDuplicateId) {  <%-- 아이디가 중복일 때 --%>
				$("#id").focus();
				return false; // submit 동작 취소
			} else if(!iscorrectPasswd) { <%-- 비밀번호 미입력 시 --%>
				$("#checkPasswdResult").text("8~16자의 영문 대/소문자, 숫자, 특수문자(!@#%^&*)만 사용 가능합니다").css("color", "red");
				$("#passwd").focus();
				return false; // submit 동작 취소
			} else if(!isSafePasswd) { <%-- 비밀번호가 안전하지 않을 때 --%>
				$("#passwd").focus();
				return false; // submit 동작 취소
			} else if(!isSamePasswd) { <%-- 비밀번호 불일치 시 --%>
				$("#passwd2").focus();
				return false; // submit 동작 취소
			} else if(!iscorrectName) { <%-- 이름 미입력 시 --%>
				$("#checkNameResult").text("2~5글자의 한글만 사용 가능합니다").css("color", "red");
				$("#name").focus();
				return false; // submit 동작 취소
			} else if(!iscorrectPhone) {  <%-- 휴대폰번호 미입력 시 --%>
				$("#checkPhoneResult").text("휴대폰번호를 확인해주세요").css("color", "red");
				$("#phone").focus();
				return false; // submit 동작 취소
			} else if(isDuplicatePhone) {  <%-- 휴대폰번호 중복 시 --%>
				$("#phone").focus();
				return false; // submit 동작 취소
			} else if($("#email").val() == null) {  <%-- 이메일 주소 미입력 시 --%>
				$("#checkEmailResult").text("이메일 주소를 확인해주세요").css("color", "red");
				$("#email").focus();
				return false; // submit 동작 취소
			} else if(isDuplicateEmail) {  <%-- 이메일 주소 중복 시 --%>
				$("#email").focus();
				return false; // submit 동작 취소
			} else if(!iscorrectBirth) {  <%-- 생년월일 미입력 시 --%>
				$("#checkBirthResult").text("생년월일을 확인해주세요").css("color", "red");
				$("#birth").focus();
				return false; // submit 동작 취소
			} else if(!$('input[name=member_gender]:checked').is(":checked")) {  <%-- 성별 미선택 시 --%>
				$("#checkGenderResult").text("성별을 선택해주세요").css("color", "red");
				$("#identityGender1").focus();
				return false; // submit 동작 취소
			} else if(confirm("확인을 누르시면 회원가입이 완료됩니다")) {
				return true; 
			} else {
				return false;
			}	
			
			return true; // submit 동작 수행(생략 가능)
		});
		
	});
	
</script>			
</head>
<body>
	<%-- div 태그로 전체를 감싼 후 가운데에 정렬하기 --%>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
				
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>

		<section id="content">	
			<h1 id="h01">회원가입</h1> <%-- 제목영역 --%>
			<section id="join_top"> <%-- 회원가입 진행상황 --%>
				<span>본인인증</span>
				<span>약관동의</span>
				<span id="this">정보입력</span>
				<span>가입완료</span>		
			</section>
			
			<form action="memberJoinPro" method="post" name="joinForm">
				<hr>
				<h2 id="join_top">회원정보입력</h2> <%-- 소제목 --%>
				<section id="join_center">
					<label for="id"><b>아이디</b></label>
					<input type="text" placeholder="5~20자의 영문 대/소문자, 숫자" name="member_id" id="id">
					<div id="checkIdResult" class="resultArea"></div>
					<label for="passwd"><b>비밀번호</b></label>
					<input type="password" placeholder="8~16자의 영문 대/소문자, 숫자, 특수문자(!@#%^&*)" name="member_passwd" id="passwd">
					<div id="checkPasswdResult" class="resultArea"></div>
					<label for="passwd2"><b>비밀번호확인</b></label>
					<input type="password" placeholder="비밀번호를 다시 입력해주세요" name="passwd2" id="passwd2">
					<div id="checkPasswd2Result" class="resultArea"></div>
					<label for="name"><b>이름</b></label>
					<input type="text" placeholder="2~5글자의 한글" name="member_name" id="name">
					<div id="checkNameResult" class="resultArea"></div>
					<label for="phone"><b>휴대폰번호</b></label>
					<input type="tel" placeholder="숫자만 입력해주세요" name="member_phone" id="phone" maxlength="13">
					<div id="checkPhoneResult" class="resultArea"></div>
					<label for="email"><b>이메일주소</b></label>
					<input type="text" placeholder="숫자만 입력해주세요" value="${param.email}" name="member_email" id="email" readonly>
					<div id="checkEmailResult" class="resultArea"></div>
					<label for="birth"><b>생년월일</b></label>
					<input type="text" placeholder="숫자만 입력해주세요" name="member_birth" id="birth" maxlength="10">
					<div id="checkBirthResult" class="resultArea"></div>
					<label for="gender"><b>성별</b></label>
					<div id="gender">
                        <input type="radio" id="identityGender1" name="member_gender" value="M" class="blind">
                        <label for="identityGender1">남자</label>
                        <input type="radio" id="identityGender2" name="member_gender" value="F" class="blind">
                        <label for="identityGender2">여자</label>
                    </div>
					<div id="checkGenderResult" class="resultArea"></div>
					<hr>
					<div class="joinbtn">
						<input type="button" value="이전" onclick="history.back()">
						<input type="submit" value="가입완료">
					</div>
				</section>
			</form>
		</section>
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>
		</footer>
	</div>
</body>
</html>